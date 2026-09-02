import tempfile
import unittest
from pathlib import Path
from unittest import mock

import configure_android_home_widget_t0297 as module


class ConfigureAndroidHomeWidgetT0297Test(unittest.TestCase):
    def test_generates_bridge_provider_and_app_selected_language_resources(self):
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
            strings = (root / "android/app/src/main/res/values/islami_hayat_widget_strings.xml").read_text(encoding="utf-8")

            self.assertIn('MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "islami_hayat/home_widget")', activity)
            self.assertIn('INVALID_WIDGET_SNAPSHOT', activity)
            self.assertIn('call.argument<String>("civilDateKey")', activity)
            self.assertIn('.putString("civilDateKey", civilDateKey)', activity)
            self.assertIn('Regex("\\\\d{4}-\\\\d{2}-\\\\d{2}")', activity)
            self.assertIn('(languageCode != "ar" && verseTranslation.isEmpty())', activity)
            self.assertIn('class IslamiHayatWidgetProvider', provider)
            self.assertIn('civilDateKey == currentCivilDateKey()', provider)
            self.assertIn('val hasContent = isCurrentCivilDate &&', provider)
            self.assertIn('private fun currentCivilDateKey()', provider)
            self.assertIn('(languageCode == "ar" || verseTranslation.isNotBlank())', provider)
            self.assertIn('if (hasContent) verseArabic else ""', provider)
            self.assertIn('R.id.widget_verse_translation, if (hasContent && verseTranslation.isNotBlank()) View.VISIBLE else View.GONE', provider)
            self.assertIn('PendingIntent.FLAG_IMMUTABLE', provider)

            # Empty-state language must follow the language stored in the app
            # snapshot rather than Android's independently configured locale.
            self.assertIn('val emptyTextRes = when (languageCode)', provider)
            self.assertIn('"tr" -> R.string.islami_hayat_widget_empty_tr', provider)
            self.assertIn('"ar" -> R.string.islami_hayat_widget_empty_ar', provider)
            self.assertIn('else -> R.string.islami_hayat_widget_empty_en', provider)
            self.assertIn('context.getString(emptyTextRes)', provider)

            self.assertIn('@+id/widget_verse_arabic', layout)
            self.assertIn('@string/islami_hayat_widget_empty_en', layout)
            self.assertNotIn('android:text="İslami Hayat"', layout)
            self.assertIn('name="islami_hayat_widget_empty_en"', strings)
            self.assertIn('Open Islami Hayat to prepare today’s widget.', strings)
            self.assertIn('name="islami_hayat_widget_empty_tr"', strings)
            self.assertIn('Bugünün widget’ını hazırlamak için İslami Hayat’ı açın.', strings)
            self.assertIn('name="islami_hayat_widget_empty_ar"', strings)
            self.assertIn('افتح إسلامي حيات لإعداد أداة اليوم.', strings)
            self.assertFalse((root / "android/app/src/main/res/values-tr/islami_hayat_widget_strings.xml").exists())
            self.assertFalse((root / "android/app/src/main/res/values-ar/islami_hayat_widget_strings.xml").exists())
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