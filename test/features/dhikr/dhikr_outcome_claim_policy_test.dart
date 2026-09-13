import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';
import 'package:islami_hayat/features/dhikr/domain/dhikr_outcome_claim_policy.dart';

void main() {
  const safeRationale = LocalizedReligiousText(
    tr: 'Bu öneri yalnız ismin anlamı ile rızık temasındaki anlam bağlantısını açıklar; maddi sonuç vaat etmez.',
    en: 'This suggestion only explains the meaning connection with provision and does not promise a material outcome.',
    ar: 'يشرح هذا الاقتراح صلة المعنى بموضوع الرزق فقط ولا يعد بنتيجة مادية.',
  );

  DhikrIntentionSuggestion suggestion(LocalizedReligiousText rationale) {
    return DhikrIntentionSuggestion(
      id: 'intent:claim-policy:test',
      categoryId: DhikrIntentionCategoryId.provisionAndBlessing,
      divineNameId: 'esma:test',
      basis: DhikrIntentionBasis.divineNameMeaning,
      rationale: rationale,
      reviewStatus: ContentReviewStatus.published,
      version: 1,
    );
  }

  test('meaning/evidence connection remains allowed', () {
    expect(DhikrOutcomeClaimPolicy.allows(safeRationale), isTrue);
    expect(suggestion(safeRationale).canEnterProductionDataset, isTrue);
  });

  test('Turkish guaranteed money claim fails closed', () {
    const rationale = LocalizedReligiousText(
      tr: 'Bu zikri söylemek kesin para getirir.',
      en: 'Meaning connection only.',
      ar: 'صلة معنى فقط.',
    );

    expect(DhikrOutcomeClaimPolicy.allows(rationale), isFalse);
    expect(suggestion(rationale).canEnterProductionDataset, isFalse);
    expect(
      () => DhikrOutcomeClaimPolicy.requireAllowed(rationale),
      throwsStateError,
    );
  });

  test('English coercive love claim fails closed', () {
    const rationale = LocalizedReligiousText(
      tr: 'Yalnız anlam bağlantısı.',
      en: 'Reciting this will make them love you.',
      ar: 'صلة معنى فقط.',
    );

    expect(DhikrOutcomeClaimPolicy.allows(rationale), isFalse);
    expect(suggestion(rationale).canEnterProductionDataset, isFalse);
  });

  test('Arabic healing guarantee fails closed', () {
    const rationale = LocalizedReligiousText(
      tr: 'Yalnız anlam bağlantısı.',
      en: 'Meaning connection only.',
      ar: 'هذا الذكر يضمن الشفاء.',
    );

    expect(DhikrOutcomeClaimPolicy.allows(rationale), isFalse);
    expect(suggestion(rationale).canEnterProductionDataset, isFalse);
  });

  test('one unsafe locale blocks the whole three-language record', () {
    const rationale = LocalizedReligiousText(
      tr: 'Yalnız anlam bağlantısı.',
      en: 'This brings money.',
      ar: 'صلة معنى فقط.',
    );

    expect(suggestion(rationale).canEnterProductionDataset, isFalse);
  });
}
