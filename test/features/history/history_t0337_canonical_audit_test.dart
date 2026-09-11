import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0337_canonical_audit.dart';

void main() {
  group('T0337 canonical history audit', () {
    test('real T0220 early-caliphate events have two independent work families', () {
      final result = auditEarlyCaliphateT0337();

      expect(result.eventCount, 5);
      expect(result.contestedEventCount, 2);
    });

    test('early-caliphate registry records three explicit underlying works', () {
      expect(earlyCaliphateT0337SourceIdentities, hasLength(3));
      expect(
        earlyCaliphateT0337SourceIdentities
            .map((source) => source.independenceFamily)
            .toSet(),
        hasLength(3),
      );
    });

    test('real T0214/T0220 medieval events pass work-family independence gate', () {
      final result = auditMedievalT0214T0337();

      expect(result.eventCount, 6);
    });

    test('T0214 registry preserves every reviewed work family', () {
      expect(medievalT0214T0337SourceIdentities, hasLength(10));
      expect(
        medievalT0214T0337SourceIdentities
            .map((source) => source.independenceFamily)
            .toSet(),
        hasLength(10),
      );
    });

    test('real T0215/T0220 high-medieval events pass work-family independence gate', () {
      final result = auditHighMedievalT0215T0337();

      expect(result.eventCount, 5);
    });

    test('T0215 registry preserves every reviewed work family', () {
      expect(
        highMedievalT0215T0337SourceIdentities.length,
        highMedievalT0215T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet()
            .length,
      );
      expect(
        highMedievalT0215T0337SourceIdentities.length,
        highMedievalT0215T0337SourceIdentities
            .map((source) => source.independenceFamily)
            .toSet()
            .length,
      );
    });
  });
}
