import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/data/history_t0337_canonical_audit.dart';
import 'package:islami_hayat/features/history/data/history_t0337_coverage.dart';
import 'package:islami_hayat/features/history/data/muhammad_period_events_t0220.dart';

void main() {
  group('T0337 aggregate canonical coverage', () {
    test('audited tracks cover the exact T0220 inventory', () {
      final report = buildHistoryT0337CoverageReport();

      expect(report.auditedTrackCount, 7);
      expect(report.auditedEventCount, 47);
      expect(report.canonicalEventCount, historyT0220Inventory.events.length);
      expect(report.auditedEventCount, report.canonicalEventCount);
      expect(report.missingEventIds, isEmpty);
      expect(report.isComplete, isTrue);
      expect(report.requireComplete, returnsNormally);
    });

    test('all Muhammad events are independently reviewed', () {
      final report = buildHistoryT0337CoverageReport();
      final muhammadIds =
          muhammadPeriodEventsT0220.events.map((event) => event.id).toSet();

      expect(muhammadPartialT0337EventIds, hasLength(19));
      expect(muhammadPartialT0337EventIds, equals(muhammadIds));
      expect(report.missingEventIds, isEmpty);
      expect(report.auditedEventIds, containsAll(muhammadIds));
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

    test('incomplete exact coverage still fails the release assertion', () {
      final report = HistoryT0337CoverageReport.validated(
        canonicalEventIds: const ['a', 'b'],
        auditedTrackEventIds: const [
          ['a'],
        ],
      );

      expect(report.isComplete, isFalse);
      expect(report.missingEventIds, equals({'b'}));
      expect(() => report.requireComplete(), throwsStateError);
    });
  });
}
