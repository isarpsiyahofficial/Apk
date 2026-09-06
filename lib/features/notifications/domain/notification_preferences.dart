enum NotificationCategory {
  dailyVerse,
  dailyDua,
  dhikrReminder,
  religiousDay,
}

final class NotificationPreferences {
  const NotificationPreferences({
    this.dailyVerse = false,
    this.dailyDua = false,
    this.dhikrReminder = false,
    this.religiousDay = false,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const FormatException('Unsupported notification preferences schema.');
    }

    bool readBool(String key) {
      final value = json[key];
      if (value is! bool) {
        throw FormatException('Expected boolean notification preference: $key');
      }
      return value;
    }

    return NotificationPreferences(
      dailyVerse: readBool('dailyVerse'),
      dailyDua: readBool('dailyDua'),
      dhikrReminder: readBool('dhikrReminder'),
      religiousDay: readBool('religiousDay'),
    );
  }

  final bool dailyVerse;
  final bool dailyDua;
  final bool dhikrReminder;
  final bool religiousDay;

  bool enabled(NotificationCategory category) => switch (category) {
        NotificationCategory.dailyVerse => dailyVerse,
        NotificationCategory.dailyDua => dailyDua,
        NotificationCategory.dhikrReminder => dhikrReminder,
        NotificationCategory.religiousDay => religiousDay,
      };

  NotificationPreferences withCategory(
    NotificationCategory category,
    bool enabled,
  ) =>
      switch (category) {
        NotificationCategory.dailyVerse => NotificationPreferences(
            dailyVerse: enabled,
            dailyDua: dailyDua,
            dhikrReminder: dhikrReminder,
            religiousDay: religiousDay,
          ),
        NotificationCategory.dailyDua => NotificationPreferences(
            dailyVerse: dailyVerse,
            dailyDua: enabled,
            dhikrReminder: dhikrReminder,
            religiousDay: religiousDay,
          ),
        NotificationCategory.dhikrReminder => NotificationPreferences(
            dailyVerse: dailyVerse,
            dailyDua: dailyDua,
            dhikrReminder: enabled,
            religiousDay: religiousDay,
          ),
        NotificationCategory.religiousDay => NotificationPreferences(
            dailyVerse: dailyVerse,
            dailyDua: dailyDua,
            dhikrReminder: dhikrReminder,
            religiousDay: enabled,
          ),
      };

  Map<String, Object> toJson() => <String, Object>{
        'schemaVersion': 1,
        'dailyVerse': dailyVerse,
        'dailyDua': dailyDua,
        'dhikrReminder': dhikrReminder,
        'religiousDay': religiousDay,
      };
}

abstract interface class NotificationPreferencesStore {
  Future<NotificationPreferences> load();
  Future<void> save(NotificationPreferences preferences);
}
