import '../data/pre_islam_world_context.dart';

enum HistoryDateCertainty {
  exact,
  approximate,
  broadRange,
  contested,
  unknown,
}

enum HistoryGeographyPrecision { exact, approximate, regional }

class HistoryPersonRef {
  const HistoryPersonRef({required this.id, required this.name});

  final String id;
  final LocalizedHistorySummary name;

  bool get isComplete => id.trim().isNotEmpty && name.isComplete;
}

class HistoryGeographyRef {
  const HistoryGeographyRef({
    required this.id,
    required this.label,
    required this.precision,
  });

  final String id;
  final LocalizedHistorySummary label;
  final HistoryGeographyPrecision precision;

  bool get isComplete => id.trim().isNotEmpty && label.isComplete;
}

class HistoryEventRecord {
  HistoryEventRecord._({
    required this.id,
    required this.title,
    required this.startYearCe,
    required this.endYearCe,
    required this.dateCertainty,
    required this.dateCaveat,
    required this.beforeContext,
    required this.causes,
    required this.consequences,
    required this.people,
    required this.geographies,
    required this.sourceIds,
    required this.status,
  });

  factory HistoryEventRecord.validated({
    required String id,
    required LocalizedHistorySummary title,
    required int? startYearCe,
    required int? endYearCe,
    required HistoryDateCertainty dateCertainty,
    required LocalizedHistorySummary dateCaveat,
    required LocalizedHistorySummary beforeContext,
    required List<LocalizedHistorySummary> causes,
    required List<LocalizedHistorySummary> consequences,
    required List<HistoryPersonRef> people,
    required List<HistoryGeographyRef> geographies,
    required List<String> sourceIds,
    required Set<String> knownSourceIds,
    required HistoryResearchStatus status,
  }) {
    if (id.trim().isEmpty || !title.isComplete) {
      throw StateError('T0220 event identity and TR/EN/AR title are required.');
    }

    final hasStart = startYearCe != null;
    final hasEnd = endYearCe != null;
    if (hasStart != hasEnd) {
      throw StateError('T0220 event dates must provide both range bounds or neither.');
    }
    if (startYearCe != null && endYearCe != null && startYearCe > endYearCe) {
      throw StateError('T0220 event date range is invalid.');
    }
    if (dateCertainty == HistoryDateCertainty.unknown) {
      if (hasStart || hasEnd) {
        throw StateError('Unknown T0220 dates must not carry invented year sentinels.');
      }
    } else if (!hasStart || !hasEnd) {
      throw StateError('Known/estimated T0220 dates require an explicit year range.');
    }

    if (!dateCaveat.isComplete || !beforeContext.isComplete) {
      throw StateError('T0220 date certainty and before-context require TR/EN/AR text.');
    }
    if (causes.isEmpty || causes.any((value) => !value.isComplete)) {
      throw StateError('T0220 requires at least one complete TR/EN/AR cause.');
    }
    if (consequences.isEmpty || consequences.any((value) => !value.isComplete)) {
      throw StateError('T0220 requires at least one complete TR/EN/AR consequence.');
    }
    if (people.isEmpty || people.any((value) => !value.isComplete)) {
      throw StateError('T0220 requires at least one identified person/actor.');
    }
    if (geographies.isEmpty || geographies.any((value) => !value.isComplete)) {
      throw StateError('T0220 requires at least one geography with precision.');
    }

    final normalizedSourceIds = sourceIds.map((id) => id.trim()).toList(growable: false);
    if (normalizedSourceIds.isEmpty ||
        normalizedSourceIds.any((id) => id.isEmpty || !knownSourceIds.contains(id)) ||
        normalizedSourceIds.toSet().length != normalizedSourceIds.length) {
      throw StateError('T0220 source references must be unique and known.');
    }

    if (dateCertainty == HistoryDateCertainty.unknown &&
        status == HistoryResearchStatus.reviewedForProduction) {
      throw StateError('Unknown event dates cannot be promoted to production.');
    }

    return HistoryEventRecord._(
      id: id.trim(),
      title: title,
      startYearCe: startYearCe,
      endYearCe: endYearCe,
      dateCertainty: dateCertainty,
      dateCaveat: dateCaveat,
      beforeContext: beforeContext,
      causes: List.unmodifiable(causes),
      consequences: List.unmodifiable(consequences),
      people: List.unmodifiable(people),
      geographies: List.unmodifiable(geographies),
      sourceIds: List.unmodifiable(normalizedSourceIds),
      status: status,
    );
  }

  final String id;
  final LocalizedHistorySummary title;
  final int? startYearCe;
  final int? endYearCe;
  final HistoryDateCertainty dateCertainty;
  final LocalizedHistorySummary dateCaveat;
  final LocalizedHistorySummary beforeContext;
  final List<LocalizedHistorySummary> causes;
  final List<LocalizedHistorySummary> consequences;
  final List<HistoryPersonRef> people;
  final List<HistoryGeographyRef> geographies;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class HistoryEventContractDataset {
  HistoryEventContractDataset._(this.events);

  factory HistoryEventContractDataset.validated(List<HistoryEventRecord> events) {
    if (events.isEmpty) {
      throw StateError('T0220 history event dataset must not be empty.');
    }
    final ids = <String>{};
    for (final event in events) {
      if (!ids.add(event.id)) {
        throw StateError('T0220 history event IDs must be unique.');
      }
    }
    return HistoryEventContractDataset._(List.unmodifiable(events));
  }

  final List<HistoryEventRecord> events;

  List<HistoryEventRecord> get productionEvents => List.unmodifiable(
        events.where((event) => event.status == HistoryResearchStatus.reviewedForProduction),
      );
}
