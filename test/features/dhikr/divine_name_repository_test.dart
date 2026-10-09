import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_dataset_review.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_repository.dart';

void main() {
  SourceReference quranSource(String locator) => SourceReference(
        id: 'quran:$locator',
        title: 'Pinned Quran source',
        sourceClass: ReligiousSourceClass.quran,
        licenseId: 'quran-license',
        locator: locator,
      );

  DivineNameEntry entry(
    String id, {
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
    int version = 1,
    DateTime? lastReviewedAt,
  }) =>
      DivineNameEntry(
        id: id,
        arabic: 'اسم عربي تجريبي',
        transliterationTr: 'Kaynak inceleme örneği',
        transliterationEn: 'Source review example',
        meaning: const LocalizedReligiousText(
          tr: 'İnceleme amaçlı anlam.',
          en: 'Meaning used for review testing.',
          ar: 'معنى مخصص لاختبار المراجعة.',
        ),
        whyRecited: const LocalizedReligiousText(
          tr: 'Yalnız kaynak bağlantısı davranışını test eder.',
          en: 'Only tests source-link behavior.',
          ar: 'يختبر سلوك ربط المصدر فقط.',
        ),
        sources: [quranSource('1:1')],
        reviewStatus: reviewStatus,
        version: version,
        lastReviewedAt: lastReviewedAt ?? DateTime.utc(2026, 9, 3),
      );

  DivineNameDatasetReviewEvidence evidence(
    String id, {
    int version = 1,
    DivineNameReviewDecision religious = DivineNameReviewDecision.approved,
    DivineNameReviewDecision tr = DivineNameReviewDecision.approved,
    DivineNameReviewDecision en = DivineNameReviewDecision.approved,
    DivineNameReviewDecision ar = DivineNameReviewDecision.approved,
    DateTime? reviewedAt,
  }) =>
      DivineNameDatasetReviewEvidence(
        entryId: id,
        contentVersion: version,
        religiousReview: religious,
        turkishNativeReview: tr,
        englishNativeReview: en,
        arabicNativeReview: ar,
        reviewedAt: reviewedAt ?? DateTime.utc(2026, 9, 3),
        religiousReviewerId: 'religious-reviewer',
        turkishReviewerId: 'tr-reviewer',
        englishReviewerId: 'en-reviewer',
        arabicReviewerId: 'ar-reviewer',
      );

  test('accepts exact-version religious plus TR EN AR reviewed Esma records', () {
    final repository = DivineNameRepository(
      entries: [entry('esma:one'), entry('esma:two')],
      reviewEvidence: [evidence('esma:one'), evidence('esma:two')],
    );

    expect(repository.entries, hasLength(2));
    expect(repository.findById('esma:two')?.id, 'esma:two');
    expect(repository.findById('  esma:one  ')?.id, 'esma:one');
    expect(repository.findById('missing'), isNull);
  });

  test('empty production dataset fails closed', () {
    expect(
      () => DivineNameRepository(entries: const [], reviewEvidence: const []),
      throwsStateError,
    );
  });

  test('one source-unreviewed record rejects the whole production dataset', () {
    expect(
      () => DivineNameRepository(
        entries: [
          entry('esma:published'),
          entry(
            'esma:pending',
            reviewStatus: ContentReviewStatus.languageReview,
          ),
        ],
        reviewEvidence: [
          evidence('esma:published'),
          evidence('esma:pending'),
        ],
      ),
      throwsStateError,
    );
  });

  test('missing native Arabic approval fails closed', () {
    expect(
      () => DivineNameRepository(
        entries: [entry('esma:one')],
        reviewEvidence: [
          evidence('esma:one', ar: DivineNameReviewDecision.pending),
        ],
      ),
      throwsStateError,
    );
  });

  test('review for an older content version cannot authorize edited record', () {
    expect(
      () => DivineNameRepository(
        entries: [entry('esma:one', version: 2)],
        reviewEvidence: [evidence('esma:one', version: 1)],
      ),
      throwsStateError,
    );
  });

  test('stale review timestamp cannot authorize re-reviewed content', () {
    expect(
      () => DivineNameRepository(
        entries: [
          entry(
            'esma:one',
            lastReviewedAt: DateTime.utc(2026, 9, 3, 12),
          ),
        ],
        reviewEvidence: [
          evidence(
            'esma:one',
            reviewedAt: DateTime.utc(2026, 9, 3, 11),
          ),
        ],
      ),
      throwsStateError,
    );
  });

  test('duplicate stable ids reject the production dataset', () {
    expect(
      () => DivineNameRepository(
        entries: [entry('esma:duplicate'), entry('esma:duplicate')],
        reviewEvidence: [evidence('esma:duplicate')],
      ),
      throwsStateError,
    );
  });

  test('duplicate review evidence rejects the production dataset', () {
    expect(
      () => DivineNameRepository(
        entries: [entry('esma:one')],
        reviewEvidence: [evidence('esma:one'), evidence('esma:one')],
      ),
      throwsStateError,
    );
  });

  test('exposed collection is immutable', () {
    final repository = DivineNameRepository(
      entries: [entry('esma:one')],
      reviewEvidence: [evidence('esma:one')],
    );

    expect(
      () => repository.entries.add(entry('esma:two')),
      throwsUnsupportedError,
    );
  });
}
