import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/domain/muhammad_history_seerah_bridge.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_timeline.dart';

void main() {
  group('MuhammadHistorySeerahBridge T0212', () {
    test('canonical history timeline is a 1:1 projection of canonical seerah', () {
      final bridge = canonicalMuhammadHistorySeerahBridge;

      expect(bridge.links.length, muhammadSeerahT0201Events.length);

      for (var index = 0; index < muhammadSeerahT0201Events.length; index++) {
        final seerah = muhammadSeerahT0201Events[index];
        final history = bridge.links[index];

        expect(history.historyEventId, 'history:${seerah.id}');
        expect(history.seerahEventId, seerah.id);
        expect(history.order, seerah.order);
        expect(history.phase, seerah.phase);
        expect(bridge.resolveSeerahEvent(history.historyEventId), same(seerah));
      }
    });

    test('rejects duplicate seerah ids and orders', () {
      final first = muhammadSeerahT0201Events.first;

      expect(
        () => MuhammadHistorySeerahBridge.validated([first, first]),
        throwsStateError,
      );
    });

    test('rejects chronology drift from the seerah ordering', () {
      final first = muhammadSeerahT0201Events.first;
      final second = muhammadSeerahT0201Events[1];

      expect(
        () => MuhammadHistorySeerahBridge.validated([second, first]),
        throwsStateError,
      );
    });

    test('rejects empty timelines and unknown history ids', () {
      expect(
        () => MuhammadHistorySeerahBridge.validated(const []),
        throwsStateError,
      );

      expect(
        () => canonicalMuhammadHistorySeerahBridge
            .resolveSeerahEvent('history:missing-event'),
        throwsStateError,
      );
    });
  });
}
