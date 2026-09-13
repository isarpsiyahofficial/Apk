import 'religious_date_metadata.dart';

enum ReligiousDayNotificationGateReason {
  allowed,
  userOptOut,
  missingDateObservation,
  unconfirmedLocalDate,
}

class ReligiousDayNotificationGateResult {
  const ReligiousDayNotificationGateResult({
    required this.allowed,
    required this.reason,
  });

  final bool allowed;
  final ReligiousDayNotificationGateReason reason;
}

/// SPEC 318 / TODO T0180: no religious-day notification may be scheduled from
/// a generic Hijri conversion alone. The user must opt in and the exact local
/// Gregorian date must be backed by confirmed jurisdiction-scoped metadata.
class ReligiousDayNotificationGate {
  const ReligiousDayNotificationGate._();

  static ReligiousDayNotificationGateResult evaluate({
    required bool userOptedIn,
    required ReligiousDateObservation? observation,
  }) {
    if (!userOptedIn) {
      return const ReligiousDayNotificationGateResult(
        allowed: false,
        reason: ReligiousDayNotificationGateReason.userOptOut,
      );
    }
    if (observation == null) {
      return const ReligiousDayNotificationGateResult(
        allowed: false,
        reason: ReligiousDayNotificationGateReason.missingDateObservation,
      );
    }
    if (!ReligiousDateDisplayPolicy.canShowExactDate(observation)) {
      return const ReligiousDayNotificationGateResult(
        allowed: false,
        reason: ReligiousDayNotificationGateReason.unconfirmedLocalDate,
      );
    }
    return const ReligiousDayNotificationGateResult(
      allowed: true,
      reason: ReligiousDayNotificationGateReason.allowed,
    );
  }
}
