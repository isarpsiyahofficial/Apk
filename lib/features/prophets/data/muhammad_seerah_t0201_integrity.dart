import '../../../core/content/content_governance.dart';
import 'muhammad_seerah_timeline.dart';

/// T0201 fail-closed integrity rules layered over the seerah chronology.
///
/// The base model validates shape. This audit validates that a source class is
/// actually appropriate for seerah, every deep-link is backed by the event's
/// own provenance, event families are unique, and phase progression never
/// silently moves backwards.
class MuhammadSeerahT0201Integrity {
  static const Set<ReligiousSourceClass> allowedSourceClasses = {
    ReligiousSourceClass.quran,
    ReligiousSourceClass.sahihHasanHadith,
    ReligiousSourceClass.earlyIslamicHistoryTafsir,
    ReligiousSourceClass.modernHistoryArchaeology,
  };

  static List<String> audit(List<MuhammadSeerahEvent> events) {
    final issues = <String>[...auditMuhammadSeerahT0201(events)];
    final kinds = <SeerahEventKind>{};
    var previousPhaseIndex = -1;

    for (final event in events) {
      if (!kinds.add(event.kind)) {
        issues.add('${event.id}: duplicate seerah event family ${event.kind.name}');
      }

      final phaseIndex = _phaseIndex(event.phase);
      if (phaseIndex < previousPhaseIndex) {
        issues.add('${event.id}: seerah phase regressed to ${event.phase.name}');
      }
      previousPhaseIndex = phaseIndex;

      for (final source in event.sources) {
        if (!allowedSourceClasses.contains(source.sourceClass)) {
          issues.add(
            '${event.id}: source class ${source.sourceClass.stableId} is not allowed for T0201 seerah',
          );
        }
      }

      for (final link in event.links) {
        if (link.verse case final verse?) {
          final locatorPrefix = '${verse.surah}:${verse.ayah}';
          final backed = event.sources.any(
            (source) =>
                source.sourceClass == ReligiousSourceClass.quran &&
                (source.locator?.startsWith(locatorPrefix) ?? false),
          );
          if (!backed) {
            issues.add(
              '${event.id}: Quran link $locatorPrefix is not backed by event provenance',
            );
          }
        }

        if (link.hadithLocator case final locator?) {
          final backed = event.sources.any(
            (source) =>
                source.sourceClass == ReligiousSourceClass.sahihHasanHadith &&
                source.locator == locator,
          );
          if (!backed) {
            issues.add(
              '${event.id}: hadith link $locator is not backed by event provenance',
            );
          }
        }
      }
    }

    return issues;
  }

  static void requireValid(List<MuhammadSeerahEvent> events) {
    final issues = audit(events);
    if (issues.isNotEmpty) {
      throw StateError('T0201 seerah integrity failed: ${issues.join('; ')}');
    }
  }

  static int _phaseIndex(SeerahPhase phase) => switch (phase) {
        SeerahPhase.birthAndEarlyLife => 0,
        SeerahPhase.meccan => 1,
        SeerahPhase.hijrah => 2,
        SeerahPhase.medinan => 3,
        SeerahPhase.finalYears => 4,
      };
}
