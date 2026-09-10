import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';

enum ProphetSemanticDimension {
  identity,
  event,
  quranVerse,
  hadith,
  familyLineage,
  chronology,
  geography,
  historicalDate,
}

enum ProphetSemanticEvidenceState {
  verified,
  unknown,
  pendingReview,
}

/// Typed semantic evidence used by the release QA layer. Text-only name
/// matching is intentionally insufficient because another prophet may be
/// mentioned naturally inside a biography. [subjectProphetId] identifies whose
/// fact/event the claim actually describes; [contextReference] marks an
/// intentional cross-reference rather than assigning that fact to the page
/// owner.
final class ProphetSemanticClaim {
  const ProphetSemanticClaim({
    required this.biographyProphetId,
    required this.subjectProphetId,
    required this.dimension,
    required this.claimKey,
    required this.sourceIds,
    this.sourceClasses = const <ReligiousSourceClass>{},
    this.contextReference = false,
    this.evidenceState = ProphetSemanticEvidenceState.verified,
  });

  final String biographyProphetId;
  final String subjectProphetId;
  final ProphetSemanticDimension dimension;
  final String claimKey;
  final List<String> sourceIds;
  final Set<ReligiousSourceClass> sourceClasses;
  final bool contextReference;
  final ProphetSemanticEvidenceState evidenceState;
}

final class ProphetSemanticOwnershipQaResult {
  const ProphetSemanticOwnershipQaResult(this.errors);
  final List<String> errors;
  bool get isValid => errors.isEmpty;
}

/// Extra fail-closed release gate for semantic biography ownership.
///
/// This gate does not try to infer theology/history from words. Editorial data
/// must provide typed subject ownership and sources for each verified semantic
/// claim. Explicit unknown/pending records are allowed so editors never need to
/// invent a date, lineage or location merely to fill the matrix, but those
/// records never satisfy release coverage.
///
/// Every non-exclusive claim key is namespaced by its semantic dimension
/// (`identity:...`, `quranVerse:...`, etc.). This prevents an editor from making
/// an event satisfy the date/hadith/geography coverage merely by changing the
/// enum value while reusing the same evidence key. Known exclusive events keep
/// stable historical keys and are separately forced to the `event` dimension.
///
/// A source id alone is also insufficient for `verified` coverage. Each claim
/// must declare source classes appropriate to its semantic dimension so, for
/// example, a Quran citation cannot be relabelled as hadith evidence and a
/// later/disputed tradition cannot silently satisfy a verified historical date.
final class ProphetSemanticOwnershipQa {
  const ProphetSemanticOwnershipQa();

  static final Set<String> _canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();

  static const Map<String, String> _exclusiveEventOwners = {
    'yusuf_well_and_egypt': 'yusuf',
    'muhammad_hijra_to_medina': 'muhammad',
    'muhammad_first_revelation_hira': 'muhammad',
    'musa_exodus_pharaoh': 'musa',
    'yunus_fish_episode': 'yunus',
    'ibrahim_fire_trial': 'ibrahim',
  };

  static const Set<ReligiousSourceClass> _strongHistoricalSources = {
    ReligiousSourceClass.quran,
    ReligiousSourceClass.sahihHasanHadith,
    ReligiousSourceClass.earlyIslamicHistoryTafsir,
    ReligiousSourceClass.modernHistoryArchaeology,
  };

  static Set<ReligiousSourceClass> _allowedSourceClassesFor(
    ProphetSemanticDimension dimension,
  ) {
    switch (dimension) {
      case ProphetSemanticDimension.identity:
      case ProphetSemanticDimension.quranVerse:
        return const {ReligiousSourceClass.quran};
      case ProphetSemanticDimension.hadith:
        return const {ReligiousSourceClass.sahihHasanHadith};
      case ProphetSemanticDimension.event:
      case ProphetSemanticDimension.familyLineage:
      case ProphetSemanticDimension.chronology:
      case ProphetSemanticDimension.geography:
      case ProphetSemanticDimension.historicalDate:
        return _strongHistoricalSources;
    }
  }

  ProphetSemanticOwnershipQaResult audit({
    required Iterable<ProphetSemanticClaim> claims,
    bool requireFull25Coverage = true,
  }) {
    final errors = <String>[];
    final seenDimensions = <String, Set<ProphetSemanticDimension>>{};
    final seenEvidenceKeys = <String>{};

    if (requireFull25Coverage && _canonicalIds.length != 25) {
      errors.add(
        'canonical prophet identity set must contain exactly 25 unique ids; got ${_canonicalIds.length}',
      );
    }

    for (final claim in claims) {
      final biographyId = claim.biographyProphetId.trim();
      final subjectId = claim.subjectProphetId.trim();
      final claimKey = claim.claimKey.trim();
      final normalizedSources = claim.sourceIds.map((id) => id.trim()).toList();
      final isVerified =
          claim.evidenceState == ProphetSemanticEvidenceState.verified;

      if (!_canonicalIds.contains(biographyId)) {
        errors.add('$biographyId: unknown biography prophet id');
        continue;
      }
      if (!_canonicalIds.contains(subjectId)) {
        errors.add('$biographyId/$claimKey: unknown semantic subject $subjectId');
      }
      if (claimKey.isEmpty) {
        errors.add('$biographyId: incomplete semantic evidence');
      }
      if (isVerified &&
          (normalizedSources.isEmpty ||
              normalizedSources.any((id) => id.isEmpty))) {
        errors.add('$biographyId: verified semantic evidence requires sources');
      }
      if (normalizedSources.any((id) => id.isEmpty)) {
        errors.add('$biographyId: semantic source id must not be empty');
      }
      if (normalizedSources.toSet().length != normalizedSources.length) {
        errors.add('$biographyId/$claimKey: duplicate semantic source evidence');
      }

      if (isVerified && claim.sourceClasses.isEmpty) {
        errors.add(
          '$biographyId/$claimKey: verified semantic evidence requires source classes',
        );
      }
      if (!isVerified && claim.sourceClasses.isNotEmpty) {
        errors.add(
          '$biographyId/$claimKey: unresolved semantic evidence must not claim verified source classes',
        );
      }
      if (isVerified && claim.sourceClasses.isNotEmpty) {
        final allowed = _allowedSourceClassesFor(claim.dimension);
        final invalidClasses = claim.sourceClasses.difference(allowed);
        if (invalidClasses.isNotEmpty) {
          errors.add(
            '$biographyId/$claimKey: source class ${invalidClasses.map((e) => e.stableId).join(',')} cannot verify ${claim.dimension.name}',
          );
        }
      }

      final exclusiveOwner = _exclusiveEventOwners[claimKey];
      if (exclusiveOwner != null) {
        if (claim.dimension != ProphetSemanticDimension.event) {
          errors.add(
            '$biographyId/$claimKey: exclusive event must use the event dimension',
          );
        }
      } else if (claimKey.isNotEmpty &&
          !claimKey.startsWith('${claim.dimension.name}:')) {
        errors.add(
          '$biographyId/$claimKey: semantic key must be namespaced as ${claim.dimension.name}:...',
        );
      }

      final evidenceKey = '$biographyId|${claim.dimension.name}|$claimKey';
      if (claimKey.isNotEmpty && !seenEvidenceKeys.add(evidenceKey)) {
        errors.add('$biographyId/$claimKey: duplicate semantic claim evidence');
      }

      if (subjectId != biographyId && !claim.contextReference) {
        errors.add(
          '$biographyId/$claimKey: fact belongs to $subjectId but is assigned to $biographyId',
        );
      }

      if (exclusiveOwner != null && subjectId != exclusiveOwner) {
        errors.add(
          '$biographyId/$claimKey: exclusive event subject must be $exclusiveOwner, got $subjectId',
        );
      }
      if (exclusiveOwner != null &&
          biographyId != exclusiveOwner &&
          !claim.contextReference) {
        errors.add(
          '$biographyId/$claimKey: exclusive event belongs to $exclusiveOwner',
        );
      }

      if (!claim.contextReference && isVerified) {
        seenDimensions
            .putIfAbsent(biographyId, () => <ProphetSemanticDimension>{})
            .add(claim.dimension);
      }
    }

    if (requireFull25Coverage) {
      final required = ProphetSemanticDimension.values.toSet();
      for (final identity in canonicalQuranNamedProphets) {
        final covered = seenDimensions[identity.canonicalId] ?? const {};
        final missing = required.difference(covered);
        if (missing.isNotEmpty) {
          errors.add(
            '${identity.canonicalId}: semantic cross-check coverage missing ${missing.map((e) => e.name).join(',')}',
          );
        }
      }
    }

    return ProphetSemanticOwnershipQaResult(List.unmodifiable(errors));
  }
}
