import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  test('release backlog projects all eight dimensions without losing prophets', () {
    final backlog = canonicalProphetSemanticReleaseBacklogT0336;
    final canonicalIds = canonicalQuranNamedProphets
        .map((identity) => identity.canonicalId)
        .toSet();

    expect(backlog, hasLength(ProphetSemanticDimension.values.length));
    for (final entry in backlog) {
      expect(
        {...entry.verifiedProphetIds, ...entry.unresolvedProphetIds},
        canonicalIds,
        reason: entry.dimension.name,
      );
      expect(
        entry.verifiedCount + entry.unresolvedCount,
        25,
        reason: entry.dimension.name,
      );
      expect(
        entry.verifiedProphetIds.toSet().intersection(
              entry.unresolvedProphetIds.toSet(),
            ),
        isEmpty,
        reason: entry.dimension.name,
      );
    }
  });

  test('already complete semantic dimensions stay explicitly complete', () {
    for (final dimension in const [
      ProphetSemanticDimension.identity,
      ProphetSemanticDimension.event,
      ProphetSemanticDimension.quranVerse,
      ProphetSemanticDimension.chronology,
    ]) {
      final entry = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (item) => item.dimension == dimension,
      );
      expect(entry.verifiedCount, 25, reason: dimension.name);
      expect(entry.unresolvedProphetIds, isEmpty, reason: dimension.name);
      expect(entry.isComplete, isTrue, reason: dimension.name);
    }
  });

  test('hadith backlog locks the exact fifteen source-reviewed owners', () {
    final entry = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
      (item) => item.dimension == ProphetSemanticDimension.hadith,
    );

    expect(entry.verifiedCount, 15);
    expect(entry.unresolvedCount, 10);
    expect(entry.isComplete, isFalse);
    expect(entry.verifiedProphetIds, <String>[
      'adam',
      'ayyub',
      'dawud',
      'harun',
      'ibrahim',
      'idris',
      'isa',
      'lut',
      'muhammad',
      'musa',
      'nuh',
      'sulayman',
      'yahya',
      'yunus',
      'yusuf',
    ]);
  });

  test('historical-date backlog remains 25 explicit unresolved records', () {
    final entry = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
      (item) => item.dimension == ProphetSemanticDimension.historicalDate,
    );

    expect(entry.verifiedProphetIds, isEmpty);
    expect(entry.unresolvedCount, 25);
    expect(entry.isComplete, isFalse);

    for (final prophetId in entry.unresolvedProphetIds) {
      final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
        prophetId,
        ProphetSemanticDimension.historicalDate,
      );
      expect(slot.hasExplicitUnresolvedEvidence, isTrue, reason: prophetId);
      expect(slot.sourceIds, isEmpty, reason: prophetId);
    }
  });

  test('open hadith geography and lineage work remains explicit and canonical', () {
    for (final dimension in const [
      ProphetSemanticDimension.hadith,
      ProphetSemanticDimension.familyLineage,
      ProphetSemanticDimension.geography,
    ]) {
      final entry = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (item) => item.dimension == dimension,
      );
      expect(entry.unresolvedCount, greaterThan(0), reason: dimension.name);
      expect(entry.isComplete, isFalse, reason: dimension.name);
      for (final prophetId in entry.unresolvedProphetIds) {
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          prophetId,
          dimension,
        );
        expect(
          slot.hasExplicitUnresolvedEvidence,
          isTrue,
          reason: '$prophetId/${dimension.name}',
        );
      }
    }
  });

  test('backlog builder rejects a manifest with silent gaps', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final corrupted = ProphetSemanticGapManifestT0336(
      slots: canonical.slots
          .where(
            (slot) =>
                !(slot.prophetId == 'adam' &&
                    slot.dimension == ProphetSemanticDimension.hadith),
          )
          .toList(growable: false),
    );

    expect(
      () => buildProphetSemanticReleaseBacklogT0336(manifest: corrupted),
      throwsStateError,
    );
  });
}
