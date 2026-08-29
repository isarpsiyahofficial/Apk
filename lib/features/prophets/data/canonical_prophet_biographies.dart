import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_content.dart';

enum ProphetBiographySectionKey {
  community,
  geography,
  period,
  birth,
  childhoodYouth,
  missionStart,
  mainMessage,
  communityResponse,
  keyEvents,
  miracles,
  scriptureScrolls,
  death,
  laterImpact,
}

enum ProphetBiographyFieldStatus {
  sourceBacked,
  unknownPendingResearch,
}

class ProphetBiographyField {
  const ProphetBiographyField({
    required this.text,
    required this.status,
    required this.sources,
  });

  final LocalizedReligiousText text;
  final ProphetBiographyFieldStatus status;
  final List<SourceReference> sources;

  bool get isValid {
    if (!text.isComplete) return false;
    switch (status) {
      case ProphetBiographyFieldStatus.sourceBacked:
        return sources.isNotEmpty &&
            sources.every(
              (source) =>
                  source.id.trim().isNotEmpty &&
                  source.title.trim().isNotEmpty &&
                  source.licenseId.trim().isNotEmpty &&
                  source.sourceClass != ReligiousSourceClass.unknown,
            );
      case ProphetBiographyFieldStatus.unknownPendingResearch:
        return sources.isEmpty;
    }
  }
}

class CanonicalProphetBiographyDraft {
  const CanonicalProphetBiographyDraft({
    required this.identity,
    required this.quranReferences,
    required this.sections,
  });

  final CanonicalProphetIdentity identity;
  final List<ProphetVerseReference> quranReferences;
  final Map<ProphetBiographySectionKey, ProphetBiographyField> sections;

  bool get isStructurallyComplete {
    if (!identity.isValid || quranReferences.isEmpty) return false;
    if (quranReferences.any((reference) => !reference.isValid)) return false;
    if (quranReferences.map((e) => e.stableId).toSet().length !=
        quranReferences.length) {
      return false;
    }
    if (sections.length != ProphetBiographySectionKey.values.length ||
        sections.keys.toSet().length != ProphetBiographySectionKey.values.length ||
        sections.values.any((field) => !field.isValid)) {
      return false;
    }
    return ProphetBiographySectionKey.values.every(sections.containsKey);
  }

  /// T0194 is an editorial/research dataset stage. Unknown fields are explicit
  /// and prevent an incomplete biography from being mistaken for reviewed
  /// production content.
  bool get hasPendingResearch => sections.values.any(
        (field) =>
            field.status == ProphetBiographyFieldStatus.unknownPendingResearch,
      );
}

const prophetQuranDatasetSource = SourceReference(
  id: 'tanzil-uthmani-v1.1',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
);

const _unknownField = ProphetBiographyField(
  text: LocalizedReligiousText(
    tr: 'Bu alan için güvenilir ayrıntı henüz doğrulanmadı; kesin bilgi uydurulmayacaktır.',
    en: 'Reliable detail for this field has not yet been verified; no definite claim will be invented.',
    ar: 'لم تُتحقق بعدُ تفاصيل موثوقة لهذا الحقل؛ ولن تُختلق معلومة قطعية.',
  ),
  status: ProphetBiographyFieldStatus.unknownPendingResearch,
  sources: <SourceReference>[],
);

Map<ProphetBiographySectionKey, ProphetBiographyField> _emptyResearchSections() =>
    <ProphetBiographySectionKey, ProphetBiographyField>{
      for (final key in ProphetBiographySectionKey.values) key: _unknownField,
    };

final canonicalProphetBiographyDrafts = <CanonicalProphetBiographyDraft>[
  for (final identity in canonicalQuranNamedProphets)
    CanonicalProphetBiographyDraft(
      identity: identity,
      quranReferences: <ProphetVerseReference>[
        identity.explicitNameReference,
      ],
      sections: _emptyResearchSections(),
    ),
];

bool get canonicalProphetBiographyDraftsAreValid {
  if (canonicalProphetBiographyDrafts.length != 25 ||
      canonicalProphetBiographyDrafts.any(
        (draft) => !draft.isStructurallyComplete || !draft.hasPendingResearch,
      )) {
    return false;
  }

  final ids = canonicalProphetBiographyDrafts
      .map((draft) => draft.identity.canonicalId)
      .toSet();
  return ids.length == 25 &&
      ids.containsAll(
        canonicalQuranNamedProphets.map((entry) => entry.canonicalId),
      );
}
