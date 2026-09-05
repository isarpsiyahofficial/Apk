import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/quran_source_lock_t0244.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';

class QuranSharePageT0248 {
  const QuranSharePageT0248({
    required this.text,
    required this.textPreferences,
    required this.pageIndex,
    required this.pageCount,
  });

  final String text;
  final ShareTextPreferencesT0246 textPreferences;
  final int pageIndex;
  final int pageCount;
}

class QuranLongTextPaginatorT0248 {
  const QuranLongTextPaginatorT0248();

  static const double _normalizedCanvasWidth = 360;
  static const double _baseFontSize = 26;
  static const double _sourceReserveHeight = 52;
  static const double _sourceGap = 16;

  List<QuranSharePageT0248> paginate({
    required RuntimeReligiousShareContentT0243 content,
    required ShareCanvasFormatT0242 format,
    required TextDirection textDirection,
    ShareTextPreferencesT0246 requestedPreferences =
        const ShareTextPreferencesT0246(),
  }) {
    QuranShareSourceLockT0244.fromRuntimeContent(content);
    if (content.text.isEmpty) {
      throw StateError('T0248 Quran text cannot be empty.');
    }

    final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
    final normalizedHeight = _normalizedCanvasWidth / layout.aspectRatio;
    final usableWidth = _normalizedCanvasWidth *
        (1 - (2 * layout.safeHorizontalFraction));
    final usableHeight = normalizedHeight *
            (1 - layout.safeTopFraction - layout.safeBottomFraction) -
        _sourceReserveHeight -
        _sourceGap;
    if (usableWidth <= 0 || usableHeight <= 0) {
      throw StateError('T0248 share safe area cannot fit Quran text.');
    }

    for (final preset in _fallbackPresets(requestedPreferences.fontSizePreset)) {
      final preferences = requestedPreferences.copyWith(fontSizePreset: preset);
      if (_fits(
        content.text,
        preferences: preferences,
        textDirection: textDirection,
        maxWidth: usableWidth,
        maxHeight: usableHeight,
      )) {
        return <QuranSharePageT0248>[
          QuranSharePageT0248(
            text: content.text,
            textPreferences: preferences,
            pageIndex: 0,
            pageCount: 1,
          ),
        ];
      }
    }

    final compactPreferences = requestedPreferences.copyWith(
      fontSizePreset: ShareFontSizePresetT0246.compact,
    );
    final segments = _losslessSegments(
      content.text,
      preferences: compactPreferences,
      textDirection: textDirection,
      maxWidth: usableWidth,
      maxHeight: usableHeight,
    );

    return List<QuranSharePageT0248>.generate(
      segments.length,
      (index) => QuranSharePageT0248(
        text: segments[index],
        textPreferences: compactPreferences,
        pageIndex: index,
        pageCount: segments.length,
      ),
      growable: false,
    );
  }

  List<ShareFontSizePresetT0246> _fallbackPresets(
    ShareFontSizePresetT0246 requested,
  ) {
    return switch (requested) {
      ShareFontSizePresetT0246.large => <ShareFontSizePresetT0246>[
          ShareFontSizePresetT0246.large,
          ShareFontSizePresetT0246.standard,
          ShareFontSizePresetT0246.compact,
        ],
      ShareFontSizePresetT0246.standard => <ShareFontSizePresetT0246>[
          ShareFontSizePresetT0246.standard,
          ShareFontSizePresetT0246.compact,
        ],
      ShareFontSizePresetT0246.compact => <ShareFontSizePresetT0246>[
          ShareFontSizePresetT0246.compact,
        ],
    };
  }

  List<String> _losslessSegments(
    String text, {
    required ShareTextPreferencesT0246 preferences,
    required TextDirection textDirection,
    required double maxWidth,
    required double maxHeight,
  }) {
    final segments = <String>[];
    var start = 0;
    while (start < text.length) {
      final remaining = text.substring(start);
      final relativeEnd = _largestSafeLineBoundary(
        remaining,
        preferences: preferences,
        textDirection: textDirection,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      if (relativeEnd <= 0 || relativeEnd > remaining.length) {
        throw StateError('T0248 produced an invalid Quran page boundary.');
      }
      final end = start + relativeEnd;
      segments.add(text.substring(start, end));
      start = end;
    }

    if (segments.isEmpty || segments.join() != text) {
      throw StateError('T0248 pagination must preserve Quran text byte-for-byte.');
    }
    return segments;
  }

  int _largestSafeLineBoundary(
    String text, {
    required ShareTextPreferencesT0246 preferences,
    required TextDirection textDirection,
    required double maxWidth,
    required double maxHeight,
  }) {
    final painter = _layoutPainter(
      text,
      preferences: preferences,
      textDirection: textDirection,
      maxWidth: maxWidth,
    );
    if (painter.height <= maxHeight) {
      return text.length;
    }

    final lines = painter.computeLineMetrics();
    var lastFittingLine = -1;
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final lineTop = line.baseline - line.ascent;
      final lineBottom = lineTop + line.height;
      if (lineBottom <= maxHeight + 0.001) {
        lastFittingLine = index;
      } else {
        break;
      }
    }
    if (lastFittingLine < 0) {
      throw StateError('T0248 safe area cannot fit even one Quran text line.');
    }

    final line = lines[lastFittingLine];
    final lineMidY = line.baseline - line.ascent + (line.height / 2);
    final position = painter.getPositionForOffset(
      Offset(maxWidth / 2, lineMidY),
    );
    final lineRange = painter.getLineBoundary(position);
    if (lineRange.end >= text.length) {
      return text.length;
    }

    // Flutter may wrap a single exceptionally long token. Page boundaries are
    // stricter: never split a Quran word. Move back to the last whitespace
    // boundary on the final fully fitting line and preserve that whitespace in
    // the preceding page so joining pages reproduces the exact source bytes.
    final prefix = text.substring(0, lineRange.end);
    final whitespace = RegExp(r'\s+').allMatches(prefix).toList(growable: false);
    if (whitespace.isEmpty) {
      throw StateError(
        'T0248 cannot fit the next Quran word without splitting it.',
      );
    }
    return whitespace.last.end;
  }

  bool _fits(
    String text, {
    required ShareTextPreferencesT0246 preferences,
    required TextDirection textDirection,
    required double maxWidth,
    required double maxHeight,
  }) {
    return _layoutPainter(
          text,
          preferences: preferences,
          textDirection: textDirection,
          maxWidth: maxWidth,
        ).height <=
        maxHeight;
  }

  TextPainter _layoutPainter(
    String text, {
    required ShareTextPreferencesT0246 preferences,
    required TextDirection textDirection,
    required double maxWidth,
  }) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: preferences.fontSizeFor(_baseFontSize)),
      ),
      textAlign: preferences.textAlign,
      textDirection: textDirection,
    )..layout(maxWidth: maxWidth);
  }
}

class QuranSharePageCardT0248 extends StatelessWidget {
  const QuranSharePageCardT0248({
    required this.format,
    required this.background,
    required this.content,
    required this.page,
    this.readabilityDecision,
    super.key,
  });

  final ShareCanvasFormatT0242 format;
  final Widget background;
  final RuntimeReligiousShareContentT0243 content;
  final QuranSharePageT0248 page;
  final ShareReadabilityDecisionT0247? readabilityDecision;

  @override
  Widget build(BuildContext context) {
    final sourceLock = QuranShareSourceLockT0244.fromRuntimeContent(content);
    if (page.pageIndex < 0 ||
        page.pageCount < 1 ||
        page.pageIndex >= page.pageCount) {
      throw StateError('T0248 page coordinates are invalid.');
    }

    return ShareLayoutRendererT0242(
      format: format,
      background: background,
      readabilityDecision: readabilityDecision,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.text,
            key: ValueKey('t0248-quran-page-text-${page.pageIndex}'),
            textAlign: page.textPreferences.textAlign,
            style: TextStyle(
              fontSize: page.textPreferences.fontSizeFor(
                QuranLongTextPaginatorT0248._baseFontSize,
              ),
            ),
          ),
          const SizedBox(height: QuranLongTextPaginatorT0248._sourceGap),
          Text(
            sourceLock.lockedSourceLabel,
            key: ValueKey('t0248-locked-source-${page.pageIndex}'),
            textAlign: page.textPreferences.textAlign,
          ),
        ],
      ),
    );
  }
}
