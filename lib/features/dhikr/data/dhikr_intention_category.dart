import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/domain/dhikr_outcome_claim_policy.dart';

enum DhikrIntentionCategoryId {
  provisionAndBlessing,
  loveAndMercy,
  spiritualSupportForHealing,
  easeAndWayOut,
}

enum DhikrIntentionBasis {
  divineNameMeaning,
  quran,
  sahihHasanHadith,
  meaningBasedDua,
}

final class DhikrIntentionCategory {
  const DhikrIntentionCategory({
    required this.id,
    required this.title,
    required this.description,
  });

  final DhikrIntentionCategoryId id;
  final LocalizedReligiousText title;
  final LocalizedReligiousText description;

  bool get isComplete => title.isComplete && description.isComplete;
}

final class DhikrIntentionSuggestion {
  DhikrIntentionSuggestion({
    required this.id,
    required this.categoryId,
    required this.divineNameId,
    required this.basis,
    required this.rationale,
    required this.reviewStatus,
    required this.version,
    this.sourceReferences = const <SourceReference>[],
  }) {
    if (id.trim().isEmpty ||
        divineNameId.trim().isEmpty ||
        !rationale.isComplete ||
        version <= 0) {
      throw ArgumentError('Dhikr intention suggestion is incomplete.');
    }
  }

  final String id;
  final DhikrIntentionCategoryId categoryId;
  final String divineNameId;
  final DhikrIntentionBasis basis;
  final LocalizedReligiousText rationale;
  final ContentReviewStatus reviewStatus;
  final int version;
  final List<SourceReference> sourceReferences;

  bool get hasValidBasisEvidence {
    if (basis == DhikrIntentionBasis.divineNameMeaning) {
      // The linked DivineNameEntry carries its own governed source chain.
      // Explicit extra references are allowed, but are not required here.
      return sourceReferences.every(_isCompleteReference);
    }

    if (sourceReferences.isEmpty ||
        !sourceReferences.every(_isCompleteReference)) {
      return false;
    }

    final requiredClass = switch (basis) {
      DhikrIntentionBasis.quran => ReligiousSourceClass.quran,
      DhikrIntentionBasis.sahihHasanHadith =>
        ReligiousSourceClass.sahihHasanHadith,
      DhikrIntentionBasis.meaningBasedDua => ReligiousSourceClass.meaningBasedDua,
      DhikrIntentionBasis.divineNameMeaning => throw StateError('unreachable'),
    };
    return sourceReferences.any((source) => source.sourceClass == requiredClass);
  }

  bool get canEnterProductionDataset =>
      reviewStatus == ContentReviewStatus.published &&
      id.trim().isNotEmpty &&
      divineNameId.trim().isNotEmpty &&
      rationale.isComplete &&
      version > 0 &&
      hasValidBasisEvidence &&
      DhikrOutcomeClaimPolicy.allows(rationale);

  static bool _isCompleteReference(SourceReference source) =>
      source.id.trim().isNotEmpty &&
      source.title.trim().isNotEmpty &&
      source.licenseId.trim().isNotEmpty &&
      source.sourceClass != ReligiousSourceClass.unknown;
}

const dhikrIntentionCategories = <DhikrIntentionCategory>[
  DhikrIntentionCategory(
    id: DhikrIntentionCategoryId.provisionAndBlessing,
    title: LocalizedReligiousText(
      tr: 'Rızık ve bereket',
      en: 'Provision and blessing',
      ar: 'الرزق والبركة',
    ),
    description: LocalizedReligiousText(
      tr: 'Anlam ve güvenilir dayanak bağlantısı üzerinden ilgili Esmâ ve duaları keşfet.',
      en: 'Explore related Divine Names and supplications through meaning and verified evidence links.',
      ar: 'استكشف الأسماء والأدعية ذات الصلة من خلال المعنى والروابط الموثقة.',
    ),
  ),
  DhikrIntentionCategory(
    id: DhikrIntentionCategoryId.loveAndMercy,
    title: LocalizedReligiousText(
      tr: 'Sevgi ve merhamet',
      en: 'Love and mercy',
      ar: 'المحبة والرحمة',
    ),
    description: LocalizedReligiousText(
      tr: 'Sevgi ve merhamet anlamıyla ilişkili güvenilir dini içeriği keşfet.',
      en: 'Explore verified religious content connected to the meanings of love and mercy.',
      ar: 'استكشف المحتوى الديني الموثق المرتبط بمعاني المحبة والرحمة.',
    ),
  ),
  DhikrIntentionCategory(
    id: DhikrIntentionCategoryId.spiritualSupportForHealing,
    title: LocalizedReligiousText(
      tr: 'Şifa için manevi destek',
      en: 'Spiritual support for healing',
      ar: 'الدعم الروحي للشفاء',
    ),
    description: LocalizedReligiousText(
      tr: 'Manevi destek içeriğini gör; bu alan tıbbi tedavi veya sağlık sonucu garantisi değildir.',
      en: 'View spiritual-support content; this is not medical treatment or a guarantee of a health outcome.',
      ar: 'اعرض محتوى الدعم الروحي؛ فهذا ليس علاجًا طبيًا ولا ضمانًا لنتيجة صحية.',
    ),
  ),
  DhikrIntentionCategory(
    id: DhikrIntentionCategoryId.easeAndWayOut,
    title: LocalizedReligiousText(
      tr: 'Kolaylık ve çıkış yolu',
      en: 'Ease and a way forward',
      ar: 'التيسير والمخرج',
    ),
    description: LocalizedReligiousText(
      tr: 'Kolaylık, sabır ve çıkış yolu temalarıyla ilişkili doğrulanmış içeriği keşfet.',
      en: 'Explore verified content connected to ease, patience and finding a way forward.',
      ar: 'استكشف المحتوى الموثق المرتبط بالتيسير والصبر وطلب المخرج.',
    ),
  ),
];
