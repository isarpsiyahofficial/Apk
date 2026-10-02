import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final muhammad = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'muhammad',
  );

  test('T0194 Muhammad period is modern history, not a Quran date claim', () {
    final field = muhammad.sections[ProphetBiographySectionKey.period]!;
    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));

    final source = field.sources.single;
    expect(
      source.id,
      'oxford-princeton-islamic-political-thought-muhammad-2015',
    );
    expect(source.title, 'Muhammad — Islamic Political Thought: An Introduction');
    expect(source.sourceClass, ReligiousSourceClass.modernHistoryArchaeology);
    expect(source.licenseId, 'COPYRIGHT-PRINCETON-CITATION-ONLY');
    expect(
      source.locator,
      'Chapter 10, pp. 152-168; DOI 10.23943/princeton/9780691164823.003.0010',
    );
    expect(
      source.url?.toString(),
      'https://doi.org/10.23943/princeton/9780691164823.003.0010',
    );

    expect(field.text.tr, contains('yaklaşık miladî 570–632'));
    expect(field.text.en, contains('approximately in the period ca. 570–632 CE'));
    expect(field.text.ar, contains('تقريبًا في الفترة من نحو 570 إلى 632م'));

    expect(field.text.tr, contains('Kur’an’ın verdiği tarihler değildir'));
    expect(field.text.en, contains('rather than dates supplied by the Quran'));
    expect(field.text.ar, contains('وليست تواريخ يوردها القرآن'));

    expect(field.text.tr, contains('kesin bir doğum yılı iddiası olarak sunulmaz'));
    expect(field.text.en, contains('not presented as an exact birth year'));
    expect(field.text.ar, contains('سنة ميلاد قطعية'));

    expect(prophetBiographyT0194DraftHasTraceableProvenance(muhammad), isTrue);
  });

  test('T0194 Muhammad period adds no fabricated Quran reference', () {
    final verseIds = muhammad.quranReferences.map((item) => item.stableId).toSet();
    expect(verseIds, hasLength(muhammad.quranReferences.length));
  });

  test('T0194 Muhammad period source tampering fails provenance closed', () {
    final period = muhammad.sections[ProphetBiographySectionKey.period]!;
    final originalSource = period.sources.single;

    CanonicalProphetBiographyDraft withSource(SourceReference source) =>
        CanonicalProphetBiographyDraft(
          identity: muhammad.identity,
          quranReferences: muhammad.quranReferences,
          sections: <ProphetBiographySectionKey, ProphetBiographyField>{
            ...muhammad.sections,
            ProphetBiographySectionKey.period: ProphetBiographyField(
              text: period.text,
              status: ProphetBiographyFieldStatus.sourceBacked,
              sources: <SourceReference>[source],
            ),
          },
        );

    for (final source in <SourceReference>[
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
    ]) {
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
