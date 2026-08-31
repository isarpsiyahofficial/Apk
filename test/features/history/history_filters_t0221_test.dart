import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/data/islamic_history_horizontal_themes.dart';
import 'package:islami_hayat/features/history/domain/history_filters_t0221.dart';

void main() {
  test('empty T0221 query returns the full canonical event + horizontal-theme inventory', () {
    final result = historyFilterIndexT0221.filter(HistoryFilterQuery());

    expect(result.events.length, historyT0220Inventory.events.length);
    expect(
      result.horizontalThemes.length,
      islamicHistoryHorizontalThemesT0219.entries.length,
    );
  });

  test('period filter uses overlap and excludes unknown-date events rather than inventing years', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(startYearCe: 900, endYearCe: 1000),
    );

    expect(result.events, isNotEmpty);
    expect(
      result.events.every((event) =>
          event.startYearCe != null &&
          event.endYearCe != null &&
          event.startYearCe! <= 1000 &&
          event.endYearCe! >= 900),
      isTrue,
    );
  });

  test('region filter is backed by canonical geography IDs', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(regionIds: const {'syria_damascus'}),
    );

    expect(result.events.map((event) => event.id), contains('umayyad_caliphate'));
    expect(result.horizontalThemes, isEmpty);
    expect(
      result.events.every((event) => event.geographies.any((value) => value.id == 'syria_damascus')),
      isTrue,
    );
  });

  test('dynasty filter uses explicit stable metadata instead of title matching', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(dynastyIds: const {'ottoman'}),
    );

    expect(result.events.map((event) => event.id), equals(['ottoman_empire']));
    expect(result.horizontalThemes, isEmpty);
  });

  test('person filter uses canonical actor IDs', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(personIds: const {'muawiya_ibn_abi_sufyan'}),
    );

    expect(result.events, isNotEmpty);
    expect(
      result.events.every((event) => event.people.any((value) => value.id == 'muawiya_ibn_abi_sufyan')),
      isTrue,
    );
  });

  test('science facet returns the three source-backed T0219 science families', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(subjects: const {HistorySubjectFacet.science}),
    );

    expect(result.events, isEmpty);
    expect(result.horizontalThemes.map((entry) => entry.theme).toSet(), {
      IslamicHistoryTheme.science,
      IslamicHistoryTheme.medicine,
      IslamicHistoryTheme.mathematicsAstronomy,
    });
  });

  test('culture facet returns only the five broad cultural/social T0219 themes', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(subjects: const {HistorySubjectFacet.culture}),
    );

    expect(result.events, isEmpty);
    expect(result.horizontalThemes.map((entry) => entry.theme).toSet(), {
      IslamicHistoryTheme.philosophyThought,
      IslamicHistoryTheme.artArchitecture,
      IslamicHistoryTheme.tradeUrbanization,
      IslamicHistoryTheme.education,
      IslamicHistoryTheme.womenHistoricalRoles,
    });
  });

  test('religious-development facet is tied to hadith/tafsir/fiqh theme, not guessed from titles', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(subjects: const {HistorySubjectFacet.religiousDevelopment}),
    );

    expect(result.events, isEmpty);
    expect(result.horizontalThemes.map((entry) => entry.theme), [IslamicHistoryTheme.hadithTafsirFiqh]);
  });

  test('war facet exposes only explicitly annotated canonical events', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(subjects: const {HistorySubjectFacet.war}),
    );

    final ids = result.events.map((event) => event.id).toSet();
    expect(ids, contains('first_fitna'));
    expect(ids, contains('crusading_movement_levant'));
    expect(ids, contains('mongol_invasions_islamic_lands'));
    expect(result.horizontalThemes, isEmpty);
  });

  test('multiple event dimensions intersect instead of broadening results', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(
        dynastyIds: const {'umayyad'},
        personIds: const {'muawiya_ibn_abi_sufyan'},
        regionIds: const {'syria_damascus'},
      ),
    );

    expect(result.events.map((event) => event.id), equals(['umayyad_caliphate']));
    expect(result.horizontalThemes, isEmpty);
  });

  test('event-only dimensions never manufacture region/person/dynasty links for horizontal themes', () {
    final result = historyFilterIndexT0221.filter(
      HistoryFilterQuery(
        regionIds: const {'syria_damascus'},
        subjects: const {HistorySubjectFacet.culture},
      ),
    );

    expect(result.horizontalThemes, isEmpty);
  });

  test('invalid and half-present period ranges fail closed', () {
    expect(
      () => HistoryFilterQuery(startYearCe: 1000, endYearCe: 900),
      throwsStateError,
    );
    expect(
      () => HistoryFilterQuery(startYearCe: 1000),
      throwsStateError,
    );
  });
}
