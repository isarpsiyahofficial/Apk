import '../../../core/content/content_governance.dart';
import 'arafah_content.dart';
import 'berat_content.dart';
import 'eid_al_adha_content.dart';
import 'eid_al_fitr_content.dart';
import 'laylat_al_qadr_content.dart';
import 'mawlid_content.dart';
import 'miraj_content.dart';
import 'muharram_ashura_content.dart';
import 'ramadan_content.dart';
import 'regaib_content.dart';
import 'religious_date_metadata.dart';
import 'religious_day_content.dart';

/// T0335 canonical religious-day release audit.
///
/// This registry deliberately enumerates every current religious-day content
/// record. Adding a new content file without updating this expected-ID set is a
/// release failure rather than a silent QA omission.
final class ReligiousDayReleaseAuditT0335 {
  const ReligiousDayReleaseAuditT0335._();

  static const Set<String> expectedCanonicalContentIds = <String>{
    'religious-day-arafah',
    'religious-night-berat-mid-shaban',
    'religious-day-eid-al-adha',
    'religious-day-eid-al-fitr',
    'religious-day-laylat-al-qadr',
    'religious-night-mawlid',
    'religious-night-isra-miraj',
    'religious-day-muharram-ashura',
    'religious-day-ramadan',
    'religious-night-regaib',
  };

  static final List<ReligiousDayContent> canonicalContents =
      List<ReligiousDayContent>.unmodifiable(<ReligiousDayContent>[
    arafahResearchContent,
    beratResearchContent,
    eidAlAdhaResearchContent,
    eidAlFitrResearchContent,
    laylatAlQadrResearchContent,
    mawlidResearchContent,
    mirajResearchContent,
    muharramAshuraResearchContent,
    ramadanResearchContent,
    regaibResearchContent,
  ]);

  /// V1 does not silently manufacture future Gregorian religious dates.
  /// Exact local observations may be added only from dated official authority
  /// publications and must pass [auditDateObservations].
  static const List<ReligiousDateObservation> canonicalDateObservations =
      <ReligiousDateObservation>[];

  static void requireCanonicalContentSafe() {
    requireContentsSafe(
      canonicalContents,
      expectedIds: expectedCanonicalContentIds,
    );
  }

  static void requireContentsSafe(
    Iterable<ReligiousDayContent> contents, {
    required Set<String> expectedIds,
  }) {
    final materialized = contents.toList(growable: false);
    final ids = materialized.map((content) => content.record.id).toList();
    final uniqueIds = ids.toSet();

    if (ids.length != uniqueIds.length) {
      throw StateError('T0335 duplicate religious-day content ID detected.');
    }
    if (uniqueIds.length != expectedIds.length ||
        !uniqueIds.containsAll(expectedIds) ||
        !expectedIds.containsAll(uniqueIds)) {
      throw StateError(
        'T0335 canonical religious-day registry mismatch. '
        'Expected ${expectedIds.length} IDs, found ${uniqueIds.length}.',
      );
    }

    for (final content in materialized) {
      if (content.record.type != ContentType.religiousDay) {
        throw StateError(
          'T0335 non-religious-day record in registry: ${content.record.id}',
        );
      }
      if (!content.hasSafeEvidenceSemantics) {
        throw StateError(
          'T0335 unsafe evidence/specific-worship semantics: '
          '${content.record.id}',
        );
      }
      _requireSourceClosure(content);

      final isPublished =
          content.record.reviewStatus == ContentReviewStatus.published;
      if (isPublished && !content.canEnterProductionDataset) {
        throw StateError(
          'T0335 published religious-day record fails production gate: '
          '${content.record.id}',
        );
      }
      if (!isPublished && content.canEnterProductionDataset) {
        throw StateError(
          'T0335 non-published religious-day record entered production: '
          '${content.record.id}',
        );
      }
    }
  }

  /// Every evidence source must be declared at record level as well.
  ///
  /// This prevents a future edit from attaching a convincing-looking source to
  /// one evidence section while leaving the governed record's source manifest
  /// stale, incomplete, duplicated, or downgraded to an unknown source class.
  static void _requireSourceClosure(ReligiousDayContent content) {
    final recordSources = content.record.sources;
    final recordSourceIds = recordSources.map((source) => source.id).toList();
    if (recordSourceIds.length != recordSourceIds.toSet().length) {
      throw StateError(
        'T0335 duplicate record-level source ID: ${content.record.id}',
      );
    }

    for (final source in recordSources) {
      if (source.id.trim().isEmpty ||
          source.title.trim().isEmpty ||
          source.licenseId.trim().isEmpty ||
          (source.locator?.trim().isEmpty ?? true) ||
          source.sourceClass == ReligiousSourceClass.unknown) {
        throw StateError(
          'T0335 incomplete/unknown record-level source metadata: '
          '${content.record.id}',
        );
      }
    }

    final governedIds = recordSourceIds.toSet();
    for (final section in content.evidence) {
      for (final source in section.sources) {
        if (!governedIds.contains(source.id)) {
          throw StateError(
            'T0335 evidence source missing from record manifest: '
            '${content.record.id} -> ${source.id}',
          );
        }
      }
    }
  }

  static void requireCanonicalDatesSafe() {
    auditDateObservations(canonicalDateObservations);
  }

  static void auditDateObservations(
    Iterable<ReligiousDateObservation> observations,
  ) {
    final seenKeys = <String>{};
    for (final observation in observations) {
      final key = <Object>[
        observation.contentId,
        observation.hijriYear,
        observation.hijriMonth,
        observation.hijriDay,
        observation.source.countryCode,
      ].join('|');
      if (!seenKeys.add(key)) {
        throw StateError('T0335 duplicate religious-date observation: $key');
      }
      if (!expectedCanonicalContentIds.contains(observation.contentId)) {
        throw StateError(
          'T0335 date references unknown religious-day content: '
          '${observation.contentId}',
        );
      }
      if (!ReligiousDateDisplayPolicy.canShowExactDate(observation)) {
        throw StateError(
          'T0335 unpinned/provisional exact date cannot enter release data: '
          '${observation.contentId} ${observation.source.countryCode}',
        );
      }
    }
  }
}
