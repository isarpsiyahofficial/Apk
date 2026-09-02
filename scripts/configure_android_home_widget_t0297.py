from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ANDROID_MAIN = ROOT / "android" / "app" / "src" / "main"
CHANNEL = "islami_hayat/home_widget"
PREFS = "islami_hayat_widget"


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

    main_activity.write_text(_main_activity_source(package_name), encoding="utf-8")
    (main_activity.parent / "IslamiHayatWidgetProvider.kt").write_text(
        _provider_source(package_name), encoding="utf-8"
    )

    layout_dir = ANDROID_MAIN / "res" / "layout"
    xml_dir = ANDROID_MAIN / "res" / "xml"
    values_dir = ANDROID_MAIN / "res" / "values"
    for directory in (layout_dir, xml_dir, values_dir):
        directory.mkdir(parents=True, exist_ok=True)

    (layout_dir / "islami_hayat_widget.xml").write_text(WIDGET_LAYOUT, encoding="utf-8")
    (xml_dir / "islami_hayat_widget_info.xml").write_text(WIDGET_INFO, encoding="utf-8")
    (values_dir / "islami_hayat_widget_strings.xml").write_text(WIDGET_STRINGS, encoding="utf-8")

    print(f"Configured T0297 Android home widget bridge for package {package_name}")


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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "{CHANNEL}")
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

                getSharedPreferences("{PREFS}", Context.MODE_PRIVATE)
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
    }}
}}
'''


def _provider_source(package_name: str) -> str:
    return f'''package {package_name}

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import java.util.Calendar
import java.util.Locale

class IslamiHayatWidgetProvider : AppWidgetProvider() {{
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {{
        updateAll(context, manager, ids)
    }}

    companion object {{
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {{
            val prefs = context.getSharedPreferences("{PREFS}", Context.MODE_PRIVATE)
            val civilDateKey = prefs.getString("civilDateKey", "").orEmpty()
            val verseArabic = prefs.getString("verseArabic", "").orEmpty()
            val verseTranslation = prefs.getString("verseTranslation", "").orEmpty()
            val duaText = prefs.getString("duaText", "").orEmpty()
            val languageCode = prefs.getString("languageCode", "tr").orEmpty()
            val proVisuals = prefs.getBoolean("proVisualsEnabled", false)
            val isCurrentCivilDate = civilDateKey == currentCivilDateKey()
            val emptyTextRes = when (languageCode) {{
                "tr" -> R.string.islami_hayat_widget_empty_tr
                "ar" -> R.string.islami_hayat_widget_empty_ar
                else -> R.string.islami_hayat_widget_empty_en
            }}

            for (id in ids) {{
                val views = RemoteViews(context.packageName, R.layout.islami_hayat_widget)
                val hasContent = isCurrentCivilDate &&
                    verseArabic.isNotBlank() && duaText.isNotBlank() &&
                    (languageCode == "ar" || verseTranslation.isNotBlank())
                views.setViewVisibility(R.id.widget_content, if (hasContent) View.VISIBLE else View.GONE)
                views.setViewVisibility(R.id.widget_empty, if (hasContent) View.GONE else View.VISIBLE)
                views.setTextViewText(R.id.widget_empty, context.getString(emptyTextRes))
                views.setTextViewText(R.id.widget_verse_arabic, if (hasContent) verseArabic else "")
                views.setTextViewText(R.id.widget_verse_translation, if (hasContent) verseTranslation else "")
                views.setViewVisibility(R.id.widget_verse_translation, if (hasContent && verseTranslation.isNotBlank()) View.VISIBLE else View.GONE)
                views.setTextViewText(R.id.widget_dua, if (hasContent) duaText else "")
                views.setInt(R.id.widget_content, "setLayoutDirection", if (languageCode == "ar") View.LAYOUT_DIRECTION_RTL else View.LAYOUT_DIRECTION_LTR)
                views.setViewVisibility(R.id.widget_pro_mark, if (hasContent && proVisuals) View.VISIBLE else View.GONE)

                val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                if (launchIntent != null) {{
                    launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    val pending = PendingIntent.getActivity(
                        context,
                        297,
                        launchIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                    )
                    views.setOnClickPendingIntent(R.id.widget_root, pending)
                }}
                manager.updateAppWidget(id, views)
            }}
        }}

        private fun currentCivilDateKey(): String {{
            val calendar = Calendar.getInstance()
            return String.format(
                Locale.US,
                "%04d-%02d-%02d",
                calendar.get(Calendar.YEAR),
                calendar.get(Calendar.MONTH) + 1,
                calendar.get(Calendar.DAY_OF_MONTH),
            )
        }}
    }}
}}
'''


WIDGET_LAYOUT = '''<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#FFFDF7"
    android:orientation="vertical"
    android:padding="14dp">

    <TextView
        android:id="@+id/widget_empty"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="@string/islami_hayat_widget_empty_en"
        android:textColor="#244A36"
        android:textSize="16sp" />

    <LinearLayout
        android:id="@+id/widget_content"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:visibility="gone">

        <TextView
            android:id="@+id/widget_verse_arabic"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:gravity="end"
            android:maxLines="3"
            android:textColor="#183C2A"
            android:textSize="19sp" />

        <TextView
            android:id="@+id/widget_verse_translation"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="6dp"
            android:ellipsize="end"
            android:maxLines="3"
            android:textColor="#30352F"
            android:textSize="13sp" />

        <View
            android:layout_width="match_parent"
            android:layout_height="1dp"
            android:layout_marginVertical="8dp"
            android:background="#D9DDCF" />

        <TextView
            android:id="@+id/widget_dua"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:ellipsize="end"
            android:maxLines="3"
            android:textColor="#30352F"
            android:textSize="13sp" />

        <TextView
            android:id="@+id/widget_pro_mark"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="end"
            android:layout_marginTop="6dp"
            android:text="PRO"
            android:textColor="#8A6A20"
            android:textSize="10sp"
            android:visibility="gone" />
    </LinearLayout>
</LinearLayout>
'''

WIDGET_INFO = '''<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/islami_hayat_widget"
    android:minWidth="250dp"
    android:minHeight="110dp"
    android:previewLayout="@layout/islami_hayat_widget"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />
'''

WIDGET_STRINGS = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Explicit ids are selected from the app snapshot language, not the
         Android system locale. This prevents a device-locale leak when the
         user selected a different language inside Islami Hayat. -->
    <string name="islami_hayat_widget_empty_en">Open Islami Hayat to prepare today’s widget.</string>
    <string name="islami_hayat_widget_empty_tr">Bugünün widget’ını hazırlamak için İslami Hayat’ı açın.</string>
    <string name="islami_hayat_widget_empty_ar">افتح إسلامي حيات لإعداد أداة اليوم.</string>
</resources>
'''


if __name__ == "__main__":
    configure()