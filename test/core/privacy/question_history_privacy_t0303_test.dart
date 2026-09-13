import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/privacy/question_history_privacy_t0303.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

void main() {
  test('history is disabled by default and does not retain raw questions', () async {
    final store = _MemoryPrivateStore();
    final privacy = QuestionHistoryPrivacyT0303(store);

    expect(await privacy.isEnabled(), isFalse);
    expect(await privacy.recordQuestion('Borçlarım için hangi ayetler?'), isFalse);
    expect(store.values.containsKey(QuestionHistoryPrivacyT0303.historyKey), isFalse);
  });

  test('explicit opt-in records locally and clear history removes entries', () async {
    final store = _MemoryPrivateStore();
    final privacy = QuestionHistoryPrivacyT0303(store);

    await privacy.setEnabled(true);
    expect(await privacy.recordQuestion('  Sabır ile ilgili ayetler  '), isTrue);
    expect(await privacy.loadHistory(), <String>['Sabır ile ilgili ayetler']);

    await privacy.clearHistory();
    expect(await privacy.loadHistory(), isEmpty);
    expect(await privacy.isEnabled(), isTrue);
  });

  test('disabling history clears retained questions and blocks future writes', () async {
    final store = _MemoryPrivateStore();
    final privacy = QuestionHistoryPrivacyT0303(store);

    await privacy.setEnabled(true);
    await privacy.recordQuestion('Kaygı hakkında ayetler');
    await privacy.setEnabled(false);

    expect(await privacy.isEnabled(), isFalse);
    expect(await privacy.loadHistory(), isEmpty);
    expect(store.values.containsKey(QuestionHistoryPrivacyT0303.historyKey), isFalse);
    expect(await privacy.recordQuestion('Yeni hassas soru'), isFalse);
  });

  test('corrupt preference and corrupt history fail closed', () async {
    final store = _MemoryPrivateStore()
      ..values[QuestionHistoryPrivacyT0303.preferenceKey] = 'yes'
      ..values[QuestionHistoryPrivacyT0303.historyKey] = '{not-json';
    final privacy = QuestionHistoryPrivacyT0303(store);

    expect(await privacy.isEnabled(), isFalse);
    expect(await privacy.loadHistory(), isEmpty);
    expect(await privacy.recordQuestion('Kaydedilmemeli'), isFalse);

    await privacy.setEnabled(true);
    store.values[QuestionHistoryPrivacyT0303.historyKey] = '{not-json';
    expect(await privacy.loadHistory(), isEmpty);
  });

  test('history is bounded and duplicate questions are de-duplicated', () async {
    final store = _MemoryPrivateStore();
    final privacy = QuestionHistoryPrivacyT0303(store);
    await privacy.setEnabled(true);

    for (var i = 0; i < QuestionHistoryPrivacyT0303.maxEntries + 5; i++) {
      await privacy.recordQuestion('Soru $i');
    }
    await privacy.recordQuestion('Soru 50');

    final history = await privacy.loadHistory();
    expect(history.length, QuestionHistoryPrivacyT0303.maxEntries);
    expect(history.first, 'Soru 50');
    expect(history.where((q) => q == 'Soru 50').length, 1);
  });
}

final class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
