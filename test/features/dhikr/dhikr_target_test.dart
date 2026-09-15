import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_target.dart';

void main() {
  test('personal target is never religiously sourced', () {
    final target = DhikrTarget.personal(47);

    expect(target.kind, DhikrTargetKind.personal);
    expect(target.count, 47);
    expect(target.isReligiouslySourced, isFalse);
    expect(target.sourceId, isNull);
    expect(target.sourceReference, isNull);
  });

  test('33 and 100 presets are convenience values, not source claims', () {
    for (final count in DhikrTarget.supportedPresetCounts) {
      final target = DhikrTarget.preset(count);
      expect(target.kind, DhikrTargetKind.preset);
      expect(target.count, count);
      expect(target.isReligiouslySourced, isFalse);
      expect(target.sourceId, isNull);
      expect(target.sourceReference, isNull);
    }
  });

  test('unsupported preset is rejected instead of becoming a religious claim', () {
    expect(() => DhikrTarget.preset(313), throwsArgumentError);
  });

  test('source-backed target requires stable source metadata', () {
    final target = DhikrTarget.sourceBacked(
      count: 33,
      sourceId: 'hadith:example:stable-id',
      sourceReference: 'Verified source reference',
    );

    expect(target.kind, DhikrTargetKind.sourceBacked);
    expect(target.isReligiouslySourced, isTrue);
    expect(target.sourceId, 'hadith:example:stable-id');
    expect(target.sourceReference, 'Verified source reference');
  });

  test('source-backed target fails closed without source id/reference', () {
    expect(
      () => DhikrTarget.sourceBacked(
        count: 33,
        sourceId: ' ',
        sourceReference: 'Verified source reference',
      ),
      throwsArgumentError,
    );
    expect(
      () => DhikrTarget.sourceBacked(
        count: 33,
        sourceId: 'hadith:example:stable-id',
        sourceReference: '',
      ),
      throwsArgumentError,
    );
  });

  test('invalid, zero, negative and impossible counts fail closed', () {
    expect(() => DhikrTarget.personal(0), throwsArgumentError);
    expect(() => DhikrTarget.personal(-1), throwsArgumentError);
    expect(
      () => DhikrTarget.personal(DhikrTarget.maxCount + 1),
      throwsArgumentError,
    );
  });

  test('json round trip preserves target provenance', () {
    final targets = [
      DhikrTarget.personal(25),
      DhikrTarget.preset(100),
      DhikrTarget.sourceBacked(
        count: 33,
        sourceId: 'source:stable',
        sourceReference: 'Verified reference',
      ),
    ];

    for (final target in targets) {
      final restored = DhikrTarget.fromJson(target.toJson());
      expect(restored.kind, target.kind);
      expect(restored.count, target.count);
      expect(restored.sourceId, target.sourceId);
      expect(restored.sourceReference, target.sourceReference);
    }
  });

  test('tampered source-backed json cannot downgrade metadata requirements', () {
    expect(
      () => DhikrTarget.fromJson({
        'kind': 'sourceBacked',
        'count': 33,
      }),
      throwsFormatException,
    );
    expect(
      () => DhikrTarget.fromJson({
        'kind': 'unknown',
        'count': 33,
      }),
      throwsFormatException,
    );
  });
}
