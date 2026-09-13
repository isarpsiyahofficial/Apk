import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/rashidun_first_fitna_timeline.dart';

void main() {
  group('EarlyCaliphateTimelineDataset T0213', () {
    test('covers four Rashidun caliphs and the First Fitna in chronology order', () {
      final dataset = earlyCaliphateTimelineT0213;

      expect(
        dataset.entries.map((entry) => entry.id),
        orderedEquals(const [
          'abu_bakr_caliphate',
          'umar_caliphate',
          'uthman_caliphate',
          'ali_caliphate',
          'first_fitna',
        ]),
      );
      expect(dataset.entries.first.startYearCe, 632);
      expect(dataset.entries.last.endYearCe, 661);
    });

    test('keeps every entry research-only until editorial/native review evidence exists', () {
      final dataset = earlyCaliphateTimelineT0213;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every(
          (entry) => entry.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('First Fitna is explicitly contested and caveated in TR/EN/AR', () {
      final fitna = earlyCaliphateTimelineT0213.entries.singleWhere(
        (entry) => entry.id == 'first_fitna',
      );

      expect(fitna.certainty, EarlyCaliphateCertainty.contestedInterpretation);
      expect(fitna.caveat, isNotNull);
      expect(fitna.caveat!.isComplete, isTrue);
      expect(fitna.sourceIds.toSet().length, greaterThanOrEqualTo(2));
    });

    test('rejects a contested entry without a complete uncertainty caveat', () {
      final fitna = earlyCaliphateResearchEntries.last;
      final invalid = EarlyCaliphateTimelineEntry(
        id: fitna.id,
        title: fitna.title,
        summary: fitna.summary,
        startYearCe: fitna.startYearCe,
        endYearCe: fitna.endYearCe,
        certainty: fitna.certainty,
        caveat: const LocalizedHistorySummary(tr: 'Belirsiz', en: 'Contested', ar: ''),
        sourceIds: fitna.sourceIds,
        status: fitna.status,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: [
            ...earlyCaliphateResearchEntries.take(4),
            invalid,
          ],
        ),
        throwsStateError,
      );
    });

    test('rejects wrong canonical certainty classification', () {
      final fitna = earlyCaliphateResearchEntries.last;
      final incorrectlyEstablishedFitna = EarlyCaliphateTimelineEntry(
        id: fitna.id,
        title: fitna.title,
        summary: fitna.summary,
        startYearCe: fitna.startYearCe,
        endYearCe: fitna.endYearCe,
        certainty: EarlyCaliphateCertainty.establishedChronology,
        caveat: null,
        sourceIds: fitna.sourceIds,
        status: fitna.status,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: [
            ...earlyCaliphateResearchEntries.take(4),
            incorrectlyEstablishedFitna,
          ],
        ),
        throwsStateError,
      );

      final abuBakr = earlyCaliphateResearchEntries.first;
      final incorrectlyContestedCaliphate = EarlyCaliphateTimelineEntry(
        id: abuBakr.id,
        title: abuBakr.title,
        summary: abuBakr.summary,
        startYearCe: abuBakr.startYearCe,
        endYearCe: abuBakr.endYearCe,
        certainty: EarlyCaliphateCertainty.contestedInterpretation,
        caveat: const LocalizedHistorySummary(
          tr: 'İhtilaflı yorum.',
          en: 'Contested interpretation.',
          ar: 'تفسير محل خلاف.',
        ),
        sourceIds: abuBakr.sourceIds,
        status: abuBakr.status,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: [
            incorrectlyContestedCaliphate,
            ...earlyCaliphateResearchEntries.skip(1),
          ],
        ),
        throwsStateError,
      );
    });

    test('rejects extra non-canonical periods even when otherwise valid', () {
      final ali = earlyCaliphateResearchEntries[3];
      final extra = EarlyCaliphateTimelineEntry(
        id: 'extra_period',
        title: const LocalizedHistorySummary(
          tr: 'Ek Dönem',
          en: 'Extra Period',
          ar: 'فترة إضافية',
        ),
        summary: const LocalizedHistorySummary(
          tr: 'Canonical T0213 kapsamı dışı sentetik dönem.',
          en: 'Synthetic period outside the canonical T0213 scope.',
          ar: 'فترة تجريبية خارج النطاق المعتمد للمهمة T0213.',
        ),
        startYearCe: 656,
        endYearCe: 660,
        certainty: EarlyCaliphateCertainty.establishedChronology,
        caveat: null,
        sourceIds: ali.sourceIds,
        status: HistoryResearchStatus.researchDraft,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: [
            ...earlyCaliphateResearchEntries.take(4),
            extra,
            earlyCaliphateResearchEntries.last,
          ],
        ),
        throwsStateError,
      );
    });

    test('rejects single-source claims, missing required periods and chronology drift', () {
      final abuBakr = earlyCaliphateResearchEntries.first;
      final singleSource = EarlyCaliphateTimelineEntry(
        id: abuBakr.id,
        title: abuBakr.title,
        summary: abuBakr.summary,
        startYearCe: abuBakr.startYearCe,
        endYearCe: abuBakr.endYearCe,
        certainty: abuBakr.certainty,
        caveat: abuBakr.caveat,
        sourceIds: const ['lapidus_caliphate_to_750'],
        status: abuBakr.status,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: [singleSource, ...earlyCaliphateResearchEntries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: earlyCaliphateResearchEntries.where(
            (entry) => entry.id != 'umar_caliphate',
          ).toList(),
        ),
        throwsStateError,
      );

      expect(
        () => EarlyCaliphateTimelineDataset.validated(
          sources: earlyCaliphateResearchSources,
          entries: earlyCaliphateResearchEntries.reversed.toList(),
        ),
        throwsStateError,
      );
    });
  });
}