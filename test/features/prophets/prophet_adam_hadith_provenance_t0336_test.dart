import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  CanonicalProphetBiographyDraft adamDraft() =>
      canonicalProphetBiographyT0194Dataset.singleWhere(
        (entry) => entry.identity.canonicalId == 'adam',
      );

  CanonicalProphetBiographyDraft withTamperedBirthSource(
    SourceReference source,
  ) {
    final original = adamDraft();
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

  test('Adam Friday report is exact, reference-only and provenance admitted', () {
    final draft = adamDraft();
    final birth = draft.sections[ProphetBiographySectionKey.birth]!;

    expect(birth.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(birth.sources, hasLength(1));
    final source = birth.sources.single;
    expect(source.id, 'sahih-muslim-854b-adam-friday');
    expect(source.title, 'Sahih Muslim');
    expect(source.sourceClass, ReligiousSourceClass.sahihHasanHadith);
    expect(source.licenseId, 'REFERENCE-ONLY');
    expect(source.locator, 'Sahih Muslim 854b');
    expect(prophetBiographyT0194DraftHasTraceableProvenance(draft), isTrue);
  });

  test('Adam hadith id title licence or locator tampering fails closed', () {
    for (final source in const <SourceReference>[
      SourceReference(
        id: 'sahih-muslim-854-adam-friday',
        title: 'Sahih Muslim',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih Muslim 854b',
      ),
      SourceReference(
        id: 'sahih-muslim-854b-adam-friday',
        title: 'Popular hadith website',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih Muslim 854b',
      ),
      SourceReference(
        id: 'sahih-muslim-854b-adam-friday',
        title: 'Sahih Muslim',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'UNKNOWN',
        locator: 'Sahih Muslim 854b',
      ),
      SourceReference(
        id: 'sahih-muslim-854b-adam-friday',
        title: 'Sahih Muslim',
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        licenseId: 'REFERENCE-ONLY',
        locator: 'Sahih Muslim 854',
      ),
    ]) {
      final tampered = withTamperedBirthSource(source);
      expect(tampered.isStructurallyComplete, isTrue, reason: source.id);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: '${source.id} / ${source.title} / ${source.locator}',
      );
    }
  });
}
