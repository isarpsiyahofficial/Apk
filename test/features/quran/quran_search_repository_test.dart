import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranSearchRepository', () {
    final repository = QuranSearchRepository();

    test('parses only canonical surah:ayah addresses', () {
      final address = repository.parseAddress(' 2 : 255 ');
      expect(address, isNotNull);
      expect(address!.surah, 2);
      expect(address.ayah, 255);
      expect(address.key, '2:255');

      expect(repository.parseAddress('2:287'), isNull);
      expect(repository.parseAddress('115:1'), isNull);
      expect(repository.parseAddress('2-255'), isNull);
      expect(repository.parseAddress('Bakara 255'), isNull);
    });

    test('direct address returns exact verified verse with selected meal', () async {
      final results = await repository.search(
        languageCode: 'en',
        query: '2:255',
      );

      expect(results, hasLength(1));
      expect(results.single.key, '2:255');
      expect(results.single.surahDisplayName, 'Al-Baqara');
      expect(results.single.arabic, isNotEmpty);
      expect(results.single.translation, isNotNull);
      expect(results.single.translation, isNotEmpty);
    });

    test('Turkish sura-name search tolerates common local spelling', () async {
      final bakara = await repository.search(
        languageCode: 'tr',
        query: 'Bakara',
        limit: 5,
      );
      expect(bakara, isNotEmpty);
      expect(bakara.first.key, '2:1');
      expect(bakara.first.surahDisplayName, 'Al-Baqara');

      final fatiha = await repository.search(
        languageCode: 'tr',
        query: 'Fatiha',
        limit: 5,
      );
      expect(fatiha, isNotEmpty);
      expect(fatiha.first.key, '1:1');

      final yasin = await repository.search(
        languageCode: 'tr',
        query: 'Yasin',
        limit: 5,
      );
      expect(yasin, isNotEmpty);
      expect(yasin.first.key, '36:1');
    });

    test('Arabic sura-name search uses verified Arabic metadata', () async {
      final results = await repository.search(
        languageCode: 'ar',
        query: 'البقرة',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(results.first.key, '2:1');
      expect(results.first.surahDisplayName, 'البقرة');
      expect(results.first.translation, isNull);
    });

    test('English transliterated sura-name search opens its first ayah', () async {
      final results = await repository.search(
        languageCode: 'en',
        query: 'Al-Baqara',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(results.first.key, '2:1');
      expect(results.first.surahDisplayName, 'Al-Baqara');
    });

    test('Turkish keyword search uses the verified bundled meal locally', () async {
      final results = await repository.search(
        languageCode: 'tr',
        query: 'ALLAH',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
      for (final result in results) {
        expect(result.translation, isNotNull);
        expect(result.translation!.toLowerCase(), contains('allah'));
      }
    });

    test('Arabic search ignores Quranic marks without changing source text', () async {
      final results = await repository.search(
        languageCode: 'ar',
        query: 'الله',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
      for (final result in results) {
        expect(result.arabic, isNotEmpty);
        expect(result.translation, isNull);
      }
    });

    test('empty query returns no result and unsupported locale fails closed', () async {
      expect(
        await repository.search(languageCode: 'tr', query: '   '),
        isEmpty,
      );
      expect(
        () => repository.search(languageCode: 'de', query: 'Allah'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
