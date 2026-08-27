import 'dart:convert';

import 'storage_boundaries.dart';

final class UserDataSnapshot {
  const UserDataSnapshot({
    required this.favorites,
    required this.bookmarks,
    required this.notes,
    required this.questionHistory,
    required this.dhikrTotals,
    required this.settings,
    required this.entitlementCache,
  });

  factory UserDataSnapshot.empty() => const UserDataSnapshot(
        favorites: <String>{},
        bookmarks: <String>{},
        notes: <String, String>{},
        questionHistory: <String>[],
        dhikrTotals: <String, int>{},
        settings: <String, String>{},
        entitlementCache: <String, String>{},
      );

  final Set<String> favorites;
  final Set<String> bookmarks;
  final Map<String, String> notes;
  final List<String> questionHistory;
  final Map<String, int> dhikrTotals;
  final Map<String, String> settings;
  final Map<String, String> entitlementCache;

  Map<String, Object> toJson() => <String, Object>{
        'schemaVersion': 1,
        'favorites': favorites.toList()..sort(),
        'bookmarks': bookmarks.toList()..sort(),
        'notes': notes,
        'questionHistory': questionHistory,
        'dhikrTotals': dhikrTotals,
        'settings': settings,
        'entitlementCache': entitlementCache,
      };

  factory UserDataSnapshot.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const UserDataFormatException('Unsupported user-data schema.');
    }

    return UserDataSnapshot(
      favorites: _stringSet(json['favorites']),
      bookmarks: _stringSet(json['bookmarks']),
      notes: _stringMap(json['notes']),
      questionHistory: _stringList(json['questionHistory']),
      dhikrTotals: _intMap(json['dhikrTotals']),
      settings: _stringMap(json['settings']),
      entitlementCache: _stringMap(json['entitlementCache']),
    );
  }

  static Set<String> _stringSet(Object? value) => _stringList(value).toSet();

  static List<String> _stringList(Object? value) {
    if (value is! List) throw const UserDataFormatException('Expected list.');
    return List<String>.unmodifiable(value.map((item) {
      if (item is! String) {
        throw const UserDataFormatException('Expected string list item.');
      }
      return item;
    }));
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) throw const UserDataFormatException('Expected map.');
    final result = <String, String>{};
    for (final entry in value.entries) {
      if (entry.key is! String || entry.value is! String) {
        throw const UserDataFormatException('Expected string map.');
      }
      result[entry.key as String] = entry.value as String;
    }
    return Map<String, String>.unmodifiable(result);
  }

  static Map<String, int> _intMap(Object? value) {
    if (value is! Map) throw const UserDataFormatException('Expected map.');
    final result = <String, int>{};
    for (final entry in value.entries) {
      if (entry.key is! String || entry.value is! int || entry.value < 0) {
        throw const UserDataFormatException('Expected non-negative integer map.');
      }
      result[entry.key as String] = entry.value as int;
    }
    return Map<String, int>.unmodifiable(result);
  }
}

final class UserDataRepository {
  UserDataRepository(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String storageKey = 'user.snapshot.v1';

  final PrivateUserStore _store;

  Future<UserDataSnapshot> load() async {
    final encoded = await _store.read(storageKey);
    if (encoded == null) return UserDataSnapshot.empty();

    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) {
        throw const UserDataFormatException('Expected root JSON object.');
      }
      return UserDataSnapshot.fromJson(decoded);
    } on FormatException catch (error) {
      throw UserDataFormatException('Invalid stored JSON: ${error.message}');
    }
  }

  Future<void> save(UserDataSnapshot snapshot) =>
      _store.write(storageKey, jsonEncode(snapshot.toJson()));

  Future<void> reset() => _store.delete(storageKey);
}

final class UserDataFormatException implements Exception {
  const UserDataFormatException(this.message);

  final String message;

  @override
  String toString() => 'UserDataFormatException: $message';
}
