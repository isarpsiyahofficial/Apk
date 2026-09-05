import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  CanonicalProphetBiographyDraft muhammadDraft() =>
      canonicalProphetBiographyT0194Dataset.singleWhere(
        (entry) => entry.identity.canonicalId == 'muhammad',
      );

  CanonicalProphetBiographyDraft withBirthSource(SourceReference source) {
    final original = muhammadDraft();
    final birth = original.sections[ProphetBiographySectionKey.birth]!;
    return CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: original.quranReferences,
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        ...original.sections,
        ProphetBiographySectionKey.birth: ProphetBiographyField(
          text: birth.text,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: <SourceReference>[source],
        ),
      },
    );
  }

  test('pinned Bukhari and Muslim reference-only locators remain auditable', () {
    final original = muhammadDraft();
    expect(prophetBiographyT0194DraftHasTraceableProvenance(original), isTrue);

    expect(
      prophetBiographyT0194DraftHasTraceableProvenance(
        withBirthSource(
          const SourceReference(
            id: 'sahih-bukhari-4449-regression',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 4449',
          ),
        ),
      ),
      isTrue,
    );
  });

  test('spoofed hadith collection metadata fails T0194 provenance closed', () {
    for (final source in const <SourceReference>[
      SourceReference(
        id: 'unknown-copy-1162e',
        title: 'Sahih Muslim',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih Muslim 1162e',
      ),
      SourceReference(
        id: 'sahih-muslim-1162e-spoof-title',
        title: 'Popular hadith website',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih Muslim 1162e',
      ),
      SourceReference(
        id: 'sahih-muslim-1162e-spoof-license',
        title: 'Sahih Muslim',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'UNKNOWN',
        locator: 'Sahih Muslim 1162e',
      ),
    ]) {
      final tampered = withBirthSource(source);
      expect(tampered.isStructurallyComplete, isTrue, reason: source.id);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: source.id,
      );
    }
  });

  test('placeholder or malformed hadith locators fail closed', () {
    for (final locator in const <String>[
      'Sahih Muslim unknown',
      'Sahih Muslim',
      'Muslim 1162e',
      'Sahih Muslim 1162e extra',
      'https://example.invalid/hadith/1162e',
    ]) {
      final tampered = withBirthSource(
        SourceReference(
          id: 'sahih-muslim-malformed-locator',
          title: 'Sahih Muslim',
          sourceClass: ReligiousSourceClass.sahihHasanHadith,
          licenseId: 'REFERENCE-ONLY',
          locator: locator,
        ),
      );
      expect(tampered.isStructurallyComplete, isTrue, reason: locator);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: locator,
      );
    }
  });
}
