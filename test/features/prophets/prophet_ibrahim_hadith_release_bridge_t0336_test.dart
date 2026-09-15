import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  test('Ibrahim hadith evidence reaches canonical coverage and gap views together', () {
    final coverage = canonicalProphetCoverageReportT0336.rowFor('ibrahim');
    final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
      'ibrahim',
      ProphetSemanticDimension.hadith,
    );

    expect(coverage.covered, contains(ProphetSemanticDimension.hadith));
    expect(slot.isVerified, isTrue);
    expect(
      slot.sourceIds,
      contains('sahih-bukhari-3356-ibrahim-circumcision'),
    );
    expect(
      slot.verifiedClaimKeys,
      contains('hadith:ibrahim:sahih-bukhari-3356-circumcision-age-eighty'),
    );
    expect(canonicalProphetSemanticReleaseGateT0336.isValid, isTrue);
    expect(canonicalProphetSemanticReleaseGateT0336.isReleaseComplete, isFalse);
  });
}
