import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_geography_unresolved_audit_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  test('T0336 geography gaps are explicit and fail closed', () {
    final geography = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
      (entry) => entry.dimension == ProphetSemanticDimension.geography,
    );

    expect(geography.verifiedCount, 18);
    expect(geography.unresolvedCount, 7);
    expect(canonicalProphetGeographyUnresolvedAuditT0336, hasLength(7));
    expect(
      canonicalProphetGeographyUnresolvedAuditT0336
          .map((gap) => gap.prophetId)
          .toSet(),
      geography.unresolvedProphetIds.toSet(),
    );
    expect(
      canonicalProphetGeographyUnresolvedAuditT0336.every(
        (gap) =>
            gap.reason ==
            ProphetGeographyGapReasonT0336
                .noReviewedBiographyOwnedGeographyAdmitted,
      ),
      isTrue,
    );
  });

  test('T0336 geography audit rejects malformed 25-prophet partition', () {
    final malformed = canonicalProphetSemanticReleaseBacklogT0336
        .map(
          (entry) => entry.dimension == ProphetSemanticDimension.geography
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
      () => buildProphetGeographyUnresolvedAuditT0336(backlog: malformed),
      throwsStateError,
    );
  });
}
