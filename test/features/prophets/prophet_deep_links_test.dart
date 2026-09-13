import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';

void main() {
  group('T0202 prophet deep-link contract', () {
    test('builds all four typed targets and round-trips them', () {
      const bundle = ProphetDeepLinkBundle(
        prophetId: 'ibrahim',
        quranReferences: <ProphetVerseReference>[
          ProphetVerseReference(surah: 14, ayah: 35),
        ],
        duaReferences: <ProphetDuaReference>[
          ProphetDuaReference(duaId: 'prophet-ibrahim-14-35'),
        ],
        historyEventIds: <String>['history-ibrahim-kaaba'],
        mapLocationIds: <String>['prophet-ibrahim-mecca-approx'],
      );

      expect(bundle.audit(), isEmpty);
      final links = bundle.buildLinks();
      expect(
        links.map((link) => link.kind).toSet(),
        ProphetDeepLinkKind.values.toSet(),
      );
      for (final link in links) {
        final parsed = parseProphetDeepLink(link.uri);
        expect(parsed, isNotNull, reason: link.uri.toString());
        expect(parsed!.kind, link.kind);
        expect(parsed.prophetId, 'ibrahim');
        expect(parsed.targetId, link.targetId);
      }
    });

    test('Quran route preserves exact surah and ayah without guessing', () {
      final link = ProphetDeepLink.quranVerse(
        prophetId: 'musa',
        verse: const ProphetVerseReference(surah: 20, ayah: 25),
      );
      expect(link.isValid, isTrue);
      expect(link.uri.toString(),
          'islami-hayat://quran/verse/20/25?prophet=musa');
      final parsed = parseProphetDeepLink(link.uri)!;
      expect(parsed.surah, 20);
      expect(parsed.ayah, 25);
      expect(parsed.targetId, '20:25');
    });

    test('reserved characters in reviewed target IDs remain URI-safe', () {
      final link = ProphetDeepLink.dua(
        prophetId: 'yunus',
        duaId: 'dua/yunus:21:87',
      );
      final parsed = parseProphetDeepLink(link.uri);
      expect(parsed, isNotNull);
      expect(parsed!.targetId, 'dua/yunus:21:87');
    });

    test('missing history or map review IDs never invents a target', () {
      const bundle = ProphetDeepLinkBundle(
        prophetId: 'isa',
        quranReferences: <ProphetVerseReference>[
          ProphetVerseReference(surah: 3, ayah: 49),
        ],
        duaReferences: <ProphetDuaReference>[],
      );
      final links = bundle.buildLinks();
      expect(
        links.where((link) => link.kind == ProphetDeepLinkKind.islamicHistory),
        isEmpty,
      );
      expect(
        links.where((link) => link.kind == ProphetDeepLinkKind.map),
        isEmpty,
      );
    });

    test('invalid or duplicate source targets fail closed before navigation', () {
      const bundle = ProphetDeepLinkBundle(
        prophetId: 'nuh',
        quranReferences: <ProphetVerseReference>[
          ProphetVerseReference(surah: 11, ayah: 44),
          ProphetVerseReference(surah: 11, ayah: 44),
        ],
        duaReferences: <ProphetDuaReference>[
          ProphetDuaReference(duaId: ''),
        ],
        historyEventIds: <String>['history-nuh', 'history-nuh'],
        mapLocationIds: <String>[''],
      );
      expect(bundle.audit(), contains('duplicate Quran target'));
      expect(bundle.audit(), contains('invalid dua reference'));
      expect(bundle.audit(), contains('duplicate history target'));
      expect(bundle.audit(), contains('invalid map location id'));
      expect(bundle.buildLinks, throwsStateError);
    });

    test('parser rejects foreign schemes hosts malformed verses and missing prophet', () {
      expect(parseProphetDeepLink(Uri.parse('https://quran/verse/2/31?prophet=adam')),
          isNull);
      expect(parseProphetDeepLink(Uri.parse('islami-hayat://unknown/x?prophet=adam')),
          isNull);
      expect(parseProphetDeepLink(Uri.parse('islami-hayat://quran/verse/115/1?prophet=adam')),
          isNull);
      expect(parseProphetDeepLink(Uri.parse('islami-hayat://quran/verse/2/0?prophet=adam')),
          isNull);
      expect(parseProphetDeepLink(Uri.parse('islami-hayat://quran/verse/2/31')),
          isNull);
    });
  });
}
