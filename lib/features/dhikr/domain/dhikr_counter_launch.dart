import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_target.dart';

/// Immutable hand-off from a reviewed dhikr guide entry to the counter.
///
/// The counter launch payload is built only from an entry that already passed
/// the religious/content production gate. This prevents presentation code from
/// manufacturing a source-backed number independently of the reviewed guide.
final class DhikrCounterLaunch {
  const DhikrCounterLaunch._({
    required this.guideEntryId,
    required this.arabic,
    required this.transliterationTr,
    required this.transliterationEn,
    required this.target,
  });

  factory DhikrCounterLaunch.fromGuide(DhikrGuideEntry entry) {
    if (!entry.canEnterProductionDataset) {
      throw StateError(
        'Unreviewed dhikr guide entry cannot be loaded into counter: ${entry.id}',
      );
    }

    return DhikrCounterLaunch._(
      guideEntryId: entry.id,
      arabic: entry.arabic,
      transliterationTr: entry.transliterationTr,
      transliterationEn: entry.transliterationEn,
      target: entry.toSourceBackedTarget(),
    );
  }

  final String guideEntryId;
  final String arabic;
  final String transliterationTr;
  final String transliterationEn;
  final DhikrTarget? target;

  bool get hasSourceBackedTarget => target?.isReligiouslySourced ?? false;
}
