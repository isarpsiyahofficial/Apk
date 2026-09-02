import tempfile
import unittest
from pathlib import Path
from unittest import mock

import configure_android_home_widget_t0297 as module


class ConfigureAndroidHomeWidgetT0297Test(unittest.TestCase):
    def test_generates_bridge_provider_and_localized_resources_for_generated_package(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            main = root / "android/app/src/main/kotlin/com/example/islami_hayat/MainActivity.kt"
            main.parent.mkdir(parents=True)
            main.write_text(
                "package com.example.islami_hayat\n\nimport io.flutter.embedding.android.FlutterActivity\nclass MainActivity: FlutterActivity()\n",
                encoding="utf-8",
            )
            with mock.patch.object(module, "ROOT", root), mock.patch.object(
                module, "ANDROID_MAIN", root / "android/app/src/main"
            ):
                module.configure()

            activity = main.read_text(encoding="utf-8")
            provider = (main.parent / "IslamiHayatWidgetProvider.kt").read_text(encoding="utf-8")
            layout = (root / "android/app/src/main/res/layout/islami_hayat_widget.xml").read_text(encoding="utf-8")
            info = (root / "android/app/src/main/res/xml/islami_hayat_widget_info.xml").read_text(encoding="utf-8")
            strings_en = (root / "android/app/src/main/res/values/islami_hayat_widget_strings.xml").read_text(encoding="utf-8")
            strings_tr = (root / "android/app/src/main/res/values-tr/islami_hayat_widget_strings.xml").read_text(encoding="utf-8")
            strings_ar = (root / "android/app/src/main/res/values-ar/islami_hayat_widget_strings.xml").read_text(encoding="utf-8")

            self.assertIn('MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "islami_hayat/home_widget")', activity)
            self.assertIn('INVALID_WIDGET_SNAPSHOT', activity)
            self.assertIn('(languageCode != "ar" && verseTranslation.isEmpty())', activity)
            self.assertIn('class IslamiHayatWidgetProvider', provider)
            self.assertIn('(languageCode == "ar" || verseTranslation.isNotBlank())', provider)
            self.assertIn('R.id.widget_verse_translation, if (verseTranslation.isBlank()) View.GONE else View.VISIBLE', provider)
            self.assertIn('PendingIntent.FLAG_IMMUTABLE', provider)
            self.assertIn('@+id/widget_verse_arabic', layout)
            self.assertIn('@string/islami_hayat_widget_empty', layout)
            self.assertNotIn('android:text="İslami Hayat"', layout)
            self.assertIn('Open Islami Hayat to prepare today’s widget.', strings_en)
            self.assertIn('Bugünün widget’ını hazırlamak için İslami Hayat’ı açın.', strings_tr)
            self.assertIn('افتح إسلامي حيات لإعداد أداة اليوم.', strings_ar)
            self.assertIn('android:resizeMode="horizontal|vertical"', info)
            self.assertNotIn('@string/app_name', info)

    def test_rejects_missing_generated_main_activity(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            with mock.patch.object(module, "ROOT", root), mock.patch.object(
                module, "ANDROID_MAIN", root / "android/app/src/main"
            ):
                with self.assertRaisesRegex(RuntimeError, "Expected exactly one"):
                    module.configure()


if __name__ == "__main__":
    unittest.main()
