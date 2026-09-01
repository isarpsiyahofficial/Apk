import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';

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

  testWidgets('T0247 renderer applies the automatically selected foreground', (
    tester,
  ) async {
    final decision = policy.evaluate(
      backgroundSamples: const [Color(0xFFFFFFFF), Color(0xFFF4F0E8)],
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 320,
          child: ShareLayoutRendererT0242(
            format: ShareCanvasFormatT0242.square11,
            background: const ColoredBox(color: Color(0xFFFFFFFF)),
            readabilityDecision: decision,
            content: const Text('Readable content'),
          ),
        ),
      ),
    );

    final defaultStyle = tester.widget<DefaultTextStyle>(
      find.ancestor(
        of: find.text('Readable content'),
        matching: find.byType(DefaultTextStyle),
      ).first,
    );
    expect(defaultStyle.style.color, const Color(0xFF111111));
    expect(tester.takeException(), isNull);
  });

  testWidgets('T0247 renderer blocks a non-readable export candidate', (
    tester,
  ) async {
    final decision = policy.evaluate(
      backgroundSamples: const [Color(0xFFFFFFFF), Color(0xFF000000)],
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 320,
          child: ShareLayoutRendererT0242(
            format: ShareCanvasFormatT0242.square11,
            background: const SizedBox.expand(),
            readabilityDecision: decision,
            content: const Text('Blocked content'),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isA<StateError>());
  });
}
