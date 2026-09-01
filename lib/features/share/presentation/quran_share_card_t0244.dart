import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/quran_source_lock_t0244.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';

class QuranShareCardT0244 extends StatelessWidget {
  const QuranShareCardT0244({
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
    final sourceLock = QuranShareSourceLockT0244.fromRuntimeContent(content);

    return ShareLayoutRendererT0242(
      format: format,
      background: background,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content.text,
            key: const ValueKey('t0246-immutable-quran-text'),
            textAlign: textPreferences.textAlign,
            style: TextStyle(fontSize: textPreferences.fontSizeFor(26)),
          ),
          const SizedBox(height: 16),
          Text(
            sourceLock.lockedSourceLabel,
            key: const ValueKey('t0244-locked-quran-source'),
            textAlign: textPreferences.textAlign,
          ),
        ],
      ),
    );
  }
}
