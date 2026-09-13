import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';
import 'package:islami_hayat/features/history/domain/history_t0337_audit.dart';

LocalizedHistorySummary _text([String value = 'reviewed']) =>
    LocalizedHistorySummary(tr: value, en: value, ar: value);

HistoryEventRecord _event({
  String id = 'event-1',
  List<String> sourceIds = const ['source-a', 'source-b'],
  HistoryDateCertainty certainty = HistoryDateCertainty.approximate,
  int? startYear = 700,
  int? endYear = 701,
}) {
  return HistoryEventRecord.validated(
    id: id,
    title: _text('event'),
    startYearCe: startYear,
    endYearCe: endYear,
    dateCertainty: certainty,
    dateCaveat: _text('certainty caveat'),
    beforeContext: _text('before'),
    causes: [_text('cause')],
    consequences: [_text('consequence')],
    people: [HistoryPersonRef(id: 'person', name: _text('person'))],
    geographies: [
      HistoryGeographyRef(
        id: 'region',
        label: _text('region'),
        precision: HistoryGeographyPrecision.regional,
      ),
    ],
    sourceIds: sourceIds,
    knownSourceIds: sourceIds.toSet(),
    status: HistoryResearchStatus.researchDraft,
  );
}

const _independentSources = [
  HistoryT0337SourceIdentity(
    sourceId: 'source-a',
    independenceFamily: 'work-a',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'source-b',
    independenceFamily: 'work-b',
  ),
];

void main() {
  test('accepts two explicitly independent source families', () {
    final result = HistoryT0337Audit.validate(
      events: [_event()],
      sourceIdentities: _independentSources,
    );

    expect(result.eventCount, 1);
    expect(result.contestedEventCount, 0);
  });

  test('same underlying work cannot masquerade as two sources', () {
    const aliasesOfOneWork = [
      HistoryT0337SourceIdentity(
        sourceId: 'source-a',
        independenceFamily: 'same-work',
      ),
      HistoryT0337SourceIdentity(
        sourceId: 'source-b',
        independenceFamily: 'same-work',
      ),
    ];

    expect(
      () => HistoryT0337Audit.validate(
        events: [_event()],
        sourceIdentities: aliasesOfOneWork,
      ),
      throwsStateError,
    );
  });

  test('unmapped bibliography row fails closed', () {
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event()],
        sourceIdentities: _independentSources.take(1).toList(),
      ),
      throwsStateError,
    );
  });

  test('a single cited source never satisfies the double-source gate', () {
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event(sourceIds: const ['source-a'])],
        sourceIdentities: _independentSources,
      ),
      throwsStateError,
    );
  });

  test('reviewed event-scoped corroboration may provide a second family', () {
    final result = HistoryT0337Audit.validate(
      events: [_event(sourceIds: const ['source-a'])],
      sourceIdentities: _independentSources,
      corroborations: const [
        HistoryT0337Corroboration(
          eventId: 'event-1',
          sourceId: 'source-b',
          locator: 'Exact reviewed locator',
        ),
      ],
    );

    expect(result.eventCount, 1);
  });

  test('corroboration cannot target an event outside the current audit', () {
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event(sourceIds: const ['source-a'])],
        sourceIdentities: _independentSources,
        corroborations: const [
          HistoryT0337Corroboration(
            eventId: 'different-event',
            sourceId: 'source-b',
            locator: 'Exact reviewed locator',
          ),
        ],
      ),
      throwsStateError,
    );
  });

  test('corroboration requires a mapped distinct source and exact locator', () {
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event(sourceIds: const ['source-a'])],
        sourceIdentities: _independentSources,
        corroborations: const [
          HistoryT0337Corroboration(
            eventId: 'event-1',
            sourceId: 'source-a',
            locator: 'Same source cannot be counted twice',
          ),
        ],
      ),
      throwsStateError,
    );
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event(sourceIds: const ['source-a'])],
        sourceIdentities: _independentSources,
        corroborations: const [
          HistoryT0337Corroboration(
            eventId: 'event-1',
            sourceId: 'source-b',
            locator: ' ',
          ),
        ],
      ),
      throwsStateError,
    );
  });

  test('contested event stays explicitly contested and disclosed', () {
    final result = HistoryT0337Audit.validate(
      events: [
        _event(
          certainty: HistoryDateCertainty.contested,
          startYear: 656,
          endYear: 661,
        ),
      ],
      sourceIdentities: _independentSources,
    );

    expect(result.contestedEventCount, 1);
  });

  test('duplicate event IDs fail closed', () {
    expect(
      () => HistoryT0337Audit.validate(
        events: [_event(), _event()],
        sourceIdentities: _independentSources,
      ),
      throwsStateError,
    );
  });
}
