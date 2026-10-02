import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/data/prophet_map_markers.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_map_target_adapter_t0202.dart';

const _reviewedSource = SourceReference(
  id: 'modern-history-map-source',
  title: 'Reviewed historical geography source',
  sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
  licenseId: 'REFERENCE-ONLY',
  locator: 'pp. 10-12',
);

const _reviewedExactGeography = ProphetGeography(
  name: LocalizedReligiousText(
    tr: 'Test konumu',
    en: 'Test location',
    ar: 'موقع اختباري',
  ),
  precision: ProphetLocationPrecision.exact,
  certainty: CertaintyLevel.explicitSource,
  sources: <SourceReference>[_reviewedSource],
  latitude: 29.9792,
  longitude: 31.1342,
);

void main() {
  group('T0202 ProphetMapTargetAdapter', () {
    test('resolves only exact prophet + stable target ID', () async {
      final target = ProphetMapTargetT0202.validated(
        prophetId: 'musa',
        targetId: 'musa-reviewed-map-1',
        geography: _reviewedExactGeography,
      );
      final adapter = ProphetMapTargetAdapterT0202([target]);
      final link = ProphetDeepLink.map(
        prophetId: 'musa',
        mapLocationId: 'musa-reviewed-map-1',
      );

      final resolved = adapter.resolve(link);
      expect(resolved, same(target));
      expect(resolved!.marker.kind, ProphetMapMarkerKind.exactPoint);

      String? openedId;
      final opened = await adapter.open(
        link,
        onOpen: (value) async => openedId = value.targetId,
      );
      expect(opened, isTrue);
      expect(openedId, 'musa-reviewed-map-1');
    });

    test('cross-prophet target rebinding fails closed', () {
      final target = ProphetMapTargetT0202.validated(
        prophetId: 'musa',
        targetId: 'musa-reviewed-map-1',
        geography: _reviewedExactGeography,
      );
      final adapter = ProphetMapTargetAdapterT0202([target]);
      final rebound = ProphetDeepLink.map(
        prophetId: 'harun',
        mapLocationId: 'musa-reviewed-map-1',
      );

      expect(adapter.resolve(rebound), isNull);
      expect(adapter.canOpen(rebound), isFalse);
    });

    test('invalid/disputed geography cannot become a normal map target', () {
      const disputed = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'İhtilaflı yer',
          en: 'Disputed place',
          ar: 'مكان مختلف عليه',
        ),
        precision: ProphetLocationPrecision.disputed,
        certainty: CertaintyLevel.disputed,
        sources: <SourceReference>[_reviewedSource],
      );

      expect(
        () => ProphetMapTargetT0202.validated(
          prophetId: 'musa',
          targetId: 'musa-disputed-map',
          geography: disputed,
        ),
        throwsStateError,
      );
    });

    test('duplicate stable target IDs for same prophet are rejected', () {
      final first = ProphetMapTargetT0202.validated(
        prophetId: 'musa',
        targetId: 'musa-reviewed-map-1',
        geography: _reviewedExactGeography,
      );
      final duplicate = ProphetMapTargetT0202.validated(
        prophetId: 'musa',
        targetId: 'musa-reviewed-map-1',
        geography: _reviewedExactGeography,
      );

      expect(
        () => ProphetMapTargetAdapterT0202([first, duplicate]),
        throwsStateError,
      );
    });
  });
}
