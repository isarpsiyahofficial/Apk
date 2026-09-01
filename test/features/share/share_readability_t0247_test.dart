import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';

void main() {
  const policy = ShareReadabilityPolicyT0247();

  test('T0247 selects dark text for a consistently light background', () {
    final decision = policy.evaluate(
      backgroundSamples: const [
        Color(0xFFFFFFFF),
        Color(0xFFF4F0E8),
        Color(0xFFECE5D8),
      ],
    );

    expect(decision.foregroundColor, const Color(0xFF111111));
    expect(decision.canExport, isTrue);
    expect(decision.minimumObservedContrastRatio, greaterThanOrEqualTo(4.5));
    expect(decision.requireExportable, returnsNormally);
  });

  test('T0247 selects light text for a consistently dark background', () {
    final decision = policy.evaluate(
      backgroundSamples: const [
        Color(0xFF111111),
        Color(0xFF1B2A24),
        Color(0xFF26352E),
      ],
    );

    expect(decision.foregroundColor, const Color(0xFFFFFFFF));
    expect(decision.canExport, isTrue);
    expect(decision.minimumObservedContrastRatio, greaterThanOrEqualTo(4.5));
  });

  test('T0247 blocks export when one text color cannot read across mixed extremes', () {
    final decision = policy.evaluate(
      backgroundSamples: const [
        Color(0xFFFFFFFF),
        Color(0xFF000000),
      ],
    );

    expect(decision.canExport, isFalse);
    expect(decision.requireExportable, throwsStateError);
  });

  test('T0247 fails closed without samples or with transparent samples', () {
    expect(
      () => policy.evaluate(backgroundSamples: const []),
      throwsStateError,
    );
    expect(
      () => policy.evaluate(
        backgroundSamples: const [Color(0x80FFFFFF)],
      ),
      throwsStateError,
    );
  });

  test('T0247 rejects invalid contrast thresholds', () {
    expect(
      () => const ShareReadabilityPolicyT0247(
        minimumContrastRatio: 1,
      ).evaluate(backgroundSamples: const [Color(0xFFFFFFFF)]),
      throwsArgumentError,
    );
    expect(
      () => const ShareReadabilityPolicyT0247(
        minimumContrastRatio: double.infinity,
      ).evaluate(backgroundSamples: const [Color(0xFFFFFFFF)]),
      throwsArgumentError,
    );
  });
}
