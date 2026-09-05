import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/dhikr/domain/dhikr_progress_policy.dart';

void main() {
  group('DhikrProgressPolicy', () {
    test('allows only private personal progress surfaces', () {
      expect(
        DhikrProgressPolicy.isAllowed(DhikrProgressSurface.localDailyTotal),
        isTrue,
      );
      expect(
        DhikrProgressPolicy.isAllowed(DhikrProgressSurface.localWeeklyTotal),
        isTrue,
      );
      expect(
        DhikrProgressPolicy.isAllowed(DhikrProgressSurface.personalStreak),
        isTrue,
      );
    });

    test('fails closed for competitive and guilt-inducing surfaces', () {
      for (final surface in const [
        DhikrProgressSurface.leaderboard,
        DhikrProgressSurface.peerComparison,
        DhikrProgressSurface.missedDayGuilt,
      ]) {
        expect(DhikrProgressPolicy.isAllowed(surface), isFalse);
        expect(
          () => DhikrProgressPolicy.requireAllowed(surface),
          throwsStateError,
        );
      }
    });
  });
}
