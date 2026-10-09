import tempfile
import unittest
from pathlib import Path
from unittest import mock

import configure_android_share_t0251 as module


class ConfigureAndroidShareT0251Test(unittest.TestCase):
    def test_materializes_combined_main_activity_bridge_paths_and_debug_probe(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            main = root / "android/app/src/main/kotlin/com/example/islami_hayat/MainActivity.kt"
            main.parent.mkdir(parents=True)
            main.write_text(
                "package com.example.islami_hayat\nclass MainActivity\n",
                encoding="utf-8",
            )
            debug_manifest = root / "android/app/src/debug/AndroidManifest.xml"
            debug_manifest.parent.mkdir(parents=True)
            debug_manifest.write_text(
                '<manifest xmlns:android="http://schemas.android.com/apk/res/android">\n'
                '    <application>\n'
                '        <activity android:name=".WidgetPinSmokeActivity" />\n'
                '    </application>\n'
                '</manifest>\n',
                encoding="utf-8",
            )

            with mock.patch.object(module, "ROOT", root), mock.patch.object(
                module, "ANDROID_MAIN", root / "android/app/src/main"
            ):
                module.configure()

            activity = main.read_text(encoding="utf-8")
            bridge = (main.parent / "ShareSheetBridgeT0251.kt").read_text(encoding="utf-8")
            paths = (root / "android/app/src/main/res/xml/islami_hayat_share_paths.xml").read_text(
                encoding="utf-8"
            )
            smoke = (
                root
                / "android/app/src/debug/kotlin/com/example/islami_hayat/ShareSheetSmokeActivity.kt"
            ).read_text(encoding="utf-8")
            manifest = debug_manifest.read_text(encoding="utf-8")

            self.assertIn('"islami_hayat/home_widget"', activity)
            self.assertIn('"islami_hayat/share_t0251"', activity)
            self.assertIn('call.argument<ByteArray>("pngBytes")', activity)
            self.assertIn('ShareSheetBridgeT0251(this)', activity)
            self.assertIn('INVALID_SHARE_REQUEST', activity)

            self.assertIn('FileProvider.getUriForFile', bridge)
            self.assertIn('.share.fileprovider', bridge)
            self.assertIn('Intent.FLAG_GRANT_READ_URI_PERMISSION', bridge)
            self.assertIn('com.instagram.share.ADD_TO_STORY', bridge)
            self.assertIn('com.instagram.android', bridge)
            self.assertIn('com.whatsapp', bridge)
            self.assertIn('com.whatsapp.w4b', bridge)
            self.assertIn('Intent.createChooser', bridge)
            self.assertIn('return "package_unavailable"', bridge)
            self.assertNotIn('Uri.fromFile', bridge)

            self.assertIn('<cache-path', paths)
            self.assertIn('path="share_exports/"', paths)
            self.assertIn('class ShareSheetSmokeActivity : Activity()', smoke)
            self.assertIn('class ShareSinkActivity : Activity()', smoke)
            self.assertIn('contentResolver.openInputStream', smoke)
            self.assertIn('uri.scheme == "content"', smoke)
            self.assertIn('received_png', smoke)

            self.assertIn('android:name=".ShareSheetSmokeActivity"', manifest)
            self.assertIn('android:name=".ShareSinkActivity"', manifest)
            self.assertIn('android:mimeType="image/png"', manifest)
            self.assertIn('T0251 Share Sink', manifest)
            self.assertIn('.WidgetPinSmokeActivity', manifest)

    def test_requires_t0297_debug_manifest_to_exist(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            main = root / "android/app/src/main/kotlin/com/example/islami_hayat/MainActivity.kt"
            main.parent.mkdir(parents=True)
            main.write_text("package com.example.islami_hayat\nclass MainActivity\n", encoding="utf-8")
            with mock.patch.object(module, "ROOT", root), mock.patch.object(
                module, "ANDROID_MAIN", root / "android/app/src/main"
            ):
                with self.assertRaisesRegex(RuntimeError, "after T0297"):
                    module.configure()


if __name__ == "__main__":
    unittest.main()
