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
            .map((s) => s.independenceFamily)
            .toSet(),
        hasLength(3),
      );
    });

    test('Muhammad partial audit includes only independently reviewed canonical events', () {
      final result = auditMuhammadPartialT0337();
      expect(result.eventCount, 9);
      expect(muhammadPartialT0337EventIds, hasLength(9));
      expect(muhammadPartialT0337Corroborations, hasLength(6));
      expect(
        muhammadPartialT0337SourceIdentities
            .map((s) => s.independenceFamily)
            .toSet(),
        equals({
          'primary:quran',
          'primary:sahih-al-bukhari',
          'primary:sahih-muslim',
        }),
      );
      expect(
        muhammadPartialT0337Corroborations.map((c) => c.locator).toSet(),
        equals({
          'Sahih al-Bukhari 3992',
          'Sahih al-Bukhari 4843',
          'Sahih al-Bukhari 4770',
          'Sahih Muslim 1783a',
          'Sahih Muslim 1780c',
          'Sahih Muslim 1218b',
        }),
      );
    });

    test('new corroborations stay scoped to their exact Muhammad events', () {
      final eventToLocator = {
        for (final evidence in muhammadPartialT0337Corroborations)
          evidence.eventId: evidence.locator,
      };

      expect(
        eventToLocator['history:muhammad-meccan-nearest-kindred'],
        'Sahih al-Bukhari 4770',
      );
      expect(
        eventToLocator['history:muhammad-hudaybiyyah-treaty'],
        'Sahih Muslim 1783a',
      );
      expect(
        eventToLocator['history:muhammad-conquest-mecca'],
        'Sahih Muslim 1780c',
      );
      expect(
        eventToLocator['history:muhammad-farewell-pilgrimage'],
        'Sahih Muslim 1218b',
      );
    });

    test('real T0214/T0220 medieval events pass work-family independence gate', () {
      expect(auditMedievalT0214T0337().eventCount, 6);
    });

    test('T0214 registry preserves every reviewed source identity', () {
      expect(medievalT0214T0337SourceIdentities, hasLength(10));
      expect(
        medievalT0214T0337SourceIdentities.map((s) => s.sourceId).toSet(),
        hasLength(medievalT0214T0337SourceIdentities.length),
      );
    });

    test('real T0215/T0220 high-medieval events pass work-family independence gate', () {
      expect(auditHighMedievalT0215T0337().eventCount, 5);
    });

    test('real T0216/T0220 early-modern events pass work-family independence gate', () {
      expect(auditEarlyModernT0216T0337().eventCount, 3);
    });

    test('real T0217/T0220 regional events pass work-family independence gate', () {
      expect(auditRegionalT0217T0337().eventCount, 5);
    });

    test('T0217 keeps source IDs unique while allowing work-family reuse', () {
      expect(
        regionalT0217T0337SourceIdentities.map((s) => s.sourceId).toSet(),
        hasLength(regionalT0217T0337SourceIdentities.length),
      );
      expect(
        regionalT0217T0337SourceIdentities
                .map((s) => s.independenceFamily)
                .toSet()
                .length <
            regionalT0217T0337SourceIdentities.length,
        isTrue,
      );
    });

    test('real T0218/T0220 modern-global events pass work-family independence gate', () {
      expect(auditModernGlobalT0218T0337().eventCount, 4);
    });
  });
}
