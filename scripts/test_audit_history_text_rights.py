import pathlib
import tempfile
import unittest

from audit_history_text_rights import audit_tree


class HistoryTextRightsAuditTest(unittest.TestCase):
    def _write(self, root: pathlib.Path, body: str) -> None:
        (root / "sample.dart").write_text(body, encoding="utf-8")

    def test_editorial_localized_prose_passes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const x = LocalizedHistorySummary("
                "tr: 'Editoryal tarih özeti.', "
                "en: 'Editorial history summary.', "
                "ar: 'ملخص تاريخي تحريري.');",
            )
            files, count, findings = audit_tree(root)
            self.assertEqual(len(files), 1)
            self.assertEqual(count, 3)
            self.assertEqual(findings, [])

    def test_double_quoted_editorial_localized_prose_passes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                'const x = LocalizedHistorySummary('
                'tr: "Editoryal tarih özeti.", '
                'en: "Editorial history summary.", '
                'ar: "ملخص تاريخي تحريري.");',
            )
            files, count, findings = audit_tree(root)
            self.assertEqual(len(files), 1)
            self.assertEqual(count, 3)
            self.assertEqual(findings, [])

    def test_tdv_reference_boilerplate_in_user_text_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const x = LocalizedHistorySummary("
                "tr: 'TDV İslâm Ansiklopedisi metni', "
                "en: 'Editorial text', ar: 'نص تحريري');",
            )
            _, _, findings = audit_tree(root)
            self.assertTrue(any('tdv islâm ansiklopedisi' == item.marker for item in findings))

    def test_double_quoted_tdv_reference_boilerplate_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                'const x = LocalizedHistorySummary('
                'tr: "TDV İslâm Ansiklopedisi metni", '
                'en: "Editorial text", ar: "نص تحريري");',
            )
            _, _, findings = audit_tree(root)
            self.assertTrue(any('tdv islâm ansiklopedisi' == item.marker for item in findings))

    def test_source_url_in_localized_text_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const x = LocalizedHistorySummary("
                "tr: 'Kaynak https://example.org/article', "
                "en: 'Editorial text', ar: 'نص تحريري');",
            )
            _, _, findings = audit_tree(root)
            self.assertTrue(any(item.marker.startswith('http') for item in findings))

    def test_double_quoted_source_url_in_localized_text_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                'const x = LocalizedHistorySummary('
                'tr: "Kaynak https://example.org/article", '
                'en: "Editorial text", ar: "نص تحريري");',
            )
            _, _, findings = audit_tree(root)
            self.assertTrue(any(item.marker.startswith('http') for item in findings))

    def test_source_locator_outside_localized_text_is_allowed(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const source = HistorySourceLocator("
                "id: 'x', kind: HistorySourceKind.academicChapter, "
                "citation: 'Cambridge Core: reference', locator: 'doi:10.1/x');\n"
                "const x = LocalizedHistorySummary("
                "tr: 'Özgün özet', en: 'Original summary', ar: 'ملخص أصلي');",
            )
            _, _, findings = audit_tree(root)
            self.assertEqual(findings, [])

    def test_escaped_apostrophe_keeps_unicode_and_is_audited(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const x = LocalizedHistorySummary("
                "tr: 'İslam\\'ın tarih özeti', en: 'Editorial', ar: 'تحريري');",
            )
            _, count, findings = audit_tree(root)
            self.assertEqual(count, 3)
            self.assertEqual(findings, [])

    def test_delegated_locale_values_are_not_mistaken_for_unscanned_prose(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const seed = LocalizedHistorySummary("
                "tr: 'Özgün özet', en: 'Original summary', ar: 'ملخص أصلي');\n"
                "LocalizedHistorySummary copy(LocalizedHistorySummary value) => "
                "LocalizedHistorySummary(tr: value.tr, en: value.en, ar: value.ar);",
            )
            _, count, findings = audit_tree(root)
            self.assertEqual(count, 3)
            self.assertEqual(findings, [])

    def test_unparsed_locale_literal_fails_closed(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(
                root,
                "const x = LocalizedHistorySummary("
                "tr: '''çok satırlı editoryal metin''', "
                "en: 'Editorial', ar: 'تحريري');",
            )
            _, count, findings = audit_tree(root)
            self.assertEqual(count, 2)
            self.assertTrue(
                any(item.marker == 'unparsed localized literal syntax' for item in findings)
            )

    def test_zero_parser_coverage_fails_closed(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self._write(root, "const sourceOnly = 'no localized content';")
            with self.assertRaises(SystemExit):
                audit_tree(root)


if __name__ == '__main__':
    unittest.main()