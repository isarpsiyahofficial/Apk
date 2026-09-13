import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const musaCommunityHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3410-musa-community',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3410',
);

const isaPropheticSuccessionHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3442-isa-prophetic-succession',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3442',
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

/// Source-reviewed hadith evidence for Musa.
///
/// Sahih al-Bukhari 3410 explicitly identifies Musa together with his people.
/// This evidence satisfies only Musa's hadith slot. It does not infer an exact
/// historical date, earthly location, genealogy edge, or chronology band.
ProphetSemanticClaim buildMusaHadithEvidenceT0336({
  String biographyProphetId = 'musa',
  String subjectProphetId = 'musa',
  SourceReference source = musaCommunityHadithSourceT0336,
}) {
  if (biographyProphetId != 'musa' || subjectProphetId != 'musa') {
    throw StateError(
      'Sahih al-Bukhari 3410 may only satisfy Musa hadith ownership',
    );
  }
  if (!_isExactSource(source, musaCommunityHadithSourceT0336)) {
    throw StateError('T0336 Musa hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:musa:sahih-bukhari-3410-community',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Source-reviewed hadith evidence for Isa.
///
/// Sahih al-Bukhari 3442 explicitly names Isa ibn Maryam and states that no
/// prophet came between him and Muhammad. The semantic claim deliberately
/// remains hadith-only: it does not promote chronology or an exact date.
ProphetSemanticClaim buildIsaHadithEvidenceT0336({
  String biographyProphetId = 'isa',
  String subjectProphetId = 'isa',
  SourceReference source = isaPropheticSuccessionHadithSourceT0336,
}) {
  if (biographyProphetId != 'isa' || subjectProphetId != 'isa') {
    throw StateError(
      'Sahih al-Bukhari 3442 may only satisfy Isa hadith ownership',
    );
  }
  if (!_isExactSource(source, isaPropheticSuccessionHadithSourceT0336)) {
    throw StateError('T0336 Isa hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:isa:sahih-bukhari-3442-prophetic-succession',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch34 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildMusaHadithEvidenceT0336(),
  buildIsaHadithEvidenceT0336(),
]);