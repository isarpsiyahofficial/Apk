import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/berat_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_release_audit_t0335.dart';

void main() {
  group('T0335 religious-day release audit', () {
    test('canonical registry is complete and semantically safe', () {
      expect(
        ReligiousDayReleaseAuditT0335.canonicalContents,
        hasLength(ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds.length),
      );
      expect(
        () => ReligiousDayReleaseAuditT0335.requireCanonicalContentSafe(),
        returnsNormally,
      );
      expect(
        ReligiousDayReleaseAuditT0335.canonicalContents
            .every((content) => content.hasSafeEvidenceSemantics),
        isTrue,
      );
    });

    test('registry omission and duplicate IDs fail closed', () {
      final canonical = ReligiousDayReleaseAuditT0335.canonicalContents;
      expect(
        () => ReligiousDayReleaseAuditT0335.requireContentsSafe(
          canonical.take(canonical.length - 1),
          expectedIds:
              ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds,
        ),
        throwsStateError,
      );
      expect(
        () => ReligiousDayReleaseAuditT0335.requireContentsSafe(
          <ReligiousDayContent>[canonical.first, ...canonical],
          expectedIds:
              ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds,
        ),
        throwsStateError,
      );
    });

    test('hidden special-worship claim fails even while record is research', () {
      final disputedSource = beratResearchContent.evidence.first.sources.first;
      final unsafe = ReligiousDayContent(
        record: beratResearchContent.record,
        title: beratResearchContent.title,
        whatIsIt: beratResearchContent.whatIsIt,
        history: beratResearchContent.history,
        evidence: <ReligiousDayEvidenceSection>[
          ...beratResearchContent.evidence,
          ReligiousDayEvidenceSection(
            kind: ReligiousDayEvidenceKind.specificWorship,
            text: beratResearchContent.title,
            certainty: CertaintyLevel.disputed,
            sources: <SourceReference>[disputedSource],
          ),
        ],
        specificWorshipStatus:
            SpecificWorshipStatus.noSpecificPracticeEstablished,
        reviewedEvidenceKinds:
            ReligiousDayContent.requiredReviewedEvidenceKinds,
      );

      expect(unsafe.hasSafeEvidenceSemantics, isFalse);
      final contents = <ReligiousDayContent>[
        for (final content in ReligiousDayReleaseAuditT0335.canonicalContents)
          if (content.record.id == unsafe.record.id) unsafe else content,
      ];
      expect(
        () => ReligiousDayReleaseAuditT0335.requireContentsSafe(
          contents,
          expectedIds:
              ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds,
        ),
        throwsStateError,
      );
    });

    test('evidence source absent from governed record manifest fails closed', () {
      const undeclaredDisputedSource = SourceReference(
        id: 'test-undeclared-disputed-source',
        title: 'Test disputed source',
        sourceClass: ReligiousSourceClass.disputed,
        licenseId: 'test-reference-only',
        locator: 'test locator',
      );
      final firstEvidence = beratResearchContent.evidence.first;
      final tampered = ReligiousDayContent(
        record: beratResearchContent.record,
        title: beratResearchContent.title,
        whatIsIt: beratResearchContent.whatIsIt,
        history: beratResearchContent.history,
        evidence: <ReligiousDayEvidenceSection>[
          ReligiousDayEvidenceSection(
            kind: firstEvidence.kind,
            text: firstEvidence.text,
            certainty: firstEvidence.certainty,
            sources: const <SourceReference>[undeclaredDisputedSource],
          ),
          ...beratResearchContent.evidence.skip(1),
        ],
        specificWorshipStatus: beratResearchContent.specificWorshipStatus,
        reviewedEvidenceKinds: beratResearchContent.reviewedEvidenceKinds,
      );

      expect(tampered.hasSafeEvidenceSemantics, isTrue);
      final contents = <ReligiousDayContent>[
        for (final content in ReligiousDayReleaseAuditT0335.canonicalContents)
          if (content.record.id == tampered.record.id) tampered else content,
      ];
      expect(
        () => ReligiousDayReleaseAuditT0335.requireContentsSafe(
          contents,
          expectedIds:
              ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds,
        ),
        throwsStateError,
      );
    });

    test('no unverified exact Gregorian date is present in canonical data', () {
      expect(
        ReligiousDayReleaseAuditT0335.canonicalDateObservations,
        isEmpty,
      );
      expect(
        () => ReligiousDayReleaseAuditT0335.requireCanonicalDatesSafe(),
        returnsNormally,
      );
    });

    test('provisional or unpinned exact date fails closed', () {
      final authority = religiousDateAuthorities.first;
      final provisional = ReligiousDateObservation(
        contentId: 'religious-day-laylat-al-qadr',
        hijriYear: 1448,
        hijriMonth: 9,
        hijriDay: 27,
        gregorianDate: DateTime.utc(2027, 3, 6),
        source: authority,
        status: ReligiousDateVerificationStatus.provisional,
        verifiedAt: DateTime.utc(2026, 9, 5),
      );

      expect(
        () => ReligiousDayReleaseAuditT0335.auditDateObservations(
          <ReligiousDateObservation>[provisional],
        ),
        throwsStateError,
      );
    });

    test('confirmed pinned local date can pass but unknown content cannot', () {
      final authority = religiousDateAuthorities.first;
      ReligiousDateObservation observation(String contentId) =>
          ReligiousDateObservation(
            contentId: contentId,
            hijriYear: 1448,
            hijriMonth: 9,
            hijriDay: 27,
            gregorianDate: DateTime.utc(2027, 3, 6),
            source: authority,
            status: ReligiousDateVerificationStatus.confirmed,
            verifiedAt: DateTime.utc(2026, 9, 5),
            sourcePublicationLocator: 'official-calendar-row-1448-09-27',
            sourcePublicationUrl: Uri.parse(
              'https://namazvakitleri.diyanet.gov.tr/tr-TR/hicri-takvim',
            ),
          );

      expect(
        () => ReligiousDayReleaseAuditT0335.auditDateObservations(
          <ReligiousDateObservation>[
            observation('religious-day-laylat-al-qadr'),
          ],
        ),
        returnsNormally,
      );
      expect(
        () => ReligiousDayReleaseAuditT0335.auditDateObservations(
          <ReligiousDateObservation>[observation('unknown-religious-day')],
        ),
        throwsStateError,
      );
    });
  });
}
