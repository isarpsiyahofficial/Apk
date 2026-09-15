import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_motion_policy_t0252.dart';

void main() {
  group('T0252 V1 motion and music feature gates', () {
    test('still-image export remains available in V1', () {
      const policy = ShareMotionPolicyT0252.v1;

      expect(policy.canExport(ShareExportModeT0252.stillImage), isTrue);
      expect(
        () => policy.requireExportAllowed(ShareExportModeT0252.stillImage),
        returnsNormally,
      );
    });

    test('Reels motion export is fail-closed in V1', () {
      const policy = ShareMotionPolicyT0252.v1;

      expect(policy.reelsMotionExportEnabled, isFalse);
      expect(policy.canExport(ShareExportModeT0252.reelsMotion), isFalse);
      expect(
        () => policy.requireExportAllowed(ShareExportModeT0252.reelsMotion),
        throwsA(isA<StateError>()),
      );
    });

    test('V1 never embeds music even when rights would otherwise be known', () {
      const policy = ShareMotionPolicyT0252.v1;

      expect(policy.embeddedMusicEnabled, isFalse);
      expect(
        policy.canEmbedMusic(hasDocumentedRedistributionRights: true),
        isFalse,
      );
      expect(
        () => policy.requireMusicEmbeddingAllowed(
          hasDocumentedRedistributionRights: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('missing redistribution rights always blocks embedded music', () {
      const policy = ShareMotionPolicyT0252.v1;

      expect(
        policy.canEmbedMusic(hasDocumentedRedistributionRights: false),
        isFalse,
      );
      expect(
        () => policy.requireMusicEmbeddingAllowed(
          hasDocumentedRedistributionRights: false,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
