import 'package:flutter/material.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({
    super.key,
    this.initialPreferences = const NotificationPreferences(),
    this.store,
    this.onChanged,
    this.onEnableRequested,
  });

  final NotificationPreferences initialPreferences;
  final NotificationPreferencesStore? store;
  final ValueChanged<NotificationPreferences>? onChanged;

  /// Runs only for an explicit OFF -> ON user action. Returning false keeps
  /// the category disabled. This lets Android request POST_NOTIFICATIONS only
  /// after a user opt-in instead of at app startup.
  final Future<bool> Function(NotificationCategory category)? onEnableRequested;

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late NotificationPreferences _preferences;
  late bool _loading;
  bool _saving = false;
  bool _storageError = false;
  bool _permissionError = false;

  @override
  void initState() {
    super.initState();
    _preferences = widget.initialPreferences;
    _loading = widget.store != null;
    if (widget.store != null) {
      _loadPreferences();
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final preferences = await widget.store!.load();
      if (!mounted) return;
      setState(() {
        _preferences = preferences;
        _loading = false;
        _storageError = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _preferences = const NotificationPreferences();
        _loading = false;
        _storageError = true;
      });
    }
  }

  Future<void> _setCategory(
    NotificationCategory category,
    bool enabled,
  ) async {
    if (_saving) return;

    if (enabled && widget.onEnableRequested != null) {
      setState(() {
        _saving = true;
        _permissionError = false;
      });
      var allowed = false;
      try {
        allowed = await widget.onEnableRequested!(category);
      } on Object {
        allowed = false;
      }
      if (!mounted) return;
      if (!allowed) {
        setState(() {
          _saving = false;
          _permissionError = true;
        });
        return;
      }
      setState(() => _saving = false);
    }

    final previous = _preferences;
    final next = previous.withCategory(category, enabled);

    setState(() {
      _preferences = next;
      _saving = widget.store != null;
      _storageError = false;
      _permissionError = false;
    });
    widget.onChanged?.call(next);

    final store = widget.store;
    if (store == null) return;

    try {
      await store.save(next);
      if (!mounted) return;
      setState(() => _saving = false);
    } on Object {
      if (!mounted) return;
      setState(() {
        _preferences = previous;
        _saving = false;
        _storageError = true;
      });
      widget.onChanged?.call(previous);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings =
        _NotificationStrings.forLocale(Localizations.localeOf(context));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(strings.intro, style: theme.textTheme.bodyLarge),
                if (_storageError) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      strings.storageError,
                      key: const Key('notification-storage-error'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
                if (_permissionError) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      strings.permissionError,
                      key: const Key('notification-permission-error'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _CategorySwitch(
                  icon: Icons.menu_book_outlined,
                  title: strings.dailyVerse,
                  subtitle: strings.dailyVerseSubtitle,
                  value: _preferences.dailyVerse,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dailyVerse, value),
                ),
                _CategorySwitch(
                  icon: Icons.volunteer_activism_outlined,
                  title: strings.dailyDua,
                  subtitle: strings.dailyDuaSubtitle,
                  value: _preferences.dailyDua,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dailyDua, value),
                ),
                _CategorySwitch(
                  icon: Icons.touch_app_outlined,
                  title: strings.dhikrReminder,
                  subtitle: strings.dhikrReminderSubtitle,
                  value: _preferences.dhikrReminder,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dhikrReminder, value),
                ),
                _CategorySwitch(
                  icon: Icons.event_available_outlined,
                  title: strings.religiousDay,
                  subtitle: strings.religiousDaySubtitle,
                  value: _preferences.religiousDay,
                  enabled: !_saving,
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
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: enabled ? onChanged : null,
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
    required this.storageError,
    required this.permissionError,
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
  final String storageError;
  final String permissionError;

  static _NotificationStrings forLocale(Locale locale) {
    return switch (locale.languageCode) {
      'ar' => const _NotificationStrings(
          title: 'الإشعارات',
          intro:
              'الإشعارات اختيارية بالكامل. فعّل فقط الفئات التي تريدها، ويمكنك إيقاف كل فئة بشكل مستقل.',
          dailyVerse: 'آية اليوم',
          dailyVerseSubtitle: 'تذكير محلي اختياري بآية اليوم.',
          dailyDua: 'دعاء اليوم',
          dailyDuaSubtitle: 'تذكير محلي اختياري بدعاء اليوم.',
          dhikrReminder: 'تذكير الذكر',
          dhikrReminderSubtitle: 'ذكّرني بالذكر دون ضغط أو مقارنة.',
          religiousDay: 'الأيام الدينية',
          religiousDaySubtitle:
              'يعمل فقط عندما يكون تاريخ اليوم موثّقًا من مصدر موثوق.',
          footnote:
              'لا توجد إشعارات للأذان أو مواقيت الصلاة في الإصدار الأول.',
          storageError:
              'تعذّر حفظ إعدادات الإشعارات. بقيت الفئات غير المحفوظة مغلقة.',
          permissionError:
              'لم يتم منح إذن الإشعارات. بقي هذا النوع من التذكيرات مغلقًا.',
        ),
      'en' => const _NotificationStrings(
          title: 'Notifications',
          intro:
              'Notifications are fully opt-in. Enable only the categories you want, and turn each category off independently at any time.',
          dailyVerse: 'Verse of the day',
          dailyVerseSubtitle:
              'Optional local reminder for the verse of the day.',
          dailyDua: 'Dua of the day',
          dailyDuaSubtitle: 'Optional local reminder for the dua of the day.',
          dhikrReminder: 'Dhikr reminder',
          dhikrReminderSubtitle:
              'A personal reminder without pressure or comparison.',
          religiousDay: 'Religious days',
          religiousDaySubtitle:
              'Enabled only when the date is backed by a trusted calendar source.',
          footnote: 'V1 does not send adhan or prayer-time notifications.',
          storageError:
              'Notification settings could not be saved. Unsaved categories remain off.',
          permissionError:
              'Notification permission was not granted. This reminder stayed off.',
        ),
      _ => const _NotificationStrings(
          title: 'Bildirimler',
          intro:
              'Bildirimlerin tamamı isteğe bağlıdır. Yalnız istediğin kategorileri açabilir, her birini ayrı ayrı kapatabilirsin.',
          dailyVerse: 'Günün Ayeti',
          dailyVerseSubtitle:
              'Günün ayeti için isteğe bağlı yerel hatırlatma.',
          dailyDua: 'Günün Duası',
          dailyDuaSubtitle:
              'Günün duası için isteğe bağlı yerel hatırlatma.',
          dhikrReminder: 'Zikir Hatırlatması',
          dhikrReminderSubtitle:
              'Baskı veya karşılaştırma olmadan kişisel hatırlatma.',
          religiousDay: 'Dini Günler',
          religiousDaySubtitle:
              'Yalnız tarih güvenilir bir takvim kaynağıyla doğrulandığında etkinleştirilir.',
          footnote:
              'V1 içinde ezan veya namaz vakti bildirimi gönderilmez.',
          storageError:
              'Bildirim ayarları kaydedilemedi. Kaydedilemeyen kategoriler kapalı kaldı.',
          permissionError:
              'Bildirim izni verilmedi. Bu hatırlatma kapalı kaldı.',
        ),
    };
  }
}
