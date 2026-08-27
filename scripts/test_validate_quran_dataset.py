#!/usr/bin/env python3
import unittest

from validate_quran_dataset import AYAH_COUNTS, EXPECTED_AYAHS, validate_bytes


def synthetic_dataset() -> bytes:
    lines = []
    for sura, count in enumerate(AYAH_COUNTS, start=1):
        for ayah in range(1, count + 1):
            lines.append(f"{sura}:{ayah}|ا")
    return ("\n".join(lines) + "\n").encode("utf-8")


class QuranDatasetValidatorTest(unittest.TestCase):
    def test_canonical_shape_accepts_114_suras_and_6236_ayahs(self):
        result = validate_bytes(synthetic_dataset())
        self.assertEqual(result["surahs"], 114)
        self.assertEqual(result["ayahs"], EXPECTED_AYAHS)
        self.assertEqual(len(result["sha256"]), 64)

    def test_missing_ayah_fails_closed(self):
        raw = synthetic_dataset().splitlines()
        with self.assertRaisesRegex(ValueError, "Expected 6236 ayah records"):
            validate_bytes(b"\n".join(raw[:-1]) + b"\n")

    def test_duplicate_key_fails_closed(self):
        raw = synthetic_dataset().decode("utf-8").splitlines()
        raw[1] = raw[0]
        with self.assertRaisesRegex(ValueError, "Duplicate ayah key"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_empty_text_fails_closed(self):
        raw = synthetic_dataset().decode("utf-8").splitlines()
        raw[0] = "1:1|"
        with self.assertRaisesRegex(ValueError, "Empty Quran text"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))

    def test_wrong_sura_ayah_range_fails_closed(self):
        raw = synthetic_dataset().decode("utf-8").splitlines()
        raw[0] = "1:8|ا"
        with self.assertRaisesRegex(ValueError, "Invalid ayah 1:8"):
            validate_bytes(("\n".join(raw) + "\n").encode("utf-8"))


if __name__ == "__main__":
    unittest.main()
