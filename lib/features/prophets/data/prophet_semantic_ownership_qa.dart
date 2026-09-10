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
    this.contextReference = false,
  });

  final String biographyProphetId;
  final String subjectProphetId;
  final ProphetSemanticDimension dimension;
  final String claimKey;
  final List<String> sourceIds;
  final bool contextReference;
}

final class ProphetSemanticOwnershipQaResult {
  const ProphetSemanticOwnershipQaResult(this.errors);
  final List<String> errors;
  bool get isValid => errors.isEmpty;
}

/// Extra fail-closed release gate for semantic biography ownership.
///
/// This gate does not try to infer theology/history from words. Editorial data
/// must provide typed subject ownership and sources for each semantic claim.
/// That makes accidental copy/paste across prophet biographies detectable while
/// still allowing explicit contextual mentions of another prophet.
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

  ProphetSemanticOwnershipQaResult audit({
    required Iterable<ProphetSemanticClaim> claims,
    bool requireFull25Coverage = true,
  }) {
    final errors = <String>[];
    final seenDimensions = <String, Set<ProphetSemanticDimension>>{};

    for (final claim in claims) {
      final biographyId = claim.biographyProphetId.trim();
      final subjectId = claim.subjectProphetId.trim();
      final claimKey = claim.claimKey.trim();

      if (!_canonicalIds.contains(biographyId)) {
        errors.add('$biographyId: unknown biography prophet id');
        continue;
      }
      if (!_canonicalIds.contains(subjectId)) {
        errors.add('$biographyId/$claimKey: unknown semantic subject $subjectId');
      }
      if (claimKey.isEmpty ||
          claim.sourceIds.isEmpty ||
          claim.sourceIds.any((id) => id.trim().isEmpty)) {
        errors.add('$biographyId: incomplete semantic evidence');
      }

      if (subjectId != biographyId && !claim.contextReference) {
        errors.add(
          '$biographyId/$claimKey: fact belongs to $subjectId but is assigned to $biographyId',
        );
      }

      final exclusiveOwner = _exclusiveEventOwners[claimKey];
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

      if (!claim.contextReference) {
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
