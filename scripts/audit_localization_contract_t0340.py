#!/usr/bin/env python3
"""Fail-closed localization contract audit for T0340-T0343.

This audit intentionally covers deterministic release invariants that can be
proved from source control without pretending that static checks replace the
required full UI crawl/snapshot pass:

* TR/EN/AR catalogs must expose the exact same message-key set.
* @@locale markers must match the catalog file.
* User-facing values must not be blank.
* ICU-style placeholder names must stay identical in every locale.
* Turkish-specific letters leaking into EN/AR are rejected.
* Arabic-script text leaking into EN/TR is rejected.

Dynamic route/snapshot/RTL behavior remains a separate TEST_MATRIX gate.
"""

from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, Mapping, Set

ROOT = Path(__file__).resolve().parents[1]
L10N_DIR = ROOT / "lib" / "l10n"
CATALOGS = {
    "tr": L10N_DIR / "app_tr.arb",
    "en": L10N_DIR / "app_en.arb",
    "ar": L10N_DIR / "app_ar.arb",
}

_PLACEHOLDER = re.compile(r"\{([A-Za-z][A-Za-z0-9_]*)\}")
_ARABIC_SCRIPT = re.compile(r"[\u0600-\u06ff\u0750-\u077f\u08a0-\u08ff]")
_TURKISH_SPECIFIC = re.compile(r"[çğıöşüÇĞİÖŞÜ]")


@dataclass(frozen=True)
class AuditFailure:
    code: str
    detail: str

    def __str__(self) -> str:
        return f"{self.code}: {self.detail}"


def load_catalog(path: Path) -> Dict[str, object]:
    with path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
    if not isinstance(payload, dict):
        raise ValueError(f"catalog root must be an object: {path}")
    return payload


def message_values(catalog: Mapping[str, object]) -> Dict[str, str]:
    result: Dict[str, str] = {}
    for key, value in catalog.items():
        if key.startswith("@"):
            continue
        if not isinstance(value, str):
            raise ValueError(f"message {key!r} must be a string")
        result[key] = value
    return result


def placeholders(value: str) -> Set[str]:
    return set(_PLACEHOLDER.findall(value))


def audit_catalogs(catalogs: Mapping[str, Mapping[str, object]]) -> list[AuditFailure]:
    failures: list[AuditFailure] = []
    messages = {locale: message_values(catalog) for locale, catalog in catalogs.items()}

    for locale, catalog in catalogs.items():
        marker = catalog.get("@@locale")
        if marker != locale:
            failures.append(
                AuditFailure("locale-marker", f"{locale}: @@locale={marker!r}"),
            )

    reference_keys = set(messages["tr"])
    for locale in ("en", "ar"):
        keys = set(messages[locale])
        missing = sorted(reference_keys - keys)
        extra = sorted(keys - reference_keys)
        if missing:
            failures.append(
                AuditFailure("missing-keys", f"{locale}: {', '.join(missing)}"),
            )
        if extra:
            failures.append(
                AuditFailure("extra-keys", f"{locale}: {', '.join(extra)}"),
            )

    common_keys = set.intersection(*(set(values) for values in messages.values()))
    for key in sorted(common_keys):
        expected_placeholders = placeholders(messages["tr"][key])
        for locale in ("tr", "en", "ar"):
            value = messages[locale][key]
            if not value.strip():
                failures.append(AuditFailure("blank-value", f"{locale}:{key}"))
            actual_placeholders = placeholders(value)
            if actual_placeholders != expected_placeholders:
                failures.append(
                    AuditFailure(
                        "placeholder-drift",
                        f"{locale}:{key} expected={sorted(expected_placeholders)} "
                        f"actual={sorted(actual_placeholders)}",
                    ),
                )

            # Directional leakage checks are deliberately conservative. Arabic
            # may legitimately contain Latin product/source names (PRO,
            # Google Play, SHA-256), so Latin characters are not banned there.
            if locale in {"tr", "en"} and _ARABIC_SCRIPT.search(value):
                failures.append(
                    AuditFailure("arabic-script-leak", f"{locale}:{key}"),
                )
            if locale in {"en", "ar"} and _TURKISH_SPECIFIC.search(value):
                failures.append(
                    AuditFailure("turkish-letter-leak", f"{locale}:{key}"),
                )

    return failures


def audit_files(paths: Mapping[str, Path] = CATALOGS) -> list[AuditFailure]:
    catalogs = {locale: load_catalog(path) for locale, path in paths.items()}
    return audit_catalogs(catalogs)


def main() -> int:
    failures = audit_files()
    if failures:
        print("Localization contract audit FAILED:", file=sys.stderr)
        for failure in failures:
            print(f" - {failure}", file=sys.stderr)
        return 1

    count = len(message_values(load_catalog(CATALOGS["tr"])))
    print(
        f"Localization contract audit PASS: {count} message keys are aligned "
        "across TR/EN/AR with placeholder and conservative leakage checks."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
