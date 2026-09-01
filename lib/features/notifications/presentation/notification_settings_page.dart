import 'package:flutter/material.dart';

enum NotificationCategory {
  dailyVerse,
  dailyDua,
  dhikrReminder,
  religiousDay,
}

class NotificationPreferences {
  const NotificationPreferences({
    this.dailyVerse = false,
    this.dailyDua = false,
    this.dhikrReminder = false,
    this.religiousDay = false,
  });

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
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({
    super.key,
    this.initialPreferences = const NotificationPreferences(),
    this.onChanged,
  });

  final NotificationPreferences initialPreferences;
  final ValueChanged<NotificationPreferences>? onChanged;

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late NotificationPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = widget.initialPreferences;
  }

  void _setCategory(NotificationCategory category, bool enabled) {
    setState(() {
      _preferences = _preferences.withCategory(category, enabled);
    });
    widget.onChanged?.call(_preferences);
  }

  @override
  Widget build(BuildContext context) {
    final strings = _NotificationStrings.forLocale(Localizations.localeOf(context));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(strings.intro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          _CategorySwitch(
            icon: Icons.menu_book_outlined,
            title: strings.dailyVerse,
            subtitle: strings.dailyVerseSubtitle,
            value: _preferences.dailyVerse,
            onChanged: (value) =>
                _setCategory(NotificationCategory.dailyVerse, value),
          ),
          _CategorySwitch(
            icon: Icons.volunteer_activism_outlined,
            title: strings.dailyDua,
            subtitle: strings.dailyDuaSubtitle,
            value: _preferences.dailyDua,
            onChanged: (value) =>
                _setCategory(NotificationCategory.dailyDua, value),
          ),
          _CategorySwitch(
            icon: Icons.touch_app_outlined,
            title: strings.dhikrReminder,
            subtitle: strings.dhikrReminderSubtitle,
            value: _preferences.dhikrReminder,
            onChanged: (value) =>
                _setCategory(NotificationCategory.dhikrReminder, value),
          ),
          _CategorySwitch(
            icon: Icons.event_available_outlined,
            title: strings.religiousDay,
            subtitle: strings.religiousDaySubtitle,
            value: _preferences.religiousDay,
            onChanged: (value) =>
                _setCategory(NotificationCategory.religiousDay, value),
          ),
          const SizedBox(height: 12),
          Text(strings.footnote, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CategorySwitch extends StatelessWidget {
  const _CategorySwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _NotificationStrings {
  const _NotificationStrings({
    required this.title,
    required this.intro,
    required this.dailyVerse,
    required this.dailyVerseSubtitle,
    required this.dailyDua,
    required this.dailyDuaSubtitle,
    required this.dhikrReminder,
    required this.dhikrReminderSubtitle,
    required this.religiousDay,
    required this.religiousDaySubtitle,
    required this.footnote,
  });

  final String title;
  final String intro;
  final String dailyVerse;
  final String dailyVerseSubtitle;
  final String dailyDua;
  final String dailyDuaSubtitle;
  final String dhikrReminder;
  final String dhikrReminderSubtitle;
  final String religiousDay;
  final String religiousDaySubtitle;
  final String footnote;

  static _NotificationStrings forLocale(Locale locale) {
    return switch (locale.languageCode) {
      'ar' => const _NotificationStrings(
          title: 'الإشعارات',
          intro: 'الإشعارات اختيارية بالكامل. فعّل فقط الفئات التي تريدها، ويمكنك إيقاف كل فئة بشكل مستقل.',
          dailyVerse: 'آية اليوم',
          dailyVerseSubtitle: 'تذكير محلي اختياري بآية اليوم.',
          dailyDua: 'دعاء اليوم',
          dailyDuaSubtitle: 'تذكير محلي اختياري بدعاء اليوم.',
          dhikrReminder: 'تذكير الذكر',
          dhikrReminderSubtitle: 'ذكّرني بالذكر دون ضغط أو مقارنة.',
          religiousDay: 'الأيام الدينية',
          religiousDaySubtitle: 'يعمل فقط عندما يكون تاريخ اليوم موثّقًا من مصدر موثوق.',
          footnote: 'لا توجد إشعارات للأذان أو مواقيت الصلاة في الإصدار الأول.',
        ),
      'en' => const _NotificationStrings(
          title: 'Notifications',
          intro: 'Notifications are fully opt-in. Enable only the categories you want, and turn each category off independently at any time.',
          dailyVerse: 'Verse of the day',
          dailyVerseSubtitle: 'Optional local reminder for the verse of the day.',
          dailyDua: 'Dua of the day',
          dailyDuaSubtitle: 'Optional local reminder for the dua of the day.',
          dhikrReminder: 'Dhikr reminder',
          dhikrReminderSubtitle: 'A personal reminder without pressure or comparison.',
          religiousDay: 'Religious days',
          religiousDaySubtitle: 'Enabled only when the date is backed by a trusted calendar source.',
          footnote: 'V1 does not send adhan or prayer-time notifications.',
        ),
      _ => const _NotificationStrings(
          title: 'Bildirimler',
          intro: 'Bildirimlerin tamamı isteğe bağlıdır. Yalnız istediğin kategorileri açabilir, her birini ayrı ayrı kapatabilirsin.',
          dailyVerse: 'Günün Ayeti',
          dailyVerseSubtitle: 'Günün ayeti için isteğe bağlı yerel hatırlatma.',
          dailyDua: 'Günün Duası',
          dailyDuaSubtitle: 'Günün duası için isteğe bağlı yerel hatırlatma.',
          dhikrReminder: 'Zikir Hatırlatması',
          dhikrReminderSubtitle: 'Baskı veya karşılaştırma olmadan kişisel hatırlatma.',
          religiousDay: 'Dini Günler',
          religiousDaySubtitle: 'Yalnız tarih güvenilir bir takvim kaynağıyla doğrulandığında etkinleştirilir.',
          footnote: 'V1 içinde ezan veya namaz vakti bildirimi gönderilmez.',
        ),
    };
  }
}
