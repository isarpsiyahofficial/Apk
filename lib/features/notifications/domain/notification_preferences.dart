enum NotificationCategory {
  dailyVerse,
  dailyDua,
  dhikrReminder,
  religiousDay,
}

final class NotificationTime {
  const NotificationTime({required this.hour, required this.minute})
      : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59);

  factory NotificationTime.fromMinutesSinceMidnight(int value) {
    if (value < 0 || value >= 24 * 60) {
      throw FormatException(
        'Notification time must be between 0 and ${24 * 60 - 1}.',
      );
    }
    return NotificationTime(hour: value ~/ 60, minute: value % 60);
  }

  final int hour;
  final int minute;

  int get minutesSinceMidnight => hour * 60 + minute;

  @override
  bool operator ==(Object other) =>
      other is NotificationTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}

const NotificationTime dailyVerseDefaultTime =
    NotificationTime(hour: 9, minute: 0);
const NotificationTime dailyDuaDefaultTime =
    NotificationTime(hour: 10, minute: 0);
const NotificationTime dhikrReminderDefaultTime =
    NotificationTime(hour: 20, minute: 0);
const NotificationTime religiousDayDefaultTime =
    NotificationTime(hour: 9, minute: 0);

final class NotificationPreferences {
  const NotificationPreferences({
    this.dailyVerse = false,
    this.dailyDua = false,
    this.dhikrReminder = false,
    this.religiousDay = false,
    this.dailyVerseTime = dailyVerseDefaultTime,
    this.dailyDuaTime = dailyDuaDefaultTime,
    this.dhikrReminderTime = dhikrReminderDefaultTime,
    this.religiousDayTime = religiousDayDefaultTime,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion != 1 && schemaVersion != 2) {
      throw const FormatException('Unsupported notification preferences schema.');
    }

    final expectedKeys = schemaVersion == 1
        ? const <String>{
            'schemaVersion',
            'dailyVerse',
            'dailyDua',
            'dhikrReminder',
            'religiousDay',
          }
        : const <String>{
            'schemaVersion',
            'dailyVerse',
            'dailyDua',
            'dhikrReminder',
            'religiousDay',
            'dailyVerseTime',
            'dailyDuaTime',
            'dhikrReminderTime',
            'religiousDayTime',
          };
    if (json.keys.toSet().difference(expectedKeys).isNotEmpty ||
        expectedKeys.difference(json.keys.toSet()).isNotEmpty) {
      throw const FormatException(
        'Notification preferences contain an unexpected or missing field.',
      );
    }

    bool readBool(String key) {
      final value = json[key];
      if (value is! bool) {
        throw FormatException('Expected boolean notification preference: $key');
      }
      return value;
    }

    NotificationTime readTime(String key, NotificationTime fallback) {
      if (schemaVersion == 1) return fallback;
      final value = json[key];
      if (value is! int) {
        throw FormatException('Expected notification time minutes: $key');
      }
      return NotificationTime.fromMinutesSinceMidnight(value);
    }

    return NotificationPreferences(
      dailyVerse: readBool('dailyVerse'),
      dailyDua: readBool('dailyDua'),
      dhikrReminder: readBool('dhikrReminder'),
      religiousDay: readBool('religiousDay'),
      dailyVerseTime: readTime('dailyVerseTime', dailyVerseDefaultTime),
      dailyDuaTime: readTime('dailyDuaTime', dailyDuaDefaultTime),
      dhikrReminderTime:
          readTime('dhikrReminderTime', dhikrReminderDefaultTime),
      religiousDayTime: readTime('religiousDayTime', religiousDayDefaultTime),
    );
  }

  final bool dailyVerse;
  final bool dailyDua;
  final bool dhikrReminder;
  final bool religiousDay;
  final NotificationTime dailyVerseTime;
  final NotificationTime dailyDuaTime;
  final NotificationTime dhikrReminderTime;
  final NotificationTime religiousDayTime;

  bool enabled(NotificationCategory category) => switch (category) {
        NotificationCategory.dailyVerse => dailyVerse,
        NotificationCategory.dailyDua => dailyDua,
        NotificationCategory.dhikrReminder => dhikrReminder,
        NotificationCategory.religiousDay => religiousDay,
      };

  NotificationTime timeFor(NotificationCategory category) => switch (category) {
        NotificationCategory.dailyVerse => dailyVerseTime,
        NotificationCategory.dailyDua => dailyDuaTime,
        NotificationCategory.dhikrReminder => dhikrReminderTime,
        NotificationCategory.religiousDay => religiousDayTime,
      };

  NotificationPreferences withCategory(
    NotificationCategory category,
    bool enabled,
  ) =>
      NotificationPreferences(
        dailyVerse:
            category == NotificationCategory.dailyVerse ? enabled : dailyVerse,
        dailyDua:
            category == NotificationCategory.dailyDua ? enabled : dailyDua,
        dhikrReminder: category == NotificationCategory.dhikrReminder
            ? enabled
            : dhikrReminder,
        religiousDay: category == NotificationCategory.religiousDay
            ? enabled
            : religiousDay,
        dailyVerseTime: dailyVerseTime,
        dailyDuaTime: dailyDuaTime,
        dhikrReminderTime: dhikrReminderTime,
        religiousDayTime: religiousDayTime,
      );

  NotificationPreferences withTime(
    NotificationCategory category,
    NotificationTime time,
  ) =>
      NotificationPreferences(
        dailyVerse: dailyVerse,
        dailyDua: dailyDua,
        dhikrReminder: dhikrReminder,
        religiousDay: religiousDay,
        dailyVerseTime:
            category == NotificationCategory.dailyVerse ? time : dailyVerseTime,
        dailyDuaTime:
            category == NotificationCategory.dailyDua ? time : dailyDuaTime,
        dhikrReminderTime: category == NotificationCategory.dhikrReminder
            ? time
            : dhikrReminderTime,
        religiousDayTime: category == NotificationCategory.religiousDay
            ? time
            : religiousDayTime,
      );

  Map<String, Object> toJson() => <String, Object>{
        'schemaVersion': 2,
        'dailyVerse': dailyVerse,
        'dailyDua': dailyDua,
        'dhikrReminder': dhikrReminder,
        'religiousDay': religiousDay,
        'dailyVerseTime': dailyVerseTime.minutesSinceMidnight,
        'dailyDuaTime': dailyDuaTime.minutesSinceMidnight,
        'dhikrReminderTime': dhikrReminderTime.minutesSinceMidnight,
        'religiousDayTime': religiousDayTime.minutesSinceMidnight,
      };
}

abstract interface class NotificationPreferencesStore {
  Future<NotificationPreferences> load();
  Future<void> save(NotificationPreferences preferences);
}
