import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

/// Core religious/informational areas that are required to remain available
/// from bundled/local storage for PRO users when there is no network.
enum CoreContentArea {
  quran,
  meal,
  dua,
  dhikr,
  divineNames,
  religiousDays,
  prophets,
  history,
}

/// Fail-closed entitlement policy for offline core content.
///
/// This policy does not make network calls and does not grant FREE users an
/// offline bypass. Presentation/data layers can use the same decision before
/// opening any locally bundled core area.
abstract final class CoreContentOfflinePolicy {
  static const Set<CoreContentArea> requiredProOfflineAreas =
      <CoreContentArea>{
    CoreContentArea.quran,
    CoreContentArea.meal,
    CoreContentArea.dua,
    CoreContentArea.dhikr,
    CoreContentArea.divineNames,
    CoreContentArea.religiousDays,
    CoreContentArea.prophets,
    CoreContentArea.history,
  };

  static bool canOpenOffline({
    required EntitlementState entitlement,
    required CoreContentArea area,
  }) {
    if (!requiredProOfflineAreas.contains(area)) return false;
    return entitlement.isPro && entitlement.allowsOfflineCore;
  }

  static void requireOfflineAccess({
    required EntitlementState entitlement,
    required CoreContentArea area,
  }) {
    if (!canOpenOffline(entitlement: entitlement, area: area)) {
      throw StateError(
        'Offline core access denied for ${area.name} (${entitlement.tier.name}).',
      );
    }
  }
}
