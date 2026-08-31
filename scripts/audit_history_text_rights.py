#!/usr/bin/env python3
"""Fail-closed audit for user-facing Islamic history prose.

T0224 exists to keep reference works (including TDV Islam Ansiklopedisi),
academic books, articles and websites in a verification/citation role unless an
explicit redistribution licence permits verbatim reuse. This script does not
copy or download reference prose. Instead it audits every Dart history data
file and fails when reference-site/copyright boilerplate leaks into localized
TR/EN/AR strings or when obvious long-form verbatim/source markup is embedded
there.

The audit is intentionally conservative: source citations and locators may name
publishers/DOIs outside LocalizedHistorySummary fields; user-facing prose may
not contain those source-site artefacts.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
from dataclasses import dataclass

ROOT = pathlib.Path(__file__).resolve().parents[1]
DEFAULT_HISTORY_ROOT = ROOT / "lib" / "features" / "history" / "data"

# Strings that belong to a source/reference interface or copyright notice,
# never to editorial user-facing history narration.
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

# Extract Dart single-quoted strings assigned to localized TR/EN/AR fields.
# Current history datasets use these fields for all user-facing summaries.
LOCALIZED_FIELD_RE = re.compile(
    r"\b(?P<locale>tr|en|ar)\s*:\s*'(?P<text>(?:\\.|[^'\\])*)'",
    re.MULTILINE,
)

# Source/article HTML or block-copy artefacts should never be present inside
# localized prose even if a forbidden publisher name is absent.
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


def _normalize(text: str) -> str:
    return " ".join(text.casefold().split())


def audit_file(path: pathlib.Path) -> list[Finding]:
    source = path.read_text(encoding="utf-8")
    findings: list[Finding] = []

    for match in LOCALIZED_FIELD_RE.finditer(source):
        locale = match.group("locale")
        text = bytes(match.group("text"), "utf-8").decode("unicode_escape") if "\\" in match.group("text") else match.group("text")
        normalized = _normalize(text)

        for marker in FORBIDDEN_LOCALIZED_MARKERS:
            if marker.casefold() in normalized:
                findings.append(
                    Finding(path, locale, marker, text[:180].replace("\n", " "))
                )

        artefact = SOURCE_ARTEFACT_RE.search(text)
        if artefact:
            findings.append(
                Finding(path, locale, artefact.group(0), text[:180].replace("\n", " "))
            )

    return findings


def audit_tree(history_root: pathlib.Path) -> tuple[list[pathlib.Path], list[Finding]]:
    if not history_root.is_dir():
        raise SystemExit(f"History data directory does not exist: {history_root}")

    files = sorted(history_root.glob("*.dart"))
    if not files:
        raise SystemExit("No history Dart data files were found; T0224 cannot pass.")

    findings: list[Finding] = []
    localized_string_count = 0
    for path in files:
        source = path.read_text(encoding="utf-8")
        localized_string_count += len(list(LOCALIZED_FIELD_RE.finditer(source)))
        findings.extend(audit_file(path))

    if localized_string_count == 0:
        raise SystemExit("No localized history strings were audited; parser coverage is zero.")

    return files, findings


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--history-root",
        type=pathlib.Path,
        default=DEFAULT_HISTORY_ROOT,
        help="History data directory to audit (used by failure-path tests too).",
    )
    args = parser.parse_args(argv)

    files, findings = audit_tree(args.history_root)
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
        f"{len(files)} history data files scanned; no reference/copyright "
        "boilerplate or source URLs detected in localized user-facing prose."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
