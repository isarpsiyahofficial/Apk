import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/islamic_history_horizontal_themes.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('IslamicHistoryHorizontalThemesDataset T0219', () {
    test('covers all nine required horizontal themes', () {
      final dataset = islamicHistoryHorizontalThemesT0219;

      expect(
        dataset.entries.map((entry) => entry.theme).toSet(),
        IslamicHistoryTheme.values.toSet(),
      );
      expect(dataset.entries, hasLength(IslamicHistoryTheme.values.length));
    });

    test('keeps all T0219 content research-only pending factual and native review', () {
      final dataset = islamicHistoryHorizontalThemesT0219;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every(
          (entry) => entry.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('requires two independent academic work families', () {
      final science = islamicHistoryT0219Entries.first;
      const duplicateFamily = HorizontalThemeSource(
        workFamilyId: 'saliba_islamic_science',
        locator: HistorySourceLocator(
          id: 'saliba_second_locator_test',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Saliba work family.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalidScience = IslamicHistoryThemeEntry(
        id: science.id,
        theme: science.theme,
        title: science.title,
        summary: science.summary,
        startYearCe: science.startYearCe,
        endYearCe: science.endYearCe,
        certainty: science.certainty,
        caveat: science.caveat,
        sourceIds: const ['saliba_islamic_science', 'saliba_second_locator_test'],
        status: science.status,
      );

      expect(
        () => IslamicHistoryHorizontalThemesDataset.validated(
          sources: [...islamicHistoryT0219Sources, duplicateFamily],
          entries: [invalidScience, ...islamicHistoryT0219Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown sources', () {
      final medicine = islamicHistoryT0219Entries.singleWhere(
        (entry) => entry.theme == IslamicHistoryTheme.medicine,
      );
      final invalid = IslamicHistoryThemeEntry(
        id: medicine.id,
        theme: medicine.theme,
        title: medicine.title,
        summary: medicine.summary,
        startYearCe: medicine.startYearCe,
        endYearCe: medicine.endYearCe,
        certainty: medicine.certainty,
        caveat: medicine.caveat,
        sourceIds: const ['pormann_savage_smith_medicine', 'unknown_source'],
        status: medicine.status,
      );

      expect(
        () => IslamicHistoryHorizontalThemesDataset.validated(
          sources: islamicHistoryT0219Sources,
          entries: islamicHistoryT0219Entries
              .map((entry) => entry.id == medicine.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('rejects a missing required horizontal theme', () {
      expect(
        () => IslamicHistoryHorizontalThemesDataset.validated(
          sources: islamicHistoryT0219Sources,
          entries: islamicHistoryT0219Entries
              .where((entry) => entry.theme != IslamicHistoryTheme.womenHistoricalRoles)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR certainty caveats', () {
      final women = islamicHistoryT0219Entries.singleWhere(
        (entry) => entry.theme == IslamicHistoryTheme.womenHistoricalRoles,
      );
      final invalid = IslamicHistoryThemeEntry(
        id: women.id,
        theme: women.theme,
        title: women.title,
        summary: women.summary,
        startYearCe: women.startYearCe,
        endYearCe: women.endYearCe,
        certainty: women.certainty,
        caveat: const LocalizedHistorySummary(
          tr: 'Kaynak türüne göre değişir.',
          en: 'Varies by source type.',
          ar: '',
        ),
        sourceIds: women.sourceIds,
        status: women.status,
      );

      expect(
        () => IslamicHistoryHorizontalThemesDataset.validated(
          sources: islamicHistoryT0219Sources,
          entries: islamicHistoryT0219Entries
              .map((entry) => entry.id == women.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('women history is not treated as one timeless generalization', () {
      final women = islamicHistoryT0219Entries.singleWhere(
        (entry) => entry.theme == IslamicHistoryTheme.womenHistoricalRoles,
      );

      expect(women.certainty, HorizontalThemeCertainty.contestedInterpretation);
      expect(women.caveat.tr, contains('sınıf'));
      expect(women.caveat.en, contains('class'));
      expect(women.caveat.ar, isNotEmpty);
      expect(women.sourceIds, containsAll(['sayeed_women_knowledge', 'ahmed_women_gender']));
    });

    test('hadith tafsir and fiqh development is explicitly non-linear', () {
      final entry = islamicHistoryT0219Entries.singleWhere(
        (item) => item.theme == IslamicHistoryTheme.hadithTafsirFiqh,
      );

      expect(entry.certainty, HorizontalThemeCertainty.contestedInterpretation);
      expect(entry.sourceIds, containsAll(['hallaq_origins_islamic_law', 'melchert_sunni_schools']));
      expect(entry.caveat.en, contains('single linear process'));
    });
  });
}
