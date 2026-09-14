import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const idrisNightJourneyHadithSourceT0336 = SourceReference(
  id: 'sahih-muslim-164a-idris-night-journey',
  title: 'Sahih Muslim',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih Muslim 164a',
);

const yahyaNightJourneyHadithSourceT0336 = SourceReference(
  id: 'sahih-muslim-164a-yahya-night-journey',
  title: 'Sahih Muslim',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih Muslim 164a',
);

const lutSupportHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3375-lut-support',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3375',
);

bool _isExactSource(SourceReference actual, SourceReference expected) =>
    actual.id == expected.id &&
    actual.title == expected.title &&
    actual.sourceClass == expected.sourceClass &&
    actual.licenseId == expected.licenseId &&
    actual.locator == expected.locator;

/// Sahih Muslim 164a explicitly identifies Idris during the Night Journey.
/// This satisfies only Idris's hadith slot and does not infer an earthly
/// geography, genealogy edge, chronology band, or exact historical date.
ProphetSemanticClaim buildIdrisHadithEvidenceT0336({
  String biographyProphetId = 'idris',
  String subjectProphetId = 'idris',
  SourceReference source = idrisNightJourneyHadithSourceT0336,
}) {
  if (biographyProphetId != 'idris' || subjectProphetId != 'idris') {
    throw StateError('Sahih Muslim 164a may only satisfy Idris hadith ownership');
  }
  if (!_isExactSource(source, idrisNightJourneyHadithSourceT0336)) {
    throw StateError('T0336 Idris hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:idris:sahih-muslim-164a-night-journey',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Sahih Muslim 164a explicitly identifies Yahya during the Night Journey.
/// The shared report also names other prophets; those contextual mentions do
/// not transfer Yahya's biography ownership or verify any other dimension.
ProphetSemanticClaim buildYahyaHadithEvidenceT0336({
  String biographyProphetId = 'yahya',
  String subjectProphetId = 'yahya',
  SourceReference source = yahyaNightJourneyHadithSourceT0336,
}) {
  if (biographyProphetId != 'yahya' || subjectProphetId != 'yahya') {
    throw StateError('Sahih Muslim 164a may only satisfy Yahya hadith ownership');
  }
  if (!_isExactSource(source, yahyaNightJourneyHadithSourceT0336)) {
    throw StateError('T0336 Yahya hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:yahya:sahih-muslim-164a-night-journey',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Sahih al-Bukhari 3375 directly names Lut in a prophetic report.
/// It is admitted only as hadith evidence; the statement does not establish an
/// exact date, geography, lineage edge, or chronology band for Lut.
ProphetSemanticClaim buildLutHadithEvidenceT0336({
  String biographyProphetId = 'lut',
  String subjectProphetId = 'lut',
  SourceReference source = lutSupportHadithSourceT0336,
}) {
  if (biographyProphetId != 'lut' || subjectProphetId != 'lut') {
    throw StateError(
      'Sahih al-Bukhari 3375 may only satisfy Lut hadith ownership',
    );
  }
  if (!_isExactSource(source, lutSupportHadithSourceT0336)) {
    throw StateError('T0336 Lut hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:lut:sahih-bukhari-3375-support',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch37 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildIdrisHadithEvidenceT0336(),
  buildYahyaHadithEvidenceT0336(),
  buildLutHadithEvidenceT0336(),
]);
