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

    test('T0214 registry preserves every reviewed source identity', () {
      expect(medievalT0214T0337SourceIdentities, hasLength(10));
      expect(
        medievalT0214T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet(),
        hasLength(medievalT0214T0337SourceIdentities.length),
      );
    });

    test('real T0215/T0220 high-medieval events pass work-family independence gate', () {
      final result = auditHighMedievalT0215T0337();

      expect(result.eventCount, 5);
    });

    test('T0215 registry preserves every reviewed source identity', () {
      expect(
        highMedievalT0215T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet(),
        hasLength(highMedievalT0215T0337SourceIdentities.length),
      );
      expect(
        highMedievalT0215T0337SourceIdentities.every(
          (source) => source.independenceFamily.startsWith('work:'),
        ),
        isTrue,
      );
    });

    test('real T0216/T0220 early-modern events pass work-family independence gate', () {
      final result = auditEarlyModernT0216T0337();

      expect(result.eventCount, 3);
    });

    test('T0216 registry preserves every reviewed source identity', () {
      expect(
        earlyModernT0216T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet(),
        hasLength(earlyModernT0216T0337SourceIdentities.length),
      );
    });

    test('real T0217/T0220 regional events pass work-family independence gate', () {
      final result = auditRegionalT0217T0337();

      expect(result.eventCount, 5);
    });

    test('T0217 keeps source IDs unique while allowing deliberate work-family reuse', () {
      expect(
        regionalT0217T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet(),
        hasLength(regionalT0217T0337SourceIdentities.length),
      );
      expect(
        regionalT0217T0337SourceIdentities
                .map((source) => source.independenceFamily)
                .toSet()
                .length <
            regionalT0217T0337SourceIdentities.length,
        isTrue,
      );
    });

    test('real T0218/T0220 modern-global events pass work-family independence gate', () {
      final result = auditModernGlobalT0218T0337();

      expect(result.eventCount, 4);
    });

    test('T0218 registry preserves every reviewed source identity', () {
      expect(
        modernGlobalT0218T0337SourceIdentities
            .map((source) => source.sourceId)
            .toSet(),
        hasLength(modernGlobalT0218T0337SourceIdentities.length),
      );
      expect(
        modernGlobalT0218T0337SourceIdentities.every(
          (source) => source.independenceFamily.startsWith('work:'),
        ),
        isTrue,
      );
    });
  });
}
