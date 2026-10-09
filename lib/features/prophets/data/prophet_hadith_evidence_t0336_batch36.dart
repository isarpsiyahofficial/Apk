import '../../../core/content/content_governance.dart';
import 'prophet_semantic_ownership_qa.dart';

const harunNightJourneyHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3393-harun-night-journey',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3393',
);

const yunusNoSuperiorityHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-3412-yunus-no-superiority',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 3412',
);

const dawudManualLabourHadithSourceT0336 = SourceReference(
  id: 'sahih-bukhari-2072-dawud-manual-labour',
  title: 'Sahih al-Bukhari',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih al-Bukhari 2072',
);

bool _isExactSource(SourceReference actual, SourceReference expected) =>
    actual.id == expected.id &&
    actual.title == expected.title &&
    actual.sourceClass == expected.sourceClass &&
    actual.licenseId == expected.licenseId &&
    actual.locator == expected.locator;

/// Source-reviewed hadith evidence for Harun.
///
/// Sahih al-Bukhari 3393 explicitly identifies Harun during the Night Journey.
/// The report is admitted only to Harun's hadith slot; it does not infer an
/// earthly geography, civil date, genealogy edge, or chronology band.
ProphetSemanticClaim buildHarunHadithEvidenceT0336({
  String biographyProphetId = 'harun',
  String subjectProphetId = 'harun',
  SourceReference source = harunNightJourneyHadithSourceT0336,
}) {
  if (biographyProphetId != 'harun' || subjectProphetId != 'harun') {
    throw StateError(
      'Sahih al-Bukhari 3393 may only satisfy Harun hadith ownership',
    );
  }
  if (!_isExactSource(source, harunNightJourneyHadithSourceT0336)) {
    throw StateError('T0336 Harun hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:harun:sahih-bukhari-3393-night-journey',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Source-reviewed hadith evidence for Yunus.
///
/// Sahih al-Bukhari 3412 explicitly names Yunus ibn Matta. The statement is
/// hadith-only evidence and must not be transformed into geography, lineage,
/// chronology, or an exact historical date.
ProphetSemanticClaim buildYunusHadithEvidenceT0336({
  String biographyProphetId = 'yunus',
  String subjectProphetId = 'yunus',
  SourceReference source = yunusNoSuperiorityHadithSourceT0336,
}) {
  if (biographyProphetId != 'yunus' || subjectProphetId != 'yunus') {
    throw StateError(
      'Sahih al-Bukhari 3412 may only satisfy Yunus hadith ownership',
    );
  }
  if (!_isExactSource(source, yunusNoSuperiorityHadithSourceT0336)) {
    throw StateError('T0336 Yunus hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:yunus:sahih-bukhari-3412-no-superiority',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

/// Source-reviewed hadith evidence for Dawud.
///
/// Sahih al-Bukhari 2072 explicitly identifies Allah's prophet Dawud and his
/// manual labour. It satisfies only Dawud's hadith dimension; it does not turn
/// later biographical inferences into verified lineage, dates, or geography.
ProphetSemanticClaim buildDawudHadithEvidenceT0336({
  String biographyProphetId = 'dawud',
  String subjectProphetId = 'dawud',
  SourceReference source = dawudManualLabourHadithSourceT0336,
}) {
  if (biographyProphetId != 'dawud' || subjectProphetId != 'dawud') {
    throw StateError(
      'Sahih al-Bukhari 2072 may only satisfy Dawud hadith ownership',
    );
  }
  if (!_isExactSource(source, dawudManualLabourHadithSourceT0336)) {
    throw StateError('T0336 Dawud hadith source metadata mismatch');
  }

  return ProphetSemanticClaim(
    biographyProphetId: biographyProphetId,
    subjectProphetId: subjectProphetId,
    dimension: ProphetSemanticDimension.hadith,
    claimKey: 'hadith:dawud:sahih-bukhari-2072-manual-labour',
    sourceIds: <String>[source.id],
    sourceClasses: const <ReligiousSourceClass>{
      ReligiousSourceClass.sahihHasanHadith,
    },
  );
}

final List<ProphetSemanticClaim> prophetHadithEvidenceT0336Batch36 =
    List<ProphetSemanticClaim>.unmodifiable(<ProphetSemanticClaim>[
  buildHarunHadithEvidenceT0336(),
  buildYunusHadithEvidenceT0336(),
  buildDawudHadithEvidenceT0336(),
]);
