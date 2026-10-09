import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/core_content_offline_policy.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

void main() {
  group('T0264 PRO offline core access', () {
    test('cached PRO can open every required core area offline', () {
      for (final area in CoreContentOfflinePolicy.requiredProOfflineAreas) {
        expect(
          CoreContentOfflinePolicy.canOpenOffline(
            entitlement: const EntitlementState.cachedPro(),
            area: area,
          ),
          isTrue,
          reason: '${area.name} must remain available to cached PRO offline',
        );
      }
    });

    test('verified PRO can open every required core area offline', () {
      for (final area in CoreContentArea.values) {
        expect(
          CoreContentOfflinePolicy.canOpenOffline(
            entitlement: const EntitlementState.verifiedPro(),
            area: area,
          ),
          isTrue,
        );
      }
    });

    test('FREE never receives the PRO offline core bypass', () {
      for (final area in CoreContentArea.values) {
        expect(
          CoreContentOfflinePolicy.canOpenOffline(
            entitlement: const EntitlementState.free(),
            area: area,
          ),
          isFalse,
        );
      }
    });

    test('requireOfflineAccess fails closed for FREE', () {
      expect(
        () => CoreContentOfflinePolicy.requireOfflineAccess(
          entitlement: const EntitlementState.free(),
          area: CoreContentArea.quran,
        ),
        throwsStateError,
      );
    });

    test('the required PRO offline set covers every declared core area', () {
      expect(
        CoreContentOfflinePolicy.requiredProOfflineAreas,
        containsAll(CoreContentArea.values),
      );
      expect(
        CoreContentOfflinePolicy.requiredProOfflineAreas.length,
        CoreContentArea.values.length,
      );
    });
  });
}
