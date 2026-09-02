#!/usr/bin/env python3
"""Fetch and fail-closed validate pinned QuranEnc meal sources.

The source translation strings are never corrected, paraphrased, normalized or
translated. Each official API response is hashed byte-for-byte before parsing.
The generated canonical JSON only rearranges source fields into deterministic
sura/ayah order while preserving ``translation`` and ``footnotes`` values
exactly as returned by QuranEnc.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import time
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from validate_quran_dataset import AYAH_COUNTS, EXPECTED_AYAHS, EXPECTED_SURAS

API_BASE = "https://quranenc.com/api/v1"
SOURCES = {
    "tr": {"key": "turkish_rwwad", "language": "tr", "publisher": "Rowad Tercüme Merkezi"},
    "en": {"key": "english_rwwad", "language": "en", "publisher": "Rowwad Translation Center"},
}

# Network retries are intentionally limited to transient transport/server
# failures. Content, schema, locator, source version and hash validation remains
# fail-closed and is never retried into acceptance.
_GET_ATTEMPTS = 3
_GET_TIMEOUT_SECONDS = 30
_RETRYABLE_HTTP = {408, 425, 429, 500, 502, 503, 504}


def _get(url: str) -> bytes:
    req = Request(url, headers={"User-Agent": "IslamicLifeSourceVerifier/1.0"})
    for attempt in range(1, _GET_ATTEMPTS + 1):
        try:
            with urlopen(req, timeout=_GET_TIMEOUT_SECONDS) as response:
                if response.status != 200:
                    raise ValueError(f"HTTP {response.status} for {url}")
                return response.read()
        except HTTPError as exc:
            if exc.code not in _RETRYABLE_HTTP or attempt == _GET_ATTEMPTS:
                raise
            delay = 2 ** (attempt - 1)
            print(
                f"Transient HTTP {exc.code} for {url}; "
                f"retry {attempt + 1}/{_GET_ATTEMPTS} in {delay}s",
                flush=True,
            )
            time.sleep(delay)
        except (TimeoutError, URLError) as exc:
            if attempt == _GET_ATTEMPTS:
                raise
            delay = 2 ** (attempt - 1)
            print(
                f"Transient network error for {url}: {type(exc).__name__}; "
                f"retry {attempt + 1}/{_GET_ATTEMPTS} in {delay}s",
                flush=True,
            )
            time.sleep(delay)
    raise RuntimeError(f"Unreachable retry state for {url}")


def _json(raw: bytes, url: str):
    try:
        return json.loads(raw.decode("utf-8"))
    except Exception as exc:
        raise ValueError(f"Invalid UTF-8 JSON from {url}: {exc}") from exc


def _unwrap_list(payload, *, context: str) -> list:
    """Accept documented arrays or known QuranEnc wrapper objects only."""
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        for key in ("result", "data", "translations"):
            value = payload.get(key)
            if isinstance(value, list):
                return value
        raise ValueError(
            f"{context}: unsupported object wrapper; keys={sorted(payload.keys())}"
        )
    raise ValueError(f"{context}: expected array/object, got {type(payload).__name__}")


def _translation_metadata(locale: str, source: dict[str, str]) -> dict:
    url = f"{API_BASE}/translations/list/{source['language']}?localization={locale}"
    raw = _get(url)
    payload = _unwrap_list(_json(raw, url), context="translation list")
    matches = [item for item in payload if isinstance(item, dict) and item.get("key") == source["key"]]
    if len(matches) != 1:
        raise ValueError(f"Expected exactly one metadata row for {source['key']}, found {len(matches)}")
    item = matches[0]
    version = str(item.get("version", "")).strip()
    if not version:
        raise ValueError(f"Missing version for {source['key']}")
    return {
        "key": source["key"],
        "language_iso_code": item.get("language_iso_code"),
        "version": version,
        "last_update": item.get("last_update"),
        "title": item.get("title"),
        "description": item.get("description"),
        "metadata_url": url,
        "metadata_sha256": hashlib.sha256(raw).hexdigest(),
    }


def fetch_translation(locale: str) -> tuple[dict, dict]:
    source = SOURCES[locale]
    metadata = _translation_metadata(locale, source)
    verses: list[dict] = []
    response_hashes: list[dict] = []
    seen: set[tuple[int, int]] = set()

    for sura in range(1, EXPECTED_SURAS + 1):
        url = f"{API_BASE}/translation/sura/{source['key']}/{sura}"
        raw = _get(url)
        payload = _unwrap_list(_json(raw, url), context=f"sura {sura}")
        expected_count = AYAH_COUNTS[sura - 1]
        if len(payload) != expected_count:
            raise ValueError(f"Sura {sura}: expected {expected_count} ayahs, found {len(payload)}")
        response_hashes.append({"sura": sura, "url": url, "sha256": hashlib.sha256(raw).hexdigest(), "bytes": len(raw)})

        for expected_aya, row in enumerate(payload, start=1):
            if not isinstance(row, dict):
                raise ValueError(f"Sura {sura} row {expected_aya}: expected object")
            try:
                row_sura = int(row["sura"])
                row_aya = int(row["aya"])
            except Exception as exc:
                raise ValueError(f"Sura {sura} row {expected_aya}: invalid locator") from exc
            if (row_sura, row_aya) != (sura, expected_aya):
                raise ValueError(f"Unexpected locator {row_sura}:{row_aya}; expected {sura}:{expected_aya}")
            key = (row_sura, row_aya)
            if key in seen:
                raise ValueError(f"Duplicate ayah {row_sura}:{row_aya}")
            seen.add(key)
            translation = row.get("translation")
            footnotes = row.get("footnotes")
            if not isinstance(translation, str) or not translation.strip():
                raise ValueError(f"Empty/non-string translation at {row_sura}:{row_aya}")
            if footnotes is not None and not isinstance(footnotes, str):
                raise ValueError(f"Non-string footnotes at {row_sura}:{row_aya}")
            verses.append({"sura": row_sura, "aya": row_aya, "translation": translation, "footnotes": footnotes})

    if len(verses) != EXPECTED_AYAHS or len(seen) != EXPECTED_AYAHS:
        raise ValueError(f"Expected {EXPECTED_AYAHS} unique ayahs, got verses={len(verses)} unique={len(seen)}")

    dataset = {
        "translation_key": source["key"],
        "publisher": source["publisher"],
        "source": "QuranEnc.com",
        "version": metadata["version"],
        "verses": verses,
    }
    canonical = (json.dumps(dataset, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")
    manifest = {
        "translation_key": source["key"],
        "publisher": source["publisher"],
        "source": "https://quranenc.com",
        "version": metadata["version"],
        "last_update": metadata["last_update"],
        "ayahs": EXPECTED_AYAHS,
        "surahs": EXPECTED_SURAS,
        "canonical_sha256": hashlib.sha256(canonical).hexdigest(),
        "canonical_bytes": len(canonical),
        "metadata": metadata,
        "source_response_hashes": response_hashes,
        "integrity_rule": "translation and footnotes preserved exactly; source responses byte-hashed before parsing",
    }
    return dataset, manifest


def write_locale(locale: str, output_dir: Path) -> None:
    dataset, manifest = fetch_translation(locale)
    output_dir.mkdir(parents=True, exist_ok=True)
    dataset_path = output_dir / f"{SOURCES[locale]['key']}.json"
    manifest_path = output_dir / f"{SOURCES[locale]['key']}.manifest.json"
    dataset_path.write_text(json.dumps(dataset, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n", encoding="utf-8")
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"{locale}: version={manifest['version']} ayahs={manifest['ayahs']} sha256={manifest['canonical_sha256']}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", default="build/quranenc-meals")
    parser.add_argument("--locale", choices=("tr", "en", "all"), default="all")
    args = parser.parse_args()
    locales = ("tr", "en") if args.locale == "all" else (args.locale,)
    for locale in locales:
        write_locale(locale, Path(args.output_dir))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
