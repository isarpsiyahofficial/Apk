import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/biography_timeline_link_t0222.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_history_target_adapter_t0202.dart';

const _text = LocalizedHistorySummary(tr: 'Test', en: 'Test', ar: 'اختبار');

HistoryEventRecord _reviewedMuhammadEvent() => HistoryEventRecord.validated(
      id: 'history-reviewed-muhammad-event',
      title: _text,
      startYearCe: 622,
      endYearCe: 622,
      dateCertainty: HistoryDateCertainty.exact,
      dateCaveat: _text,
      beforeContext: _text,
      causes: const <LocalizedHistorySummary>[_text],
      consequences: const <LocalizedHistorySummary>[_text],
      people: const <HistoryPersonRef>[
        HistoryPersonRef(id: 'prophet:muhammad', name: _text),
      ],
      geographies: const <HistoryGeographyRef>[
        HistoryGeographyRef(
          id: 'city:medina',
          label: _text,
          precision: HistoryGeographyPrecision.regional,
        ),
      ],
      sourceIds: const <String>['source-reviewed'],
      knownSourceIds: const <String>{'source-reviewed'},
      status: HistoryResearchStatus.reviewedForProduction,
    );

void main() {
  group('T0202 ProphetHistoryTargetAdapter', () {
    test('opens only exact reviewed event joined to the same prophet', () async {
      final event = _reviewedMuhammadEvent();
      final index = HistoryBiographyTimelineIndexT0222.validated(
        entries: const <HistoryBiographyTimelineEntryT0222>[
          HistoryBiographyTimelineEntryT0222(
            biographyId: 'prophet:muhammad',
            personId: 'prophet:muhammad',
            relatedEventIds: <String>['history-reviewed-muhammad-event'],
          ),
        ],
        events: <HistoryEventRecord>[event],
      );
      final adapter = ProphetHistoryTargetAdapterT0202(index);
      final link = ProphetDeepLink.islamicHistory(
        prophetId: 'muhammad',
        historyEventId: event.id,
      );

      final resolved = adapter.resolve(link);
      expect(resolved, same(event));
      expect(resolved!.status, HistoryResearchStatus.reviewedForProduction);

      String? openedId;
      final opened = await adapter.open(
        link,
        onOpen: (value) async => openedId = value.id,
      );
      expect(opened, isTrue);
      expect(openedId, event.id);
    });

    test('current research-draft Muhammad history does not open as production', () {
      final adapter = ProphetHistoryTargetAdapterT0202(
        historyBiographyTimelineT0222,
      );
      final relation = historyBiographyTimelineT0222.requireBiography(
        'prophet:muhammad',
      );
      expect(relation.relatedEventIds, isNotEmpty);
      final link = ProphetDeepLink.islamicHistory(
        prophetId: 'muhammad',
        historyEventId: relation.relatedEventIds.first,
      );
      expect(adapter.resolve(link), isNull);
      expect(adapter.canOpen(link), isFalse);
    });

    test('cross-prophet rebinding of a valid history ID fails closed', () {
      final event = _reviewedMuhammadEvent();
      final index = HistoryBiographyTimelineIndexT0222.validated(
        entries: const <HistoryBiographyTimelineEntryT0222>[
          HistoryBiographyTimelineEntryT0222(
            biographyId: 'prophet:muhammad',
            personId: 'prophet:muhammad',
            relatedEventIds: <String>['history-reviewed-muhammad-event'],
          ),
        ],
        events: <HistoryEventRecord>[event],
      );
      final adapter = ProphetHistoryTargetAdapterT0202(index);
      final rebound = ProphetDeepLink.islamicHistory(
        prophetId: 'isa',
        historyEventId: event.id,
      );

      expect(adapter.resolve(rebound), isNull);
      expect(adapter.canOpen(rebound), isFalse);
    });

    test('unknown history target never falls back to title or fuzzy lookup', () {
      final adapter = ProphetHistoryTargetAdapterT0202(
        historyBiographyTimelineT0222,
      );
      final unknown = ProphetDeepLink.islamicHistory(
        prophetId: 'muhammad',
        historyEventId: 'not-a-reviewed-history-event',
      );
      expect(adapter.resolve(unknown), isNull);
    });
  });
}
