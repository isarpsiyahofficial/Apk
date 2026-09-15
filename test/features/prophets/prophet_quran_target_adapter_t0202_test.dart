import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_deep_link_authorization_t0202.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_quran_target_adapter_t0202.dart';

ProphetDeepLinkAuthorization _authorization({
  ProphetVerseReference verse = const ProphetVerseReference(surah: 7, ayah: 23),
}) =>
    ProphetDeepLinkAuthorization(<ProphetDeepLinkBundle>[
      ProphetDeepLinkBundle(
        prophetId: 'adam',
        quranReferences: <ProphetVerseReference>[verse],
        duaReferences: const <ProphetDuaReference>[],
      ),
    ]);

void main() {
  group('T0202 ProphetQuranTargetAdapter', () {
    test('opens exact authorized verse that exists in canonical Quran', () async {
      final adapter = ProphetQuranTargetAdapterT0202(_authorization());
      final link = ProphetDeepLink.quranVerse(
        prophetId: 'adam',
        verse: const ProphetVerseReference(surah: 7, ayah: 23),
      );
      ProphetVerseReference? opened;

      expect(adapter.canOpen(link), isTrue);
      expect(adapter.resolve(link)?.stableId, '7:23');
      expect(
        await adapter.open(link, onOpen: (verse) async => opened = verse),
        isTrue,
      );
      expect(opened?.stableId, '7:23');
    });

    test('valid Quran verse cannot be rebound to another prophet', () async {
      final adapter = ProphetQuranTargetAdapterT0202(_authorization());
      final rebound = ProphetDeepLink.quranVerse(
        prophetId: 'nuh',
        verse: const ProphetVerseReference(surah: 7, ayah: 23),
      );
      var called = false;

      expect(adapter.resolve(rebound), isNull);
      expect(
        await adapter.open(rebound, onOpen: (_) async => called = true),
        isFalse,
      );
      expect(called, isFalse);
    });

    test('syntactically valid but impossible ayah fails canonical structure gate', () {
      const impossible = ProphetVerseReference(surah: 2, ayah: 999);
      expect(impossible.isValid, isTrue, reason: 'legacy syntax gate is intentionally broad');
      final adapter = ProphetQuranTargetAdapterT0202(
        _authorization(verse: impossible),
      );
      final link = ProphetDeepLink.quranVerse(
        prophetId: 'adam',
        verse: impossible,
      );

      expect(link.isValid, isTrue);
      expect(adapter.resolve(link), isNull);
      expect(adapter.canOpen(link), isFalse);
    });

    test('authorized target mismatch fails closed', () {
      final adapter = ProphetQuranTargetAdapterT0202(_authorization());
      final differentVerse = ProphetDeepLink.quranVerse(
        prophetId: 'adam',
        verse: const ProphetVerseReference(surah: 2, ayah: 255),
      );

      expect(adapter.resolve(differentVerse), isNull);
    });

    test('non-Quran target is rejected before lookup', () {
      final adapter = ProphetQuranTargetAdapterT0202(_authorization());
      final dua = ProphetDeepLink.dua(prophetId: 'adam', duaId: 'adam-q7-23');

      expect(adapter.resolve(dua), isNull);
    });
  });
}
