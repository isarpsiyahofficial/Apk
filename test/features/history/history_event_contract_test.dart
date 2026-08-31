import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_life/features/history/data/pre_islam_world_context.dart';
import 'package:islamic_life/features/history/domain/history_event_contract.dart';

const _text = LocalizedHistorySummary(tr: 'TR', en: 'EN', ar: 'AR');
const _person = HistoryPersonRef(id: 'person', name: _text);
const _place = HistoryGeographyRef(
  id: 'place',
  label: _text,
  precision: HistoryGeographyPrecision.approximate,
);

HistoryEventRecord buildEvent({
  String id = 'event',
  int startYearCe = 622,
  int endYearCe = 622,
  HistoryDateCertainty certainty = HistoryDateCertainty.exact,
  LocalizedHistorySummary dateCaveat = _text,
  LocalizedHistorySummary beforeContext = _text,
  List<LocalizedHistorySummary> causes = const [_text],
  List<LocalizedHistorySummary> consequences = const [_text],
  List<HistoryPersonRef> people = const [_person],
  List<HistoryGeographyRef> geographies = const [_place],
  List<String> sourceIds = const ['source_a'],
  Set<String> knownSourceIds = const {'source_a', 'source_b'},
  HistoryResearchStatus status = HistoryResearchStatus.researchDraft,
}) {
  return HistoryEventRecord.validated(
    id: id,
    title: _text,
    startYearCe: startYearCe,
    endYearCe: endYearCe,
    dateCertainty: certainty,
    dateCaveat: dateCaveat,
    beforeContext: beforeContext,
    causes: causes,
    consequences: consequences,
    people: people,
    geographies: geographies,
    sourceIds: sourceIds,
    knownSourceIds: knownSourceIds,
    status: status,
  );
}

void main() {
  group('T0220 history event contract', () {
    test('accepts a complete event with every required field', () {
      final event = buildEvent();
      expect(event.id, 'event');
      expect(event.dateCertainty, HistoryDateCertainty.exact);
      expect(event.causes, hasLength(1));
      expect(event.consequences, hasLength(1));
      expect(event.people, hasLength(1));
      expect(event.geographies.single.precision, HistoryGeographyPrecision.approximate);
      expect(event.sourceIds, ['source_a']);
    });

    test('rejects reversed event date ranges', () {
      expect(() => buildEvent(startYearCe: 623, endYearCe: 622), throwsStateError);
    });

    test('rejects missing before-context, cause and consequence evidence', () {
      expect(
        () => buildEvent(beforeContext: const LocalizedHistorySummary(tr: '', en: 'EN', ar: 'AR')),
        throwsStateError,
      );
      expect(() => buildEvent(causes: const []), throwsStateError);
      expect(() => buildEvent(consequences: const []), throwsStateError);
    });

    test('rejects missing people or geography', () {
      expect(() => buildEvent(people: const []), throwsStateError);
      expect(() => buildEvent(geographies: const []), throwsStateError);
    });

    test('rejects incomplete TR/EN/AR cause or certainty caveat', () {
      const incomplete = LocalizedHistorySummary(tr: 'TR', en: 'EN', ar: '');
      expect(() => buildEvent(causes: const [incomplete]), throwsStateError);
      expect(() => buildEvent(dateCaveat: incomplete), throwsStateError);
    });

    test('rejects unknown, duplicate or blank source references', () {
      expect(() => buildEvent(sourceIds: const ['missing']), throwsStateError);
      expect(() => buildEvent(sourceIds: const ['source_a', 'source_a']), throwsStateError);
      expect(() => buildEvent(sourceIds: const ['']), throwsStateError);
    });

    test('unknown date certainty cannot be promoted to production', () {
      expect(
        () => buildEvent(
          certainty: HistoryDateCertainty.unknown,
          status: HistoryResearchStatus.reviewedForProduction,
        ),
        throwsStateError,
      );
    });

    test('dataset rejects duplicate event identities and separates production records', () {
      final draft = buildEvent(id: 'draft');
      final production = buildEvent(
        id: 'production',
        status: HistoryResearchStatus.reviewedForProduction,
      );
      final dataset = HistoryEventContractDataset.validated([draft, production]);
      expect(dataset.productionEvents.map((e) => e.id), ['production']);
      expect(
        () => HistoryEventContractDataset.validated([draft, buildEvent(id: 'draft')]),
        throwsStateError,
      );
    });
  });
}
