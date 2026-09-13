from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ANDROID_MAIN = ROOT / "android" / "app" / "src" / "main"
WIDGET_CHANNEL = "islami_hayat/home_widget"
SHARE_CHANNEL = "islami_hayat/share_t0251"
WIDGET_PREFS = "islami_hayat_widget"
SHARE_SMOKE_PREFS = "islami_hayat_share_t0251_smoke"


def _main_activity() -> Path:
    candidates = list((ANDROID_MAIN / "kotlin").rglob("MainActivity.kt"))
    if len(candidates) != 1:
        raise RuntimeError(f"Expected exactly one generated MainActivity.kt, found {len(candidates)}")
    return candidates[0]


def _package_name(main_activity: Path) -> str:
    text = main_activity.read_text(encoding="utf-8")
    match = re.search(r"^package\s+([A-Za-z0-9_.]+)\s*$", text, re.MULTILINE)
    if match is None:
        raise RuntimeError("Generated MainActivity.kt has no package declaration")
    return match.group(1)


def configure() -> None:
    main_activity = _main_activity()
    package_name = _package_name(main_activity)
    package_dir = main_activity.parent

    main_activity.write_text(_main_activity_source(package_name), encoding="utf-8")
    (package_dir / "ShareSheetBridgeT0251.kt").write_text(
        _share_bridge_source(package_name), encoding="utf-8"
    )

    xml_dir = ANDROID_MAIN / "res" / "xml"
    xml_dir.mkdir(parents=True, exist_ok=True)
    (xml_dir / "islami_hayat_share_paths.xml").write_text(SHARE_PATHS, encoding="utf-8")

    debug_package_dir = ROOT / "android" / "app" / "src" / "debug" / "kotlin" / Path(
        package_name.replace(".", "/")
    )
    debug_package_dir.mkdir(parents=True, exist_ok=True)
    (debug_package_dir / "ShareSheetSmokeActivity.kt").write_text(
        _share_smoke_source(package_name), encoding="utf-8"
    )

    debug_manifest = ROOT / "android" / "app" / "src" / "debug" / "AndroidManifest.xml"
    if not debug_manifest.exists():
        raise RuntimeError("T0251 must run after T0297 debug manifest materialization")
    manifest_text = debug_manifest.read_text(encoding="utf-8")
    marker = "    </application>"
    if marker not in manifest_text:
        raise RuntimeError("Debug AndroidManifest.xml has no application closing marker")
    insertion = '''        <activity
            android:name=".ShareSheetSmokeActivity"
            android:exported="true"
            android:excludeFromRecents="true" />
        <activity
            android:name=".ShareSinkActivity"
            android:label="T0251 Share Sink"
            android:exported="true"
            android:excludeFromRecents="true">
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/png" />
            </intent-filter>
        </activity>
'''
    if ".ShareSheetSmokeActivity" not in manifest_text:
        manifest_text = manifest_text.replace(marker, insertion + marker)
        debug_manifest.write_text(manifest_text, encoding="utf-8")

    print(f"Configured T0251 Android share bridge for package {package_name}")


def _main_activity_source(package_name: str) -> str:
    return f'''package {package_name}

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {{
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {{
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "{WIDGET_CHANNEL}")
            .setMethodCallHandler {{ call, result ->
                if (call.method != "updateWidget") {{
                    result.notImplemented()
                    return@setMethodCallHandler
                }}

                val civilDateKey = call.argument<String>("civilDateKey")?.trim().orEmpty()
                val languageCode = call.argument<String>("languageCode")?.trim().orEmpty()
                val verseArabic = call.argument<String>("verseArabic")?.trim().orEmpty()
                val verseTranslation = call.argument<String>("verseTranslation")?.trim().orEmpty()
                val duaText = call.argument<String>("duaText")?.trim().orEmpty()
                val proVisualsEnabled = call.argument<Boolean>("proVisualsEnabled") ?: false

                if (!Regex("\\\\d{{4}}-\\\\d{{2}}-\\\\d{{2}}").matches(civilDateKey) ||
                    languageCode !in setOf("tr", "en", "ar") ||
                    verseArabic.isEmpty() || duaText.isEmpty() ||
                    (languageCode != "ar" && verseTranslation.isEmpty())) {{
                    result.error("INVALID_WIDGET_SNAPSHOT", "Widget snapshot is incomplete or unsupported.", null)
                    return@setMethodCallHandler
                }}

                getSharedPreferences("{WIDGET_PREFS}", Context.MODE_PRIVATE)
                    .edit()
                    .putString("civilDateKey", civilDateKey)
                    .putString("languageCode", languageCode)
                    .putString("verseArabic", verseArabic)
                    .putString("verseTranslation", verseTranslation)
                    .putString("duaText", duaText)
                    .putBoolean("proVisualsEnabled", proVisualsEnabled)
                    .apply()

                val manager = AppWidgetManager.getInstance(this)
                val component = ComponentName(this, IslamiHayatWidgetProvider::class.java)
                val ids = manager.getAppWidgetIds(component)
                IslamiHayatWidgetProvider.updateAll(this, manager, ids)
                result.success(true)
            }}

        val shareBridge = ShareSheetBridgeT0251(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "{SHARE_CHANNEL}")
            .setMethodCallHandler {{ call, result ->
                if (call.method != "sharePng") {{
                    result.notImplemented()
                    return@setMethodCallHandler
                }}
                try {{
                    val pngBytes = call.argument<ByteArray>("pngBytes")
                    val destination = call.argument<String>("destination")?.trim().orEmpty()
                    val format = call.argument<String>("format")?.trim().orEmpty()
                    result.success(shareBridge.sharePng(pngBytes, destination, format))
                }} catch (error: IllegalArgumentException) {{
                    result.error("INVALID_SHARE_REQUEST", error.message, null)
                }} catch (error: Exception) {{
                    result.error("SHARE_FAILED", "Android share sheet launch failed.", error.javaClass.simpleName)
                }}
            }}
    }}
}}
'''


def _share_bridge_source(package_name: str) -> str:
    return f'''package {package_name}

import android.app.Activity
import android.content.ClipData
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File

class ShareSheetBridgeT0251(private val activity: Activity) {{
    companion object {{
        private const val MAX_PNG_BYTES = 16 * 1024 * 1024
        private const val INSTAGRAM_PACKAGE = "com.instagram.android"
        private const val WHATSAPP_PACKAGE = "com.whatsapp"
        private const val WHATSAPP_BUSINESS_PACKAGE = "com.whatsapp.w4b"
        private const val INSTAGRAM_STORY_ACTION = "com.instagram.share.ADD_TO_STORY"
        private val PNG_SIGNATURE = byteArrayOf(
            0x89.toByte(), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        )
    }}

    fun sharePng(pngBytes: ByteArray?, destination: String, format: String): String {{
        requireValidRequest(pngBytes, destination, format)
        val bytes = pngBytes!!
        val directory = File(activity.cacheDir, "share_exports").apply {{ mkdirs() }}
        val file = File(directory, "share-${{System.nanoTime()}}.png")
        file.writeBytes(bytes)
        val uri = FileProvider.getUriForFile(
            activity,
            "${{activity.packageName}}.share.fileprovider",
            file,
        )

        return when (destination) {{
            "instagramStory" -> launchInstagramStory(uri)
            "whatsapp" -> launchWhatsApp(uri)
            "general" -> launchGeneral(uri)
            else -> throw IllegalArgumentException("Unsupported T0251 destination.")
        }}
    }}

    private fun requireValidRequest(pngBytes: ByteArray?, destination: String, format: String) {{
        if (pngBytes == null || pngBytes.size < PNG_SIGNATURE.size || pngBytes.size > MAX_PNG_BYTES) {{
            throw IllegalArgumentException("T0251 requires a bounded PNG payload.")
        }}
        for (index in PNG_SIGNATURE.indices) {{
            if (pngBytes[index] != PNG_SIGNATURE[index]) {{
                throw IllegalArgumentException("T0251 payload is not PNG.")
            }}
        }}
        val validFormats = setOf("instagramStory916", "whatsappStatus916", "instagramPost45", "square11")
        if (format !in validFormats) {{
            throw IllegalArgumentException("Unsupported T0251 share format.")
        }}
        if (destination == "instagramStory" && format != "instagramStory916") {{
            throw IllegalArgumentException("Instagram Story requires canonical 9:16 Story output.")
        }}
        if (destination == "whatsapp" && format == "instagramStory916") {{
            throw IllegalArgumentException("WhatsApp requires Status/Post output.")
        }}
    }}

    private fun launchInstagramStory(uri: Uri): String {{
        val intent = Intent(INSTAGRAM_STORY_ACTION).apply {{
            setDataAndType(uri, "image/png")
            setPackage(INSTAGRAM_PACKAGE)
            clipData = ClipData.newRawUri("islami_hayat_share", uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }}
        if (intent.resolveActivity(activity.packageManager) == null) {{
            return "package_unavailable"
        }}
        activity.grantUriPermission(INSTAGRAM_PACKAGE, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        activity.startActivity(intent)
        return "launched"
    }}

    private fun launchWhatsApp(uri: Uri): String {{
        for (targetPackage in listOf(WHATSAPP_PACKAGE, WHATSAPP_BUSINESS_PACKAGE)) {{
            val intent = baseSendIntent(uri).apply {{ setPackage(targetPackage) }}
            if (intent.resolveActivity(activity.packageManager) != null) {{
                activity.grantUriPermission(targetPackage, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
                activity.startActivity(intent)
                return "launched"
            }}
        }}
        return "package_unavailable"
    }}

    private fun launchGeneral(uri: Uri): String {{
        val sendIntent = baseSendIntent(uri)
        if (sendIntent.resolveActivity(activity.packageManager) == null) {{
            return "package_unavailable"
        }}
        activity.startActivity(Intent.createChooser(sendIntent, null))
        return "launched"
    }}

    private fun baseSendIntent(uri: Uri): Intent = Intent(Intent.ACTION_SEND).apply {{
        type = "image/png"
        putExtra(Intent.EXTRA_STREAM, uri)
        clipData = ClipData.newRawUri("islami_hayat_share", uri)
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    }}
}}
'''


def _share_smoke_source(package_name: str) -> str:
    return f'''package {package_name}

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle

class ShareSheetSmokeActivity : Activity() {{
    override fun onCreate(savedInstanceState: Bundle?) {{
        super.onCreate(savedInstanceState)
        val destination = intent.getStringExtra("destination") ?: "general"
        val format = intent.getStringExtra("format") ?: "instagramStory916"
        val prefs = getSharedPreferences("{SHARE_SMOKE_PREFS}", Context.MODE_PRIVATE)
        prefs.edit().clear().commit()
        val result = try {{
            ShareSheetBridgeT0251(this).sharePng(PNG_BYTES, destination, format)
        }} catch (error: IllegalArgumentException) {{
            "invalid_request"
        }} catch (error: Exception) {{
            "exception:${{error.javaClass.simpleName}}"
        }}
        prefs.edit()
            .putString("status", result)
            .putString("destination", destination)
            .putString("format", format)
            .commit()
        if (result != "launched") finish()
    }}

    companion object {{
        private val PNG_BYTES = byteArrayOf(
            0x89.toByte(), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00,
        )
    }}
}}

class ShareSinkActivity : Activity() {{
    override fun onCreate(savedInstanceState: Bundle?) {{
        super.onCreate(savedInstanceState)
        val prefs = getSharedPreferences("{SHARE_SMOKE_PREFS}", Context.MODE_PRIVATE)
        val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM) ?: intent.data
        var readablePng = false
        if (uri != null && uri.scheme == "content") {{
            readablePng = try {{
                contentResolver.openInputStream(uri)?.use {{ stream ->
                    val header = ByteArray(8)
                    stream.read(header) == 8 &&
                        header.contentEquals(byteArrayOf(
                            0x89.toByte(), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
                        ))
                }} ?: false
            }} catch (_: Exception) {{
                false
            }}
        }}
        prefs.edit()
            .putString("sinkStatus", if (readablePng) "received_png" else "unreadable")
            .putString("sinkUriScheme", uri?.scheme ?: "")
            .commit()
        finish()
    }}
}}
'''


SHARE_PATHS = '''<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <cache-path
        name="share_exports"
        path="share_exports/" />
</paths>
'''


if __name__ == "__main__":
    configure()
