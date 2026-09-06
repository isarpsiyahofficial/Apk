import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/biography_timeline_link_t0222.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_history_target_adapter_t0202.dart';

void main() {
  group('T0202 ProphetHistoryTargetAdapter', () {
    final adapter = ProphetHistoryTargetAdapterT0202(
      historyBiographyTimelineT0222,
    );
    final muhammadRelation = historyBiographyTimelineT0222.requireBiography(
      'prophet:muhammad',
    );

    test('opens only exact reviewed event joined to the same prophet', () async {
      expect(muhammadRelation.relatedEventIds, isNotEmpty);
      final eventId = muhammadRelation.relatedEventIds.first;
      final link = ProphetDeepLink.islamicHistory(
        prophetId: 'muhammad',
        historyEventId: eventId,
      );

      final resolved = adapter.resolve(link);
      expect(resolved, isNotNull);
      expect(resolved!.id, eventId);
      expect(resolved.status, HistoryResearchStatus.reviewedForProduction);

      String? openedId;
      final opened = await adapter.open(
        link,
        onOpen: (event) async => openedId = event.id,
      );
      expect(opened, isTrue);
      expect(openedId, eventId);
    });

    test('cross-prophet rebinding of a valid history ID fails closed', () {
      expect(muhammadRelation.relatedEventIds, isNotEmpty);
      final eventId = muhammadRelation.relatedEventIds.first;
      final rebound = ProphetDeepLink.islamicHistory(
        prophetId: 'isa',
        historyEventId: eventId,
      );

      expect(adapter.resolve(rebound), isNull);
      expect(adapter.canOpen(rebound), isFalse);
    });

    test('unknown history target never falls back to title or fuzzy lookup', () {
      final unknown = ProphetDeepLink.islamicHistory(
        prophetId: 'muhammad',
        historyEventId: 'not-a-reviewed-history-event',
      );
      expect(adapter.resolve(unknown), isNull);
    });

    test('non-history link is rejected before target lookup', () {
      final wrongKind = ProphetDeepLink.dua(
        prophetId: 'muhammad',
        duaId: muhammadRelation.relatedEventIds.first,
      );
      expect(adapter.resolve(wrongKind), isNull);
    });
  });
}
