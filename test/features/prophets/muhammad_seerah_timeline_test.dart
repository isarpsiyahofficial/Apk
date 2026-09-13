import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_timeline.dart';

void main() {
  group('T0201 Muhammad seerah chronology', () {
    test('working chronology covers every required SPEC 884 event family', () {
      expect(auditMuhammadSeerahT0201(muhammadSeerahT0201Events), isEmpty);
      expect(muhammadSeerahT0201Events.length, SeerahEventKind.values.length);
      expect(muhammadSeerahT0201Events.map((event) => event.kind).toSet(),
          SeerahEventKind.values.toSet());
    });

    test('events are strictly ordered and TR EN AR complete', () {
      var previous = 0;
      for (final event in muhammadSeerahT0201Events) {
        expect(event.order, greaterThan(previous));
        previous = event.order;
        expect(event.title.isComplete, isTrue);
        expect(event.summary.isComplete, isTrue);
        expect(event.links, isNotEmpty);
        expect(event.links.every((link) => link.isValid), isTrue);
      }
    });

    test('no weak, israiliyat, disputed, or unknown source can validate an event', () {
      final sourceClasses = muhammadSeerahT0201Events
          .expand((event) => event.sources)
          .map((source) => source.sourceClass)
          .toSet();
      expect(sourceClasses, contains(ReligiousSourceClass.quran));
      expect(sourceClasses, contains(ReligiousSourceClass.sahihHasanHadith));
      expect(sourceClasses, isNot(contains(ReligiousSourceClass.israiliyat)));
      expect(sourceClasses, isNot(contains(ReligiousSourceClass.laterTradition)));
      expect(sourceClasses, isNot(contains(ReligiousSourceClass.disputed)));
      expect(sourceClasses, isNot(contains(ReligiousSourceClass.unknown)));
    });

    test('Quran sources retain pinned Tanzil identity license and locator', () {
      final quranSources = muhammadSeerahT0201Events
          .expand((event) => event.sources)
          .where((source) => source.sourceClass == ReligiousSourceClass.quran)
          .toList();
      expect(quranSources, isNotEmpty);
      for (final source in quranSources) {
        expect(source.title, 'Tanzil Project Uthmani Quran v1.1');
        expect(source.licenseId, 'CC-BY-3.0');
        expect(source.locator, isNotEmpty);
      }
    });

    test('hadith remains bibliographic REFERENCE-ONLY metadata', () {
      final hadithSources = muhammadSeerahT0201Events
          .expand((event) => event.sources)
          .where((source) =>
              source.sourceClass == ReligiousSourceClass.sahihHasanHadith)
          .toList();
      expect(hadithSources, isNotEmpty);
      expect(
          hadithSources.every((source) => source.licenseId == 'REFERENCE-ONLY'),
          isTrue);
    });

    test('birth entry does not invent a Gregorian or Hijri year', () {
      final birth = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.birth);
      final combined = '${birth.summary.tr} ${birth.summary.en} ${birth.summary.ar}';
      expect(RegExp(r'\b(5|6|7|8|9)\d{2}\b').hasMatch(combined), isFalse);
      expect(birth.certainty, CertaintyLevel.stronglyAttested);
    });

    test('youth and marriage use explicit sahih locators without invented dates', () {
      final youth = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.youth);
      final marriage = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.marriage);
      expect(youth.sources.single.locator, 'Sahih al-Bukhari 2262');
      expect(marriage.sources.single.locator, 'Sahih al-Bukhari 3817');
      expect('${youth.summary.tr} ${marriage.summary.tr}', isNot(contains('595')));
    });

    test('Hira and first revelation are separate linked milestones', () {
      final hira = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.hira);
      final first = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.firstRevelation);
      expect(hira.sources.single.locator, 'Sahih al-Bukhari 3');
      expect(first.sources.map((source) => source.locator),
          containsAll(<String?>['Sahih al-Bukhari 3', '96:1-5']));
    });

    test('Meccan pressure and migration milestones keep sahih locators', () {
      final expected = <SeerahEventKind, String>{
        SeerahEventKind.abyssiniaMigration: 'Sahih al-Bukhari 3876',
        SeerahEventKind.boycott: 'Sahih al-Bukhari 3058',
        SeerahEventKind.taif: 'Sahih al-Bukhari 3231',
        SeerahEventKind.aqaba: 'Sahih al-Bukhari 3893',
      };
      for (final entry in expected.entries) {
        final event = muhammadSeerahT0201Events
            .singleWhere((candidate) => candidate.kind == entry.key);
        expect(event.sources.map((source) => source.locator), contains(entry.value));
      }
    });

    test('Isra and Miraj preserve Quran and sahih layers together', () {
      final event = muhammadSeerahT0201Events
          .singleWhere((candidate) => candidate.kind == SeerahEventKind.israMiraj);
      expect(event.sources.map((source) => source.locator),
          containsAll(<String?>['17:1', 'Sahih al-Bukhari 3887']));
    });

    test('Hijrah and Medina arrival are separate sourced milestones', () {
      final hijrah = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.hijrah);
      final medina = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.medinaArrival);
      expect(hijrah.sources.map((source) => source.locator),
          containsAll(<String?>['9:40', 'Sahih al-Bukhari 4663']));
      expect(medina.sources.single.locator, 'Sahih al-Bukhari 3925');
    });

    test('campaign treaty conquest farewell and death chain is sourced', () {
      final expected = <SeerahEventKind, String>{
        SeerahEventKind.badr: '3:123',
        SeerahEventKind.pledgeUnderTree: '48:18',
        SeerahEventKind.hudaybiyyahTreaty: 'Sahih al-Bukhari 2711-2712',
        SeerahEventKind.conquestOfMecca: 'Sahih al-Bukhari 4280',
        SeerahEventKind.farewellPilgrimage: 'Sahih al-Bukhari 1739',
        SeerahEventKind.death: 'Sahih al-Bukhari 4449',
      };
      for (final entry in expected.entries) {
        final event = muhammadSeerahT0201Events
            .singleWhere((candidate) => candidate.kind == entry.key);
        expect(event.sources.map((source) => source.locator), contains(entry.value));
      }
    });

    test('audit rejects duplicate IDs duplicate source IDs and chronology collisions', () {
      final original = muhammadSeerahT0201Events.first;
      final duplicate = MuhammadSeerahEvent(
        id: original.id,
        order: original.order,
        kind: original.kind,
        phase: original.phase,
        title: original.title,
        summary: original.summary,
        certainty: original.certainty,
        sources: original.sources,
        links: original.links,
      );
      final issues = auditMuhammadSeerahT0201(<MuhammadSeerahEvent>[
        original,
        duplicate,
        ...muhammadSeerahT0201Events.skip(1),
      ]);
      expect(issues.any((issue) => issue.contains('duplicate event id')), isTrue);
      expect(issues.any((issue) => issue.contains('duplicate source id')), isTrue);
      expect(issues.any((issue) => issue.contains('not strictly increasing')), isTrue);
    });

    test('audit rejects any missing SPEC 884 event family', () {
      for (final kind in SeerahEventKind.values) {
        final withoutKind = muhammadSeerahT0201Events
            .where((event) => event.kind != kind)
            .toList();
        expect(
          auditMuhammadSeerahT0201(withoutKind)
              .any((issue) => issue.contains(kind.name)),
          isTrue,
          reason: 'missing ${kind.name} must fail closed',
        );
      }
    });
  });
}
