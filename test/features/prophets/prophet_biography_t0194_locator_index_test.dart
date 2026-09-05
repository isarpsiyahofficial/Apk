import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

void main() {
  test('T0194 rejects valid Quran locator absent from biography Quran index', () {
    final original = canonicalProphetBiographyT0194Dataset.firstWhere(
      (draft) => draft.identity.canonicalId == 'adam',
    );
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
              id: 'tanzil-uthmani-v1.1-unindexed-q112-1',
              title: 'Tanzil Project — Uthmani Quran Text v1.1',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
              locator: 'Quran 112:1',
            ),
          ],
        ),
      },
    );

    expect(tampered.isStructurallyComplete, isTrue);
    expect(prophetBiographyT0194DraftHasTraceableProvenance(tampered), isFalse);
  });

  test('T0194 accepts locator after its verse is added to auditable index', () {
    final original = canonicalProphetBiographyT0194Dataset.firstWhere(
      (draft) => draft.identity.canonicalId == 'adam',
    );
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;

    final indexed = CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: <ProphetVerseReference>[
        ...original.quranReferences,
        const ProphetVerseReference(surah: 112, ayah: 1),
      ],
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        ...original.sections,
        ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
          text: originalMainMessage.text,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: const <SourceReference>[
            SourceReference(
              id: 'tanzil-uthmani-v1.1-indexed-q112-1',
              title: 'Tanzil Project — Uthmani Quran Text v1.1',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
              locator: 'Quran 112:1',
            ),
          ],
        ),
      },
    );

    expect(indexed.isStructurallyComplete, isTrue);
    expect(prophetBiographyT0194DraftHasTraceableProvenance(indexed), isTrue);
  });

  test('canonical universal Quran 21:25 message does not pollute prophet index', () {
    final adam = canonicalProphetBiographyT0194Dataset.firstWhere(
      (draft) => draft.identity.canonicalId == 'adam',
    );

    expect(
      adam.quranReferences.any(
        (reference) => reference.surah == 21 && reference.ayah == 25,
      ),
      isFalse,
    );
    expect(
      adam.sections[ProphetBiographySectionKey.mainMessage]!.sources,
      contains(prophetUniversalMessageSource),
    );
    expect(prophetBiographyT0194DraftHasTraceableProvenance(adam), isTrue);
  });

  test('spoofed universal-message identity cannot bypass Quran index gate', () {
    final original = canonicalProphetBiographyT0194Dataset.firstWhere(
      (draft) => draft.identity.canonicalId == 'adam',
    );
    final originalMainMessage =
        original.sections[ProphetBiographySectionKey.mainMessage]!;

    final spoofed = CanonicalProphetBiographyDraft(
      identity: original.identity,
      quranReferences: original.quranReferences,
      sections: <ProphetBiographySectionKey, ProphetBiographyField>{
        ...original.sections,
        ProphetBiographySectionKey.mainMessage: ProphetBiographyField(
          text: originalMainMessage.text,
          status: ProphetBiographyFieldStatus.sourceBacked,
          sources: const <SourceReference>[
            SourceReference(
              id: 'tanzil-uthmani-v1.1-q21-25-spoof',
              title: 'Tanzil Project — Uthmani Quran Text v1.1',
              sourceClass: ReligiousSourceClass.quran,
              licenseId: 'CC-BY-3.0',
              locator: 'Quran 21:25',
            ),
          ],
        ),
      },
    );

    expect(prophetBiographyT0194DraftHasTraceableProvenance(spoofed), isFalse);
  });

  test('current 25-prophet T0194 dataset keeps locator-index consistency', () {
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(draft),
        isTrue,
        reason: draft.identity.canonicalId,
      );
    }
  });
}
