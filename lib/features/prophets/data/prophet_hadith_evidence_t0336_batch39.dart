import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const ishaqPropheticLineageHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3390-ishaq-prophetic-lineage',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3390',
);

const yakubPropheticLineageHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3390-yakub-prophetic-lineage',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3390',
);

bool _isExactSource(SourceReference actual, SourceReference expected) =>
    actual.id == expected.id &&
    actual.title == expected.title &&
    actual.sourceClass == expected.sourceClass &&
    actual.licenseId == expected.licenseId &&
    actual.locator == expected.locator;

/// Sahih al-Bukhari 3390 directly places Ishaq in the named prophetic lineage
/// Ibrahim -> Ishaq -> Yakub -> Yusuf. This claim verifies only that a sahih
/// hadith directly attests Ishaq in that lineage; the independent family-lineage
/// gate remains the authority for genealogy coverage.
ProphetSemanticClaim buildIshaqHadithEvidenceT0336({
  String biographyProphetId = 'ishaq',
  String subjectProphetId = 'ishaq',
  SourceReference source = ishaqPropheticLineageHadithSourceT0336,
}) {
  if (biographyProphetId != 'ishaq' || subjectProphetId != 'ishaq') {
    throw StateError(
      'Sahih al-Bukhari 3390 may only satisfy Ishaq hadith ownership',
    );
  }
  if (!_isExactSource(source, ishaqPropheticLineageHadithSourceT0336)) {
    throw StateError('T0336 Ishaq hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:ishaq:sahih-bukhari-3390-prophetic-lineage',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// The same Sahih al-Bukhari 3390 proposition directly names Yakub between
/// Ishaq and Yusuf. Shared-source use is allowed because the report makes a
/// direct proposition about each named member; it is not mere incidental name
/// presence. Other semantic dimensions remain independently gated.
ProphetSemanticClaim buildYakubHadithEvidenceT0336({
  String biographyProphetId = 'yakub',
  String subjectProphetId = 'yakub',
  SourceReference source = yakubPropheticLineageHadithSourceT0336,
}) {
  if (biographyProphetId != 'yakub' || subjectProphetId != 'yakub') {
    throw StateError(
      'Sahih al-Bukhari 3390 may only satisfy Yakub hadith ownership',
    );
  }
  if (!_isExactSource(source, yakubPropheticLineageHadithSourceT0336)) {
    throw StateError('T0336 Yakub hadith source metadata mismatch');
  }
  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:yakub:sahih-bukhari-3390-prophetic-lineage',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch39 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildIshaqHadithEvidenceT0336(),
  buildYakubHadithEvidenceT0336(),
]);
