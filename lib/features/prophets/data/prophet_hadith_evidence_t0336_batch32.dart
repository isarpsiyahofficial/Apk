import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const ibrahimCircumcisionHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3356-ibrahim-circumcision',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3356',
);

bool _isExactIbrahimHadithSourceT0336(SourceReference source) =>
    source.id == ibrahimCircumcisionHadithSourceT0336.id &&
    source.title == ibrahimCircumcisionHadithSourceT0336.title &&
    source.sourceClass == ibrahimCircumcisionHadithSourceT0336.sourceClass &&
    source.licenseId == ibrahimCircumcisionHadithSourceT0336.licenseId &&
    source.locator == ibrahimCircumcisionHadithSourceT0336.locator;

/// Builds the source-reviewed T0336 hadith evidence for Ibrahim.
///
/// The underlying report states that Ibrahim was circumcised at the age of
/// eighty. This semantic record deliberately contributes only to the hadith
/// dimension. It does not promote the age into an exact calendar date,
/// chronology band, geography, or genealogy claim.
ProphetSemanticClaim buildIbrahimHadithEvidenceT0336({
  String biographyProphetId = 'ibrahim',
  String subjectProphetId = 'ibrahim',
  SourceReference source = ibrahimCircumcisionHadithSourceT0336,
}) {
  if (biographyProphetId != 'ibrahim' || subjectProphetId != 'ibrahim') {
    throw StateError(
      'Sahih al-Bukhari 3356 may only satisfy Ibrahim hadith ownership',
    );
  }
  if (!_isExactIbrahimHadithSourceT0336(source)) {
    throw StateError('T0336 Ibrahim hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:ibrahim:sahih-bukhari-3356-circumcision-age-eighty',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch32 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildIbrahimHadithEvidenceT0336(),
]);
