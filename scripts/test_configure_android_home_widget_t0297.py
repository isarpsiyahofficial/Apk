import tempfile
import unittest
from pathlib import Path
from unittest import mock

import configure_android_home_widget_t0297 as module


class ConfigureAndroidHomeWidgetT0297Test(unittest.TestCase):
    def test_generates_bridge_provider_and_resources_for_generated_package(self):
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

            self.assertIn('MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "islami_hayat/home_widget")', activity)
            self.assertIn('INVALID_WIDGET_SNAPSHOT', activity)
            self.assertIn('(languageCode != "ar" && verseTranslation.isEmpty())', activity)
            self.assertIn('class IslamiHayatWidgetProvider', provider)
            self.assertIn('(languageCode == "ar" || verseTranslation.isNotBlank())', provider)
            self.assertIn('R.id.widget_verse_translation, if (verseTranslation.isBlank()) View.GONE else View.VISIBLE', provider)
            self.assertIn('PendingIntent.FLAG_IMMUTABLE', provider)
            self.assertIn('@+id/widget_verse_arabic', layout)
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
