import unittest

from audit_localization_contract_t0340 import audit_catalogs


class LocalizationContractT0340Test(unittest.TestCase):
    def _catalogs(self):
        return {
            "tr": {"@@locale": "tr", "title": "Başlık", "count": "{count} kayıt"},
            "en": {"@@locale": "en", "title": "Title", "count": "{count} records"},
            "ar": {"@@locale": "ar", "title": "العنوان", "count": "{count} سجلات"},
        }

    def _codes(self, catalogs):
        return {failure.code for failure in audit_catalogs(catalogs)}

    def test_valid_catalogs_pass(self):
        self.assertEqual([], audit_catalogs(self._catalogs()))

    def test_missing_key_fails_closed(self):
        catalogs = self._catalogs()
        del catalogs["ar"]["title"]
        self.assertIn("missing-keys", self._codes(catalogs))

    def test_extra_key_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["en"]["extra"] = "Extra"
        self.assertIn("extra-keys", self._codes(catalogs))

    def test_wrong_locale_marker_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["ar"]["@@locale"] = "en"
        self.assertIn("locale-marker", self._codes(catalogs))

    def test_blank_value_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["tr"]["title"] = "   "
        self.assertIn("blank-value", self._codes(catalogs))

    def test_placeholder_drift_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["en"]["count"] = "{total} records"
        self.assertIn("placeholder-drift", self._codes(catalogs))

    def test_arabic_script_in_english_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["en"]["title"] = "العنوان"
        self.assertIn("arabic-script-leak", self._codes(catalogs))

    def test_turkish_specific_letters_in_arabic_fails_closed(self):
        catalogs = self._catalogs()
        catalogs["ar"]["title"] = "Bugün"
        self.assertIn("turkish-letter-leak", self._codes(catalogs))

    def test_latin_source_names_are_allowed_in_arabic(self):
        catalogs = self._catalogs()
        catalogs["ar"]["title"] = "Google Play PRO SHA-256"
        self.assertNotIn("turkish-letter-leak", self._codes(catalogs))


if __name__ == "__main__":
    unittest.main()
