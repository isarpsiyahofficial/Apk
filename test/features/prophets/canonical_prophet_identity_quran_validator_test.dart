import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_identity_quran_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('T0191 canonical prophet Quran identity anchors', () {
    test('all 25 canonical identities resolve to verses that explicitly name them', () async {
      const validator = CanonicalProphetIdentityQuranValidator();
      final result = await validator.validateBundled();

      expect(result.identityCount, 25);
      expect(result.validatedAnchorCount, 25);
    });
  });
}
