#!/usr/bin/env python3
"""Prepare the exact canonical Quran asset for a release build.

The repository pins provenance and SHA-256 in
``assets/quran/source/quran-uthmani.manifest.json``. The large canonical source
is fetched from Tanzil only when preparing a build, structurally validated, and
must match every pinned integrity field before it is written into the Flutter
asset directory.
"""
from __future__ import annotations

from pathlib import Path
import argparse
import json
import sys
import tempfile

from fetch_tanzil_uthmani import OFFICIAL_URL, download_exact
from validate_quran_dataset import validate_bytes

DEFAULT_LOCK = Path("assets/quran/source/quran-uthmani.manifest.json")
DEFAULT_OUTPUT = Path("assets/quran/source/quran-uthmani.txt")
PINNED_FIELDS = ("sha256", "bytes", "layout", "surahs", "ayahs", "footer_lines")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lock", type=Path, default=DEFAULT_LOCK)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    if not args.lock.is_file():
        print(f"Pinned Quran manifest not found: {args.lock}", file=sys.stderr)
        return 2

    lock = json.loads(args.lock.read_text(encoding="utf-8"))
    expected_url = lock.get("download_url", OFFICIAL_URL)
    if expected_url != OFFICIAL_URL:
        print("Pinned Quran download URL differs from the approved Tanzil URL", file=sys.stderr)
        return 1

    try:
        payload = download_exact(OFFICIAL_URL)
        actual = validate_bytes(payload)
    except (OSError, RuntimeError, ValueError) as exc:
        print(f"Canonical Quran asset preparation FAIL: {exc}", file=sys.stderr)
        return 1

    mismatches = []
    for field in PINNED_FIELDS:
        if actual.get(field) != lock.get(field):
            mismatches.append(
                f"{field}: downloaded={actual.get(field)!r}, pinned={lock.get(field)!r}"
            )
    if mismatches:
        print("Canonical Quran source does not match the pinned manifest:", file=sys.stderr)
        for mismatch in mismatches:
            print(f"- {mismatch}", file=sys.stderr)
        return 1

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=args.output.parent, delete=False) as temp:
        temp.write(payload)
        temp_path = Path(temp.name)
    temp_path.replace(args.output)

    print("Canonical Quran release asset PASS")
    print(f"source=Tanzil Project Uthmani v1.1")
    print(f"ayahs={actual['ayahs']} surahs={actual['surahs']} footer_lines={actual['footer_lines']}")
    print(f"bytes={actual['bytes']} sha256={actual['sha256']}")
    print(f"asset={args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
