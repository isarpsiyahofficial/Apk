import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

const String dailyContentChannelIdT0291 = 'daily_religious_content';
const String dailyContentChannelNameT0291 = 'Daily religious content';
const String dailyContentChannelDescriptionT0291 =
    'Optional local reminders explicitly enabled by the user.';

final class AndroidLocalNotificationSchedulerT0291
    implements LocalNotificationSchedulerT0291 {
  AndroidLocalNotificationSchedulerT0291({
    FlutterLocalNotificationsPlugin? plugin,
    Future<String> Function()? timeZoneIdLoader,
    void Function(String payload)? onPayload,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _timeZoneIdLoader = timeZoneIdLoader ?? _loadDeviceTimeZoneId,
        _onPayload = onPayload;

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<String> Function() _timeZoneIdLoader;
  final void Function(String payload)? _onPayload;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    final initialized = await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _onPayload?.call(payload);
        }
      },
    );
    if (initialized != true) {
      throw StateError('Local notification plugin initialization failed.');
    }

    tz_data.initializeTimeZones();
    final timeZoneId = await _timeZoneIdLoader();
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneId));
    } on ArgumentError {
      throw StateError('Unsupported device timezone: $timeZoneId');
    }

    _initialized = true;
  }

  Future<bool> requestUserPermission() async {
    await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  Future<bool> notificationsEnabled() async {
    await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }

  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async {
    await initialize();
    if (!await notificationsEnabled()) {
      throw StateError(
        'Notification permission is not granted; scheduling is blocked.',
      );
    }

    final when = tz.TZDateTime.from(request.scheduledAt, tz.local);
    if (!when.isAfter(tz.TZDateTime.now(tz.local))) {
      throw ArgumentError.value(
        request.scheduledAt,
        'scheduledAt',
        'A local notification must be scheduled in the future.',
      );
    }

    await _plugin.zonedSchedule(
      request.id,
      request.title,
      request.body,
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          dailyContentChannelIdT0291,
          dailyContentChannelNameT0291,
          channelDescription: dailyContentChannelDescriptionT0291,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          category: AndroidNotificationCategory.reminder,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: request.payload,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id);
  }

  static Future<String> _loadDeviceTimeZoneId() async {
    final info = await FlutterTimezone.getLocalTimezone();
    return info.identifier;
  }
}
