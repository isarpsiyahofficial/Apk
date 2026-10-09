#!/usr/bin/env python3
"""Fail-closed structural validator for the canonical Quran dataset.

The canonical source bytes must remain verbatim. Tanzil text downloads may
contain 6236 Quran records followed by their license/attribution footer. This
validator therefore separates *inspection* of the Quran records from hashing:
SHA-256 always covers the complete original file, including footer and exact
line endings.

Accepted Quran-record layouts:
1. Plain Tanzil text: one ayah text per line.
2. Tanzil numbered text: ``sura|ayah|text``.
3. Internal locator text: ``sura:ayah|text`` (legacy/import-fixture support).

After the 6236 Quran records, only blank lines or comment lines beginning with
``#`` are accepted. This preserves Tanzil's attribution block while rejecting
unexpected extra Quran/content records.
"""
from __future__ import annotations

from pathlib import Path
import argparse
import hashlib
import json
import sys
from typing import Iterable

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


def canonical_keys() -> Iterable[tuple[int, int]]:
    for sura, count in enumerate(AYAH_COUNTS, start=1):
        for ayah in range(1, count + 1):
            yield sura, ayah


def _parse_line(
    line: str,
    expected_key: tuple[int, int],
    index: int,
) -> tuple[int, int, str, str]:
    """Return ``sura, ayah, text, layout`` without mutating Quran text."""
    if not line:
        fail(f"Blank Quran record at line {index}")

    # Tanzil/other numbered export: sura|ayah|text
    parts = line.split("|", 2)
    if len(parts) == 3 and parts[0].isdigit() and parts[1].isdigit():
        return int(parts[0]), int(parts[1]), parts[2], "sura|ayah|text"

    # Legacy internal import fixture: sura:ayah|text
    if len(parts) >= 2 and ":" in parts[0]:
        locator, arabic = line.split("|", 1)
        sura_raw, ayah_raw = locator.split(":", 1)
        if sura_raw.isdigit() and ayah_raw.isdigit():
            return int(sura_raw), int(ayah_raw), arabic, "sura:ayah|text"

    # Official Tanzil plain text: one ayah per line. Location is derived only in
    # memory from canonical order; source bytes remain untouched.
    return expected_key[0], expected_key[1], line, "plain"


def _validate_footer(footer: list[str]) -> None:
    """Allow only Tanzil-style blank/comment attribution lines after ayah 6236."""
    for offset, line in enumerate(footer, start=EXPECTED_AYAHS + 1):
        if line == "" or line.startswith("#"):
            continue
        fail(
            "Unexpected non-comment content after the 6236 Quran records "
            f"at line {offset}"
        )


def validate_bytes(raw: bytes) -> dict[str, str | int]:
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        fail(f"Dataset is not valid UTF-8: {exc}")

    # splitlines() is intentionally used only for structural inspection. Hashing
    # below uses the original raw bytes, preserving CRLF/LF and final newline.
    lines = text.splitlines()
    if len(lines) < EXPECTED_AYAHS:
        fail(f"Expected {EXPECTED_AYAHS} ayah records, found {len(lines)}")

    quran_lines = lines[:EXPECTED_AYAHS]
    footer = lines[EXPECTED_AYAHS:]
    _validate_footer(footer)

    expected_keys = list(canonical_keys())
    seen: set[tuple[int, int]] = set()
    per_sura = [0] * EXPECTED_SURAS
    layouts: set[str] = set()

    for index, (line, expected_key) in enumerate(
        zip(quran_lines, expected_keys),
        start=1,
    ):
        sura, ayah, arabic, layout = _parse_line(line, expected_key, index)
        layouts.add(layout)

        if arabic == "" or arabic.isspace():
            fail(f"Empty Quran text at line {index}")
        if not 1 <= sura <= EXPECTED_SURAS:
            fail(f"Invalid sura {sura} at line {index}")
        max_ayah = AYAH_COUNTS[sura - 1]
        if not 1 <= ayah <= max_ayah:
            fail(f"Invalid ayah {sura}:{ayah}; expected 1..{max_ayah}")

        key = (sura, ayah)
        if key != expected_key:
            fail(
                f"Unexpected Quran order at line {index}: found {sura}:{ayah}, "
                f"expected {expected_key[0]}:{expected_key[1]}"
            )
        if key in seen:
            fail(f"Duplicate ayah key {sura}:{ayah}")

        seen.add(key)
        per_sura[sura - 1] += 1

    if len(layouts) != 1:
        fail(f"Mixed dataset layouts are not allowed: {', '.join(sorted(layouts))}")

    for sura, (actual, expected) in enumerate(zip(per_sura, AYAH_COUNTS), start=1):
        if actual != expected:
            fail(f"Sura {sura}: expected {expected} ayahs, found {actual}")

    if len(seen) != EXPECTED_AYAHS:
        fail(f"Expected {EXPECTED_AYAHS} unique ayahs, found {len(seen)}")

    return {
        "surahs": EXPECTED_SURAS,
        "ayahs": EXPECTED_AYAHS,
        "layout": next(iter(layouts)),
        "footer_lines": len(footer),
        "bytes": len(raw),
        "sha256": hashlib.sha256(raw).hexdigest(),
    }


def build_manifest(dataset: Path, result: dict[str, str | int]) -> dict[str, object]:
    return {
        "schema": 1,
        "kind": "quran-arabic-canonical",
        "source": "Tanzil Project",
        "text_family": "Uthmani",
        "source_version": "1.1",
        "source_url": "https://tanzil.net/download/",
        "license": "CC BY 3.0",
        "license_url": "https://tanzil.net/docs/Text_License",
        "file": dataset.name,
        "layout": result["layout"],
        "surahs": result["surahs"],
        "ayahs": result["ayahs"],
        "footer_lines": result["footer_lines"],
        "bytes": result["bytes"],
        "sha256": result["sha256"],
        "hash_scope": "exact source bytes; includes attribution footer; no newline or Unicode normalization",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("dataset", type=Path)
    parser.add_argument(
        "--manifest",
        type=Path,
        help="Write a provenance/integrity manifest after successful validation",
    )
    args = parser.parse_args()

    if not args.dataset.is_file():
        print(f"Quran dataset not found: {args.dataset}", file=sys.stderr)
        return 2

    raw = args.dataset.read_bytes()
    try:
        result = validate_bytes(raw)
    except ValueError as exc:
        print(f"Quran dataset validation FAIL: {exc}", file=sys.stderr)
        return 1

    if args.manifest:
        args.manifest.parent.mkdir(parents=True, exist_ok=True)
        args.manifest.write_text(
            json.dumps(build_manifest(args.dataset, result), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )

    print("Quran dataset structural validation PASS")
    print(
        f"layout={result['layout']} surahs={result['surahs']} "
        f"ayahs={result['ayahs']} footer_lines={result['footer_lines']} "
        f"bytes={result['bytes']}"
    )
    print(f"sha256={result['sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
