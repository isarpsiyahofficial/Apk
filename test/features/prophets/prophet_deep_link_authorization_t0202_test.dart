import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_deep_link_authorization_t0202.dart';

void main() {
  const ibrahim = ProphetDeepLinkBundle(
    prophetId: 'ibrahim',
    quranReferences: <ProphetVerseReference>[
      ProphetVerseReference(surah: 14, ayah: 35),
    ],
    duaReferences: <ProphetDuaReference>[
      ProphetDuaReference(duaId: 'dua-ibrahim-14-35'),
    ],
    historyEventIds: <String>['history-ibrahim-kaaba'],
    mapLocationIds: <String>['map-ibrahim-mecca-approx'],
  );
  const musa = ProphetDeepLinkBundle(
    prophetId: 'musa',
    quranReferences: <ProphetVerseReference>[
      ProphetVerseReference(surah: 20, ayah: 25),
    ],
    duaReferences: <ProphetDuaReference>[
      ProphetDuaReference(duaId: 'dua-musa-20-25'),
    ],
    historyEventIds: <String>['history-musa-exodus'],
    mapLocationIds: <String>['map-musa-sinai-approx'],
  );

  group('T0202 prophet deep-link authorization', () {
    test('authorizes only exact targets declared for the same prophet', () {
      final gate = ProphetDeepLinkAuthorization(const [ibrahim, musa]);

      expect(
        gate.authorizes(
          ProphetDeepLink.quranVerse(
            prophetId: 'ibrahim',
            verse: const ProphetVerseReference(surah: 14, ayah: 35),
          ),
        ),
        isTrue,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.dua(
            prophetId: 'ibrahim',
            duaId: 'dua-ibrahim-14-35',
          ),
        ),
        isTrue,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.islamicHistory(
            prophetId: 'ibrahim',
            historyEventId: 'history-ibrahim-kaaba',
          ),
        ),
        isTrue,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.map(
            prophetId: 'ibrahim',
            mapLocationId: 'map-ibrahim-mecca-approx',
          ),
        ),
        isTrue,
      );
    });

    test('rejects cross-prophet target rebinding for every destination kind', () {
      final gate = ProphetDeepLinkAuthorization(const [ibrahim, musa]);

      expect(
        gate.authorizes(
          ProphetDeepLink.quranVerse(
            prophetId: 'musa',
            verse: const ProphetVerseReference(surah: 14, ayah: 35),
          ),
        ),
        isFalse,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.dua(
            prophetId: 'musa',
            duaId: 'dua-ibrahim-14-35',
          ),
        ),
        isFalse,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.islamicHistory(
            prophetId: 'musa',
            historyEventId: 'history-ibrahim-kaaba',
          ),
        ),
        isFalse,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.map(
            prophetId: 'musa',
            mapLocationId: 'map-ibrahim-mecca-approx',
          ),
        ),
        isFalse,
      );
    });

    test('unknown prophet and unknown target stay fail-closed', () {
      final gate = ProphetDeepLinkAuthorization(const [ibrahim]);

      expect(
        gate.authorizes(
          ProphetDeepLink.dua(
            prophetId: 'unknown-prophet',
            duaId: 'dua-ibrahim-14-35',
          ),
        ),
        isFalse,
      );
      expect(
        gate.authorizes(
          ProphetDeepLink.map(
            prophetId: 'ibrahim',
            mapLocationId: 'unreviewed-map-target',
          ),
        ),
        isFalse,
      );
    });

    test('duplicate or invalid reviewed bundles are rejected at construction', () {
      expect(
        () => ProphetDeepLinkAuthorization(const [ibrahim, ibrahim]),
        throwsStateError,
      );
      expect(
        () => ProphetDeepLinkAuthorization(const [
          ProphetDeepLinkBundle(
            prophetId: 'nuh',
            quranReferences: <ProphetVerseReference>[],
            duaReferences: <ProphetDuaReference>[],
            historyEventIds: <String>[''],
          ),
        ]),
        throwsStateError,
      );
    });
  });
}