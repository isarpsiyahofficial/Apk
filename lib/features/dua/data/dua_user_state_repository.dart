import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class DuaUserState {
  const DuaUserState({
    required this.favoriteIds,
    required this.historyIds,
  });

  factory DuaUserState.empty() => const DuaUserState(
        favoriteIds: <String>{},
        historyIds: <String>[],
      );

  factory DuaUserState.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const DuaUserStateFormatException('Unsupported schema version.');
    }

    return DuaUserState(
      favoriteIds: _stringList(json['favoriteIds']).toSet(),
      historyIds: _stringList(json['historyIds']),
    );
  }

  final Set<String> favoriteIds;

  /// Most-recent first. This is private local usage history and must never be
  /// sent to analytics or advertising systems.
  final List<String> historyIds;

  Map<String, Object> toJson() => <String, Object>{
        'schemaVersion': 1,
        'favoriteIds': favoriteIds.toList()..sort(),
        'historyIds': historyIds,
      };

  static List<String> _stringList(Object? value) {
    if (value is! List) {
      throw const DuaUserStateFormatException('Expected a list.');
    }
    return List<String>.unmodifiable(value.map((item) {
      if (item is! String || item.trim().isEmpty) {
        throw const DuaUserStateFormatException(
          'Expected non-empty string list items.',
        );
      }
      return item;
    }));
  }
}

final class DuaUserStateRepository {
  DuaUserStateRepository(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String storageKey = 'dua.user-state.v1';
  static const int maxHistoryItems = 100;

  final PrivateUserStore _store;

  Future<DuaUserState> load() async {
    final encoded = await _store.read(storageKey);
    if (encoded == null) return DuaUserState.empty();

    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) {
        throw const DuaUserStateFormatException('Expected root object.');
      }
      return DuaUserState.fromJson(decoded);
    } on FormatException catch (error) {
      throw DuaUserStateFormatException('Invalid JSON: ${error.message}');
    }
  }

  Future<DuaUserState> toggleFavorite(String duaId) async {
    _requireId(duaId);
    final current = await load();
    final favorites = current.favoriteIds.toSet();
    if (!favorites.add(duaId)) favorites.remove(duaId);

    final next = DuaUserState(
      favoriteIds: Set<String>.unmodifiable(favorites),
      historyIds: current.historyIds,
    );
    await _save(next);
    return next;
  }

  Future<DuaUserState> recordOpened(String duaId) async {
    _requireId(duaId);
    final current = await load();
    final history = <String>[
      duaId,
      ...current.historyIds.where((id) => id != duaId),
    ];
    if (history.length > maxHistoryItems) {
      history.removeRange(maxHistoryItems, history.length);
    }

    final next = DuaUserState(
      favoriteIds: current.favoriteIds,
      historyIds: List<String>.unmodifiable(history),
    );
    await _save(next);
    return next;
  }

  Future<void> clearHistory() async {
    final current = await load();
    await _save(
      DuaUserState(
        favoriteIds: current.favoriteIds,
        historyIds: const <String>[],
      ),
    );
  }

  Future<void> reset() => _store.delete(storageKey);

  Future<void> _save(DuaUserState state) =>
      _store.write(storageKey, jsonEncode(state.toJson()));

  static void _requireId(String id) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'duaId', 'Dua id cannot be empty.');
    }
  }
}

final class DuaUserStateFormatException implements Exception {
  const DuaUserStateFormatException(this.message);

  final String message;

  @override
  String toString() => 'DuaUserStateFormatException: $message';
}
