import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_family_unresolved_audit_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  test('T0336 family-lineage gaps are explicit and fail closed', () {
    final family = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
      (entry) => entry.dimension == ProphetSemanticDimension.familyLineage,
    );

    expect(family.verifiedCount, 11);
    expect(family.unresolvedCount, 14);
    expect(canonicalProphetFamilyUnresolvedAuditT0336, hasLength(14));
    expect(
      canonicalProphetFamilyUnresolvedAuditT0336
          .map((gap) => gap.prophetId)
          .toSet(),
      family.unresolvedProphetIds.toSet(),
    );
    expect(
      canonicalProphetFamilyUnresolvedAuditT0336.every(
        (gap) =>
            gap.reason ==
            ProphetFamilyGapReasonT0336
                .noReviewedExplicitProphetKinshipAdmitted,
      ),
      isTrue,
    );
  });

  test('T0336 family audit rejects malformed 25-prophet partition', () {
    final malformed = canonicalProphetSemanticReleaseBacklogT0336
        .map(
          (entry) => entry.dimension == ProphetSemanticDimension.familyLineage
              ? ProphetSemanticDimensionBacklogT0336(
                  dimension: entry.dimension,
                  verifiedProphetIds: entry.verifiedProphetIds,
                  unresolvedProphetIds: entry.unresolvedProphetIds
                      .where((id) => id != entry.unresolvedProphetIds.first)
                      .toList(growable: false),
                )
              : entry,
        )
        .toList(growable: false);

    expect(
      () => buildProphetFamilyUnresolvedAuditT0336(backlog: malformed),
      throwsStateError,
    );
  });
}
