import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

void main() {
  test('T0194 working dataset keeps all 25 canonical biographies valid', () {
    expect(canonicalProphetBiographyT0194Dataset, hasLength(25));
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });

  test('source supplements are applied to canonical drafts', () {
    CanonicalProphetBiographyDraft byId(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (draft) => draft.identity.canonicalId == id,
        );

    final ishaq = byId('ishaq');
    final yakub = byId('yakub');
    final yusuf = byId('yusuf');
    final ayyub = byId('ayyub');
    final shuayb = byId('shuayb');
    final musa = byId('musa');

    expect(
      ishaq.sections[ProphetBiographySectionKey.missionStart]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      yakub.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 12:86',
    );
    expect(
      yusuf.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 12:101',
    );
    expect(
      ayyub.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 21:83',
    );
    expect(
      shuayb.sections[ProphetBiographySectionKey.community]!
          .sources
          .single
          .locator,
      'Quran 11:84',
    );
    expect(
      musa.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 20:25-35',
    );

    for (final id in const [
      'ishaq',
      'yakub',
      'yusuf',
      'ayyub',
      'shuayb',
      'musa',
    ]) {
      expect(byId(id).hasPendingResearch, isTrue, reason: id);
    }

    expect(
      shuayb.sections[ProphetBiographySectionKey.geography]!.status,
      ProphetBiographyFieldStatus.unknownPendingResearch,
    );
    expect(
      musa.sections[ProphetBiographySectionKey.period]!.status,
      ProphetBiographyFieldStatus.unknownPendingResearch,
    );
    expect(
      musa.sections[ProphetBiographySectionKey.death]!.status,
      ProphetBiographyFieldStatus.unknownPendingResearch,
    );
  });

  test('supplement Quran references are merged without duplicates', () {
    for (final id in const [
      'ishaq',
      'yakub',
      'yusuf',
      'ayyub',
      'shuayb',
      'musa',
    ]) {
      final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
        (entry) => entry.identity.canonicalId == id,
      );
      expect(
        draft.quranReferences.map((entry) => entry.stableId).toSet().length,
        draft.quranReferences.length,
        reason: id,
      );
    }
  });

  test('source-backed biography field without locator fails closed', () {
    final original = canonicalProphetBiographyT0194Dataset.first;
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;
    final tampered = CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: original.quranReferences,
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        ...original.sections,
        ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
          text: originalMainMessage.text,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: const <SourceReference>[
            SourceReference(
              id: 'tampered-source-without-locator',
              title: 'Tampered source',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
            ),
          ],
        ),
      },
    );

    expect(tampered.isStructurallyComplete, isTrue);
    expect(prophetBiographyT0194DraftHasTraceableProvenance(tampered), isFalse);
  });

  test('spoofed Quran source identity fails closed even with valid locator', () {
    final original = canonicalProphetBiographyT0194Dataset.first;
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;

    CanonicalProphetBiographyDraft withSource(SourceReference source) =>
        CanonicalProphetBiographyDraft(
          identity: original.identity,
          quranReferences: original.quranReferences,
          sections: <ProphetBiographySectionKey, ProphetBiographyField>{
            ...original.sections,
            ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
              text: originalMainMessage.text,
              status: ProphetBiographyFieldStatus.sourceBacked,
              sources: <SourceReference>[source],
            ),
          },
        );

    for (final source in const <SourceReference>[
      SourceReference(
        id: 'untrusted-quran-copy-q21-25',
        title: 'Tanzil Project — Uthmani Quran Text v1.1',
        sourceClass: ReligiousSourceClass.quran,
        licenseId: 'CC-BY-3.0',
        locator: 'Quran 21:25',
      ),
      SourceReference(
        id: 'tanzil-uthmani-v1.1-q21-25',
        title: 'Different Quran source',
        sourceClass: ReligiousSourceClass.quran,
        licenseId: 'CC-BY-3.0',
        locator: 'Quran 21:25',
      ),
      SourceReference(
        id: 'tanzil-uthmani-v1.1-q21-25',
        title: 'Tanzil Project — Uthmani Quran Text v1.1',
        sourceClass: ReligiousSourceClass.quran,
        licenseId: 'UNKNOWN',
        locator: 'Quran 21:25',
      ),
    ]) {
      final tampered = withSource(source);
      expect(tampered.isStructurallyComplete, isTrue, reason: source.id);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: source.id,
      );
    }
  });

  test('impossible draft Quran reference fails T0194 provenance gate', () {
    final original = canonicalProphetBiographyT0194Dataset.first;
    final tampered = CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: const <ProphetVerseReference>[
        ProphetVerseReference(surah: 1, ayah: 8),
      ],
      sections: original.sections,
    );

    // The generic reference model intentionally performs only shape validation;
    // T0194 must additionally verify the verse against the pinned Quran shape.
    expect(tampered.isStructurallyComplete, isTrue);
    expect(prophetBiographyT0194DraftHasTraceableProvenance(tampered), isFalse);
  });

  test('malformed or impossible Quran locators fail closed', () {
    final original = canonicalProphetBiographyT0194Dataset.first;
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;

    CanonicalProphetBiographyDraft withLocator(String locator) =>
        CanonicalProphetBiographyDraft(
          identity: original.identity,
          quranReferences: original.quranReferences,
          sections: <ProphetBiographySectionKey, ProphetBiographyField>{
            ...original.sections,
            ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
              text: originalMainMessage.text,
              status: ProphetBiographyFieldStatus.sourceBacked,
              sources: <SourceReference>[
                SourceReference(
                  id: 'tanzil-uthmani-v1.1-tampered-quran-locator',
                  title: 'Tanzil Project — Uthmani Quran Text v1.1',
                  sourceClass: ReligiousSourceClass.quran,
                  licenseId: 'CC-BY-3.0',
                  locator: locator,
                ),
              ],
            ),
          },
        );

    for (final locator in const <String>[
      'Quran unknown',
      'Quran 0:1',
      'Quran 115:1',
      'Quran 2:0',
      'Quran 2:10-9',
      'Quran 1:8',
      'Quran 2:287',
      'Quran 112:4-5',
      'not-a-quran-reference',
    ]) {
      final tampered = withLocator(locator);
      expect(tampered.isStructurallyComplete, isTrue, reason: locator);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(tampered),
        isFalse,
        reason: locator,
      );
    }
  });

  test('multi-citation Quran locators remain auditable', () {
    final original = canonicalProphetBiographyT0194Dataset.first;
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;
    final valid = CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: original.quranReferences,
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        ...original.sections,
        ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
          text: originalMainMessage.text,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: const <SourceReference>[
            SourceReference(
              id: 'tanzil-uthmani-v1.1-valid-multi-quran-locator',
              title: 'Tanzil Project — Uthmani Quran Text v1.1',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
              locator: 'Quran 3:38; 21:89-90',
            ),
          ],
        ),
      },
    );

    expect(prophetBiographyT0194DraftHasTraceableProvenance(valid), isTrue);
  });
}
