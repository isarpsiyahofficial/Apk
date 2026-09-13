#!/usr/bin/env python3
import hashlib
import unittest

from validate_quran_dataset import AYAH_COUNTS, EXPECTED_AYAHS, validate_bytes


def synthetic_dataset(
    layout: str = "locator",
    newline: str = "\n",
    footer: list[str] | None = None,
) -> bytes:
    lines = []
    for sura, count in enumerate(AYAH_COUNTS, start=1):
        for ayah in range(1, count + 1):
            if layout == "locator":
                lines.append(f"{sura}:{ayah}|ا")
            elif layout == "numbered":
                lines.append(f"{sura}|{ayah}|ا")
            elif layout == "plain":
                lines.append("ا")
            else:
                raise AssertionError(layout)
    if footer:
        lines.extend(footer)
    return (newline.join(lines) + newline).encode("utf-8")


class QuranDatasetValidatorTest(unittest.TestCase):
    def test_legacy_locator_shape_accepts_complete_quran(self):
        result = validate_bytes(synthetic_dataset("locator"))
        self.assertEqual(result["surahs"], 114)
        self.assertEqual(result["ayahs"], EXPECTED_AYAHS)
        self.assertEqual(result["layout"], "sura:ayah|text")
        self.assertEqual(result["footer_lines"], 0)

    def test_numbered_tanzil_shape_accepts_complete_quran(self):
        result = validate_bytes(synthetic_dataset("numbered"))
        self.assertEqual(result["layout"], "sura|ayah|text")

    def test_plain_tanzil_shape_derives_only_locator_metadata(self):
        raw = synthetic_dataset("plain")
        result = validate_bytes(raw)
        self.assertEqual(result["layout"], "plain")
        self.assertEqual(result["sha256"], hashlib.sha256(raw).hexdigest())

    def test_tanzil_comment_footer_is_preserved_and_accepted(self):
        raw = synthetic_dataset(
            "numbered",
            footer=[
                "",
                "# Tanzil Quran Text",
                "# Creative Commons Attribution 3.0",
                "# https://tanzil.net/",
            ],
        )
        result = validate_bytes(raw)
        self.assertEqual(result["footer_lines"], 4)
        self.assertEqual(result["sha256"], hashlib.sha256(raw).hexdigest())

    def test_unexpected_content_after_quran_fails_closed(self):
        raw = synthetic_dataset("numbered", footer=["unexpected content"])
        with self.assertRaisesRegex(ValueError, "Unexpected non-comment content"):
            validate_bytes(raw)

    def test_hash_preserves_exact_newline_bytes(self):
        lf = synthetic_dataset("plain", "\n", footer=["# license"])
        crlf = synthetic_dataset("plain", "\r\n", footer=["# license"])
        lf_result = validate_bytes(lf)
        crlf_result = validate_bytes(crlf)
        self.assertNotEqual(lf_result["sha256"], crlf_result["sha256"])
        self.assertEqual(lf_result["sha256"], hashlib.sha256(lf).hexdigest())
        self.assertEqual(crlf_result["sha256"], hashlib.sha256(crlf).hexdigest())

    def test_missing_ayah_fails_closed(self):
        raw = synthetic_dataset().splitlines()
        with self.assertRaisesRegex(ValueError, "Expected 6236 ayah records"):
            validate_bytes(b"\n".join(raw[:-1]) + b"\n")

    def test_wrong_order_fails_closed(self):
        raw = synthetic_dataset("numbered").decode("utf-8").splitlines()
        raw[0], raw[1] = raw[1], raw[0]
        with self.assertRaisesRegex(ValueError, "Unexpected Quran order"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_duplicate_key_fails_closed(self):
        raw = synthetic_dataset("numbered").decode("utf-8").splitlines()
        raw[1] = raw[0]
        with self.assertRaisesRegex(ValueError, "Unexpected Quran order|Duplicate ayah key"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_empty_text_fails_closed(self):
        raw = synthetic_dataset("numbered").decode("utf-8").splitlines()
        raw[0] = "1|1|"
        with self.assertRaisesRegex(ValueError, "Empty Quran text"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_wrong_sura_ayah_range_fails_closed(self):
        raw = synthetic_dataset("numbered").decode("utf-8").splitlines()
        raw[0] = "1|8|ا"
        with self.assertRaisesRegex(ValueError, "Invalid ayah 1:8"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_mixed_layout_fails_closed(self):
        raw = synthetic_dataset("plain").decode("utf-8").splitlines()
        raw[0] = "1|1|ا"
        with self.assertRaisesRegex(ValueError, "Mixed dataset layouts"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))


if __name__ == "__main__":
    unittest.main()
