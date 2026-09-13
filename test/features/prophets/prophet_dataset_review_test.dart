import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_dataset_review.dart';

void main() {
  const quranSource = SourceReference(
    id: 'quran-canonical',
    title: 'Canonical Quran',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'CC-BY-3.0',
    locator: '2:124',
  );

  LocalizedReligiousText claimText(String value) => LocalizedReligiousText(
        tr: '$value TR',
        en: '$value EN',
        ar: '$value AR',
      );

  ProphetContent ibrahim({
    int version = 3,
    LocalizedReligiousText name = const LocalizedReligiousText(
      tr: 'İbrâhim',
      en: 'Abraham',
      ar: 'إبراهيم',
    ),
    String arabicName = 'إبراهيم',
  }) => ProphetContent(
        record: ReligiousContentRecord(
          id: 'prophet-ibrahim',
          type: ContentType.prophetBiography,
          sourceStatus: ReligiousSourceClass.quran,
          version: version,
          reviewStatus: ContentReviewStatus.published,
          certainty: CertaintyLevel.explicitSource,
          text: name,
          sources: const [quranSource],
          lastReviewedAt: DateTime.utc(2026, 8, 30, 12),
          reviewer: 'religious-editor',
        ),
        canonicalId: 'ibrahim',
        name: name,
        arabicName: arabicName,
        quranReferences: const [ProphetVerseReference(surah: 2, ayah: 124)],
        dateEvidence: const [],
        geography: const [],
        family: const [],
        duaReferences: const [],
        timelineRelations: const [],
        claims: [
          ProphetClaim(
            text: claimText('Kaynaklı biyografi'),
            certainty: CertaintyLevel.explicitSource,
            sources: const [quranSource],
          ),
        ],
      );

  ProphetDatasetReviewEvidence approvedEvidence({
    int version = 3,
    ProphetReviewDecision tr = ProphetReviewDecision.approved,
    ProphetReviewDecision en = ProphetReviewDecision.approved,
    ProphetReviewDecision ar = ProphetReviewDecision.approved,
    ProphetReviewDecision religious = ProphetReviewDecision.approved,
    ProphetReviewDecision terminology = ProphetReviewDecision.approved,
    DateTime? reviewedAt,
  }) => ProphetDatasetReviewEvidence(
        canonicalId: 'ibrahim',
        contentVersion: version,
        religiousReview: religious,
        turkishNativeReview: tr,
        englishNativeReview: en,
        arabicNativeReview: ar,
        terminologyReview: terminology,
        reviewedAt: reviewedAt ?? DateTime.utc(2026, 8, 30, 13),
        religiousReviewerId: 'religious-review-01',
        turkishReviewerId: 'tr-native-01',
        englishReviewerId: 'en-native-01',
        arabicReviewerId: 'ar-native-01',
        terminologyReviewerId: 'terminology-review-01',
      );

  const gate = ProphetDatasetReviewGate();

  test('accepts exact canonical terminology with current full review', () {
    final approved = gate.approve(
      records: [ibrahim()],
      evidence: [approvedEvidence()],
    );
    expect(approved, hasLength(1));
    expect(approved.single.canonicalId, 'ibrahim');
  });

  test('rejects pending native language review', () {
    expect(
      () => gate.approve(
        records: [ibrahim()],
        evidence: [approvedEvidence(ar: ProphetReviewDecision.pending)],
      ),
      throwsStateError,
    );
  });

  test('rejects stale review after biography version changes', () {
    expect(
      () => gate.approve(
        records: [ibrahim(version: 4)],
        evidence: [approvedEvidence(version: 3)],
      ),
      throwsStateError,
    );
  });

  test('rejects review timestamp older than the content edit', () {
    expect(
      () => gate.approve(
        records: [ibrahim()],
        evidence: [
          approvedEvidence(reviewedAt: DateTime.utc(2026, 8, 30, 11)),
        ],
      ),
      throwsStateError,
    );
  });

  test('rejects TR transliteration drift from canonical registry', () {
    expect(
      () => gate.approve(
        records: [
          ibrahim(
            name: const LocalizedReligiousText(
              tr: 'İbrahim',
              en: 'Abraham',
              ar: 'إبراهيم',
            ),
          ),
        ],
        evidence: [approvedEvidence()],
      ),
      throwsStateError,
    );
  });

  test('rejects English alias drift even when other languages match', () {
    expect(
      () => gate.approve(
        records: [
          ibrahim(
            name: const LocalizedReligiousText(
              tr: 'İbrâhim',
              en: 'Ibrahim',
              ar: 'إبراهيم',
            ),
          ),
        ],
        evidence: [approvedEvidence()],
      ),
      throwsStateError,
    );
  });

  test('rejects Arabic spelling drift from canonical identity', () {
    expect(
      () => gate.approve(
        records: [ibrahim(arabicName: 'ابراهيم')],
        evidence: [approvedEvidence()],
      ),
      throwsStateError,
    );
  });

  test('rejects duplicate review evidence', () {
    expect(
      () => gate.approve(
        records: [ibrahim()],
        evidence: [approvedEvidence(), approvedEvidence()],
      ),
      throwsStateError,
    );
  });
}
