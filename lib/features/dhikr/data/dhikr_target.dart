enum DhikrTargetKind {
  personal,
  preset,
  sourceBacked,
}

/// A counting target is deliberately separate from dhikr content itself.
///
/// Preset targets (for example 33 or 100) are convenience values only and
/// never imply a Sunnah/religious recommendation. A target may be presented as
/// religiously sourced only when [kind] is [DhikrTargetKind.sourceBacked] and
/// both a stable source id and a human-readable source reference are present.
final class DhikrTarget {
  const DhikrTarget._({
    required this.kind,
    required this.count,
    this.sourceId,
    this.sourceReference,
  });

  static const int maxCount = 999999999;
  static const Set<int> supportedPresetCounts = {33, 100};

  final DhikrTargetKind kind;
  final int count;
  final String? sourceId;
  final String? sourceReference;

  bool get isReligiouslySourced => kind == DhikrTargetKind.sourceBacked;

  factory DhikrTarget.personal(int count) {
    _validateCount(count);
    return DhikrTarget._(kind: DhikrTargetKind.personal, count: count);
  }

  factory DhikrTarget.preset(int count) {
    if (!supportedPresetCounts.contains(count)) {
      throw ArgumentError.value(
        count,
        'count',
        'Unsupported convenience preset',
      );
    }
    return DhikrTarget._(kind: DhikrTargetKind.preset, count: count);
  }

  factory DhikrTarget.sourceBacked({
    required int count,
    required String sourceId,
    required String sourceReference,
  }) {
    _validateCount(count);
    final normalizedId = sourceId.trim();
    final normalizedReference = sourceReference.trim();
    if (normalizedId.isEmpty || normalizedReference.isEmpty) {
      throw ArgumentError(
        'Source-backed targets require both sourceId and sourceReference.',
      );
    }
    return DhikrTarget._(
      kind: DhikrTargetKind.sourceBacked,
      count: count,
      sourceId: normalizedId,
      sourceReference: normalizedReference,
    );
  }

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'count': count,
        if (sourceId != null) 'sourceId': sourceId,
        if (sourceReference != null) 'sourceReference': sourceReference,
      };

  factory DhikrTarget.fromJson(Map<String, dynamic> json) {
    final rawKind = json['kind'];
    final rawCount = json['count'];
    if (rawKind is! String || rawCount is! int) {
      throw const FormatException('Invalid dhikr target shape.');
    }

    return switch (rawKind) {
      'personal' => DhikrTarget.personal(rawCount),
      'preset' => DhikrTarget.preset(rawCount),
      'sourceBacked' => _decodeSourceBacked(json, rawCount),
      _ => throw const FormatException('Unknown dhikr target kind.'),
    };
  }

  static DhikrTarget _decodeSourceBacked(
    Map<String, dynamic> json,
    int count,
  ) {
    final rawSourceId = json['sourceId'];
    final rawSourceReference = json['sourceReference'];
    if (rawSourceId is! String || rawSourceReference is! String) {
      throw const FormatException(
        'Source-backed target is missing source metadata.',
      );
    }
    try {
      return DhikrTarget.sourceBacked(
        count: count,
        sourceId: rawSourceId,
        sourceReference: rawSourceReference,
      );
    } on ArgumentError {
      throw const FormatException(
        'Source-backed target has invalid source metadata.',
      );
    }
  }

  static void _validateCount(int count) {
    if (count <= 0 || count > maxCount) {
      throw ArgumentError.value(count, 'count', 'Target must be positive.');
    }
  }
}
