#!/usr/bin/env python3
"""Fail-closed audit for user-facing Islamic history prose.

T0224 keeps reference works (including TDV Islam Ansiklopedisi), academic
books, articles and websites in a verification/citation role unless explicit
redistribution rights permit verbatim reuse. The audit never downloads or
stores reference prose. It scans every Dart history data file and fails when
reference-site/copyright boilerplate or source markup leaks into localized
TR/EN/AR strings.

This automated gate complements the documented editorial review. It cannot
prove semantic originality against every copyrighted book; it does make source
text leakage and future paste-ins visible and CI-blocking.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
import unicodedata
from dataclasses import dataclass

ROOT = pathlib.Path(__file__).resolve().parents[1]
DEFAULT_HISTORY_ROOT = ROOT / "lib" / "features" / "history" / "data"

FORBIDDEN_LOCALIZED_MARKERS = (
    "islamansiklopedisi.org.tr",
    "tdv islâm ansiklopedisi",
    "tdv islam ansiklopedisi",
    "kopyalama metni",
    "her hakkı mahfuzdur",
    "all rights reserved",
    "cambridge core:",
    "doi:",
    "isbn ",
    "©",
)

# Current history datasets use single-quoted tr/en/ar fields for user-facing
# LocalizedHistorySummary content. Dart escapes are kept as text; only the two
# quote/backslash escapes needed for marker scanning are normalized, avoiding
# accidental re-decoding of UTF-8 Turkish/Arabic characters.
LOCALIZED_FIELD_RE = re.compile(
    r"\b(?P<locale>tr|en|ar)\s*:\s*'(?P<text>(?:\\.|[^'\\])*)'",
    re.MULTILINE,
)
SOURCE_ARTEFACT_RE = re.compile(
    r"(?:https?://|<\/?(?:p|div|span|article|blockquote)\b|\[/?(?:quote|url)\])",
    re.IGNORECASE,
)


@dataclass(frozen=True)
class Finding:
    path: pathlib.Path
    locale: str
    marker: str
    preview: str


def _dart_unescape_for_scan(text: str) -> str:
    return text.replace("\\'", "'").replace("\\\\", "\\")


def _normalize(text: str) -> str:
    # Unicode casefold of Turkish capital İ yields "i" + COMBINING DOT ABOVE.
    # Strip combining marks after NFKD so rights markers cannot be bypassed by
    # Turkish casing/diacritics. This normalized form is only used for marker
    # matching; the original TR/EN/AR text is never rewritten.
    folded = unicodedata.normalize("NFKD", text.casefold())
    without_marks = "".join(
        char for char in folded if unicodedata.category(char) != "Mn"
    )
    return " ".join(without_marks.split())


def audit_file(path: pathlib.Path) -> tuple[int, list[Finding]]:
    source = path.read_text(encoding="utf-8")
    matches = list(LOCALIZED_FIELD_RE.finditer(source))
    findings: list[Finding] = []

    for match in matches:
        locale = match.group("locale")
        text = _dart_unescape_for_scan(match.group("text"))
        normalized = _normalize(text)

        for marker in FORBIDDEN_LOCALIZED_MARKERS:
            if _normalize(marker) in normalized:
                findings.append(
                    Finding(path, locale, marker, text[:180].replace("\n", " "))
                )

        artefact = SOURCE_ARTEFACT_RE.search(text)
        if artefact:
            findings.append(
                Finding(path, locale, artefact.group(0), text[:180].replace("\n", " "))
            )

    return len(matches), findings


def audit_tree(history_root: pathlib.Path) -> tuple[list[pathlib.Path], int, list[Finding]]:
    if not history_root.is_dir():
        raise SystemExit(f"History data directory does not exist: {history_root}")

    files = sorted(history_root.glob("*.dart"))
    if not files:
        raise SystemExit("No history Dart data files were found; T0224 cannot pass.")

    findings: list[Finding] = []
    localized_string_count = 0
    for path in files:
        count, file_findings = audit_file(path)
        localized_string_count += count
        findings.extend(file_findings)

    if localized_string_count == 0:
        raise SystemExit("No localized history strings were audited; parser coverage is zero.")

    return files, localized_string_count, findings


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--history-root",
        type=pathlib.Path,
        default=DEFAULT_HISTORY_ROOT,
        help="History data directory to audit (used by failure-path tests too).",
    )
    args = parser.parse_args(argv)

    files, localized_string_count, findings = audit_tree(args.history_root)
    if findings:
        print("T0224 history text-rights audit FAILED", file=sys.stderr)
        for finding in findings:
            relative = finding.path
            try:
                relative = finding.path.relative_to(ROOT)
            except ValueError:
                pass
            print(
                f"- {relative} [{finding.locale}] marker={finding.marker!r}: "
                f"{finding.preview}",
                file=sys.stderr,
            )
        return 1

    print(
        "T0224 history text-rights audit PASS: "
        f"{len(files)} data files / {localized_string_count} localized strings scanned; "
        "no reference/copyright boilerplate or source URLs detected in user-facing prose."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
