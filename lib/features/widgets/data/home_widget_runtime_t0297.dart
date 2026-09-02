import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/widgets/data/android_home_widget_bridge_t0297.dart';
import 'package:islami_hayat/features/widgets/domain/home_widget_content_t0297.dart';

/// Production-facing adapter from the already fail-closed [DuaLibraryRepository]
/// to T0297's deterministic daily widget selection contract.
///
/// This class never creates, edits or translates a dua. The repository has
/// already rejected every non-production record before a selection can occur.
final class DuaLibraryHomeWidgetSourceT0297
    implements HomeWidgetDailyDuaSourceT0297 {
  const DuaLibraryHomeWidgetSourceT0297(this._repository);

  final DuaLibraryRepository _repository;

  @override
  DuaContent forDate(DateTime civilDate) {
    final records = _repository.all;
    if (records.isEmpty) {
      throw StateError(
        'Home widget requires at least one production-reviewed dua.',
      );
    }

    final day = DateTime.utc(civilDate.year, civilDate.month, civilDate.day);
    final epoch = DateTime.utc(2020, 1, 1);
    final dayNumber = day.difference(epoch).inDays;
    final index = dayNumber % records.length;
    return records[index];
  }
}

/// Builds and persists one complete, date-bound T0297 widget snapshot.
///
/// A false sink result is propagated instead of being reported as success. Any
/// content/source validation error from the coordinator also propagates, so a
/// failed religious-content gate cannot be converted into a stale/native update.
final class HomeWidgetRuntimeSyncT0297 {
  const HomeWidgetRuntimeSyncT0297({
    required HomeWidgetContentCoordinatorT0297 coordinator,
    required HomeWidgetSnapshotSinkT0297 sink,
  })  : _coordinator = coordinator,
        _sink = sink;

  final HomeWidgetContentCoordinatorT0297 _coordinator;
  final HomeWidgetSnapshotSinkT0297 _sink;

  Future<bool> sync({
    required DateTime civilDate,
    required String languageCode,
    required bool hasLifetimePro,
  }) async {
    final snapshot = await _coordinator.buildSnapshot(
      civilDate: civilDate,
      languageCode: languageCode,
      hasLifetimePro: hasLifetimePro,
    );
    return _sink.persistSnapshot(snapshot);
  }
}
