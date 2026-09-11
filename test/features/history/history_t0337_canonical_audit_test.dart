import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0337_canonical_audit.dart';

void main() {
  group('T0337 canonical early-caliphate audit', () {
    test('real T0220 early-caliphate events have two independent work families', () {
      final result = auditEarlyCaliphateT0337();

      expect(result.eventCount, 5);
      expect(result.contestedEventCount, 1);
    });

    test('source registry records three explicit underlying works', () {
      expect(earlyCaliphateT0337SourceIdentities, hasLength(3));
      expect(
        earlyCaliphateT0337SourceIdentities
            .map((source) => source.independenceFamily)
            .toSet(),
        hasLength(3),
      );
    });
  });
}
