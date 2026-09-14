import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/content/forbidden_religious_claim_audit_t0334.dart';

/// Blocks language that turns a meaning/evidence connection into a promised
/// worldly outcome. This is a release guard, not a substitute for religious
/// and native-language review.
final class DhikrOutcomeClaimPolicy {
  const DhikrOutcomeClaimPolicy._();

  static bool allows(LocalizedReligiousText rationale) {
    return !ForbiddenReligiousClaimAuditT0334.containsForbiddenClaim(
          rationale.tr,
        ) &&
        !ForbiddenReligiousClaimAuditT0334.containsForbiddenClaim(
          rationale.en,
        ) &&
        !ForbiddenReligiousClaimAuditT0334.containsForbiddenClaim(
          rationale.ar,
        );
  }

  static void requireAllowed(LocalizedReligiousText rationale) {
    if (!allows(rationale)) {
      throw StateError(
        'Dhikr intention content contains a prohibited guaranteed-outcome claim.',
      );
    }
  }
}
