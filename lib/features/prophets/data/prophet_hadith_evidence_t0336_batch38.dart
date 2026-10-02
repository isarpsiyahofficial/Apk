import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const ismailZamzamKabaHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3364-ismail-zamzam-kaba',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3364',
);

const salihSheCamelHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3377-salih-she-camel',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3377',
);

const zakariyaCarpenterHadithSourceT0336 = SourceReference(
  id: 'sahih-muslim-2379-zakariya-carpenter',
  title: 'Sahih Muslim',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih Muslim 2379',
);

bool _isExactSource(SourceReference actual, SourceReference expected) =>
    actual.id == expected.id &&
    actual.title == expected.title &&
    actual.sourceClass == expected.sourceClass &&
    actual.licenseId == expected.licenseId &&
    actual.locator == expected.locator;

/// Sahih al-Bukhari 3364 explicitly narrates Ismail's childhood at Zamzam and
/// later his work with Ibrahim raising the Ka'ba foundations. It verifies only
/// Ismail's hadith slot; shared mentions of Ibrahim do not transfer ownership
/// and no separate lineage, geography, chronology, or exact-date slot is
/// inferred from this claim.
ProphetSemanticClaim buildIsmailHadithEvidenceT0336({
  String biographyProphetId = 'ismail',
  String subjectProphetId = 'ismail',
  SourceReference source = ismailZamzamKabaHadithSourceT0336,
}) {
  if (biographyProphetId != 'ismail' || subjectProphetId != 'ismail') {
    throw StateError(
      'Sahih al-Bukhari 3364 may only satisfy Ismail hadith ownership',
    );
  }
  if (!_isExactSource(source, ismailZamzamKabaHadithSourceT0336)) {
    throw StateError('T0336 Ismail hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:ismail:sahih-bukhari-3364-zamzam-kaba',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Sahih al-Bukhari 3377 explicitly identifies the she-camel as Salih's and
/// reports the person who hamstrung it. It is admitted only for Salih's hadith
/// slot; geography and chronology remain governed by their independent gates.
ProphetSemanticClaim buildSalihHadithEvidenceT0336({
  String biographyProphetId = 'salih',
  String subjectProphetId = 'salih',
  SourceReference source = salihSheCamelHadithSourceT0336,
}) {
  if (biographyProphetId != 'salih' || subjectProphetId != 'salih') {
    throw StateError(
      'Sahih al-Bukhari 3377 may only satisfy Salih hadith ownership',
    );
  }
  if (!_isExactSource(source, salihSheCamelHadithSourceT0336)) {
    throw StateError('T0336 Salih hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:salih:sahih-bukhari-3377-she-camel',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Sahih Muslim 2379 explicitly states that Zakariya was a carpenter. This
/// verifies only Zakariya's hadith slot and cannot be promoted into a precise
/// date, location, lineage edge, or chronology band.
ProphetSemanticClaim buildZakariyaHadithEvidenceT0336({
  String biographyProphetId = 'zakariya',
  String subjectProphetId = 'zakariya',
  SourceReference source = zakariyaCarpenterHadithSourceT0336,
}) {
  if (biographyProphetId != 'zakariya' || subjectProphetId != 'zakariya') {
    throw StateError(
      'Sahih Muslim 2379 may only satisfy Zakariya hadith ownership',
    );
  }
  if (!_isExactSource(source, zakariyaCarpenterHadithSourceT0336)) {
    throw StateError('T0336 Zakariya hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:zakariya:sahih-muslim-2379-carpenter',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch38 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildIsmailHadithEvidenceT0336(),
  buildSalihHadithEvidenceT0336(),
  buildZakariyaHadithEvidenceT0336(),
]);
