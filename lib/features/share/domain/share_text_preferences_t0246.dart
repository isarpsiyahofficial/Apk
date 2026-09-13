import 'package:flutter/widgets.dart';

enum ShareFontSizePresetT0246 {
  compact(0.90),
  standard(1.0),
  large(1.12);

  const ShareFontSizePresetT0246(this.scale);

  final double scale;
}

enum ShareTextAlignmentT0246 {
  start(TextAlign.start),
  center(TextAlign.center),
  end(TextAlign.end);

  const ShareTextAlignmentT0246(this.textAlign);

  final TextAlign textAlign;
}

/// User-adjustable presentation choices for religious share cards.
///
/// The religious text itself is intentionally not part of this object. Callers
/// may change only a bounded font-size preset and one of three directional
/// alignments; canonical religious content remains immutable in its governed
/// content model.
class ShareTextPreferencesT0246 {
  const ShareTextPreferencesT0246({
    this.fontSizePreset = ShareFontSizePresetT0246.standard,
    this.alignment = ShareTextAlignmentT0246.center,
  });

  static const double minimumScale = 0.90;
  static const double maximumScale = 1.12;

  final ShareFontSizePresetT0246 fontSizePreset;
  final ShareTextAlignmentT0246 alignment;

  double fontSizeFor(double baseFontSize) {
    if (!baseFontSize.isFinite || baseFontSize <= 0) {
      throw ArgumentError.value(
        baseFontSize,
        'baseFontSize',
        'must be a finite positive value',
      );
    }
    final scale = fontSizePreset.scale;
    if (scale < minimumScale || scale > maximumScale) {
      throw StateError('Share font-size preset escaped the safe range.');
    }
    return baseFontSize * scale;
  }

  TextAlign get textAlign => alignment.textAlign;

  ShareTextPreferencesT0246 copyWith({
    ShareFontSizePresetT0246? fontSizePreset,
    ShareTextAlignmentT0246? alignment,
  }) {
    return ShareTextPreferencesT0246(
      fontSizePreset: fontSizePreset ?? this.fontSizePreset,
      alignment: alignment ?? this.alignment,
    );
  }
}
