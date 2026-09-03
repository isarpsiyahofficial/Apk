import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
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
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 9, 3),
      );

  test('accepts only fully production-eligible Esma records', () {
    final repository = DivineNameRepository(
      entries: [entry('esma:one'), entry('esma:two')],
    );

    expect(repository.entries, hasLength(2));
    expect(repository.findById('esma:two')?.id, 'esma:two');
    expect(repository.findById('  esma:one  ')?.id, 'esma:one');
    expect(repository.findById('missing'), isNull);
  });

  test('empty production dataset fails closed', () {
    expect(
      () => DivineNameRepository(entries: const []),
      throwsStateError,
    );
  });

  test('one unreviewed record rejects the whole production dataset', () {
    expect(
      () => DivineNameRepository(
        entries: [
          entry('esma:published'),
          entry(
            'esma:pending',
            reviewStatus: ContentReviewStatus.languageReview,
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
      ),
      throwsStateError,
    );
  });

  test('exposed collection is immutable', () {
    final repository = DivineNameRepository(entries: [entry('esma:one')]);

    expect(
      () => repository.entries.add(entry('esma:two')),
      throwsUnsupportedError,
    );
  });
}
