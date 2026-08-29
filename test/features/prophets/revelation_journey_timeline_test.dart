import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/revelation_journey_timeline.dart';

void main() {
  group('T0197 Revelation Journey timeline', () {
    test('is valid, complete and preserves all five browseable periods', () {
      expect(revelationJourneyTimelineIsValid, isTrue);

      final timeline = buildRevelationJourneyTimeline();
      final prophets = timeline.expand((segment) => segment.prophetIds).toList();

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
      const invalid = RevelationJourneySegment(
        order: 1,
        period: RevelationJourneyPeriod.firstProphets,
        prophetIds: ['adam'],
        isParallel: false,
        certainty: CertaintyLevel.approximate,
        sources: [
          SourceReference(
            id: 'late-story',
            title: 'Unverified later narrative',
            sourceClass: ReligiousSourceClass.laterTradition,
            licenseId: 'reference-only',
            locator: 'n/a',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });
  });
}
