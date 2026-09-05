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

    test('every dossier contains all T0194 biography sections including dua', () {
      expect(ProphetBiographySectionKey.values, contains(ProphetBiographySectionKey.dua));
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

    test('sourced dossiers use Quran evidence without invented chronology', () {
      const researchedIds = <String>{
        'adam',
        'idris',
        'nuh',
        'hud',
        'salih',
        'ibrahim',
        'lut',
        'ismail',
      };
      for (final draft in canonicalProphetBiographyDrafts
          .where((entry) => researchedIds.contains(entry.identity.canonicalId))) {
        expect(
          draft.sections.values.where(
            (field) => field.status == ProphetBiographyFieldStatus.sourceBacked,
          ).length,
          greaterThan(1),
          reason: draft.identity.canonicalId,
        );
        for (final field in draft.sections.values.where(
          (field) => field.status == ProphetBiographyFieldStatus.sourceBacked,
        )) {
          expect(field.sources, isNotEmpty);
          expect(
            field.sources.every(
              (source) => source.sourceClass == ReligiousSourceClass.quran,
            ),
            isTrue,
            reason: draft.identity.canonicalId,
          );
        }
        expect(
          draft.sections[ProphetBiographySectionKey.period]!.status,
          ProphetBiographyFieldStatus.unknownPendingResearch,
        );
        expect(
          draft.sections[ProphetBiographySectionKey.geography]!.status,
          ProphetBiographyFieldStatus.unknownPendingResearch,
        );
        expect(
          draft.sections[ProphetBiographySectionKey.birth]!.status,
          ProphetBiographyFieldStatus.unknownPendingResearch,
        );
        expect(
          draft.sections[ProphetBiographySectionKey.death]!.status,
          ProphetBiographyFieldStatus.unknownPendingResearch,
        );
      }
    });

    test('Quran dua provenance is preserved for sourced prophet prayers', () {
      for (final id in const <String>['adam', 'nuh', 'ibrahim', 'ismail']) {
        final draft = canonicalProphetBiographyDrafts.singleWhere(
          (entry) => entry.identity.canonicalId == id,
        );
        final dua = draft.sections[ProphetBiographySectionKey.dua]!;
        expect(dua.status, ProphetBiographyFieldStatus.sourceBacked);
        expect(dua.sources, hasLength(1));
        expect(dua.sources.single.sourceClass, ReligiousSourceClass.quran);
        expect(dua.sources.single.locator, contains('Quran'));
      }
    });

    test('Ibrahim fire sign is sourced without inventing date or location', () {
      final ibrahim = canonicalProphetBiographyDrafts.singleWhere(
        (entry) => entry.identity.canonicalId == 'ibrahim',
      );
      final miracle = ibrahim.sections[ProphetBiographySectionKey.miracles]!;
      expect(miracle.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(miracle.sources.single.locator, 'Quran 21:69');
      expect(
        ibrahim.sections[ProphetBiographySectionKey.geography]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
      );
      expect(
        ibrahim.sections[ProphetBiographySectionKey.period]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
      );
    });

    test('Lut rescue account does not promote a modern exact map claim', () {
      final lut = canonicalProphetBiographyDrafts.singleWhere(
        (entry) => entry.identity.canonicalId == 'lut',
      );
      expect(
        lut.sections[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
        'Quran 11:77-83',
      );
      expect(
        lut.sections[ProphetBiographySectionKey.geography]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
      );
    });

    test('Ismail household claim stays narrower than an invented tribal label', () {
      final ismail = canonicalProphetBiographyDrafts.singleWhere(
        (entry) => entry.identity.canonicalId == 'ismail',
      );
      final community = ismail.sections[ProphetBiographySectionKey.community]!;
      expect(community.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(community.sources.single.locator, 'Quran 19:55');
      expect(community.text.en, contains('no unverified tribal or community label'));
    });

    test('Salih sign is sourced without promoting geography or dates', () {
      final salih = canonicalProphetBiographyDrafts.singleWhere(
        (entry) => entry.identity.canonicalId == 'salih',
      );
      final miracle = salih.sections[ProphetBiographySectionKey.miracles]!;
      expect(miracle.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(miracle.sources.single.locator, 'Quran 11:64');
      expect(
        salih.sections[ProphetBiographySectionKey.geography]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
      );
      expect(
        salih.sections[ProphetBiographySectionKey.period]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
      );
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
