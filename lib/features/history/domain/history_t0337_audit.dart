import 'history_event_contract.dart';

/// Canonical source identity used by the T0337 double-source gate.
///
/// `independenceFamily` must identify the underlying work/source tradition,
/// not merely a bibliography row, edition, URL, mirror, translation, or alias.
/// Two source IDs that resolve to the same family count as one source.
class HistoryT0337SourceIdentity {
  const HistoryT0337SourceIdentity({
    required this.sourceId,
    required this.independenceFamily,
  });

  final String sourceId;
  final String independenceFamily;
}

/// Reviewed source evidence that corroborates one exact canonical event without
/// mutating the underlying T0220 record merely to satisfy the release gate.
///
/// This is intentionally event-scoped. A hadith or academic work reviewed for
/// one event cannot silently become support for every event in the same period.
/// The locator is retained so QA can inspect the exact bibliographic reference.
class HistoryT0337Corroboration {
  const HistoryT0337Corroboration({
    required this.eventId,
    required this.sourceId,
    required this.locator,
  });

  final String eventId;
  final String sourceId;
  final String locator;
}

class HistoryT0337AuditResult {
  const HistoryT0337AuditResult({
    required this.eventCount,
    required this.contestedEventCount,
  });

  final int eventCount;
  final int contestedEventCount;
}

/// Fail-closed audit for SPEC 583–584 / TODO T0337.
///
/// The gate intentionally does not infer independence from different source
/// IDs. Every cited source must be explicitly mapped to an underlying source
/// family, and every event must be supported by at least two distinct families.
/// This prevents aliases, editions, mirrors, or duplicated bibliography rows
/// from satisfying the two-source requirement.
///
/// A reviewed event-scoped corroboration may supply an additional source when
/// the canonical T0220 record predates the review. Corroboration never rewrites
/// user-facing historical text or dates: it only adds an exact reviewed source
/// locator for this QA gate, and it must itself map to the explicit source-family
/// registry.
///
/// A contested event must additionally keep its uncertainty disclosure in all
/// three release languages. The base event contract already prevents unknown
/// dates from being promoted to production; this audit preserves that behavior
/// and never manufactures a date to make a record releasable.
class HistoryT0337Audit {
  const HistoryT0337Audit._();

  static HistoryT0337AuditResult validate({
    required List<HistoryEventRecord> events,
    required List<HistoryT0337SourceIdentity> sourceIdentities,
    List<HistoryT0337Corroboration> corroborations = const [],
  }) {
    if (events.isEmpty) {
      throw StateError('T0337 history audit requires at least one event.');
    }
    if (sourceIdentities.isEmpty) {
      throw StateError('T0337 source-independence registry must not be empty.');
    }

    final sourceFamilies = <String, String>{};
    for (final identity in sourceIdentities) {
      final sourceId = identity.sourceId.trim();
      final family = identity.independenceFamily.trim();
      if (sourceId.isEmpty || family.isEmpty) {
        throw StateError('T0337 source identity fields must be non-empty.');
      }
      if (sourceFamilies.containsKey(sourceId)) {
        throw StateError('T0337 source IDs must be unique: $sourceId');
      }
      sourceFamilies[sourceId] = family;
    }

    final canonicalEventIds = events.map((event) => event.id).toSet();
    final corroborationsByEvent = <String, List<String>>{};
    final corroborationKeys = <String>{};
    for (final corroboration in corroborations) {
      final eventId = corroboration.eventId.trim();
      final sourceId = corroboration.sourceId.trim();
      final locator = corroboration.locator.trim();
      if (eventId.isEmpty || sourceId.isEmpty || locator.isEmpty) {
        throw StateError('T0337 corroboration fields must be non-empty.');
      }
      if (!canonicalEventIds.contains(eventId)) {
        throw StateError(
          'T0337 corroboration targets an event outside this audit: $eventId',
        );
      }
      if (!sourceFamilies.containsKey(sourceId)) {
        throw StateError(
          'T0337 corroboration cites an unmapped source: $sourceId',
        );
      }
      final key = '$eventId::$sourceId';
      if (!corroborationKeys.add(key)) {
        throw StateError(
          'T0337 duplicate corroboration for event/source: $key',
        );
      }
      corroborationsByEvent.putIfAbsent(eventId, () => <String>[]).add(sourceId);
    }

    var contestedEventCount = 0;
    final eventIds = <String>{};
    for (final event in events) {
      if (!eventIds.add(event.id)) {
        throw StateError('T0337 event IDs must be unique: ${event.id}');
      }

      final supplementalIds = corroborationsByEvent[event.id] ?? const <String>[];
      if (supplementalIds.any(event.sourceIds.contains)) {
        throw StateError(
          'T0337 corroboration must add a distinct source to ${event.id}.',
        );
      }
      final effectiveSourceIds = <String>[...event.sourceIds, ...supplementalIds];
      if (effectiveSourceIds.length < 2) {
        throw StateError(
          'T0337 event ${event.id} requires at least two cited sources.',
        );
      }

      final independentFamilies = <String>{};
      for (final sourceId in effectiveSourceIds) {
        final family = sourceFamilies[sourceId];
        if (family == null) {
          throw StateError(
            'T0337 event ${event.id} cites an unmapped source: $sourceId',
          );
        }
        independentFamilies.add(family);
      }
      if (independentFamilies.length < 2) {
        throw StateError(
          'T0337 event ${event.id} does not have two independent source families.',
        );
      }

      if (event.dateCertainty == HistoryDateCertainty.contested) {
        contestedEventCount++;
        if (!event.dateCaveat.isComplete) {
          throw StateError(
            'T0337 contested event ${event.id} requires TR/EN/AR uncertainty disclosure.',
          );
        }
      }

      if (event.dateCertainty == HistoryDateCertainty.unknown &&
          (event.startYearCe != null || event.endYearCe != null)) {
        throw StateError(
          'T0337 unknown event ${event.id} must not carry a fabricated year.',
        );
      }
    }

    return HistoryT0337AuditResult(
      eventCount: events.length,
      contestedEventCount: contestedEventCount,
    );
  }
}
