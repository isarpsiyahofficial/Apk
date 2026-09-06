import '../../../core/content/content_governance.dart';
import '../../quran/data/canonical_quran_source.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements.dart';
import 'prophet_biography_t0194_supplements_10.dart';
import 'prophet_biography_t0194_supplements_11.dart';
import 'prophet_biography_t0194_supplements_12.dart';
import 'prophet_biography_t0194_supplements_13.dart';
import 'prophet_biography_t0194_supplements_14.dart';
import 'prophet_biography_t0194_supplements_15.dart';
import 'prophet_biography_t0194_supplements_2.dart';
import 'prophet_biography_t0194_supplements_3.dart';
import 'prophet_biography_t0194_supplements_4.dart';
import 'prophet_biography_t0194_supplements_5.dart';
import 'prophet_biography_t0194_supplements_6.dart';
import 'prophet_biography_t0194_supplements_7.dart';
import 'prophet_biography_t0194_supplements_8.dart';
import 'prophet_biography_t0194_supplements_9.dart';
import 'prophet_content.dart';

CanonicalProphetBiographyDraft _applySupplement(
  CanonicalProphetBiographyDraft draft,
) {
  final firstSupplement =
      t0194ProphetBiographySupplements[draft.identity.canonicalId];
  final secondSupplement =
      t0194ProphetBiographySupplements2[draft.identity.canonicalId];
  final thirdSupplement =
      t0194ProphetBiographySupplements3[draft.identity.canonicalId];
  final fourthSupplement =
      t0194ProphetBiographySupplements4[draft.identity.canonicalId];
  final fifthSupplement =
      t0194ProphetBiographySupplements5[draft.identity.canonicalId];
  final sixthSupplement =
      t0194ProphetBiographySupplements6[draft.identity.canonicalId];
  final seventhSupplement =
      t0194ProphetBiographySupplements7[draft.identity.canonicalId];
  final eighthSupplement =
      t0194ProphetBiographySupplements8[draft.identity.canonicalId];
  final ninthSupplement =
      t0194ProphetBiographySupplements9[draft.identity.canonicalId];
  final tenthSupplement =
      t0194ProphetBiographySupplements10[draft.identity.canonicalId];
  final eleventhSupplement =
      t0194ProphetBiographySupplements11[draft.identity.canonicalId];
  final twelfthSupplement =
      t0194ProphetBiographySupplements12[draft.identity.canonicalId];
  final thirteenthSupplement =
      t0194ProphetBiographySupplements13[draft.identity.canonicalId];
  final fourteenthSupplement =
      t0194ProphetBiographySupplements14[draft.identity.canonicalId];
  final fifteenthSupplement =
      t0194ProphetBiographySupplements15[draft.identity.canonicalId];
  final firstReferences =
      t0194ProphetSupplementReferences[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final secondReferences =
      t0194ProphetSupplementReferences2[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final thirdReferences =
      t0194ProphetSupplementReferences3[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fourthReferences =
      t0194ProphetSupplementReferences4[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fifthReferences =
      t0194ProphetSupplementReferences5[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final seventhReferences =
      t0194ProphetSupplementReferences7[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final eighthReferences =
      t0194ProphetSupplementReferences8[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final ninthReferences =
      t0194ProphetSupplementReferences9[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final tenthReferences =
      t0194ProphetSupplementReferences10[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final eleventhReferences =
      t0194ProphetSupplementReferences11[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final twelfthReferences =
      t0194ProphetSupplementReferences12[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final thirteenthReferences =
      t0194ProphetSupplementReferences13[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fourteenthReferences =
      t0194ProphetSupplementReferences14[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fifteenthReferences =
      t0194ProphetSupplementReferences15[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];

  if (firstSupplement == null &&
      secondSupplement == null &&
      thirdSupplement == null &&
      fourthSupplement == null &&
      fifthSupplement == null &&
      sixthSupplement == null &&
      seventhSupplement == null &&
      eighthSupplement == null &&
      ninthSupplement == null &&
      tenthSupplement == null &&
      eleventhSupplement == null &&
      twelfthSupplement == null &&
      thirteenthSupplement == null &&
      fourteenthSupplement == null &&
      fifteenthSupplement == null &&
      firstReferences.isEmpty &&
      secondReferences.isEmpty &&
      thirdReferences.isEmpty &&
      fourthReferences.isEmpty &&
      fifthReferences.isEmpty &&
      seventhReferences.isEmpty &&
      eighthReferences.isEmpty &&
      ninthReferences.isEmpty &&
      tenthReferences.isEmpty &&
      eleventhReferences.isEmpty &&
      twelfthReferences.isEmpty &&
      thirteenthReferences.isEmpty &&
      fourteenthReferences.isEmpty &&
      fifteenthReferences.isEmpty) {
    return draft;
  }

  final referencesById = <String, ProphetVerseReference>{
    for (final reference in draft.quranReferences) reference.stableId: reference,
    for (final reference in firstReferences) reference.stableId: reference,
    for (final reference in secondReferences) reference.stableId: reference,
    for (final reference in thirdReferences) reference.stableId: reference,
    for (final reference in fourthReferences) reference.stableId: reference,
    for (final reference in fifthReferences) reference.stableId: reference,
    for (final reference in seventhReferences) reference.stableId: reference,
    for (final reference in eighthReferences) reference.stableId: reference,
    for (final reference in ninthReferences) reference.stableId: reference,
    for (final reference in tenthReferences) reference.stableId: reference,
    for (final reference in eleventhReferences) reference.stableId: reference,
    for (final reference in twelfthReferences) reference.stableId: reference,
    for (final reference in thirteenthReferences) reference.stableId: reference,
    for (final reference in fourteenthReferences) reference.stableId: reference,
    for (final reference in fifteenthReferences) reference.stableId: reference,
  };

  return CanonicalProphetBiographyDraft(
    identity: draft.identity,
    quranReferences: referencesById.values.toList(growable: false),
    sections: <ProphetBiographySectionKey, ProphetBiographyField>{
      ...draft.sections,
      if (firstSupplement != null) ...firstSupplement,
      if (secondSupplement != null) ...secondSupplement,
      if (thirdSupplement != null) ...thirdSupplement,
      if (fourthSupplement != null) ...fourthSupplement,
      if (fifthSupplement != null) ...fifthSupplement,
      if (sixthSupplement != null) ...sixthSupplement,
      if (seventhSupplement != null) ...seventhSupplement,
      if (eighthSupplement != null) ...eighthSupplement,
      if (ninthSupplement != null) ...ninthSupplement,
      if (tenthSupplement != null) ...tenthSupplement,
      if (eleventhSupplement != null) ...eleventhSupplement,
      if (twelfthSupplement != null) ...twelfthSupplement,
      if (thirteenthSupplement != null) ...thirteenthSupplement,
      if (fourteenthSupplement != null) ...fourteenthSupplement,
      if (fifteenthSupplement != null) ...fifteenthSupplement,
    },
  );
}

bool _isAuditableQuranLocator(String locator) {
  if (!locator.startsWith('Quran ')) return false;
  final citations = locator.substring('Quran '.length).split(RegExp(r'[;,]'));
  if (citations.isEmpty) return false;

  for (final rawCitation in citations) {
    final citation = rawCitation.trim();
    final match = RegExp(r'^(\d{1,3}):(\d+)(?:-(\d+))?$').firstMatch(citation);
    if (match == null) return false;

    final surah = int.parse(match.group(1)!);
    final startAyah = int.parse(match.group(2)!);
    final endAyah = int.tryParse(match.group(3) ?? '') ?? startAyah;
    if (surah < 1 || surah > canonicalQuranSuraCount || startAyah < 1) {
      return false;
    }
    final maxAyah = canonicalQuranAyahCountForSura(surah);
    if (startAyah > maxAyah || endAyah < startAyah || endAyah > maxAyah) {
      return false;
    }
  }
  return true;
}

bool _isPinnedTanzilQuranSource(SourceReference source) =>
    source.sourceClass == ReligiousSourceClass.quran &&
    source.id.startsWith('tanzil-uthmani-v1.1-') &&
    source.title == 'Tanzil Project — Uthmani Quran Text v1.1' &&
    source.licenseId == 'CC-BY-3.0';

const _admittedHadithSources = <String, ({String title, String locator})>{
  'sahih-muslim-1162e-muhammad-birth': (
    title: 'Sahih Muslim',
    locator: 'Sahih Muslim 1162e',
  ),
  'sahih-bukhari-4449-muhammad-death': (
    title: 'Sahih al-Bukhari',
    locator: 'Sahih al-Bukhari 4449',
  ),
};

bool _isAuditableHadithSource(SourceReference source) {
  if (source.sourceClass != ReligiousSourceClass.sahihHasanHadith ||
      source.licenseId != 'REFERENCE-ONLY') {
    return false;
  }

  final locator = source.locator?.trim();
  if (locator == null || locator.isEmpty) return false;
  final admitted = _admittedHadithSources[source.id];
  return admitted != null &&
      source.title == admitted.title &&
      locator == admitted.locator;
}

const _admittedModernHistorySources =
    <String, ({String title, String locator, String licenseId, String url})>{
  'cambridge-impact-jesus-first-century-palestine-2019': (
    title:
        'The Impact of Jesus in First-Century Palestine — Cambridge University Press',
    locator: 'Book description; DOI 10.1017/9781108612364',
    licenseId: 'COPYRIGHT-CAMBRIDGE-CITATION-ONLY',
    url: 'https://doi.org/10.1017/9781108612364',
  ),
};

bool _isAuditableModernHistorySource(SourceReference source) {
  if (source.sourceClass != ReligiousSourceClass.modernHistoryArchaeology) {
    return false;
  }

  final locator = source.locator?.trim();
  final url = source.url?.toString();
  if (locator == null || locator.isEmpty || url == null || url.isEmpty) {
    return false;
  }
  final admitted = _admittedModernHistorySources[source.id];
  return admitted != null &&
      source.title == admitted.title &&
      locator == admitted.locator &&
      source.licenseId == admitted.licenseId &&
      url == admitted.url;
}

bool _draftQuranReferencesExistInPinnedStructure(
  CanonicalProphetBiographyDraft draft,
) {
  for (final reference in draft.quranReferences) {
    if (reference.surah < 1 || reference.surah > canonicalQuranSuraCount) {
      return false;
    }
    if (reference.ayah < 1 ||
        reference.ayah > canonicalQuranAyahCountForSura(reference.surah)) {
      return false;
    }
  }
  return true;
}

/// T0194 fail-closed provenance gate for biography claims. A field labelled as
/// source-backed must point to a human-auditable locator; source identity and
/// licence metadata alone are not enough evidence. Quran claims must use the
/// pinned Tanzil Uthmani v1.1 source identity and parseable
/// `Quran surah:ayah[-ayah]` citations whose ayah bounds exist in the pinned
/// 114-sura Quran structure. Sahih/hasan hadith claims fail closed to the exact,
/// source-reviewed reports admitted by this dataset. Modern historical claims
/// likewise fail closed to exact admitted scholarly source metadata and remain
/// explicitly classified as modern history/archaeology rather than Quran or
/// hadith evidence. Any other source class is rejected at this T0194 gate.
bool prophetBiographyT0194DraftHasTraceableProvenance(
  CanonicalProphetBiographyDraft draft,
) {
  if (!_draftQuranReferencesExistInPinnedStructure(draft)) return false;

  for (final field in draft.sections.values) {
    if (field.status != ProphetBiographyFieldStatus.sourceBacked) continue;
    if (field.sources.isEmpty) return false;
    for (final source in field.sources) {
      final locator = source.locator?.trim();
      if (locator == null || locator.isEmpty) return false;

      switch (source.sourceClass) {
        case ReligiousSourceClass.quran:
          if (!_isPinnedTanzilQuranSource(source) ||
              !_isAuditableQuranLocator(locator)) {
            return false;
          }
          break;
        case ReligiousSourceClass.sahihHasanHadith:
          if (!_isAuditableHadithSource(source)) return false;
          break;
        case ReligiousSourceClass.modernHistoryArchaeology:
          if (!_isAuditableModernHistorySource(source)) return false;
          break;
        default:
          return false;
      }
    }
  }
  return true;
}

/// T0194 working dataset. It preserves the 25 canonical identities while
/// layering source-reviewed biography fields onto the fail-closed base drafts.
///
/// Unresolved fields remain `unknownPendingResearch`, but structural validity
/// itself does not require every biography to keep a pending field. This lets a
/// fully researched biography become complete without making the whole working
/// dataset invalid while other prophets still remain under review.
final canonicalProphetBiographyT0194Dataset = <CanonicalProphetBiographyDraft>[
  for (final draft in canonicalProphetBiographyDrafts) _applySupplement(draft),
];

bool get canonicalProphetBiographyT0194DatasetIsStructurallyValid =>
    canonicalProphetBiographyT0194Dataset.length == 25 &&
    canonicalProphetBiographyT0194Dataset.every(
      (draft) =>
          draft.isStructurallyComplete &&
          prophetBiographyT0194DraftHasTraceableProvenance(draft),
    );
