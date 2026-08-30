import '../../../core/content/content_governance.dart';
import 'prophet_content.dart';

/// T0199 — historical map marker semantics.
///
/// A marker is a presentation projection of already-reviewed geography. It
/// never upgrades an approximate region to an exact point and never exposes
/// disputed/unknown geography as a normal map pin.
enum ProphetMapMarkerKind {
  exactPoint,
  approximateRegion,
}

class ProphetMapMarker {
  const ProphetMapMarker({
    required this.label,
    required this.kind,
    required this.certainty,
    required this.sources,
    this.latitude,
    this.longitude,
  });

  final LocalizedReligiousText label;
  final ProphetMapMarkerKind kind;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;
  final double? latitude;
  final double? longitude;

  bool get isValid {
    if (!label.isComplete || sources.isEmpty || sources.any(!_hasMapSource)) {
      return false;
    }
    if ((latitude == null) != (longitude == null)) return false;
    if (latitude != null && (latitude! < -90 || latitude! > 90)) return false;
    if (longitude != null && (longitude! < -180 || longitude! > 180)) {
      return false;
    }

    return switch (kind) {
      ProphetMapMarkerKind.exactPoint =>
        certainty == CertaintyLevel.explicitSource &&
            latitude != null &&
            longitude != null,
      ProphetMapMarkerKind.approximateRegion =>
        certainty == CertaintyLevel.approximate,
    };
  }
}

ProphetMapMarker? mapMarkerFromGeography(ProphetGeography geography) {
  if (!geography.isValid) return null;

  switch (geography.precision) {
    case ProphetLocationPrecision.exact:
      final marker = ProphetMapMarker(
        label: geography.name,
        kind: ProphetMapMarkerKind.exactPoint,
        certainty: geography.certainty,
        sources: List.unmodifiable(geography.sources),
        latitude: geography.latitude,
        longitude: geography.longitude,
      );
      return marker.isValid ? marker : null;
    case ProphetLocationPrecision.approximateRegion:
      final marker = ProphetMapMarker(
        label: geography.name,
        kind: ProphetMapMarkerKind.approximateRegion,
        certainty: geography.certainty,
        sources: List.unmodifiable(geography.sources),
        latitude: geography.latitude,
        longitude: geography.longitude,
      );
      return marker.isValid ? marker : null;
    case ProphetLocationPrecision.disputed:
    case ProphetLocationPrecision.unknown:
      return null;
  }
}

String prophetMapMarkerPrecisionLabel(
  ProphetMapMarkerKind kind,
  String languageCode,
) {
  final language = languageCode.toLowerCase().split(RegExp('[-_]')).first;
  return switch ((kind, language)) {
    (ProphetMapMarkerKind.exactPoint, 'tr') => 'Kesin konum',
    (ProphetMapMarkerKind.exactPoint, 'ar') => 'موقع محدد',
    (ProphetMapMarkerKind.exactPoint, _) => 'Exact location',
    (ProphetMapMarkerKind.approximateRegion, 'tr') => 'Yaklaşık bölge',
    (ProphetMapMarkerKind.approximateRegion, 'ar') => 'منطقة تقريبية',
    (ProphetMapMarkerKind.approximateRegion, _) => 'Approximate region',
  };
}

bool _hasMapSource(SourceReference source) =>
    source.id.trim().isNotEmpty &&
    source.title.trim().isNotEmpty &&
    source.licenseId.trim().isNotEmpty &&
    (source.locator?.trim().isNotEmpty ?? false) &&
    source.sourceClass != ReligiousSourceClass.unknown &&
    source.sourceClass != ReligiousSourceClass.disputed;
