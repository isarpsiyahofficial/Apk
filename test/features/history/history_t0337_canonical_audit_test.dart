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

    test('Muhammad audit covers all canonical events with independent families', () {
      final result = auditMuhammadPartialT0337();
      expect(result.eventCount, 19);
      expect(muhammadPartialT0337EventIds, hasLength(19));
      expect(muhammadPartialT0337Corroborations, hasLength(16));
      expect(
        muhammadPartialT0337SourceIdentities
            .map((s) => s.independenceFamily)
            .toSet(),
        equals({
          'primary:quran',
          'primary:sahih-al-bukhari',
          'primary:sahih-muslim',
          'primary:sunan-abi-dawud',
          'primary:sunan-ibn-majah',
        }),
      );
      expect(
        muhammadPartialT0337Corroborations.map((c) => c.locator).toSet(),
        containsAll({
          'Sahih Muslim 1709d',
          'Sahih Muslim 1376a',
        }),
      );
    });

    test('Aqaba and Medina evidence stay scoped to their exact events', () {
      final eventToLocator = {
        for (final evidence in muhammadPartialT0337Corroborations)
          evidence.eventId: evidence.locator,
      };

      expect(
        eventToLocator['history:muhammad-aqaba-pledge'],
        'Sahih Muslim 1709d',
      );
      expect(
        eventToLocator['history:muhammad-medina-arrival'],
        'Sahih Muslim 1376a',
      );
    });

    test('Aqaba uses a source family independent from canonical Bukhari', () {
      final aqabaFamilies = muhammadPartialT0337SourceIdentities
          .where(
            (source) =>
                source.sourceId == 'bukhari-3893-seerah-aqaba' ||
                source.sourceId == 'muslim-1709d-t0337-aqaba',
          )
          .map((source) => source.independenceFamily)
          .toSet();
      expect(aqabaFamilies, hasLength(2));
    });

    test('Medina arrival uses a source family independent from canonical Bukhari', () {
      final medinaFamilies = muhammadPartialT0337SourceIdentities
          .where(
            (source) =>
                source.sourceId == 'bukhari-3925-seerah-medina' ||
                source.sourceId == 'muslim-1376a-t0337-medina-arrival',
          )
          .map((source) => source.independenceFamily)
          .toSet();
      expect(medinaFamilies, hasLength(2));
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
