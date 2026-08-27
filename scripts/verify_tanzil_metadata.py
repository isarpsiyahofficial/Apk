#!/usr/bin/env python3
"""Verify committed Quran juz boundaries against official Tanzil metadata.

The application keeps structural pointers separate from the immutable Quran
text. This verifier downloads Tanzil quran-data.xml, validates its 30 juz
starts, and compares them byte-for-byte at the numeric tuple level with the
Dart runtime constants. Any drift fails CI.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import re
import ssl
import sys
import urllib.request
import xml.etree.ElementTree as ET

OFFICIAL_METADATA_URL = "https://tanzil.net/res/text/metadata/quran-data.xml"
USER_AGENT = "IslamiHayat-QuranMetadataVerifier/1.0 (+https://tanzil.net)"
DART_PATTERN = re.compile(
    r"QuranJuzStart\(juz:\s*(\d+),\s*surah:\s*(\d+),\s*ayah:\s*(\d+)\)"
)


def download_exact(url: str) -> bytes:
    if not url.startswith("https://tanzil.net/"):
        raise ValueError("Refusing non-Tanzil metadata URL")
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(
        request,
        context=ssl.create_default_context(),
        timeout=60,
    ) as response:
        final_url = response.geturl()
        if not final_url.startswith("https://tanzil.net/"):
            raise RuntimeError(f"Unexpected metadata redirect: {final_url}")
        payload = response.read()
        if b"<quran" not in payload[:4096]:
            raise RuntimeError("Tanzil metadata response does not contain Quran XML")
        return payload


def parse_xml_juz_starts(payload: bytes) -> list[tuple[int, int, int]]:
    root = ET.fromstring(payload)
    juzs = root.find("juzs")
    if juzs is None:
        raise ValueError("Tanzil metadata is missing <juzs>")

    result: list[tuple[int, int, int]] = []
    for element in juzs.findall("juz"):
        result.append(
            (
                int(element.attrib["index"]),
                int(element.attrib["sura"]),
                int(element.attrib["aya"]),
            )
        )
    return result


def parse_dart_juz_starts(path: Path) -> list[tuple[int, int, int]]:
    text = path.read_text(encoding="utf-8")
    return [tuple(map(int, match)) for match in DART_PATTERN.findall(text)]


def validate(starts: list[tuple[int, int, int]]) -> None:
    if len(starts) != 30:
        raise ValueError(f"Expected 30 juz boundaries, got {len(starts)}")
    indexes = [item[0] for item in starts]
    if indexes != list(range(1, 31)):
        raise ValueError(f"Juz indexes are not exactly 1..30: {indexes}")
    if starts[0] != (1, 1, 1):
        raise ValueError(f"Unexpected first juz boundary: {starts[0]}")
    if starts[-1] != (30, 78, 1):
        raise ValueError(f"Unexpected final juz boundary: {starts[-1]}")

    previous = (0, 0)
    for _, surah, ayah in starts:
        position = (surah, ayah)
        if position <= previous:
            raise ValueError(f"Juz boundaries are not strictly increasing: {position}")
        previous = position


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dart",
        type=Path,
        default=Path("lib/features/quran/data/quran_structure_metadata.dart"),
    )
    parser.add_argument("--url", default=OFFICIAL_METADATA_URL, help=argparse.SUPPRESS)
    args = parser.parse_args()

    try:
        payload = download_exact(args.url)
        official = parse_xml_juz_starts(payload)
        committed = parse_dart_juz_starts(args.dart)
        validate(official)
        validate(committed)
        if official != committed:
            for index, (expected, actual) in enumerate(
                zip(official, committed, strict=True), start=1
            ):
                if expected != actual:
                    raise ValueError(
                        f"Juz {index} drift: Tanzil={expected}, committed={actual}"
                    )
            raise ValueError("Committed Quran juz metadata differs from Tanzil")
    except (OSError, RuntimeError, ValueError, ET.ParseError) as exc:
        print(f"Tanzil Quran metadata verification FAIL: {exc}", file=sys.stderr)
        return 1

    digest = hashlib.sha256(payload).hexdigest()
    print("Tanzil Quran metadata verification PASS")
    print(f"source={args.url}")
    print(f"sha256={digest}")
    print(f"bytes={len(payload)}")
    print("juz_boundaries=30/30")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
