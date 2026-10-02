import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_source_class_audit.dart';

void main() {
  const identity = CanonicalProphetIdentity(
    canonicalId: 'test',
    name: LocalizedReligiousText(tr: 'Test', en: 'Test', ar: 'اختبار'),
    arabicName: 'اختبار',
    explicitNameReference: ProphetVerseReference(surah: 1, ayah: 1),
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
      quranReferences: const <ProphetVerseReference>[
        ProphetVerseReference(surah: 1, ayah: 1),
      ],
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        for (final key in ProphetBiographySectionKey.values)
          key: key == ProphetBiographySectionKey.mainMessage
              ? field
              : const ProphetBiographyField(
                  text: unknownText,
                  status: ProphetBiographyFieldStatus.unknownPendingResearch,
                  sources: <SourceReference>[],
                ),
      },
    );
  }

  test('canonical T0194 dataset has explicit T0196-compatible classes', () {
    expect(canonicalProphetSourceClassAudit.isValid, isTrue);
    expect(canonicalProphetSourceClassAudit.errors, isEmpty);

    for (final draft in canonicalProphetBiographyT0194Dataset) {
      for (final field in draft.sections.values) {
        final classes = effectiveProphetBiographySourceClasses(field);
        expect(classes, isNotEmpty);
        if (field.status == ProphetBiographyFieldStatus.sourceBacked) {
          expect(classes, isNot(contains(ReligiousSourceClass.unknown)));
          expect(classes.every(prophetBiographySourceClassAllowlist.contains), isTrue);
        } else {
          expect(classes, equals({ReligiousSourceClass.unknown}));
        }
      }
    }
  });

  test('T0196 allowlist is exactly the prophet source semantics', () {
    expect(
      prophetBiographySourceClassAllowlist,
      equals({
        ReligiousSourceClass.quran,
        ReligiousSourceClass.sahihHasanHadith,
        ReligiousSourceClass.earlyIslamicHistoryTafsir,
        ReligiousSourceClass.israiliyat,
        ReligiousSourceClass.laterTradition,
        ReligiousSourceClass.modernHistoryArchaeology,
        ReligiousSourceClass.disputed,
      }),
    );
    // The eighth SPEC class, "unknown", is represented only by unresolved
    // fields and deliberately cannot be attached as a fabricated source ref.
    expect(
      effectiveProphetBiographySourceClasses(
        const ProphetBiographyField(
          text: unknownText,
          status: ProphetBiographyFieldStatus.unknownPendingResearch,
          sources: <SourceReference>[],
        ),
      ),
      equals({ReligiousSourceClass.unknown}),
    );
  });

  test('source-backed field without source fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: <SourceReference>[],
        ),
      ),
    ]);
    expect(result.isValid, isFalse);
    expect(result.errors, contains(contains('has no source')));
  });

  test('unknown source class fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: <SourceReference>[
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
    expect(result.errors.join('\n'), contains('is not permitted for prophet biographies'));
  });

  test('non-prophet source classes fail closed', () {
    for (final disallowed in <ReligiousSourceClass>[
      ReligiousSourceClass.meaningBasedDua,
      ReligiousSourceClass.classicalTraditional,
      ReligiousSourceClass.ebcedHavasTradition,
      ReligiousSourceClass.unknown,
    ]) {
      final result = auditProphetBiographySourceClasses([
        draftWith(
          ProphetBiographyField(
            text: sourceText,
            status: ProphetBiographyFieldStatus.sourceBacked,
            sources: <SourceReference>[
              SourceReference(
                id: 'wrong-${disallowed.stableId}',
                title: 'Wrong source family',
                sourceClass: disallowed,
                licenseId: 'REFERENCE-ONLY',
                locator: 'test locator',
              ),
            ],
          ),
        ),
      ]);
      expect(result.isValid, isFalse, reason: disallowed.stableId);
      expect(
        result.errors.join('\n'),
        contains('is not permitted for prophet biographies'),
        reason: disallowed.stableId,
      );
    }
  });

  test('missing locator fails closed even when source class is known', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: sourceText,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: <SourceReference>[
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
    expect(result.errors.join('\n'), contains('incomplete source metadata'));
  });

  test('unknown field carrying a source fails closed', () {
    final result = auditProphetBiographySourceClasses([
      draftWith(
        const ProphetBiographyField(
          text: unknownText,
          status: ProphetBiographyFieldStatus.unknownPendingResearch,
          sources: <SourceReference>[
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
    expect(result.errors.join('\n'), contains('unknown field must not carry sources'));
  });
}
