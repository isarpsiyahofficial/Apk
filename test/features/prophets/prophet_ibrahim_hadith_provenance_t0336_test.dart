import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch32.dart';

void main() {
  test('Ibrahim hadith evidence is exact, strong and owner-bound', () {
    final claim = buildIbrahimHadithEvidenceT0336();

    expect(ibrahimCircumcisionHadithSourceT0336.id,
        'sahih-bukhari-3356-ibrahim-circumcision');
    expect(ibrahimCircumcisionHadithSourceT0336.title, 'Sahih al-Bukhari');
    expect(ibrahimCircumcisionHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith);
    expect(ibrahimCircumcisionHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
    expect(ibrahimCircumcisionHadithSourceT0336.locator,
        'Sahih al-Bukhari 3356');
    expect(claim.biographyProphetId, 'ibrahim');
    expect(claim.subjectProphetId, 'ibrahim');
    expect(claim.sourceIds,
        <String>['sahih-bukhari-3356-ibrahim-circumcision']);
    expect(claim.sourceClasses,
        <ReligiousSourceClass>{ReligiousSourceClass.sahihHasanHadith});
  });

  test('Ibrahim report cannot be reassigned to another prophet', () {
    expect(
      () => buildIbrahimHadithEvidenceT0336(
        biographyProphetId: 'muhammad',
        subjectProphetId: 'ibrahim',
      ),
      throwsStateError,
    );
    expect(
      () => buildIbrahimHadithEvidenceT0336(
        biographyProphetId: 'ibrahim',
        subjectProphetId: 'yusuf',
      ),
      throwsStateError,
    );
  });

  test('Ibrahim hadith source metadata tampering fails closed', () {
    for (final source in const <SourceReference>[
      SourceReference(
        id: 'sahih-bukhari-3356-wrong-owner',
        title: 'Sahih al-Bukhari',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih al-Bukhari 3356',
      ),
      SourceReference(
        id: 'sahih-bukhari-3356-ibrahim-circumcision',
        title: 'Popular hadith website',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih al-Bukhari 3356',
      ),
      SourceReference(
        id: 'sahih-bukhari-3356-ibrahim-circumcision',
        title: 'Sahih al-Bukhari',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'UNKNOWN',
        locator: 'Sahih al-Bukhari 3356',
      ),
      SourceReference(
        id: 'sahih-bukhari-3356-ibrahim-circumcision',
        title: 'Sahih al-Bukhari',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih al-Bukhari 3357',
      ),
    ]) {
      expect(
        () => buildIbrahimHadithEvidenceT0336(source: source),
        throwsStateError,
      );
    }
  });
}
