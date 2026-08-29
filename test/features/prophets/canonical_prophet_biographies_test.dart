import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';

void main() {
  group('T0194 canonical prophet biography research dossiers', () {
    test('covers all 25 canonical prophets exactly once', () {
      expect(canonicalProphetBiographyDraftsAreValid, isTrue);
      expect(canonicalProphetBiographyDrafts, hasLength(25));

      final ids = canonicalProphetBiographyDrafts
          .map((draft) => draft.identity.canonicalId)
          .toList();
      expect(ids.toSet(), hasLength(25));
      expect(
        ids.toSet(),
        equals(
          canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet(),
        ),
      );
    });

    test('every dossier contains all T0194 biography sections in TR EN AR', () {
      for (final draft in canonicalProphetBiographyDrafts) {
        expect(draft.identity.name.isComplete, isTrue);
        expect(draft.identity.arabicName.trim(), isNotEmpty);
        expect(draft.quranReferences, isNotEmpty);
        expect(
          draft.sections.keys.toSet(),
          equals(ProphetBiographySectionKey.values.toSet()),
        );
        for (final field in draft.sections.values) {
          expect(field.text.isComplete, isTrue);
          expect(field.isValid, isTrue);
        }
      }
    });

    test('unverified biography details fail closed instead of becoming claims', () {
      for (final draft in canonicalProphetBiographyDrafts) {
        expect(draft.hasPendingResearch, isTrue);
        for (final field in draft.sections.values) {
          if (field.status ==
              ProphetBiographyFieldStatus.unknownPendingResearch) {
            expect(field.sources, isEmpty);
            expect(field.text.tr, contains('doğrulanmadı'));
            expect(field.text.en, contains('not yet been verified'));
            expect(field.text.ar, contains('لم تُتحقق'));
          }
        }
      }
    });

    test('source-backed fields cannot use unknown source metadata', () {
      const invalid = ProphetBiographyField(
        text: LocalizedReligiousText(tr: 'Bilgi', en: 'Fact', ar: 'معلومة'),
        status: ProphetBiographyFieldStatus.sourceBacked,
        sources: <SourceReference>[
          SourceReference(
            id: 'unknown',
            title: 'Unknown',
            sourceClass: ReligiousSourceClass.unknown,
            licenseId: 'reference-only',
          ),
        ],
      );
      expect(invalid.isValid, isFalse);
    });

    test('unknown fields cannot smuggle source-backed certainty', () {
      const invalid = ProphetBiographyField(
        text: LocalizedReligiousText(tr: 'Bilgi', en: 'Fact', ar: 'معلومة'),
        status: ProphetBiographyFieldStatus.unknownPendingResearch,
        sources: <SourceReference>[
          prophetQuranDatasetSource,
        ],
      );
      expect(invalid.isValid, isFalse);
    });
  });
}
