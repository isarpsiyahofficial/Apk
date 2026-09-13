import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/islamic_history_horizontal_themes.dart';
import 'package:islami_hayat/features/history/data/islamic_history_t0219_canonical.dart';

IslamicHistoryThemeEntry _copy(
  IslamicHistoryThemeEntry entry, {
  String? id,
  IslamicHistoryTheme? theme,
  List<String>? sourceIds,
}) {
  return IslamicHistoryThemeEntry(
    id: id ?? entry.id,
    theme: theme ?? entry.theme,
    title: entry.title,
    summary: entry.summary,
    startYearCe: entry.startYearCe,
    endYearCe: entry.endYearCe,
    certainty: entry.certainty,
    caveat: entry.caveat,
    sourceIds: sourceIds ?? entry.sourceIds,
    status: entry.status,
  );
}

void main() {
  group('T0219 canonical horizontal-theme gate', () {
    test('canonical dataset is exact and uses dedicated trade provenance', () {
      final dataset = islamicHistoryHorizontalThemesT0219Canonical;
      final trade = dataset.entries.singleWhere(
        (entry) => entry.id == 'trade_urbanization_history',
      );

      expect(dataset.entries, hasLength(9));
      expect(
        trade.sourceIds,
        containsAll(['lapidus_societies_horizontal', 'bessard_caliphs_merchants']),
      );
      expect(trade.sourceIds, isNot(contains('makdisi_rise_colleges')));
    });

    test('rejects an extra unreviewed horizontal-theme record', () {
      final science = islamicHistoryT0219CanonicalEntries.first;
      final extra = _copy(science, id: 'synthetic_extra_theme');

      expect(
        () => T0219CanonicalHorizontalThemeGate.validate(
          [...islamicHistoryT0219CanonicalEntries, extra],
        ),
        throwsStateError,
      );
    });

    test('rejects ID-to-theme swaps even when all nine themes remain present', () {
      final science = islamicHistoryT0219CanonicalEntries.singleWhere(
        (entry) => entry.id == 'science_history',
      );
      final medicine = islamicHistoryT0219CanonicalEntries.singleWhere(
        (entry) => entry.id == 'medicine_history',
      );
      final swapped = islamicHistoryT0219CanonicalEntries.map((entry) {
        if (entry.id == science.id) {
          return _copy(entry, theme: medicine.theme);
        }
        if (entry.id == medicine.id) {
          return _copy(entry, theme: science.theme);
        }
        return entry;
      }).toList();

      expect(
        () => T0219CanonicalHorizontalThemeGate.validate(swapped),
        throwsStateError,
      );
    });

    test('rejects valid-but-wrong provenance replacement', () {
      final trade = islamicHistoryT0219CanonicalEntries.singleWhere(
        (entry) => entry.id == 'trade_urbanization_history',
      );
      final replaced = _copy(
        trade,
        sourceIds: const ['lapidus_societies_horizontal', 'makdisi_rise_colleges'],
      );
      final entries = islamicHistoryT0219CanonicalEntries
          .map((entry) => entry.id == trade.id ? replaced : entry)
          .toList();

      expect(
        () => T0219CanonicalHorizontalThemeGate.validate(entries),
        throwsStateError,
      );
    });
  });
}
