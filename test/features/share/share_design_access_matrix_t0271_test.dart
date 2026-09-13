import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';
import 'package:islami_hayat/features/share/domain/share_design_access_matrix_t0271.dart';

void main() {
  group('ShareDesignAccessMatrixT0271', () {
    test('contains exactly Canva-001..Canva-100 without gaps or duplicates', () {
      final entries = ShareDesignAccessMatrixT0271.entries;

      expect(entries, hasLength(100));
      expect(entries.map((entry) => entry.designId).toSet(), hasLength(100));
      expect(entries.first.designId, 'Canva-001');
      expect(entries.last.designId, 'Canva-100');

      for (var index = 0; index < 100; index++) {
        expect(
          entries[index].designId,
          'Canva-${(index + 1).toString().padLeft(3, '0')}',
        );
      }
    });

    test('FREE matrix is exactly 3 permanent free plus 97 rewarded-required', () {
      final freeEntries = ShareDesignAccessMatrixT0271.entries
          .where(
            (entry) =>
                entry.accessFor(isPro: false) ==
                ShareDesignAccessT0271.permanentFree,
          )
          .toList(growable: false);
      final rewardedEntries = ShareDesignAccessMatrixT0271.entries
          .where(
            (entry) =>
                entry.accessFor(isPro: false) ==
                ShareDesignAccessT0271.rewardedRequired,
          )
          .toList(growable: false);

      expect(freeEntries.map((entry) => entry.designId), <String>[
        'Canva-001',
        'Canva-002',
        'Canva-003',
      ]);
      expect(rewardedEntries, hasLength(97));
      expect(rewardedEntries.first.designId, 'Canva-004');
      expect(rewardedEntries.last.designId, 'Canva-100');
    });

    test('PRO receives unlimited access to all 100 and never rewarded access', () {
      for (final entry in ShareDesignAccessMatrixT0271.entries) {
        expect(
          entry.accessFor(isPro: true),
          ShareDesignAccessT0271.proUnlimited,
          reason: entry.designId,
        );
      }
    });

    test('matrix agrees with T0269 runtime gate for every design slot', () {
      for (final entry in ShareDesignAccessMatrixT0271.entries) {
        final freeGate = RewardedShareUnlockT0269(
          designId: entry.designId,
          isPro: false,
        );
        final proGate = RewardedShareUnlockT0269(
          designId: entry.designId,
          isPro: true,
        );

        final expectedFreeDecision = entry.freeAccess ==
                ShareDesignAccessT0271.permanentFree
            ? ShareUnlockDecisionT0269.allowedFree
            : ShareUnlockDecisionT0269.rewardRequired;

        expect(
          freeGate.currentDecision(),
          expectedFreeDecision,
          reason: entry.designId,
        );
        expect(
          proGate.currentDecision(),
          ShareUnlockDecisionT0269.allowedPro,
          reason: entry.designId,
        );
        expect(proGate.shouldOfferRewarded, isFalse, reason: entry.designId);
      }
    });

    test('locked FREE design becomes one-shot only after completed reward', () {
      final unlock = RewardedShareUnlockT0269(
        designId: 'Canva-100',
        isPro: false,
      );

      expect(unlock.currentDecision(), ShareUnlockDecisionT0269.rewardRequired);
      expect(unlock.consumeSingleShareRight(), isFalse);

      expect(
        unlock.applyRewardedResult(RewardedAdResultT0269.completed),
        ShareUnlockDecisionT0269.allowedSingleRewardedShare,
      );
      expect(unlock.consumeSingleShareRight(), isTrue);
      expect(unlock.consumeSingleShareRight(), isFalse);
      expect(unlock.currentDecision(), ShareUnlockDecisionT0269.rewardRequired);
    });

    test('invalid ids fail closed instead of aliasing a valid design slot', () {
      for (final invalidId in <String>[
        'Canva-000',
        'Canva-101',
        'Canva-01',
        'canva-001',
        'Canva-001-extra',
        '',
      ]) {
        expect(
          () => ShareDesignAccessMatrixT0271.entryFor(invalidId),
          throwsArgumentError,
          reason: invalidId,
        );
      }
    });
  });
}
