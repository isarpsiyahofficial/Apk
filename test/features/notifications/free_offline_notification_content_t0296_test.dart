import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_content_policy_t0296.dart';

void main() {
  group('T0296 FREE offline notification content gate', () {
    test('all ordinary local notification requests default to teaser/reference', () {
      final request = LocalNotificationRequestT0291(
        id: 1,
        scheduledAt: DateTime(2030, 1, 1, 9),
        title: 'Reminder',
        body: 'Open the verified content in Islami Hayat.',
        payload: 'islami-hayat://quran/1/1',
      );

      expect(
        request.contentExposure,
        NotificationContentExposureT0296.teaserReferenceOnly,
      );
      expect(
        NotificationContentPolicyT0296.isSafeForGenericLocalScheduler(
          request.contentExposure,
        ),
        isTrue,
      );
    });

    test('expanded Premium content is fail-closed on generic scheduler path', () {
      expect(
        () => NotificationContentPolicyT0296.requireSafeForGenericLocalScheduler(
          NotificationContentExposureT0296.expandedPremiumContent,
        ),
        throwsStateError,
      );
    });

    test('teaser/reference content remains allowed when delivered offline', () {
      expect(
        () => NotificationContentPolicyT0296.requireSafeForGenericLocalScheduler(
          NotificationContentExposureT0296.teaserReferenceOnly,
        ),
        returnsNormally,
      );
    });
  });
}
