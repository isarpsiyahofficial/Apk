import 'dart:convert';

import '../storage/storage_boundaries.dart';

/// Local-only question history policy for T0303.
///
/// History is opt-in: a missing/corrupt preference never records a question.
/// The history and its preference remain inside [PrivateUserStore].
final class QuestionHistoryPrivacyT0303 {
  QuestionHistoryPrivacyT0303(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String preferenceKey = 'privacy.questionHistory.enabled.v1';
  static const String historyKey = 'privacy.questionHistory.entries.v1';
  static const int maxEntries = 100;

  final PrivateUserStore _store;

  Future<bool> isEnabled() async {
    final raw = await _store.read(preferenceKey);
    return raw == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    await _store.write(preferenceKey, enabled ? 'true' : 'false');
    if (!enabled) {
      // Disabling collection also removes previously retained sensitive queries;
      // this avoids a misleading "disabled" state with old history left behind.
      await clearHistory();
    }
  }

  Future<List<String>> loadHistory() async {
    if (!await isEnabled()) return const <String>[];
    final raw = await _store.read(historyKey);
    if (raw == null) return const <String>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List || decoded.any((item) => item is! String)) {
        return const <String>[];
      }
      return List<String>.unmodifiable(decoded.cast<String>());
    } on FormatException {
      return const <String>[];
    }
  }

  Future<bool> recordQuestion(String question) async {
    if (!await isEnabled()) return false;
    final normalized = question.trim();
    if (normalized.isEmpty) return false;

    final current = await loadHistory();
    final next = <String>[normalized, ...current.where((q) => q != normalized)];
    if (next.length > maxEntries) {
      next.removeRange(maxEntries, next.length);
    }
    await _store.write(historyKey, jsonEncode(next));
    return true;
  }

  Future<void> clearHistory() => _store.delete(historyKey);
}
