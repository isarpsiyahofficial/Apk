import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';

/// T0193 chronology layer.
///
/// This dataset is intentionally an approximate navigation sequence, not a
/// Gregorian dating table. It must never be interpreted as assigning exact
/// years to prophets whose dates are not established by reliable sources.
enum ProphetChronologyBandKind {
  sequential,
  parallel,
}

class ProphetChronologyBand {
  const ProphetChronologyBand({
    required this.order,
    required this.prophetIds,
    required this.kind,
    required this.certainty,
    required this.sources,
  });

  final int order;
  final List<String> prophetIds;
  final ProphetChronologyBandKind kind;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid {
    if (order <= 0 ||
        prophetIds.isEmpty ||
        prophetIds.toSet().length != prophetIds.length) {
      return false;
    }
    if (kind == ProphetChronologyBandKind.sequential && prophetIds.length != 1) {
      return false;
    }
    if (kind == ProphetChronologyBandKind.parallel && prophetIds.length < 2) {
      return false;
    }
    if (certainty != CertaintyLevel.approximate ||
        !_hasTimelineSourceMetadata(sources)) {
      return false;
    }
    return sources.every(
      (source) =>
          source.sourceClass != ReligiousSourceClass.israiliyat &&
          source.sourceClass != ReligiousSourceClass.laterTradition &&
          source.sourceClass != ReligiousSourceClass.disputed &&
          source.sourceClass != ReligiousSourceClass.unknown,
    );
  }
}

const _quranRevelationSequenceSource = SourceReference(
  id: 'quran-4-163',
  title: 'Qur’an 4:163 — revelation to Noah and prophets after him',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'quran-reference-only',
  locator: '4:163',
);

const _tdvProphetReferenceFamily = SourceReference(
  id: 'tdv-prophet-reference-family',
  title: 'TDV İslâm Ansiklopedisi — prophet biography reference family',
  sourceClass: ReligiousSourceClass.earlyIslamicHistoryTafsir,
  licenseId: 'reference-only-no-copy',
  locator: 'individual prophet entries; chronology used only approximately',
);

const _timelineSources = <SourceReference>[
  _quranRevelationSequenceSource,
  _tdvProphetReferenceFamily,
];

/// Main approximate prophetic chain required by SPEC 830–834.
///
/// Parallel bands deliberately avoid inventing a strict before/after relation
/// where the product specification groups prophets in the same broad period.
const mainApproximateProphetChronology = <ProphetChronologyBand>[
  ProphetChronologyBand(
    order: 1,
    prophetIds: ['adam'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 2,
    prophetIds: ['idris'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 3,
    prophetIds: ['nuh'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 4,
    prophetIds: ['hud'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 5,
    prophetIds: ['salih'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 6,
    prophetIds: ['ibrahim', 'lut'],
    kind: ProphetChronologyBandKind.parallel,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 7,
    prophetIds: ['ismail', 'ishaq'],
    kind: ProphetChronologyBandKind.parallel,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 8,
    prophetIds: ['yakub'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 9,
    prophetIds: ['yusuf'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 10,
    prophetIds: ['ayyub'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 11,
    prophetIds: ['shuayb'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 12,
    prophetIds: ['musa', 'harun'],
    kind: ProphetChronologyBandKind.parallel,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 13,
    prophetIds: ['dawud'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 14,
    prophetIds: ['sulayman'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 15,
    prophetIds: ['ilyas'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 16,
    prophetIds: ['alyasa'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 17,
    prophetIds: ['yunus'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 18,
    prophetIds: ['dhul_kifl'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 19,
    prophetIds: ['zakariya'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 20,
    prophetIds: ['yahya'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 21,
    prophetIds: ['isa'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
  ProphetChronologyBand(
    order: 22,
    prophetIds: ['muhammad'],
    kind: ProphetChronologyBandKind.sequential,
    certainty: CertaintyLevel.approximate,
    sources: _timelineSources,
  ),
];

const specificationMainChronologyFlattened = <String>[
  'adam',
  'idris',
  'nuh',
  'hud',
  'salih',
  'ibrahim',
  'lut',
  'ismail',
  'ishaq',
  'yakub',
  'yusuf',
  'ayyub',
  'shuayb',
  'musa',
  'harun',
  'dawud',
  'sulayman',
  'ilyas',
  'alyasa',
  'yunus',
  'dhul_kifl',
  'zakariya',
  'yahya',
  'isa',
  'muhammad',
];

bool get mainApproximateProphetChronologyIsValid {
  if (mainApproximateProphetChronology.isEmpty ||
      mainApproximateProphetChronology.any((band) => !band.isValid)) {
    return false;
  }

  for (var index = 0; index < mainApproximateProphetChronology.length; index++) {
    if (mainApproximateProphetChronology[index].order != index + 1) {
      return false;
    }
  }

  final flattened = mainApproximateProphetChronology
      .expand((band) => band.prophetIds)
      .toList(growable: false);
  if (!_sameOrderedIds(flattened, specificationMainChronologyFlattened)) {
    return false;
  }

  final canonicalIds = canonicalQuranNamedProphets
      .map((entry) => entry.canonicalId)
      .toSet();
  if (flattened.toSet().length != flattened.length ||
      flattened.toSet().length != canonicalIds.length ||
      !flattened.toSet().containsAll(canonicalIds) ||
      !canonicalIds.containsAll(flattened.toSet())) {
    return false;
  }

  return true;
}

bool _sameOrderedIds(List<String> left, List<String> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

bool _hasTimelineSourceMetadata(List<SourceReference> sources) =>
    sources.isNotEmpty &&
    sources.every(
      (source) =>
          source.id.trim().isNotEmpty &&
          source.title.trim().isNotEmpty &&
          source.licenseId.trim().isNotEmpty &&
          (source.locator?.trim().isNotEmpty ?? false),
    );
