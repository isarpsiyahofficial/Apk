import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class ContentTransitionAccessGuard {
  const ContentTransitionAccessGuard({
    required this.entitlement,
    required this.verifier,
  });

  final EntitlementState entitlement;
  final InternetReachabilityVerifier verifier;

  Future<bool> canEnterNewContent() async {
    if (entitlement.isPro) return true;
    return await verifier.verify() == InternetReachability.reachable;
  }
}
