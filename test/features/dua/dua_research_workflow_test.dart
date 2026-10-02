import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_research_workflow.dart';

const _verifiedText = LocalizedReligiousText(
  tr: 'Doğrulanmış metin',
  en: 'Verified text',
  ar: 'نص موثق',
);

const _editorialText = LocalizedReligiousText(
  tr: 'Yeni editoryal dua',
  en: 'New editorial dua',
  ar: 'دعاء تحريري جديد',
);

DuaResearchCandidate _candidate({
  DuaResearchStage stage = DuaResearchStage.captured,
}) => DuaResearchCandidate(
  id: 'candidate-1',
  discoveryOrigin: 'social-media-research-only',
  capturedText: 'Untrusted popular wording',
  claimedAttribution: 'Claimed prophetic attribution',
  stage: stage,
);

SourceReference _source(ReligiousSourceClass sourceClass) => SourceReference(
  id: 'verified-source',
  title: 'Verified source fixture',
  sourceClass: sourceClass,
  licenseId: 'fixture-license',
);

void main() {
  test('captured candidate cannot skip source verification', () {
    final candidate = _candidate();

    expect(
      () => candidate.createSourceVerifiedResearchDraft(
        sourceStatus: DuaSourceStatus.quran,
        lengthClass: DuaLengthClass.short,
        categories: const {DuaCategory.morning},
        verifiedText: _verifiedText,
        verifiedSources: [_source(ReligiousSourceClass.quran)],
        version: 1,
        reviewedAt: DateTime.utc(2026, 8, 28),
      ),
      throwsStateError,
    );
  });

  test('verified source path still returns research status, never published', () {
    final candidate = _candidate().beginSourceVerification();
    final draft = candidate.createSourceVerifiedResearchDraft(
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: const {DuaCategory.morning},
      verifiedText: _verifiedText,
      verifiedSources: [_source(ReligiousSourceClass.quran)],
      version: 1,
      reviewedAt: DateTime.utc(2026, 8, 28),
    );

    expect(draft.reviewStatus, ContentReviewStatus.research);
    expect(draft.canEnterProductionDataset, isFalse);
    expect(draft.sourceStatus, DuaSourceStatus.quran);
  });

  test('source status must match verified source class', () {
    final candidate = _candidate().beginSourceVerification();

    expect(
      () => candidate.createSourceVerifiedResearchDraft(
        sourceStatus: DuaSourceStatus.sahihHasanSunnah,
        lengthClass: DuaLengthClass.short,
        categories: const {DuaCategory.morning},
        verifiedText: _verifiedText,
        verifiedSources: [_source(ReligiousSourceClass.quran)],
        version: 1,
        reviewedAt: DateTime.utc(2026, 8, 28),
        hadithReference: 'fixture:1',
        hadithGrade: 'sahih',
      ),
      throwsStateError,
    );
  });

  test('unverified candidate can be rejected only with an explicit reason', () {
    final candidate = _candidate().beginSourceVerification();

    expect(() => candidate.reject(reason: ''), throwsStateError);

    final rejected = candidate.reject(reason: 'No reliable source found');
    expect(rejected.stage, DuaResearchStage.rejected);
    expect(rejected.researchNote, 'No reliable source found');
  });

  test('editorial rewrite is a fresh unattributed non-production draft', () {
    final candidate = _candidate().beginSourceVerification();
    final draft = candidate.createGeneralEditorialRewriteDraft(
      lengthClass: DuaLengthClass.short,
      categories: const {DuaCategory.peace},
      rewrittenText: _editorialText,
      editorialSource: _source(ReligiousSourceClass.meaningBasedDua),
      version: 1,
      draftedAt: DateTime.utc(2026, 8, 28),
    );

    expect(draft.sourceStatus, DuaSourceStatus.generalEditorial);
    expect(draft.reviewStatus, ContentReviewStatus.draft);
    expect(draft.requiresEditorialDisclaimer, isTrue);
    expect(draft.hadithReference, isNull);
    expect(draft.hadithGrade, isNull);
    expect(draft.canEnterProductionDataset, isFalse);
    expect(draft.id, 'candidate-1-editorial');
  });

  test('editorial rewrite requires meaning-based source and all three languages', () {
    final candidate = _candidate().beginSourceVerification();
    const incomplete = LocalizedReligiousText(
      tr: 'Yeni dua',
      en: 'New dua',
      ar: '',
    );

    expect(
      () => candidate.createGeneralEditorialRewriteDraft(
        lengthClass: DuaLengthClass.short,
        categories: const {DuaCategory.peace},
        rewrittenText: incomplete,
        editorialSource: _source(ReligiousSourceClass.meaningBasedDua),
        version: 1,
        draftedAt: DateTime.utc(2026, 8, 28),
      ),
      throwsStateError,
    );
    expect(
      () => candidate.createGeneralEditorialRewriteDraft(
        lengthClass: DuaLengthClass.short,
        categories: const {DuaCategory.peace},
        rewrittenText: _editorialText,
        editorialSource: _source(ReligiousSourceClass.classicalTraditional),
        version: 1,
        draftedAt: DateTime.utc(2026, 8, 28),
      ),
      throwsStateError,
    );
  });
}
