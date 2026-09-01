import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class RuntimeReligiousShareCardT0243 extends StatelessWidget {
  const RuntimeReligiousShareCardT0243({
    required this.format,
    required this.background,
    required this.content,
    this.textPreferences = const ShareTextPreferencesT0246(),
    super.key,
  });

  final ShareCanvasFormatT0242 format;
  final Widget background;
  final RuntimeReligiousShareContentT0243 content;
  final ShareTextPreferencesT0246 textPreferences;

  @override
  Widget build(BuildContext context) {
    final generalDuaLabel = content.requiresGeneralDuaLabel
        ? AppLocalizations.of(context).duaSourceEditorial
        : null;

    return ShareLayoutRendererT0242(
      format: format,
      background: background,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (generalDuaLabel != null) ...[
            Text(
              generalDuaLabel,
              key: const ValueKey('general-dua-label-t0245'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
          Text(
            content.text,
            key: const ValueKey('t0246-immutable-religious-text'),
            textAlign: textPreferences.textAlign,
            style: TextStyle(fontSize: textPreferences.fontSizeFor(24)),
          ),
          const SizedBox(height: 16),
          Text(
            content.sourceLabel,
            textAlign: textPreferences.textAlign,
          ),
        ],
      ),
    );
  }
}
