import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_unresolved_source_audit_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  group('T0336 remaining hadith source audit', () {
    test('source audit locks the exact five unresolved biography owners', () {
      final audit = canonicalProphetHadithUnresolvedSourceAuditT0336;
      final hadith = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (entry) => entry.dimension == ProphetSemanticDimension.hadith,
      );
      const expected = <String>{
        'hud',
        'shuayb',
        'dhul_kifl',
        'ilyas',
        'alyasa',
      };

      expect(audit, hasLength(5));
      expect(audit.map((entry) => entry.prophetId).toSet(), expected);
      expect(hadith.unresolvedProphetIds.toSet(), expected);
      expect(hadith.verifiedProphetIds.toSet().intersection(expected), isEmpty);
      expect(audit.every((entry) => entry.isFailClosed), isTrue);
    });

    test('audited unresolved owners retain no verified hadith source ids', () {
      for (final audit
          in canonicalProphetHadithUnresolvedSourceAuditT0336) {
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          audit.prophetId,
          ProphetSemanticDimension.hadith,
        );

        expect(slot.isVerified, isFalse, reason: audit.prophetId);
        expect(slot.sourceIds, isEmpty, reason: audit.prophetId);
        expect(slot.verifiedClaimKeys, isEmpty, reason: audit.prophetId);
        expect(
          slot.hasExplicitUnresolvedEvidence,
          isTrue,
          reason: audit.prophetId,
        );
      }
    });

    test('Dhul-Kifl identity mismatch is explicitly fail closed', () {
      final dhulKifl = canonicalProphetHadithUnresolvedSourceAuditT0336
          .singleWhere((entry) => entry.prophetId == 'dhul_kifl');

      expect(
        dhulKifl.reason,
        ProphetHadithUnresolvedReasonT0336.identityMismatch,
      );
      expect(dhulKifl.reviewNote, contains('Kifl'));
      expect(dhulKifl.reviewNote, contains('must not be promoted'));
    });

    test('Israelite narrative risk cannot silently verify Ilyas', () {
      final ilyas = canonicalProphetHadithUnresolvedSourceAuditT0336
          .singleWhere((entry) => entry.prophetId == 'ilyas');

      expect(
        ilyas.reason,
        ProphetHadithUnresolvedReasonT0336.israiliyyatOrUnsupportedNarrative,
      );
      expect(
        canonicalProphetSemanticGapManifestT0336
            .slotFor('ilyas', ProphetSemanticDimension.hadith)
            .isVerified,
        isFalse,
      );
    });
  });
}
