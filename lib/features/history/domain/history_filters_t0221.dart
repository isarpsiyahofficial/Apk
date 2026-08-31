import '../data/history_t0220_inventory.dart';
import '../data/islamic_history_horizontal_themes.dart';
import 'history_event_contract.dart';

enum HistorySubjectFacet { science, culture, war, religiousDevelopment }

class HistoryFilterQuery {
  HistoryFilterQuery({
    this.startYearCe,
    this.endYearCe,
    Set<String> regionIds = const {},
    Set<String> dynastyIds = const {},
    Set<String> personIds = const {},
    Set<HistorySubjectFacet> subjects = const {},
  })  : regionIds = Set.unmodifiable(
          regionIds.map((value) => value.trim()).where((value) => value.isNotEmpty),
        ),
        dynastyIds = Set.unmodifiable(
          dynastyIds.map((value) => value.trim()).where((value) => value.isNotEmpty),
        ),
        personIds = Set.unmodifiable(
          personIds.map((value) => value.trim()).where((value) => value.isNotEmpty),
        ),
        subjects = Set.unmodifiable(subjects) {
    if ((startYearCe == null) != (endYearCe == null)) {
      throw StateError('T0221 period filter requires both start and end year.');
    }
    if (startYearCe != null && endYearCe != null && startYearCe! > endYearCe!) {
      throw StateError('T0221 period filter range is invalid.');
    }
  }

  final int? startYearCe;
  final int? endYearCe;
  final Set<String> regionIds;
  final Set<String> dynastyIds;
  final Set<String> personIds;
  final Set<HistorySubjectFacet> subjects;

  bool get hasPeriod => startYearCe != null && endYearCe != null;

  bool get isEmpty =>
      !hasPeriod && regionIds.isEmpty && dynastyIds.isEmpty && personIds.isEmpty && subjects.isEmpty;
}

class HistoryFilterResult {
  const HistoryFilterResult({required this.events, required this.horizontalThemes});

  final List<HistoryEventRecord> events;
  final List<IslamicHistoryThemeEntry> horizontalThemes;
}

class HistoryFilterIndex {
  HistoryFilterIndex._({
    required this.events,
    required this.horizontalThemes,
    required this.dynastyIdsByEvent,
    required this.subjectsByEvent,
  });

  factory HistoryFilterIndex.validated({
    required List<HistoryEventRecord> events,
    required List<IslamicHistoryThemeEntry> horizontalThemes,
    required Map<String, Set<String>> dynastyIdsByEvent,
    required Map<String, Set<HistorySubjectFacet>> subjectsByEvent,
  }) {
    if (events.isEmpty || horizontalThemes.isEmpty) {
      throw StateError('T0221 filter index requires event and horizontal-theme data.');
    }

    final eventIds = events.map((event) => event.id).toSet();
    final unknownDynastyEvents = dynastyIdsByEvent.keys.toSet().difference(eventIds);
    final unknownSubjectEvents = subjectsByEvent.keys.toSet().difference(eventIds);
    if (unknownDynastyEvents.isNotEmpty || unknownSubjectEvents.isNotEmpty) {
      throw StateError('T0221 facet metadata references unknown events.');
    }

    for (final entry in dynastyIdsByEvent.entries) {
      if (entry.value.isEmpty || entry.value.any((id) => id.trim().isEmpty)) {
        throw StateError('T0221 dynasty metadata must use non-empty stable IDs.');
      }
    }
    if (subjectsByEvent.values.any((value) => value.isEmpty)) {
      throw StateError('T0221 subject metadata must not contain empty assignments.');
    }

    return HistoryFilterIndex._(
      events: List.unmodifiable(events),
      horizontalThemes: List.unmodifiable(horizontalThemes),
      dynastyIdsByEvent: Map.unmodifiable({
        for (final entry in dynastyIdsByEvent.entries)
          entry.key: Set<String>.unmodifiable(entry.value.map((value) => value.trim())),
      }),
      subjectsByEvent: Map.unmodifiable({
        for (final entry in subjectsByEvent.entries)
          entry.key: Set<HistorySubjectFacet>.unmodifiable(entry.value),
      }),
    );
  }

  final List<HistoryEventRecord> events;
  final List<IslamicHistoryThemeEntry> horizontalThemes;
  final Map<String, Set<String>> dynastyIdsByEvent;
  final Map<String, Set<HistorySubjectFacet>> subjectsByEvent;

  HistoryFilterResult filter(HistoryFilterQuery query) {
    final matchedEvents = events.where((event) => _matchesEvent(event, query)).toList(growable: false);
    final matchedThemes =
        horizontalThemes.where((theme) => _matchesTheme(theme, query)).toList(growable: false);
    return HistoryFilterResult(
      events: List.unmodifiable(matchedEvents),
      horizontalThemes: List.unmodifiable(matchedThemes),
    );
  }

  bool _matchesEvent(HistoryEventRecord event, HistoryFilterQuery query) {
    if (query.hasPeriod && !_eventOverlapsPeriod(event, query.startYearCe!, query.endYearCe!)) {
      return false;
    }
    if (query.regionIds.isNotEmpty &&
        event.geographies.map((value) => value.id).toSet().intersection(query.regionIds).isEmpty) {
      return false;
    }
    if (query.personIds.isNotEmpty &&
        event.people.map((value) => value.id).toSet().intersection(query.personIds).isEmpty) {
      return false;
    }
    if (query.dynastyIds.isNotEmpty &&
        (dynastyIdsByEvent[event.id] ?? const <String>{}).intersection(query.dynastyIds).isEmpty) {
      return false;
    }
    if (query.subjects.isNotEmpty &&
        (subjectsByEvent[event.id] ?? const <HistorySubjectFacet>{})
            .intersection(query.subjects)
            .isEmpty) {
      return false;
    }
    return true;
  }

  bool _matchesTheme(IslamicHistoryThemeEntry theme, HistoryFilterQuery query) {
    // Horizontal themes do not claim a single dynasty, person or region. If one
    // of those event-only dimensions is active, exclude them rather than
    // manufacturing an association.
    if (query.regionIds.isNotEmpty || query.dynastyIds.isNotEmpty || query.personIds.isNotEmpty) {
      return false;
    }
    if (query.hasPeriod &&
        !_rangesOverlap(
          theme.startYearCe,
          theme.endYearCe,
          query.startYearCe!,
          query.endYearCe!,
        )) {
      return false;
    }
    if (query.subjects.isNotEmpty &&
        _subjectsForTheme(theme.theme).intersection(query.subjects).isEmpty) {
      return false;
    }
    return true;
  }

  static bool _eventOverlapsPeriod(HistoryEventRecord event, int start, int end) {
    final eventStart = event.startYearCe;
    final eventEnd = event.endYearCe;
    if (eventStart == null || eventEnd == null) {
      return false;
    }
    return _rangesOverlap(eventStart, eventEnd, start, end);
  }

  static bool _rangesOverlap(int leftStart, int leftEnd, int rightStart, int rightEnd) =>
      leftStart <= rightEnd && rightStart <= leftEnd;

  static Set<HistorySubjectFacet> _subjectsForTheme(IslamicHistoryTheme theme) {
    switch (theme) {
      case IslamicHistoryTheme.science:
      case IslamicHistoryTheme.medicine:
      case IslamicHistoryTheme.mathematicsAstronomy:
        return const {HistorySubjectFacet.science};
      case IslamicHistoryTheme.philosophyThought:
      case IslamicHistoryTheme.artArchitecture:
      case IslamicHistoryTheme.tradeUrbanization:
      case IslamicHistoryTheme.education:
      case IslamicHistoryTheme.womenHistoricalRoles:
        return const {HistorySubjectFacet.culture};
      case IslamicHistoryTheme.hadithTafsirFiqh:
        return const {HistorySubjectFacet.religiousDevelopment};
    }
  }
}

Map<String, Set<String>> _canonicalDynastyIds(List<HistoryEventRecord> events) {
  const known = <String, Set<String>>{
    'umayyad_caliphate': {'umayyad'},
    'abbasid_caliphate': {'abbasid'},
    'umayyad_al_andalus': {'umayyad_al_andalus'},
    'fatimid_caliphate': {'fatimid'},
    'samanid_regional_power': {'samanid'},
    'buyid_regional_power': {'buyid'},
    'great_seljuq_sultanate': {'great_seljuq'},
    'ayyubid_egypt_syria': {'ayyubid'},
    'mamluk_sultanate_egypt_syria': {'mamluk'},
    'ottoman_empire': {'ottoman'},
    'safavid_iran': {'safavid'},
    'mughal_empire': {'mughal'},
  };
  final eventIds = events.map((event) => event.id).toSet();
  return {
    for (final entry in known.entries)
      if (eventIds.contains(entry.key)) entry.key: entry.value,
  };
}

Map<String, Set<HistorySubjectFacet>> _canonicalEventSubjects(List<HistoryEventRecord> events) {
  const known = <String, Set<HistorySubjectFacet>>{
    'first_fitna': {HistorySubjectFacet.war},
    'crusading_movement_levant': {HistorySubjectFacet.war},
    'mongol_invasions_islamic_lands': {HistorySubjectFacet.war},
  };
  final eventIds = events.map((event) => event.id).toSet();
  return {
    for (final entry in known.entries)
      if (eventIds.contains(entry.key)) entry.key: entry.value,
  };
}

final historyFilterIndexT0221 = HistoryFilterIndex.validated(
  events: historyT0220Inventory.events,
  horizontalThemes: islamicHistoryHorizontalThemes.entries,
  dynastyIdsByEvent: _canonicalDynastyIds(historyT0220Inventory.events),
  subjectsByEvent: _canonicalEventSubjects(historyT0220Inventory.events),
);
