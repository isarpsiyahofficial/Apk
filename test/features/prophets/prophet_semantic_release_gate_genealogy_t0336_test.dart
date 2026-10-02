import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 release gate genealogy/chronology binding', () {
    test('canonical gate consumes reviewed genealogy and chronology audits', () {
      final result = auditProphetSemanticReleaseGateT0336();

      expect(result.isValid, isTrue, reason: result.errors.join('\n'));
      expect(
        result.errors.where((error) => error.contains('genealogy')),
        isEmpty,
      );
    });

    test('invalid reviewed genealogy fails closed even when slot views agree', () {
      final result = auditProphetSemanticReleaseGateT0336(
        familyGraphValid: false,
        familyChronologyConsistent: true,
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains('T0336 reviewed prophet genealogy graph is invalid'),
      );
    });

    test('chronology contradiction fails closed even with a valid graph', () {
      final result = auditProphetSemanticReleaseGateT0336(
        familyGraphValid: true,
        familyChronologyConsistent: false,
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(
          'T0336 reviewed prophet genealogy contradicts approximate chronology',
        ),
      );
    });

    test('both genealogy failures remain independently visible', () {
      final result = auditProphetSemanticReleaseGateT0336(
        familyGraphValid: false,
        familyChronologyConsistent: false,
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors.where((error) => error.startsWith('T0336 reviewed prophet genealogy')),
        hasLength(2),
      );
    });
  });
}
