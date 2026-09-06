import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_deep_link_authorization_t0202.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_deep_link_execution.dart';

void main() {
  group('ProphetDeepLinkExecutor', () {
    test('dispatches Quran verse with exact prophet/surah/ayah', () async {
      String? capturedProphetId;
      int? capturedSurah;
      int? capturedAyah;
      final executor = ProphetDeepLinkExecutor(
        ProphetDeepLinkExecutionHandlers(
          openQuranVerse: ({
            required String prophetId,
            required int surah,
            required int ayah,
          }) async {
            capturedProphetId = prophetId;
            capturedSurah = surah;
            capturedAyah = ayah;
          },
        ),
      );

      final result = await executor.execute(
        ProphetDeepLink.quranVerse(
          prophetId: 'adam',
          verse: const ProphetVerseReference(surah: 7, ayah: 23),
        ),
      );

      expect(result.executed, isTrue);
      expect(result.failure, isNull);
      expect(capturedProphetId, 'adam');
      expect(capturedSurah, 7);
      expect(capturedAyah, 23);
    });

    test('dispatches dua/history/map target IDs without rewriting them', () async {
      final calls = <String>[];
      final executor = ProphetDeepLinkExecutor(
        ProphetDeepLinkExecutionHandlers(
          openDua: ({required prophetId, required targetId}) async {
            calls.add('dua:$prophetId:$targetId');
          },
          openIslamicHistory: ({required prophetId, required targetId}) async {
            calls.add('history:$prophetId:$targetId');
          },
          openMap: ({required prophetId, required targetId}) async {
            calls.add('map:$prophetId:$targetId');
          },
        ),
      );

      expect(
        (await executor.execute(
          ProphetDeepLink.dua(prophetId: 'yunus', duaId: 'dua-yunus-21-87'),
        ))
            .executed,
        isTrue,
      );
      expect(
        (await executor.execute(
          ProphetDeepLink.islamicHistory(
            prophetId: 'muhammad',
            historyEventId: 'hijrah-622',
          ),
        ))
            .executed,
        isTrue,
      );
      expect(
        (await executor.execute(
          ProphetDeepLink.map(
            prophetId: 'musa',
            mapLocationId: 'sinai-reviewed-1',
          ),
        ))
            .executed,
        isTrue,
      );

      expect(calls, <String>[
        'dua:yunus:dua-yunus-21-87',
        'history:muhammad:hijrah-622',
        'map:musa:sinai-reviewed-1',
      ]);
    });

    test('fails closed when destination adapter is unavailable', () async {
      const executor = ProphetDeepLinkExecutor(
        ProphetDeepLinkExecutionHandlers(),
      );

      final history = await executor.execute(
        ProphetDeepLink.islamicHistory(
          prophetId: 'muhammad',
          historyEventId: 'reviewed-event',
        ),
      );
      final map = await executor.execute(
        ProphetDeepLink.map(
          prophetId: 'musa',
          mapLocationId: 'reviewed-location',
        ),
      );

      expect(history.executed, isFalse);
      expect(
        history.failure,
        ProphetDeepLinkExecutionFailure.unavailableDestination,
      );
      expect(map.executed, isFalse);
      expect(
        map.failure,
        ProphetDeepLinkExecutionFailure.unavailableDestination,
      );
    });

    test('authorization rejects cross-prophet target before handler runs', () async {
      var calls = 0;
      final authorization = ProphetDeepLinkAuthorization(const [
        ProphetDeepLinkBundle(
          prophetId: 'ibrahim',
          quranReferences: <ProphetVerseReference>[
            ProphetVerseReference(surah: 14, ayah: 35),
          ],
          duaReferences: <ProphetDuaReference>[
            ProphetDuaReference(duaId: 'dua-ibrahim-14-35'),
          ],
          historyEventIds: <String>['history-ibrahim-kaaba'],
          mapLocationIds: <String>['map-ibrahim-mecca-approx'],
        ),
        ProphetDeepLinkBundle(
          prophetId: 'musa',
          quranReferences: <ProphetVerseReference>[
            ProphetVerseReference(surah: 20, ayah: 25),
          ],
          duaReferences: <ProphetDuaReference>[],
        ),
      ]);
      final executor = ProphetDeepLinkExecutor(
        ProphetDeepLinkExecutionHandlers(
          openIslamicHistory: ({required prophetId, required targetId}) async {
            calls++;
          },
        ),
        authorization: authorization,
      );

      final result = await executor.execute(
        ProphetDeepLink.islamicHistory(
          prophetId: 'musa',
          historyEventId: 'history-ibrahim-kaaba',
        ),
      );

      expect(result.executed, isFalse);
      expect(
        result.failure,
        ProphetDeepLinkExecutionFailure.unauthorizedTarget,
      );
      expect(calls, 0);
    });

    test('rejects malformed or foreign URI before any handler runs', () async {
      var calls = 0;
      final executor = ProphetDeepLinkExecutor(
        ProphetDeepLinkExecutionHandlers(
          openQuranVerse: ({
            required String prophetId,
            required int surah,
            required int ayah,
          }) async {
            calls++;
          },
        ),
      );

      final foreign = await executor.executeUri(
        Uri.parse('https://example.com/quran/verse/7/23?prophet=adam'),
      );
      final malformed = await executor.executeUri(
        Uri.parse('islami-hayat://quran/verse/0/0?prophet=adam'),
      );

      expect(foreign.executed, isFalse);
      expect(foreign.failure, ProphetDeepLinkExecutionFailure.invalidLink);
      expect(malformed.executed, isFalse);
      expect(malformed.failure, ProphetDeepLinkExecutionFailure.invalidLink);
      expect(calls, 0);
    });
  });
}