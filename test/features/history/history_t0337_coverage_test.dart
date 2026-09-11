import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/data/history_t0337_canonical_audit.dart';
import 'package:islami_hayat/features/history/data/history_t0337_coverage.dart';
import 'package:islami_hayat/features/history/data/muhammad_period_events_t0220.dart';

void main() {
  group('T0337 aggregate canonical coverage', () {
    test('audited tracks are measured against the exact T0220 inventory', () {
      final report = buildHistoryT0337CoverageReport();

      expect(report.auditedTrackCount, 7);
      expect(report.auditedEventCount, 33);
      expect(report.canonicalEventCount, historyT0220Inventory.events.length);
      expect(
        report.auditedEventIds.length + report.missingEventIds.length,
        report.canonicalEventCount,
      );
      expect(report.isComplete, isFalse);
    });

    test('only independently reviewed Muhammad events are removed from the open gap', () {
      final report = buildHistoryT0337CoverageReport();
      final muhammadIds =
          muhammadPeriodEventsT0220.events.map((event) => event.id).toSet();
      final expectedMissing = muhammadIds.difference(muhammadPartialT0337EventIds);

      expect(report.missingEventIds, equals(expectedMissing));
      expect(report.missingEventIds, isNotEmpty);
      expect(report.auditedEventIds, containsAll(muhammadPartialT0337EventIds));
      expect(() => report.requireComplete(), throwsStateError);
    });

    test('duplicate coverage across audited tracks fails closed', () {
      expect(
        () => HistoryT0337CoverageReport.validated(
          canonicalEventIds: const ['a', 'b'],
          auditedTrackEventIds: const [
            ['a'],
            ['a'],
          ],
        ),
        throwsStateError,
      );
    });

    test('coverage outside canonical inventory fails closed', () {
      expect(
        () => HistoryT0337CoverageReport.validated(
          canonicalEventIds: const ['a'],
          auditedTrackEventIds: const [
            ['a', 'synthetic'],
          ],
        ),
        throwsStateError,
      );
    });

    test('complete exact coverage can pass the generic release assertion', () {
      final report = HistoryT0337CoverageReport.validated(
        canonicalEventIds: const ['a', 'b'],
        auditedTrackEventIds: const [
          ['a'],
          ['b'],
        ],
      );

      expect(report.isComplete, isTrue);
      expect(report.missingEventIds, isEmpty);
      expect(report.requireComplete, returnsNormally);
    });
  });
}
