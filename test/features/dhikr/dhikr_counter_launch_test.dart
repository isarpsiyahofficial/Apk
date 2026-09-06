import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/domain/dhikr_counter_launch.dart';

void main() {
  SourceReference source() => const SourceReference(
        id: 'hadith:stable:33',
        title: 'Verified hadith source',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'source-license',
        locator: 'chapter 2, narration 7',
      );

  DhikrGuideEntry entry({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
    int? recommendedCount = 33,
  }) => DhikrGuideEntry(
        id: 'dhikr:guide:1',
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
        sources: [source()],
        reviewStatus: reviewStatus,
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 8, 28),
        recommendedCount: recommendedCount,
        countSources: recommendedCount == null ? const [] : [source()],
      );

  test('reviewed guide loads exact identity and sourced target into counter', () {
    final launch = DhikrCounterLaunch.fromGuide(entry());

    expect(launch.guideEntryId, 'dhikr:guide:1');
    expect(launch.arabic, 'سُبْحَانَ اللَّهِ');
    expect(launch.transliterationTr, 'Sübhânallah');
    expect(launch.transliterationEn, 'Subhanallah');
    expect(launch.hasSourceBackedTarget, isTrue);
    expect(launch.target!.count, 33);
    expect(launch.target!.sourceId, 'hadith:stable:33');
  });

  test('guide without sourced count loads without inventing a target', () {
    final launch = DhikrCounterLaunch.fromGuide(entry(recommendedCount: null));

    expect(launch.hasSourceBackedTarget, isFalse);
    expect(launch.target, isNull);
  });

  test('unreviewed guide cannot be launched into counter', () {
    expect(
      () => DhikrCounterLaunch.fromGuide(
        entry(reviewStatus: ContentReviewStatus.religiousReview),
      ),
      throwsStateError,
    );
  });
}
