#!/usr/bin/env python3
"""Copy only pinned, verified QuranEnc meal datasets into Flutter assets.

Input files are produced by fetch_quranenc_meals.py. This step performs a
second independent byte-level hash and metadata/coverage check before anything
is allowed into assets/quran/meals. It never edits translation or footnote text.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

PINNED = {
    "turkish_rwwad": {
        "version": "1.0.4",
        "sha256": "a0c001b1e690cc022351d55b9951a7410fde4a6266638766c553fa91f401b1b7",
    },
    "english_rwwad": {
        "version": "1.0.19",
        "sha256": "24c81ccfa5818e417b96f3b457955d34308a95d006a65c894ac69eaba580a3c0",
    },
}
EXPECTED_SURAHS = 114
EXPECTED_AYAHS = 6236


def _sha256(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def validate_dataset(path: Path, key: str) -> bytes:
    raw = path.read_bytes()
    expected = PINNED[key]
    actual_sha = _sha256(raw)
    if actual_sha != expected["sha256"]:
        raise ValueError(f"{key}: SHA-256 mismatch: {actual_sha}")

    try:
        payload = json.loads(raw.decode("utf-8"))
    except Exception as exc:
        raise ValueError(f"{key}: invalid UTF-8 JSON: {exc}") from exc
    if not isinstance(payload, dict):
        raise ValueError(f"{key}: root must be an object")
    if payload.get("translation_key") != key:
        raise ValueError(f"{key}: translation_key mismatch")
    if payload.get("version") != expected["version"]:
        raise ValueError(f"{key}: version mismatch")

    verses = payload.get("verses")
    if not isinstance(verses, list) or len(verses) != EXPECTED_AYAHS:
        raise ValueError(f"{key}: expected {EXPECTED_AYAHS} verses")

    seen: set[tuple[int, int]] = set()
    surahs: set[int] = set()
    previous = (0, 0)
    for index, row in enumerate(verses, start=1):
        if not isinstance(row, dict):
            raise ValueError(f"{key}: row {index} is not an object")
        sura = row.get("sura")
        aya = row.get("aya")
        translation = row.get("translation")
        footnotes = row.get("footnotes")
        if not isinstance(sura, int) or not isinstance(aya, int):
            raise ValueError(f"{key}: invalid locator at row {index}")
        if not isinstance(translation, str) or not translation.strip():
            raise ValueError(f"{key}: empty translation at {sura}:{aya}")
        if footnotes is not None and not isinstance(footnotes, str):
            raise ValueError(f"{key}: invalid footnotes at {sura}:{aya}")
        locator = (sura, aya)
        if locator in seen:
            raise ValueError(f"{key}: duplicate locator {sura}:{aya}")
        seen.add(locator)
        surahs.add(sura)

        prev_sura, prev_aya = previous
        if sura == prev_sura:
            if aya != prev_aya + 1:
                raise ValueError(f"{key}: non-contiguous ayah at {sura}:{aya}")
        else:
            if sura != prev_sura + 1 or aya != 1:
                raise ValueError(f"{key}: non-contiguous surah at {sura}:{aya}")
        previous = locator

    if len(surahs) != EXPECTED_SURAHS or len(seen) != EXPECTED_AYAHS:
        raise ValueError(f"{key}: incomplete 114/6236 coverage")
    return raw


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", default="build/quranenc-meals")
    parser.add_argument("--output-dir", default="assets/quran/meals")
    args = parser.parse_args()
    input_dir = Path(args.input_dir)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    for key in PINNED:
        source = input_dir / f"{key}.json"
        if not source.is_file():
            raise FileNotFoundError(f"Missing verified dataset: {source}")
        raw = validate_dataset(source, key)
        destination = output_dir / source.name
        destination.write_bytes(raw)
        if destination.read_bytes() != raw:
            raise IOError(f"Byte-for-byte copy verification failed: {destination}")
        print(f"packed {key}: bytes={len(raw)} sha256={_sha256(raw)}")

    allowed = {f"{key}.json" for key in PINNED}
    for path in output_dir.glob("*.json"):
        if path.name not in allowed:
            path.unlink()
            print(f"removed stale unpinned asset: {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
