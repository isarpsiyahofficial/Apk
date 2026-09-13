import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

final class SecureNotificationPreferencesStore
    implements NotificationPreferencesStore {
  SecureNotificationPreferencesStore(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String storageKey = 'notification.preferences.v1';

  final PrivateUserStore _store;

  @override
  Future<NotificationPreferences> load() async {
    final encoded = await _store.read(storageKey);
    if (encoded == null) return const NotificationPreferences();

    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected notification preferences object.');
    }
    return NotificationPreferences.fromJson(decoded);
  }

  @override
  Future<void> save(NotificationPreferences preferences) =>
      _store.write(storageKey, jsonEncode(preferences.toJson()));
}
