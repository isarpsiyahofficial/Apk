import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';

const _themeId = 'patience';

QuranThemeReviewEvidence _evidence({
  required QuranThemeReviewKind kind,
  int revision = QuranThemeTaxonomy.revision,
  QuranThemeReviewDecision decision = QuranThemeReviewDecision.approved,
  String themeId = _themeId,
  String reviewerId = 'reviewer-1',
  String reviewedAtUtc = '2026-09-03T05:30:00Z',
}) =>
    QuranThemeReviewEvidence(
      themeId: themeId,
      taxonomyRevision: revision,
      kind: kind,
      decision: decision,
      reviewerId: reviewerId,
      reviewedAtUtc: reviewedAtUtc,
    );

List<QuranThemeReviewEvidence> _completeEvidence() =>
    QuranThemeReviewKind.values.map((kind) => _evidence(kind: kind)).toList();

QuranThemeDefinition _approvedTheme({
  int revision = QuranThemeTaxonomy.revision,
  List<QuranThemeReviewEvidence>? evidence,
}) =>
    QuranThemeDefinition(
      id: _themeId,
      labelTr: 'Sabır',
      labelEn: 'Patience',
      labelAr: 'الصبر',
      reviewStatus: QuranThemeReviewStatus.approved,
      taxonomyRevision: revision,
      reviewEvidence: evidence ?? _completeEvidence(),
    );

void main() {
  group('T0150 Quran theme production review gate', () {
    test('bare approved enum is not enough to publish a theme', () {
      const theme = QuranThemeDefinition(
        id: _themeId,
        labelTr: 'Sabır',
        labelEn: 'Patience',
        labelAr: 'الصبر',
        reviewStatus: QuranThemeReviewStatus.approved,
      );

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });

    test('exact revision with religious expert and TR EN AR approvals passes', () {
      final theme = _approvedTheme();

      expect(theme.hasCompleteReviewEvidence, isTrue);
      expect(theme.isProductionReady, isTrue);
    });

    test('missing Arabic native review fails closed', () {
      final evidence = _completeEvidence()
          .where((item) => item.kind != QuranThemeReviewKind.nativeArabic)
          .toList();
      final theme = _approvedTheme(evidence: evidence);

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });

    test('old taxonomy revision evidence cannot authorize current labels', () {
      final evidence = QuranThemeReviewKind.values
          .map((kind) => _evidence(kind: kind, revision: QuranThemeTaxonomy.revision - 1))
          .toList();
      final theme = _approvedTheme(evidence: evidence);

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });

    test('duplicate review kind fails closed instead of masking a missing reviewer', () {
      final evidence = _completeEvidence();
      evidence
        ..removeWhere((item) => item.kind == QuranThemeReviewKind.nativeArabic)
        ..add(_evidence(kind: QuranThemeReviewKind.nativeEnglish, reviewerId: 'reviewer-2'));
      final theme = _approvedTheme(evidence: evidence);

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });

    test('pending, rejected, blank-reviewer and non-UTC evidence all fail closed', () {
      final invalidEvidence = <QuranThemeReviewEvidence>[
        _evidence(kind: QuranThemeReviewKind.religiousExpert),
        _evidence(
          kind: QuranThemeReviewKind.nativeTurkish,
          decision: QuranThemeReviewDecision.pending,
        ),
        _evidence(
          kind: QuranThemeReviewKind.nativeEnglish,
          reviewerId: '   ',
        ),
        _evidence(
          kind: QuranThemeReviewKind.nativeArabic,
          reviewedAtUtc: '2026-09-03T08:30:00+03:00',
        ),
      ];
      final theme = _approvedTheme(evidence: invalidEvidence);

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });

    test('review evidence for another theme cannot be replayed', () {
      final evidence = _completeEvidence();
      evidence[0] = _evidence(
        kind: QuranThemeReviewKind.religiousExpert,
        themeId: 'hope',
      );
      final theme = _approvedTheme(evidence: evidence);

      expect(theme.hasCompleteReviewEvidence, isFalse);
      expect(theme.isProductionReady, isFalse);
    });
  });
}