import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_historical_date_unresolved_audit_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  test('T0336 historical-date gaps are explicit and fail closed', () {
    final historicalDate =
        canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
      (entry) => entry.dimension == ProphetSemanticDimension.historicalDate,
    );

    expect(historicalDate.verifiedCount, 0);
    expect(historicalDate.unresolvedCount, 25);
    expect(canonicalProphetHistoricalDateUnresolvedAuditT0336, hasLength(25));
    expect(
      canonicalProphetHistoricalDateUnresolvedAuditT0336
          .map((gap) => gap.prophetId)
          .toSet(),
      historicalDate.unresolvedProphetIds.toSet(),
    );
    expect(
      canonicalProphetHistoricalDateUnresolvedAuditT0336.every(
        (gap) =>
            gap.reason ==
            ProphetHistoricalDateGapReasonT0336
                .noReviewedHistoricalDateEvidenceAdmitted,
      ),
      isTrue,
    );
  });

  test('T0336 historical-date audit rejects malformed 25-prophet partition', () {
    final malformed = canonicalProphetSemanticReleaseBacklogT0336
        .map(
          (entry) => entry.dimension == ProphetSemanticDimension.historicalDate
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
      () => buildProphetHistoricalDateUnresolvedAuditT0336(
        backlog: malformed,
      ),
      throwsStateError,
    );
  });
}
