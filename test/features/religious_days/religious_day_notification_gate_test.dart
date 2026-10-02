import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_notification_gate.dart';

void main() {
  ReligiousDateObservation observation({
    ReligiousDateVerificationStatus status =
        ReligiousDateVerificationStatus.confirmed,
    bool includePublicationEvidence = true,
    Uri? publicationUrl,
  }) {
    final source = religiousDateAuthorities.first;
    return ReligiousDateObservation(
      contentId: 'religious-day:laylat-al-qadr',
      hijriYear: 1448,
      hijriMonth: 9,
      hijriDay: 27,
      gregorianDate: DateTime.utc(2027, 3, 6),
      source: source,
      status: status,
      verifiedAt: DateTime.utc(2027, 3, 1),
      sourcePublicationLocator:
          includePublicationEvidence ? 'official-calendar:1448-09-27' : null,
      sourcePublicationUrl: includePublicationEvidence
          ? publicationUrl ??
              Uri.parse('https://namazvakitleri.diyanet.gov.tr/')
          : null,
    );
  }

  group('ReligiousDayNotificationGate', () {
    test('user opt-out always blocks scheduling', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: false,
        observation: observation(),
      );

      expect(result.allowed, isFalse);
      expect(result.reason, ReligiousDayNotificationGateReason.userOptOut);
    });

    test('missing local date source blocks scheduling', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: true,
        observation: null,
      );

      expect(result.allowed, isFalse);
      expect(
        result.reason,
        ReligiousDayNotificationGateReason.missingDateObservation,
      );
    });

    test('provisional date blocks notification even when opted in', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: true,
        observation: observation(
          status: ReligiousDateVerificationStatus.provisional,
        ),
      );

      expect(result.allowed, isFalse);
      expect(
        result.reason,
        ReligiousDayNotificationGateReason.unconfirmedLocalDate,
      );
    });

    test('confirmed date without pinned publication evidence is blocked', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: true,
        observation: observation(includePublicationEvidence: false),
      );

      expect(result.allowed, isFalse);
      expect(
        result.reason,
        ReligiousDayNotificationGateReason.unconfirmedLocalDate,
      );
    });

    test('unrelated HTTPS publication cannot authorize a notification', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: true,
        observation: observation(
          publicationUrl: Uri.parse('https://example.org/official-calendar'),
        ),
      );

      expect(result.allowed, isFalse);
      expect(
        result.reason,
        ReligiousDayNotificationGateReason.unconfirmedLocalDate,
      );
    });

    test('confirmed jurisdiction-scoped exact date allows scheduling', () {
      final result = ReligiousDayNotificationGate.evaluate(
        userOptedIn: true,
        observation: observation(),
      );

      expect(result.allowed, isTrue);
      expect(result.reason, ReligiousDayNotificationGateReason.allowed);
    });
  });
}
