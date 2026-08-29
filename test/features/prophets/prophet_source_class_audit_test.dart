import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_source_class_audit.dart';

void main() {
  const identity = CanonicalProphetIdentity(
    canonicalId: 'test',
    name: LocalizedReligiousText(tr: 'Test', en: 'Test', ar: 'اختبار'),
    arabicName: 'اختبار',
  );
  const unknownText = LocalizedReligiousText(
    tr: 'kesin bilgi uydurulmayacaktır',
    en: 'no definite claim will be invented',
    ar: 'لن تُختلق معلومة قطعية',
  );
  const sourceText = LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR');

  CanonicalProphetBiographyDraft draftWith(ProphetBiographyField field) {
    return CanonicalProphetBiographyDraft(
      identity: identity,
      quranReferences: const [],
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        for (final key in ProphetBiographySectionKey.values)
          key: key == ProphetBiographySectionKey.mainMessage
              ? field
              : const ProphetBiographyField(
                  text: unknownText,
                  status: ProphetBiographyFieldStatus.unknownPendingResearch,
                  sources: [],
                ),
      },
    );
  }

  test('canonical T0194 dataset has explicit non-unknown source classes', () {
    expect(canonicalProphetSourceClassAudit.isValid, isTrue);
    expect(canonicalProphetSourceClassAudit.errors, isEmpty);
  });

  test('source-backed field without source fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: [],
        ),
      ),
    ]);
    expect(result.isValid, isFalse);
    expect(result.errors.single, contains('has no source'));
  });

  test('unknown source class fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: [
            SourceReference(
              id: 'unknown-source',
              title: 'Unknown',
              sourceClass: ReligiousSourceClass.unknown,
              licenseId: 'REFERENCE-ONLY',
              locator: 'unknown',
            ),
          ],
        ),
      ),
    ]);
    expect(result.isValid, isFalse);
    expect(result.errors.single, contains('unknown source class'));
  });

  test('missing locator fails closed even when source class is known', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: [
            SourceReference(
              id: 'quran-test',
              title: 'Quran',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
            ),
          ],
        ),
      ),
    ]);
    expect(result.isValid, isFalse);
    expect(result.errors.single, contains('incomplete source metadata'));
  });

  test('unknown field carrying a source fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: unknownText,
          status: ProphetBiographyFieldStatus.unknownPendingResearch,
          sources: [
            SourceReference(
              id: 'quran-test',
              title: 'Quran',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
              locator: '21:25',
            ),
          ],
        ),
      ),
    ]);
    expect(result.isValid, isFalse);
    expect(result.errors.single, contains('unknown field must not carry sources'));
  });
}
