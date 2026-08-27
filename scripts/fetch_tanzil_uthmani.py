#!/usr/bin/env python3
"""Fetch the canonical Tanzil Uthmani source without modifying its bytes.

This script intentionally downloads from Tanzil directly. It does not use a
mirror and does not normalize line endings or Unicode. After download it runs
the structural validator and writes a provenance/integrity manifest.
"""
from __future__ import annotations

from pathlib import Path
import argparse
import ssl
import sys
import tempfile
import urllib.request

from validate_quran_dataset import build_manifest, validate_bytes
import json

OFFICIAL_URL = (
    "https://tanzil.net/pub/download/index.php?"
    "quranType=uthmani&outType=txt-2&agree=true"
)
USER_AGENT = "IslamiHayat-QuranSourceFetcher/1.0 (+https://tanzil.net)"


def download_exact(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    context = ssl.create_default_context()
    with urllib.request.urlopen(request, context=context, timeout=60) as response:
        final_url = response.geturl()
        if not final_url.startswith("https://tanzil.net/"):
            raise RuntimeError(f"Unexpected download host/redirect: {final_url}")
        payload = response.read()
        content_type = response.headers.get("Content-Type", "")
        if "text/html" in content_type.lower() and b"<html" in payload[:1000].lower():
            raise RuntimeError("Tanzil returned HTML instead of Quran text")
        return payload


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("assets/quran/source/quran-uthmani.txt"),
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        default=Path("assets/quran/source/quran-uthmani.manifest.json"),
    )
    parser.add_argument("--url", default=OFFICIAL_URL, help=argparse.SUPPRESS)
    args = parser.parse_args()

    if not args.url.startswith("https://tanzil.net/"):
        print("Refusing non-Tanzil Quran source URL", file=sys.stderr)
        return 2

    try:
        payload = download_exact(args.url)
        result = validate_bytes(payload)
    except (OSError, RuntimeError, ValueError) as exc:
        print(f"Tanzil Quran fetch/validation FAIL: {exc}", file=sys.stderr)
        return 1

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.parent.mkdir(parents=True, exist_ok=True)

    # Atomic-ish local writes: validate before replacing the destination.
    with tempfile.NamedTemporaryFile(dir=args.output.parent, delete=False) as temp:
        temp.write(payload)
        temp_path = Path(temp.name)
    temp_path.replace(args.output)

    manifest = build_manifest(args.output, result)
    manifest["download_url"] = args.url
    args.manifest.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print("Official Tanzil Uthmani source fetched and validated")
    print(f"file={args.output}")
    print(f"manifest={args.manifest}")
    print(f"sha256={result['sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
