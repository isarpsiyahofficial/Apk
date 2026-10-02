import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_t0201_integrity.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_timeline.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

MuhammadSeerahEvent _copy(
  MuhammadSeerahEvent source, {
  String? id,
  SeerahEventKind? kind,
  SeerahPhase? phase,
  List<SourceReference>? sources,
  List<SeerahEventLink>? links,
}) =>
    MuhammadSeerahEvent(
      id: id ?? source.id,
      order: source.order,
      kind: kind ?? source.kind,
      phase: phase ?? source.phase,
      title: source.title,
      summary: source.summary,
      certainty: source.certainty,
      sources: sources ?? source.sources,
      links: links ?? source.links,
    );

void main() {
  group('T0201 seerah fail-closed integrity', () {
    test('canonical chronology passes source, phase and link provenance audit', () {
      expect(
        MuhammadSeerahT0201Integrity.audit(muhammadSeerahT0201Events),
        isEmpty,
      );
      expect(
        () => MuhammadSeerahT0201Integrity.requireValid(
          muhammadSeerahT0201Events,
        ),
        returnsNormally,
      );
    });

    test('non-seerah source classes cannot be promoted into chronology', () {
      final first = muhammadSeerahT0201Events.first;
      final poisoned = _copy(
        first,
        sources: const <SourceReference>[
          SourceReference(
            id: 'dua-source-injection',
            title: 'Editorial dua source',
            sourceClass: ReligiousSourceClass.meaningBasedDua,
            licenseId: 'INTERNAL',
            locator: 'editorial:1',
          ),
        ],
      );
      final events = <MuhammadSeerahEvent>[
        poisoned,
        ...muhammadSeerahT0201Events.skip(1),
      ];

      final issues = MuhammadSeerahT0201Integrity.audit(events);
      expect(
        issues.any((issue) => issue.contains('meaning_based_dua')),
        isTrue,
      );
      expect(
        () => MuhammadSeerahT0201Integrity.requireValid(events),
        throwsStateError,
      );
    });

    test('Quran deep link must be backed by the same event provenance', () {
      final first = muhammadSeerahT0201Events.first;
      final poisoned = _copy(
        first,
        links: const <SeerahEventLink>[
          SeerahEventLink.quran(ProphetVerseReference(surah: 2, ayah: 255)),
        ],
      );
      final issues = MuhammadSeerahT0201Integrity.audit(
        <MuhammadSeerahEvent>[
          poisoned,
          ...muhammadSeerahT0201Events.skip(1),
        ],
      );
      expect(
        issues.any((issue) => issue.contains('Quran link 2:255 is not backed')),
        isTrue,
      );
    });

    test('hadith deep link must match an event hadith locator exactly', () {
      final first = muhammadSeerahT0201Events.first;
      final poisoned = _copy(
        first,
        links: const <SeerahEventLink>[
          SeerahEventLink.hadith('Sahih Muslim 9999'),
        ],
      );
      final issues = MuhammadSeerahT0201Integrity.audit(
        <MuhammadSeerahEvent>[
          poisoned,
          ...muhammadSeerahT0201Events.skip(1),
        ],
      );
      expect(
        issues.any((issue) => issue.contains('Sahih Muslim 9999 is not backed')),
        isTrue,
      );
    });

    test('chronology cannot regress from final years back into Meccan phase', () {
      final last = muhammadSeerahT0201Events.last;
      final poisoned = _copy(last, phase: SeerahPhase.meccan);
      final events = <MuhammadSeerahEvent>[
        ...muhammadSeerahT0201Events.take(muhammadSeerahT0201Events.length - 1),
        poisoned,
      ];
      expect(
        MuhammadSeerahT0201Integrity.audit(events)
            .any((issue) => issue.contains('phase regressed')),
        isTrue,
      );
    });

    test('a required event family cannot be duplicated under a second id', () {
      final original = muhammadSeerahT0201Events[1];
      final duplicateFamily = _copy(
        original,
        id: '${original.id}-duplicate-family',
        kind: SeerahEventKind.birth,
      );
      final events = <MuhammadSeerahEvent>[
        muhammadSeerahT0201Events.first,
        duplicateFamily,
        ...muhammadSeerahT0201Events.skip(2),
      ];
      expect(
        MuhammadSeerahT0201Integrity.audit(events)
            .any((issue) => issue.contains('duplicate seerah event family')),
        isTrue,
      );
    });
  });
}
