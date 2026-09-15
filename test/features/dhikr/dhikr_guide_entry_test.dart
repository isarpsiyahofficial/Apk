import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_target.dart';

void main() {
  SourceReference source({
    ReligiousSourceClass sourceClass = ReligiousSourceClass.sahihHasanHadith,
    String id = 'hadith:stable',
    String title = 'Verified hadith source',
    String licenseId = 'source-license',
    String? locator = 'ref 1',
  }) => SourceReference(
        id: id,
        title: title,
        sourceClass: sourceClass,
        licenseId: licenseId,
        locator: locator,
      );

  DhikrGuideEntry entry({
    int? recommendedCount = 33,
    List<SourceReference>? countSources,
    List<SourceReference>? sources,
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) => DhikrGuideEntry(
        id: 'dhikr:test',
        arabic: 'سُبْحَانَ اللَّهِ',
        transliterationTr: 'Sübhânallah',
        transliterationEn: 'Subhanallah',
        meaning: const LocalizedReligiousText(
          tr: 'Allah eksikliklerden uzaktır.',
          en: 'Glory be to Allah.',
          ar: 'تنزيه الله عن كل نقص.',
        ),
        whyRecited: const LocalizedReligiousText(
          tr: 'Kaynağın bildirdiği bağlam için zikredilir.',
          en: 'Recited in the context supported by the cited source.',
          ar: 'يُذكر في السياق الذي يدل عليه المصدر المذكور.',
        ),
        sources: sources ?? [source()],
        reviewStatus: reviewStatus,
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 8, 28),
        recommendedCount: recommendedCount,
        countSources: countSources ??
            (recommendedCount == null ? const [] : [source()]),
      );

  test('published complete guide entry passes production gate', () {
    final item = entry();

    expect(item.canEnterProductionDataset, isTrue);
    expect(item.hasRecommendedCount, isTrue);
    expect(item.countProvenance, DhikrCountProvenance.strongSource);
  });

  test('recommended number cannot exist without an independent number source', () {
    final item = entry(countSources: const []);

    expect(item.canEnterProductionDataset, isFalse);
    expect(item.toSourceBackedTarget, throwsStateError);
  });

  test('unknown and disputed count provenance fail closed', () {
    for (final sourceClass in [
      ReligiousSourceClass.unknown,
      ReligiousSourceClass.disputed,
    ]) {
      final item = entry(countSources: [source(sourceClass: sourceClass)]);
      expect(item.canEnterProductionDataset, isFalse);
      expect(item.countProvenance, isNull);
    }
  });

  test('strong-source target preserves count provenance', () {
    final item = entry(
      countSources: [
        source(
          id: 'hadith:stable:33',
          title: 'Verified hadith source',
          locator: 'chapter 2, narration 7',
        ),
      ],
    );

    final target = item.toSourceBackedTarget();
    expect(target, isNotNull);
    expect(target!.kind, DhikrTargetKind.sourceBacked);
    expect(target.count, 33);
    expect(target.sourceId, 'hadith:stable:33');
    expect(
      target.sourceReference,
      'Verified hadith source — chapter 2, narration 7',
    );
  });

  test('traditional number remains reviewable but never becomes Sunnah target', () {
    final item = entry(
      countSources: [
        source(
          sourceClass: ReligiousSourceClass.classicalTraditional,
          id: 'tradition:33',
          title: 'Classical traditional source',
          locator: 'section 4',
        ),
      ],
    );

    expect(item.canEnterProductionDataset, isTrue);
    expect(item.countProvenance, DhikrCountProvenance.traditional);
    expect(item.toSourceBackedTarget(), isNull);
    expect(item.countSourceReference, contains('Classical traditional source'));
  });

  test('later traditional number is distinct from strong-source target', () {
    final item = entry(
      countSources: [
        source(
          sourceClass: ReligiousSourceClass.laterTradition,
          id: 'later:100',
          title: 'Later traditional source',
          locator: 'practice note 2',
        ),
      ],
    );

    expect(item.canEnterProductionDataset, isTrue);
    expect(item.countProvenance, DhikrCountProvenance.traditional);
    expect(item.toSourceBackedTarget(), isNull);
  });

  test('ebced/havas number is historical metadata and never Sunnah target', () {
    final item = entry(
      recommendedCount: 308,
      countSources: [
        source(
          sourceClass: ReligiousSourceClass.ebcedHavasTradition,
          id: 'ebced:308',
          title: 'Historical abjad source',
          locator: 'table 3',
        ),
      ],
    );

    expect(item.canEnterProductionDataset, isTrue);
    expect(item.countProvenance, DhikrCountProvenance.ebcedHavasHistorical);
    expect(item.toSourceBackedTarget(), isNull);
  });

  test('mixed strong and traditional count sources fail closed', () {
    final item = entry(
      countSources: [
        source(),
        source(
          sourceClass: ReligiousSourceClass.classicalTraditional,
          id: 'tradition:mixed',
          title: 'Traditional source',
          locator: 'section 1',
        ),
      ],
    );

    expect(item.countProvenance, isNull);
    expect(item.canEnterProductionDataset, isFalse);
  });

  test('guide without recommended count is valid only with no count sources', () {
    expect(entry(recommendedCount: null).canEnterProductionDataset, isTrue);
    expect(entry(recommendedCount: null).toSourceBackedTarget(), isNull);

    final dangling = entry(
      recommendedCount: null,
      countSources: [source()],
    );
    expect(dangling.canEnterProductionDataset, isFalse);
  });

  test('draft or incomplete source metadata fails closed', () {
    expect(
      entry(reviewStatus: ContentReviewStatus.religiousReview)
          .canEnterProductionDataset,
      isFalse,
    );
    expect(
      entry(sources: [source(licenseId: ' ')]).canEnterProductionDataset,
      isFalse,
    );
    expect(
      entry(countSources: [source(id: ' ')]).canEnterProductionDataset,
      isFalse,
    );
  });

  test('governed record remains typed as dhikr with explicit provenance', () {
    final record = entry().toGovernedRecord();

    expect(record.type, ContentType.dhikr);
    expect(record.sourceStatus, ReligiousSourceClass.sahihHasanHadith);
    expect(record.certainty, CertaintyLevel.explicitSource);
    expect(record.sources.single.id, 'hadith:stable');
    expect(record.text.isComplete, isTrue);
  });
}
