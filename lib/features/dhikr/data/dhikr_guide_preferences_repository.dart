import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class DhikrGuidePreferences {
  const DhikrGuidePreferences({
    this.showTraditionalPractices = false,
    this.showEbcedHavasHistorical = false,
  });

  final bool showTraditionalPractices;
  final bool showEbcedHavasHistorical;

  DhikrGuidePreferences copyWith({
    bool? showTraditionalPractices,
    bool? showEbcedHavasHistorical,
  }) {
    return DhikrGuidePreferences(
      showTraditionalPractices:
          showTraditionalPractices ?? this.showTraditionalPractices,
      showEbcedHavasHistorical:
          showEbcedHavasHistorical ?? this.showEbcedHavasHistorical,
    );
  }
}

final class DhikrGuidePreferencesRepository {
  DhikrGuidePreferencesRepository(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const _storageKey = 'dhikr.guide.preferences.v1';
  final PrivateUserStore _store;

  Future<DhikrGuidePreferences> load() async {
    final raw = await _store.read(_storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const DhikrGuidePreferences();
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const DhikrGuidePreferences();
      }
      final traditional = decoded['showTraditionalPractices'];
      final ebced = decoded['showEbcedHavasHistorical'];
      if (traditional is! bool || ebced is! bool) {
        return const DhikrGuidePreferences();
      }
      return DhikrGuidePreferences(
        showTraditionalPractices: traditional,
        showEbcedHavasHistorical: ebced,
      );
    } on FormatException {
      return const DhikrGuidePreferences();
    }
  }

  Future<DhikrGuidePreferences> save(DhikrGuidePreferences value) async {
    await _store.write(
      _storageKey,
      jsonEncode({
        'showTraditionalPractices': value.showTraditionalPractices,
        'showEbcedHavasHistorical': value.showEbcedHavasHistorical,
      }),
    );
    return value;
  }
}