import 'dart:ui';

class ShareReadabilityDecisionT0247 {
  const ShareReadabilityDecisionT0247._({
    required this.foregroundColor,
    required this.minimumObservedContrastRatio,
    required this.requiredContrastRatio,
  });

  final Color foregroundColor;
  final double minimumObservedContrastRatio;
  final double requiredContrastRatio;

  bool get canExport => minimumObservedContrastRatio >= requiredContrastRatio;

  void requireExportable() {
    if (!canExport) {
      throw StateError(
        'T0247 export blocked: foreground/background contrast is below '
        'the required readability threshold.',
      );
    }
  }
}

class ShareReadabilityPolicyT0247 {
  const ShareReadabilityPolicyT0247({this.minimumContrastRatio = 4.5});

  final double minimumContrastRatio;

  ShareReadabilityDecisionT0247 evaluate({
    required Iterable<Color> backgroundSamples,
  }) {
    if (!minimumContrastRatio.isFinite || minimumContrastRatio <= 1) {
      throw ArgumentError.value(
        minimumContrastRatio,
        'minimumContrastRatio',
        'T0247 contrast threshold must be finite and greater than 1.',
      );
    }

    final samples = backgroundSamples.toList(growable: false);
    if (samples.isEmpty) {
      throw StateError(
        'T0247 cannot evaluate readability without background samples.',
      );
    }
    if (samples.any((sample) => sample.a != 1.0)) {
      throw StateError(
        'T0247 background samples must be fully opaque before export.',
      );
    }

    const darkText = Color(0xFF111111);
    const lightText = Color(0xFFFFFFFF);

    final darkMinimum = _minimumContrast(darkText, samples);
    final lightMinimum = _minimumContrast(lightText, samples);
    final useDark = darkMinimum >= lightMinimum;

    return ShareReadabilityDecisionT0247._(
      foregroundColor: useDark ? darkText : lightText,
      minimumObservedContrastRatio: useDark ? darkMinimum : lightMinimum,
      requiredContrastRatio: minimumContrastRatio,
    );
  }

  static double _minimumContrast(Color foreground, List<Color> backgrounds) {
    var minimum = double.infinity;
    for (final background in backgrounds) {
      final ratio = _contrastRatio(foreground, background);
      if (ratio < minimum) {
        minimum = ratio;
      }
    }
    return minimum;
  }

  static double _contrastRatio(Color first, Color second) {
    final firstLuminance = first.computeLuminance();
    final secondLuminance = second.computeLuminance();
    final lighter = firstLuminance >= secondLuminance
        ? firstLuminance
        : secondLuminance;
    final darker = firstLuminance >= secondLuminance
        ? secondLuminance
        : firstLuminance;
    return (lighter + 0.05) / (darker + 0.05);
  }
}
