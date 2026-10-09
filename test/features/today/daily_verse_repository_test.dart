import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyVerseRepository', () {
    final repository = DailyVerseRepository();

    test('pool is unique and every address is canonical', () {
      expect(validateDailyVersePool, returnsNormally);
      final keys = dailyVersePool.map((address) => address.key).toSet();
      expect(keys, hasLength(dailyVersePool.length));
      for (final address in dailyVersePool) {
        expect(address.surah, inInclusiveRange(1, canonicalQuranSuraCount));
        expect(
          address.ayah,
          inInclusiveRange(1, canonicalQuranAyahCountForSura(address.surah)),
        );
      }
    });

    test('same civil date always selects the same verified verse', () async {
      final morning = await repository.forDate(
        date: DateTime(2026, 8, 28, 0, 1),
        languageCode: 'tr',
      );
      final evening = await repository.forDate(
        date: DateTime(2026, 8, 28, 23, 59, 59),
        languageCode: 'tr',
      );

      expect(evening.address.key, morning.address.key);
      expect(evening.arabic, morning.arabic);
      expect(evening.translation, morning.translation);
    });

    test('next civil date advances deterministically within the pool', () async {
      final first = await repository.forDate(
        date: DateTime(2026, 8, 28),
        languageCode: 'tr',
      );
      final next = await repository.forDate(
        date: DateTime(2026, 8, 29),
        languageCode: 'tr',
      );

      expect(next.address.key, isNot(first.address.key));
    });

    test('TR and EN use bundled verified meal while AR stays canonical Arabic only', () async {
      final date = DateTime(2026, 8, 28);
      final tr = await repository.forDate(date: date, languageCode: 'tr');
      final en = await repository.forDate(date: date, languageCode: 'en');
      final ar = await repository.forDate(date: date, languageCode: 'ar');

      expect(tr.address.key, en.address.key);
      expect(tr.address.key, ar.address.key);
      expect(tr.arabic, isNotEmpty);
      expect(tr.translation, isNotNull);
      expect(tr.translation, isNotEmpty);
      expect(en.translation, isNotNull);
      expect(en.translation, isNotEmpty);
      expect(ar.translation, isNull);
      expect(ar.surahDisplayName, isNotEmpty);
    });

    test('unsupported locale fails closed', () {
      expect(
        () => repository.forDate(
          date: DateTime(2026, 8, 28),
          languageCode: 'de',
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
