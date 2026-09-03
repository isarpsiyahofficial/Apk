import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';

void main() {
  const completeQuranSource = SourceReference(
    id: 'quran:94:5',
    title: 'Canonical Quran source',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'quran-canonical-license',
    locator: '94:5',
  );

  DhikrIntentionSuggestion suggestion({
    DhikrIntentionBasis basis = DhikrIntentionBasis.divineNameMeaning,
    List<SourceReference> sources = const <SourceReference>[],
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) {
    return DhikrIntentionSuggestion(
      id: 'intent:test:1',
      categoryId: DhikrIntentionCategoryId.provisionAndBlessing,
      divineNameId: 'esma:test:1',
      basis: basis,
      rationale: const LocalizedReligiousText(
        tr: 'Anlam ve dayanak bağlantısı.',
        en: 'Meaning and evidence connection.',
        ar: 'صلة بالمعنى والدليل.',
      ),
      reviewStatus: reviewStatus,
      version: 1,
      sourceReferences: sources,
    );
  }

  test('required intention categories are complete in TR EN AR', () {
    expect(dhikrIntentionCategories, hasLength(4));
    expect(
      dhikrIntentionCategories.map((item) => item.id).toSet(),
      equals(DhikrIntentionCategoryId.values.toSet()),
    );
    expect(dhikrIntentionCategories.every((item) => item.isComplete), isTrue);
  });

  test('divine-name meaning suggestion can rely on governed linked Esma', () {
    expect(suggestion().canEnterProductionDataset, isTrue);
  });

  test('Quran-based suggestion requires explicit matching Quran evidence', () {
    expect(
      suggestion(basis: DhikrIntentionBasis.quran).canEnterProductionDataset,
      isFalse,
    );
    expect(
      suggestion(
        basis: DhikrIntentionBasis.quran,
        sources: const [completeQuranSource],
      ).canEnterProductionDataset,
      isTrue,
    );
  });

  test('basis mismatch fails closed instead of laundering a source label', () {
    const hadithSource = SourceReference(
      id: 'hadith:test:1',
      title: 'Reviewed hadith source',
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'hadith-license',
      locator: 'collection:1',
    );

    expect(
      suggestion(
        basis: DhikrIntentionBasis.quran,
        sources: const [hadithSource],
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('incomplete or unknown source evidence fails closed', () {
    const unknownSource = SourceReference(
      id: 'unknown:test',
      title: 'Unknown source',
      sourceClass: ReligiousSourceClass.unknown,
      licenseId: 'unknown-license',
    );
    const missingLicense = SourceReference(
      id: 'quran:test',
      title: 'Quran source',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: '',
    );

    expect(
      suggestion(
        basis: DhikrIntentionBasis.quran,
        sources: const [unknownSource],
      ).canEnterProductionDataset,
      isFalse,
    );
    expect(
      suggestion(
        basis: DhikrIntentionBasis.quran,
        sources: const [missingLicense],
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('unreviewed suggestion fails closed', () {
    expect(
      suggestion(
        reviewStatus: ContentReviewStatus.languageReview,
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('incomplete suggestion shape is rejected', () {
    expect(
      () => DhikrIntentionSuggestion(
        id: '',
        categoryId: DhikrIntentionCategoryId.easeAndWayOut,
        divineNameId: 'esma:test:3',
        basis: DhikrIntentionBasis.quran,
        rationale: const LocalizedReligiousText(
          tr: 'Bağlantı.',
          en: 'Connection.',
          ar: 'صلة.',
        ),
        reviewStatus: ContentReviewStatus.published,
        version: 1,
      ),
      throwsArgumentError,
    );
  });
}
