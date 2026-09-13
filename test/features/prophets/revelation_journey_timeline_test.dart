import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/revelation_journey_timeline.dart';

void main() {
  group('T0197 Revelation Journey timeline', () {
    test('is valid, complete and preserves all five browseable periods', () {
      expect(revelationJourneyTimelineIsValid, isTrue);

      final timeline = buildRevelationJourneyTimeline();
      final prophets = timeline.expand((segment) => segment.prophetIds).toList();
      final audit = auditRevelationJourneyTimeline(timeline);

      expect(audit.isValid, isTrue);
      expect(audit.errors, isEmpty);
      expect(prophets.length, 25);
      expect(prophets.toSet().length, 25);
      expect(
        timeline.map((segment) => segment.period).toSet(),
        RevelationJourneyPeriod.values.toSet(),
      );
    });

    test('period filtering never reorders the canonical journey', () {
      for (final period in RevelationJourneyPeriod.values) {
        final filtered = revelationJourneyForPeriod(period);
        expect(filtered, isNotEmpty);
        expect(filtered.every((segment) => segment.period == period), isTrue);
        final orders = filtered.map((segment) => segment.order).toList();
        expect(orders, orderedEquals([...orders]..sort()));
      }
    });

    test('known broad contemporaneous groups remain parallel lanes', () {
      final parallel = buildRevelationJourneyTimeline()
          .where((segment) => segment.isParallel)
          .map((segment) => segment.prophetIds.join('|'))
          .toSet();

      expect(parallel, contains('ibrahim|lut'));
      expect(parallel, contains('ismail|ishaq'));
      expect(parallel, contains('musa|harun'));
    });

    test('timeline cannot silently upgrade approximate chronology to exact', () {
      const invalid = RevelationJourneySegment(
        order: 12,
        period: RevelationJourneyPeriod.israelite,
        prophetIds: ['musa', 'harun'],
        isParallel: true,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'quran-4-163',
            title: 'Qur’an 4:163',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'quran-reference-only',
            locator: '4:163',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });

    test('parallel lane needs at least two prophets', () {
      const invalid = RevelationJourneySegment(
        order: 12,
        period: RevelationJourneyPeriod.israelite,
        prophetIds: ['musa'],
        isParallel: true,
        certainty: CertaintyLevel.approximate,
        sources: [
          SourceReference(
            id: 'quran-4-163',
            title: 'Qur’an 4:163',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'quran-reference-only',
            locator: '4:163',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });

    test('weak or disputed evidence cannot drive a journey segment', () {
      for (final disallowed in <ReligiousSourceClass>[
        ReligiousSourceClass.israiliyat,
        ReligiousSourceClass.laterTradition,
        ReligiousSourceClass.disputed,
        ReligiousSourceClass.unknown,
        ReligiousSourceClass.meaningBasedDua,
        ReligiousSourceClass.classicalTraditional,
        ReligiousSourceClass.ebcedHavasTradition,
      ]) {
        final invalid = RevelationJourneySegment(
          order: 1,
          period: RevelationJourneyPeriod.firstProphets,
          prophetIds: const ['adam'],
          isParallel: false,
          certainty: CertaintyLevel.approximate,
          sources: [
            SourceReference(
              id: 'invalid-${disallowed.stableId}',
              title: 'Invalid chronology source',
              sourceClass: disallowed,
              licenseId: 'reference-only',
              locator: 'n/a',
            ),
          ],
        );

        expect(invalid.isValid, isFalse, reason: disallowed.stableId);
      }
    });

    test('timeline source allowlist is chronology-specific', () {
      expect(
        revelationJourneySourceClassAllowlist,
        equals({
          ReligiousSourceClass.quran,
          ReligiousSourceClass.sahihHasanHadith,
          ReligiousSourceClass.earlyIslamicHistoryTafsir,
          ReligiousSourceClass.modernHistoryArchaeology,
        }),
      );
    });

    test('whole-timeline audit rejects duplicate prophet ids', () {
      final timeline = buildRevelationJourneyTimeline();
      final tampered = <RevelationJourneySegment>[
        ...timeline.take(timeline.length - 1),
        RevelationJourneySegment(
          order: timeline.last.order,
          period: timeline.last.period,
          prophetIds: const ['isa'],
          isParallel: false,
          certainty: timeline.last.certainty,
          sources: timeline.last.sources,
        ),
      ];

      final audit = auditRevelationJourneyTimeline(tampered);
      expect(audit.isValid, isFalse);
      expect(audit.errors.join('\n'), contains('duplicate prophet ids'));
      expect(audit.errors.join('\n'), contains('missing canonical prophets'));
    });

    test('whole-timeline audit rejects order gaps and wrong browse period', () {
      final timeline = buildRevelationJourneyTimeline();
      final first = timeline.first;
      final tampered = <RevelationJourneySegment>[
        RevelationJourneySegment(
          order: 2,
          period: RevelationJourneyPeriod.muhammad,
          prophetIds: first.prophetIds,
          isParallel: first.isParallel,
          certainty: first.certainty,
          sources: first.sources,
        ),
        ...timeline.skip(1),
      ];

      final audit = auditRevelationJourneyTimeline(tampered);
      expect(audit.isValid, isFalse);
      expect(audit.errors.join('\n'), contains('timeline order must be contiguous'));
      expect(audit.errors.join('\n'), contains('expected firstProphets'));
    });
  });
}
