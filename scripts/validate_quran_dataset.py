#!/usr/bin/env python3
"""Fail-closed structural validator for the canonical Quran dataset.

Expected input format (UTF-8):
    sura:ayah|canonical Arabic text

This validates structure only. Exact Tanzil v1.1 source-byte provenance and
SHA-256 must also be verified through the release source manifest.
"""
from __future__ import annotations

from pathlib import Path
import argparse
import hashlib
import sys

AYAH_COUNTS = (
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99,
    128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34,
    30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29,
    18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12,
    12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19,
    36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6,
)
EXPECTED_SURAS = 114
EXPECTED_AYAHS = 6236


def fail(message: str) -> None:
    raise ValueError(message)


def validate_bytes(raw: bytes) -> dict[str, str | int]:
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        fail(f"Dataset is not valid UTF-8: {exc}")

    lines = text.splitlines()
    if len(lines) != EXPECTED_AYAHS:
        fail(f"Expected {EXPECTED_AYAHS} ayah records, found {len(lines)}")

    seen: set[tuple[int, int]] = set()
    per_sura = [0] * EXPECTED_SURAS
    previous_key = (0, 0)

    for index, line in enumerate(lines, start=1):
        if not line.strip():
            fail(f"Blank record at line {index}")
        if "|" not in line:
            fail(f"Missing '|' separator at line {index}")

        locator, arabic = line.split("|", 1)
        if not arabic.strip():
            fail(f"Empty Quran text at line {index}")
        if ":" not in locator:
            fail(f"Invalid locator at line {index}: {locator!r}")

        sura_raw, ayah_raw = locator.split(":", 1)
        try:
            sura = int(sura_raw)
            ayah = int(ayah_raw)
        except ValueError:
            fail(f"Non-integer locator at line {index}: {locator!r}")

        if not 1 <= sura <= EXPECTED_SURAS:
            fail(f"Invalid sura {sura} at line {index}")
        max_ayah = AYAH_COUNTS[sura - 1]
        if not 1 <= ayah <= max_ayah:
            fail(f"Invalid ayah {sura}:{ayah}; expected 1..{max_ayah}")

        key = (sura, ayah)
        if key in seen:
            fail(f"Duplicate ayah key {sura}:{ayah}")
        if key <= previous_key:
            fail(
                f"Dataset order is not strictly Quran order at {sura}:{ayah}; "
                f"previous was {previous_key[0]}:{previous_key[1]}"
            )
        seen.add(key)
        previous_key = key
        per_sura[sura - 1] += 1

    for sura, (actual, expected) in enumerate(zip(per_sura, AYAH_COUNTS), start=1):
        if actual != expected:
            fail(f"Sura {sura}: expected {expected} ayahs, found {actual}")
        for ayah in range(1, expected + 1):
            if (sura, ayah) not in seen:
                fail(f"Missing ayah {sura}:{ayah}")

    if len(seen) != EXPECTED_AYAHS:
        fail(f"Expected {EXPECTED_AYAHS} unique ayahs, found {len(seen)}")

    return {
        "surahs": EXPECTED_SURAS,
        "ayahs": EXPECTED_AYAHS,
        "sha256": hashlib.sha256(raw).hexdigest(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("dataset", type=Path)
    args = parser.parse_args()

    if not args.dataset.is_file():
        print(f"Quran dataset not found: {args.dataset}", file=sys.stderr)
        return 2

    try:
        result = validate_bytes(args.dataset.read_bytes())
    except ValueError as exc:
        print(f"Quran dataset validation FAIL: {exc}", file=sys.stderr)
        return 1

    print("Quran dataset structural validation PASS")
    print(f"surahs={result['surahs']} ayahs={result['ayahs']}")
    print(f"sha256={result['sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
