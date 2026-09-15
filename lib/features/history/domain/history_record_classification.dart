import '../data/islamic_history_horizontal_themes.dart';
import '../data/pre_islam_world_context.dart';

enum HistoryRecordKind { event, backgroundContext, horizontalTheme }

class HistoryRecordClassification {
  const HistoryRecordClassification({
    required this.id,
    required this.originTask,
    required this.kind,
    required this.rationale,
  });

  final String id;
  final String originTask;
  final HistoryRecordKind kind;
  final LocalizedHistorySummary rationale;

  bool get isComplete =>
      id.trim().isNotEmpty && originTask.trim().isNotEmpty && rationale.isComplete;
}

class HistoryNonEventClassificationDataset {
  HistoryNonEventClassificationDataset._(this.records);

  factory HistoryNonEventClassificationDataset.validated({
    required List<HistoryRecordClassification> records,
    required Set<String> expectedT0211Ids,
    required Set<String> expectedT0219Ids,
  }) {
    final ids = <String>{};
    for (final record in records) {
      if (!record.isComplete || !ids.add(record.id)) {
        throw StateError('History non-event classification requires unique, complete records.');
      }
      if (record.kind == HistoryRecordKind.event) {
        throw StateError('T0211/T0219 non-event registry must not classify records as events.');
      }
      if (record.originTask == 'T0211' && record.kind != HistoryRecordKind.backgroundContext) {
        throw StateError('T0211 records must remain background context.');
      }
      if (record.originTask == 'T0219' && record.kind != HistoryRecordKind.horizontalTheme) {
        throw StateError('T0219 records must remain horizontal themes.');
      }
    }

    final t0211Ids = records
        .where((record) => record.originTask == 'T0211')
        .map((record) => record.id)
        .toSet();
    final t0219Ids = records
        .where((record) => record.originTask == 'T0219')
        .map((record) => record.id)
        .toSet();

    if (t0211Ids.length != expectedT0211Ids.length ||
        !t0211Ids.containsAll(expectedT0211Ids) ||
        !expectedT0211Ids.containsAll(t0211Ids)) {
      throw StateError('T0211 context classification must cover the canonical dataset 1:1.');
    }
    if (t0219Ids.length != expectedT0219Ids.length ||
        !t0219Ids.containsAll(expectedT0219Ids) ||
        !expectedT0219Ids.containsAll(t0219Ids)) {
      throw StateError('T0219 theme classification must cover the canonical dataset 1:1.');
    }

    return HistoryNonEventClassificationDataset._(List.unmodifiable(records));
  }

  final List<HistoryRecordClassification> records;

  Set<String> get ids => records.map((record) => record.id).toSet();
}

const _backgroundRationale = LocalizedHistorySummary(
  tr: 'Bu kayıt tekil bir olay değil, İslam öncesi dünyayı açıklayan tarihsel bağlamdır; T0220 olay sözleşmesi için yapay tarih, neden veya kişi üretilmez.',
  en: 'This record is historical background rather than a discrete event; no artificial date, cause or person is manufactured to force it into the T0220 event contract.',
  ar: 'هذا السجل سياق تاريخي وليس حدثًا منفردًا؛ لذلك لا تُنشأ تواريخ أو أسباب أو أشخاص مصطنعة لإدخاله قسرًا في عقد أحداث T0220.',
);

const _horizontalThemeRationale = LocalizedHistorySummary(
  tr: 'Bu kayıt farklı dönem ve bölgeleri kesen yatay bir tarih temasıdır; öğretici tarih aralığı tek bir olayın başlangıç ve bitiş tarihi sayılmaz.',
  en: 'This record is a horizontal historical theme spanning periods and regions; its pedagogical range is not treated as the start and end of one event.',
  ar: 'هذا السجل موضوع تاريخي أفقي يمتد عبر فترات ومناطق متعددة؛ ولا يُعامل نطاقه التعليمي كبداية ونهاية لحدث واحد.',
);

final historyNonEventClassificationT0220 = HistoryNonEventClassificationDataset.validated(
  expectedT0211Ids: preIslamWorldResearchEntries.map((entry) => entry.id).toSet(),
  expectedT0219Ids: islamicHistoryT0219Entries.map((entry) => entry.id).toSet(),
  records: <HistoryRecordClassification>[
    ...preIslamWorldResearchEntries.map(
      (entry) => HistoryRecordClassification(
        id: entry.id,
        originTask: 'T0211',
        kind: HistoryRecordKind.backgroundContext,
        rationale: _backgroundRationale,
      ),
    ),
    ...islamicHistoryT0219Entries.map(
      (entry) => HistoryRecordClassification(
        id: entry.id,
        originTask: 'T0219',
        kind: HistoryRecordKind.horizontalTheme,
        rationale: _horizontalThemeRationale,
      ),
    ),
  ],
);