import 'content_governance.dart';

/// Fail-closed release boundary for SPEC 571–589 / TODO T0338.
///
/// A religious record may enter a production dataset only when the exact
/// canonical inventory expects it and the record has reached `published` while
/// still satisfying the shared source/localization/version production rules.
/// `approved` is deliberately not enough: publishing is a separate release
/// decision and withdrawn/earlier workflow states must never leak into the
/// shipped dataset.
final class ProductionPublicationGateT0338 {
  const ProductionPublicationGateT0338();

  List<ReligiousContentRecord> requirePublishedRecords({
    required Iterable<ReligiousContentRecord> records,
    required Set<String> expectedIds,
  }) {
    final normalizedExpectedIds = <String>{};
    for (final rawId in expectedIds) {
      final id = rawId.trim();
      if (id.isEmpty) {
        throw StateError('T0338 expected production IDs must not be blank.');
      }
      if (!normalizedExpectedIds.add(id)) {
        throw StateError(
          'T0338 expected production IDs must remain unique after normalization: $id',
        );
      }
    }
    if (normalizedExpectedIds.isEmpty) {
      throw StateError('T0338 expected production inventory must not be empty.');
    }

    final seenIds = <String>{};
    final published = <ReligiousContentRecord>[];
    for (final record in records) {
      final id = record.id.trim();
      if (id.isEmpty || !seenIds.add(id)) {
        throw StateError(
          'T0338 production record IDs must be unique and non-empty: ${record.id}',
        );
      }
      if (!normalizedExpectedIds.contains(id)) {
        throw StateError(
          'T0338 unexpected record attempted to enter production: $id',
        );
      }
      if (record.reviewStatus != ContentReviewStatus.published) {
        throw StateError(
          'T0338 non-published record attempted to enter production: '
          '$id (${record.reviewStatus.name})',
        );
      }
      if (!record.canEnterProductionDataset) {
        throw StateError(
          'T0338 published record failed production governance: $id',
        );
      }
      final reviewer = record.reviewer?.trim();
      if (reviewer == null || reviewer.isEmpty) {
        throw StateError(
          'T0338 published record requires explicit review attribution: $id',
        );
      }

      final seenSourceIds = <String>{};
      for (final source in record.sources) {
        final sourceId = source.id.trim();
        if (sourceId.isEmpty || !seenSourceIds.add(sourceId)) {
          throw StateError(
            'T0338 source IDs must be unique and non-empty for $id: ${source.id}',
          );
        }
        if (source.title.trim().isEmpty || source.licenseId.trim().isEmpty) {
          throw StateError(
            'T0338 source title/license must be non-empty for $id: $sourceId',
          );
        }
        if (source.sourceClass == ReligiousSourceClass.unknown) {
          throw StateError(
            'T0338 unknown source class cannot enter production for $id: $sourceId',
          );
        }
        final locator = source.locator?.trim();
        final hasLocator = locator != null && locator.isNotEmpty;
        final hasUrl = source.url != null;
        if (!hasLocator && !hasUrl) {
          throw StateError(
            'T0338 every production source needs an inspectable locator or URL for $id: $sourceId',
          );
        }
      }

      published.add(record);
    }

    final missingIds = normalizedExpectedIds.difference(seenIds);
    if (missingIds.isNotEmpty) {
      final ordered = missingIds.toList()..sort();
      throw StateError(
        'T0338 production inventory is missing records: ${ordered.join(', ')}',
      );
    }

    return List<ReligiousContentRecord>.unmodifiable(published);
  }
}
