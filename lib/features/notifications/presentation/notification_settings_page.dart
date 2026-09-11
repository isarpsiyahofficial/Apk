import 'package:flutter/material.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

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
    await _persistChange(previous: previous, next: next);
  }

  Future<void> _pickTime(NotificationCategory category) async {
    if (_saving) return;
    final current = _preferences.timeFor(category);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (!mounted || picked == null) return;

    final previous = _preferences;
    final next = previous.withTime(
      category,
      NotificationTime(hour: picked.hour, minute: picked.minute),
    );
    await _persistChange(previous: previous, next: next);
  }

  Future<void> _persistChange({
    required NotificationPreferences previous,
    required NotificationPreferences next,
  }) async {
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(l10n.notificationIntro, style: theme.textTheme.bodyLarge),
                if (_storageError) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.notificationStorageError,
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
                      l10n.notificationPermissionError,
                      key: const Key('notification-permission-error'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _CategoryControl(
                  category: NotificationCategory.dailyVerse,
                  icon: Icons.menu_book_outlined,
                  title: l10n.notificationDailyVerse,
                  subtitle: l10n.notificationDailyVerseSubtitle,
                  value: _preferences.dailyVerse,
                  time: _preferences.dailyVerseTime,
                  timeLabel: l10n.notificationTimeLabel,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dailyVerse, value),
                  onTimePressed: () =>
                      _pickTime(NotificationCategory.dailyVerse),
                ),
                _CategoryControl(
                  category: NotificationCategory.dailyDua,
                  icon: Icons.volunteer_activism_outlined,
                  title: l10n.notificationDailyDua,
                  subtitle: l10n.notificationDailyDuaSubtitle,
                  value: _preferences.dailyDua,
                  time: _preferences.dailyDuaTime,
                  timeLabel: l10n.notificationTimeLabel,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dailyDua, value),
                  onTimePressed: () =>
                      _pickTime(NotificationCategory.dailyDua),
                ),
                _CategoryControl(
                  category: NotificationCategory.dhikrReminder,
                  icon: Icons.touch_app_outlined,
                  title: l10n.notificationDhikrReminder,
                  subtitle: l10n.notificationDhikrReminderSubtitle,
                  value: _preferences.dhikrReminder,
                  time: _preferences.dhikrReminderTime,
                  timeLabel: l10n.notificationTimeLabel,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.dhikrReminder, value),
                  onTimePressed: () =>
                      _pickTime(NotificationCategory.dhikrReminder),
                ),
                _CategoryControl(
                  category: NotificationCategory.religiousDay,
                  icon: Icons.event_available_outlined,
                  title: l10n.notificationReligiousDay,
                  subtitle: l10n.notificationReligiousDaySubtitle,
                  value: _preferences.religiousDay,
                  time: _preferences.religiousDayTime,
                  timeLabel: l10n.notificationTimeLabel,
                  enabled: !_saving,
                  onChanged: (value) =>
                      _setCategory(NotificationCategory.religiousDay, value),
                  onTimePressed: () =>
                      _pickTime(NotificationCategory.religiousDay),
                ),
                const SizedBox(height: 12),
                Text(l10n.notificationFootnote, style: theme.textTheme.bodySmall),
              ],
            ),
    );
  }
}

class _CategoryControl extends StatelessWidget {
  const _CategoryControl({
    required this.category,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.time,
    required this.timeLabel,
    required this.enabled,
    required this.onChanged,
    required this.onTimePressed,
  });

  final NotificationCategory category;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final NotificationTime time;
  final String timeLabel;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTimePressed;

  @override
  Widget build(BuildContext context) {
    final formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: time.hour, minute: time.minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile.adaptive(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          secondary: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        if (value)
          ListTile(
            key: Key('notification-time-${category.name}'),
            enabled: enabled,
            contentPadding: const EdgeInsetsDirectional.only(start: 52, end: 4),
            leading: const Icon(Icons.schedule_outlined),
            title: Text(timeLabel),
            trailing: Text(formattedTime),
            onTap: enabled ? onTimePressed : null,
          ),
      ],
    );
  }
}
