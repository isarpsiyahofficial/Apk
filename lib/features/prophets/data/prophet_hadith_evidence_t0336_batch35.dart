import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const ayyubBlessingHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3391-ayyub-blessing',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3391',
);

const sulaymanInshaAllahHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3424-sulayman-inshaallah',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3424',
);

bool _isExactSource(
  SourceReference actual,
  SourceReference expected,
) =>
    actual.id == expected.id &&
    actual.title == expected.title &&
    actual.sourceClass == expected.sourceClass &&
    actual.licenseId == expected.licenseId &&
    actual.locator == expected.locator;

/// Source-reviewed hadith evidence for Ayyub.
///
/// Sahih al-Bukhari 3391 explicitly identifies Ayyub in the account of the
/// golden locusts and his response concerning Allah's blessing. This evidence
/// satisfies only Ayyub's hadith slot and does not infer a civil date,
/// genealogy edge, earthly location, or chronology band.
ProphetSemanticClaim buildAyyubHadithEvidenceT0336({
  String biographyProphetId = 'ayyub',
  String subjectProphetId = 'ayyub',
  SourceReference source = ayyubBlessingHadithSourceT0336,
}) {
  if (biographyProphetId != 'ayyub' || subjectProphetId != 'ayyub') {
    throw StateError(
      'Sahih al-Bukhari 3391 may only satisfy Ayyub hadith ownership',
    );
  }
  if (!_isExactSource(source, ayyubBlessingHadithSourceT0336)) {
    throw StateError('T0336 Ayyub hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:ayyub:sahih-bukhari-3391-blessing',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Source-reviewed hadith evidence for Sulayman.
///
/// Sahih al-Bukhari 3424 explicitly identifies Sulayman ibn Dawud in the
/// well-known in-sha-Allah account. It is deliberately admitted as hadith-only
/// evidence: the reported family context does not automatically verify a
/// genealogy slot, exact date, geography, or chronology.
ProphetSemanticClaim buildSulaymanHadithEvidenceT0336({
  String biographyProphetId = 'sulayman',
  String subjectProphetId = 'sulayman',
  SourceReference source = sulaymanInshaAllahHadithSourceT0336,
}) {
  if (biographyProphetId != 'sulayman' || subjectProphetId != 'sulayman') {
    throw StateError(
      'Sahih al-Bukhari 3424 may only satisfy Sulayman hadith ownership',
    );
  }
  if (!_isExactSource(source, sulaymanInshaAllahHadithSourceT0336)) {
    throw StateError('T0336 Sulayman hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:sulayman:sahih-bukhari-3424-inshaallah',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch35 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildAyyubHadithEvidenceT0336(),
  buildSulaymanHadithEvidenceT0336(),
]);
