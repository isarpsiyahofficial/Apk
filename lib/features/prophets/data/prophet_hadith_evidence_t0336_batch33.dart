import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const nuhMessageWitnessHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3339-nuh-message-witness',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3339',
);

const yusufLineageHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3390-yusuf-prophetic-lineage',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3390',
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

/// Source-reviewed hadith evidence for Nuh.
///
/// Bukhari 3339 explicitly reports Nuh affirming that he conveyed the message
/// and names Muhammad and his followers as witnesses. This record contributes
/// only to Nuh's hadith dimension; it does not infer an earthly location,
/// calendar date, genealogy edge, or chronology band.
ProphetSemanticClaim buildNuhHadithEvidenceT0336({
  String biographyProphetId = 'nuh',
  String subjectProphetId = 'nuh',
  SourceReference source = nuhMessageWitnessHadithSourceT0336,
}) {
  if (biographyProphetId != 'nuh' || subjectProphetId != 'nuh') {
    throw StateError(
      'Sahih al-Bukhari 3339 may only satisfy Nuh hadith ownership',
    );
  }
  if (!_isExactSource(source, nuhMessageWitnessHadithSourceT0336)) {
    throw StateError('T0336 Nuh hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:nuh:sahih-bukhari-3339-message-witness',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Source-reviewed hadith evidence for Yusuf.
///
/// Bukhari 3390 identifies Yusuf as the son of Yaqub, son of Ishaq, son of
/// Ibrahim. The semantic claim deliberately satisfies only Yusuf's hadith slot:
/// family/lineage remains governed by the separately reviewed genealogy graph,
/// preventing one hadith record from silently promoting another dimension.
ProphetSemanticClaim buildYusufHadithEvidenceT0336({
  String biographyProphetId = 'yusuf',
  String subjectProphetId = 'yusuf',
  SourceReference source = yusufLineageHadithSourceT0336,
}) {
  if (biographyProphetId != 'yusuf' || subjectProphetId != 'yusuf') {
    throw StateError(
      'Sahih al-Bukhari 3390 may only satisfy Yusuf hadith ownership',
    );
  }
  if (!_isExactSource(source, yusufLineageHadithSourceT0336)) {
    throw StateError('T0336 Yusuf hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:yusuf:sahih-bukhari-3390-prophetic-lineage',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch33 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildNuhHadithEvidenceT0336(),
  buildYusufHadithEvidenceT0336(),
]);
