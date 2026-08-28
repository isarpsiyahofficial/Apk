import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_dataset_review.dart';

SourceReference _source() => const SourceReference(
  id: 'quran-fixture',
  title: 'Quran fixture',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'test-license',
);

DuaContent _dua({int version = 1}) => DuaContent(
  id: 'dua-1',
  sourceStatus: DuaSourceStatus.quran,
  lengthClass: DuaLengthClass.short,
  categories: const {DuaCategory.morning},
  text: const LocalizedReligiousText(
    tr: 'Doğrulanmış dua metni',
    en: 'Verified dua text',
    ar: 'نص دعاء موثق',
  ),
  reviewStatus: ContentReviewStatus.published,
  version: version,
  lastReviewedAt: DateTime.utc(2026, 8, 28),
  sources: [_source()],
);

DuaDatasetReviewEvidence _review({
  int version = 1,
  DuaReviewDecision religious = DuaReviewDecision.approved,
  DuaReviewDecision tr = DuaReviewDecision.approved,
  DuaReviewDecision en = DuaReviewDecision.approved,
  DuaReviewDecision ar = DuaReviewDecision.approved,
}) => DuaDatasetReviewEvidence(
  duaId: 'dua-1',
  contentVersion: version,
  religiousReview: religious,
  turkishNativeReview: tr,
  englishNativeReview: en,
  arabicNativeReview: ar,
  reviewedAt: DateTime.utc(2026, 8, 28),
  religiousReviewerId: 'religious-reviewer',
  turkishReviewerId: 'tr-native-reviewer',
  englishReviewerId: 'en-native-reviewer',
  arabicReviewerId: 'ar-native-reviewer',
);

void main() {
  const gate = DuaDatasetReviewGate();

  test('approves only exact version after religious and all native reviews', () {
    final result = gate.approve(records: [_dua()], evidence: [_review()]);

    expect(result, hasLength(1));
    expect(result.single.id, 'dua-1');
  });

  test('fails closed when any native language review is pending', () {
    expect(
      () => gate.approve(
        records: [_dua()],
        evidence: [_review(ar: DuaReviewDecision.pending)],
      ),
      throwsStateError,
    );
  });

  test('fails closed when religious review is rejected', () {
    expect(
      () => gate.approve(
        records: [_dua()],
        evidence: [_review(religious: DuaReviewDecision.rejected)],
      ),
      throwsStateError,
    );
  });

  test('editing content version invalidates prior review evidence', () {
    expect(
      () => gate.approve(records: [_dua(version: 2)], evidence: [_review()]),
      throwsStateError,
    );
  });

  test('missing and duplicate evidence cannot silently pass', () {
    expect(
      () => gate.approve(records: [_dua()], evidence: const []),
      throwsStateError,
    );
    expect(
      () => gate.approve(records: [_dua()], evidence: [_review(), _review()]),
      throwsStateError,
    );
  });
}
