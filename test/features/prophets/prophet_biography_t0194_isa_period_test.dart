import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final isa = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'isa',
  );

  test('T0194 Isa period keeps modern history distinct from Quran evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.period]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));

    final source = field.sources.single;
    expect(
      source.id,
      'cambridge-impact-jesus-first-century-palestine-2019',
    );
    expect(
      source.title,
      'The Impact of Jesus in First-Century Palestine — Cambridge University Press',
    );
    expect(
      source.sourceClass,
      ReligiousSourceClass.modernHistoryArchaeology,
    );
    expect(source.licenseId, 'COPYRIGHT-CAMBRIDGE-CITATION-ONLY');
    expect(
      source.locator,
      'Book description; DOI 10.1017/9781108612364',
    );
    expect(
      source.url?.toString(),
      'https://doi.org/10.1017/9781108612364',
    );

    expect(field.text.tr, contains('miladî birinci yüzyıl'));
    expect(field.text.en, contains('first-century'));
    expect(field.text.ar, contains('القرن الأول للميلاد'));

    expect(field.text.tr, contains('Kur’an’ın verdiği bir tarih değildir'));
    expect(field.text.en, contains('not a date supplied by the Quran'));
    expect(field.text.ar, contains('ليس تاريخًا يورده القرآن'));

    expect(field.text.tr, contains('kesin bir doğum veya vefat yılı iddia etmez'));
    expect(field.text.en, contains('does not claim an exact birth or death year'));
    expect(field.text.ar, contains('لا يدّعي هذا الحقل سنةً قطعية للميلاد أو الوفاة'));

    for (final unsupportedExactYear in <String>['4 BCE', '6 BCE', '30 CE', '33 CE']) {
      expect(field.text.en, isNot(contains(unsupportedExactYear)));
    }

    expect(
      source.sourceClass == ReligiousSourceClass.quran ||
          source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
      isFalse,
    );
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa period adds no fabricated Quran verse reference', () {
    // The period source is modern historical scholarship. Composing it must not
    // manufacture a Quran locator merely to make the field look religiously
    // sourced.
    final verseIds = isa.quranReferences.map((item) => item.stableId).toSet();
    expect(verseIds, hasLength(isa.quranReferences.length));
  });

  test('T0194 Isa period source tampering fails provenance closed', () {
    final period = isa.sections[ProphetBiographySectionKey.period]!;
    final originalSource = period.sources.single;

    CanonicalProphetBiographyDraft withSource(SourceReference source) =>
        CanonicalProphetBiographyDraft(
          identity: isa.identity,
          quranReferences: isa.quranReferences,
          sections: <ProphetBiographySectionKey, ProphetBiographyField>{
            ...isa.sections,
            ProphetBiographySectionKey.period: ProphetBiographyField(
              text: period.text,
              status: ProphetBiographyFieldStatus.sourceBacked,
              sources: <SourceReference>[source],
            ),
          },
        );

    final tamperedSources = <SourceReference>[
      SourceReference(
        id: originalSource.id,
        title: originalSource.title,
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        licenseId: 'UNKNOWN',
        locator: originalSource.locator,
        url: originalSource.url,
      ),
      SourceReference(
        id: originalSource.id,
        title: originalSource.title,
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        licenseId: originalSource.licenseId,
        locator: 'Unreviewed locator',
        url: originalSource.url,
      ),
      SourceReference(
        id: originalSource.id,
        title: originalSource.title,
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        licenseId: originalSource.licenseId,
        locator: originalSource.locator,
        url: Uri.parse('https://example.invalid/spoofed-source'),
      ),
      SourceReference(
        id: 'unreviewed-modern-history-source',
        title: originalSource.title,
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        licenseId: originalSource.licenseId,
        locator: originalSource.locator,
        url: originalSource.url,
      ),
    ];

    for (final source in tamperedSources) {
      final tampered = withSource(source);
      expect(tampered.isStructurallyComplete, isTrue);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: source.id,
      );
    }
  });
}
