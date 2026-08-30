import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_timeline.dart';

void main() {
  group('T0201 Muhammad seerah chronology', () {
    test('working chronology passes fail-closed audit', () {
      expect(auditMuhammadSeerahT0201(muhammadSeerahT0201Events), isEmpty);
      expect(muhammadSeerahT0201Events.length, greaterThanOrEqualTo(9));
    });

    test('events are strictly ordered and multilingual', () {
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

    test('Quran sources retain pinned Tanzil license and locators', () {
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

    test('hadith is bibliographic reference only, never copied translation asset', () {
      final hadithSources = muhammadSeerahT0201Events
          .expand((event) => event.sources)
          .where((source) =>
              source.sourceClass == ReligiousSourceClass.sahihHasanHadith)
          .toList();
      expect(hadithSources, isNotEmpty);
      expect(hadithSources.every((source) => source.licenseId == 'REFERENCE-ONLY'),
          isTrue);
    });

    test('birth entry does not invent a Gregorian or Hijri year', () {
      final birth = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.birth);
      final combined = '${birth.summary.tr} ${birth.summary.en} ${birth.summary.ar}';
      expect(RegExp(r'\b(5|6|7|8|9)\d{2}\b').hasMatch(combined), isFalse);
      expect(birth.certainty, CertaintyLevel.stronglyAttested);
    });

    test('Hira event requires both sahih report and Quran link', () {
      final hira = muhammadSeerahT0201Events.singleWhere(
          (event) => event.kind == SeerahEventKind.hiraAndFirstRevelation);
      expect(
          hira.sources.any((source) =>
              source.sourceClass == ReligiousSourceClass.sahihHasanHadith &&
              source.locator == 'Sahih al-Bukhari 3'),
          isTrue);
      expect(
          hira.sources.any((source) =>
              source.sourceClass == ReligiousSourceClass.quran &&
              source.locator == '96:1-5'),
          isTrue);
    });

    test('Hijrah cave is independently linked to Quran and sahih report', () {
      final hijrah = muhammadSeerahT0201Events
          .singleWhere((event) => event.kind == SeerahEventKind.hijrah);
      expect(hijrah.sources.map((source) => source.locator),
          containsAll(<String?>['9:40', 'Sahih al-Bukhari 4663']));
    });

    test('conquest of Mecca has sahih event locator', () {
      final conquest = muhammadSeerahT0201Events.singleWhere(
          (event) => event.kind == SeerahEventKind.conquestOfMecca);
      expect(conquest.sources.single.locator, 'Sahih al-Bukhari 4280');
    });

    test('audit rejects duplicate IDs and non-increasing chronology', () {
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
      expect(issues.any((issue) => issue.contains('not strictly increasing')), isTrue);
    });

    test('audit rejects missing required event families', () {
      final withoutBadr = muhammadSeerahT0201Events
          .where((event) => event.kind != SeerahEventKind.badr)
          .toList();
      expect(
          auditMuhammadSeerahT0201(withoutBadr)
              .any((issue) => issue.contains('badr')),
          isTrue);
    });
  });
}
