import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';

void main() {
  test('required intention categories are complete in TR EN AR', () {
    expect(dhikrIntentionCategories, hasLength(4));
    expect(
      dhikrIntentionCategories.map((item) => item.id).toSet(),
      equals(DhikrIntentionCategoryId.values.toSet()),
    );
    expect(dhikrIntentionCategories.every((item) => item.isComplete), isTrue);
  });

  test('published complete suggestion can enter production dataset', () {
    final suggestion = DhikrIntentionSuggestion(
      id: 'intent:test:1',
      categoryId: DhikrIntentionCategoryId.provisionAndBlessing,
      divineNameId: 'esma:test:1',
      basis: DhikrIntentionBasis.divineNameMeaning,
      rationale: const LocalizedReligiousText(
        tr: 'Anlam bağlantısı.',
        en: 'Meaning connection.',
        ar: 'صلة بالمعنى.',
      ),
      reviewStatus: ContentReviewStatus.published,
      version: 1,
    );

    expect(suggestion.canEnterProductionDataset, isTrue);
  });

  test('unreviewed suggestion fails closed', () {
    final suggestion = DhikrIntentionSuggestion(
      id: 'intent:test:2',
      categoryId: DhikrIntentionCategoryId.loveAndMercy,
      divineNameId: 'esma:test:2',
      basis: DhikrIntentionBasis.divineNameMeaning,
      rationale: const LocalizedReligiousText(
        tr: 'Anlam bağlantısı.',
        en: 'Meaning connection.',
        ar: 'صلة بالمعنى.',
      ),
      reviewStatus: ContentReviewStatus.languageReview,
      version: 1,
    );

    expect(suggestion.canEnterProductionDataset, isFalse);
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
