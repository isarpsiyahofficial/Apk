import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/religious_days/data/religious_night_terminology.dart';

void main() {
  group('T0178 religious-night terminology', () {
    test('covers the five nights commonly grouped as kandil in Turkish usage', () {
      expect(religiousNightTerminology, hasLength(5));
      expect(
        religiousNightTerminology.map((entry) => entry.id).toSet(),
        ReligiousNightTerminologyId.values.toSet(),
      );
    });

    test('Turkish keeps cultural kandil labels without forcing them into main titles', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.title.tr, isNot(contains('Kandili')));
        expect(entry.turkishKandilLabel, endsWith('Kandili'));
        expect(entry.culturalNote.tr.toLowerCase(), contains('türk'));
      }
    });

    test('English never mistranslates kandil as a lamp-night religious term', () {
      for (final entry in religiousNightTerminology) {
        final english = '${entry.title.en} ${entry.culturalNote.en}'.toLowerCase();
        expect(english, isNot(contains('lamp night')));
        expect(entry.title.en, isNot(contains('Kandil')));
      }
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.israMiraj).title.en,
        'Night of Isra and Mi‘raj',
      );
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.laylatAlQadr).title.en,
        'Laylat al-Qadr',
      );
    });

    test('Arabic uses established night names and never literal Turkish kandil wording', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.title.ar, isNot(contains('قنديل')));
        expect(entry.title.ar.trim(), isNotEmpty);
      }
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.midShabanBerat).title.ar,
        'ليلة النصف من شعبان (ليلة البراءة)',
      );
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.mawlid).title.ar,
        'المولد النبوي',
      );
    });

    test('fallback is English and all cultural notes remain complete', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.titleFor('de'), entry.title.en);
        expect(entry.culturalNoteFor('de'), entry.culturalNote.en);
        expect(entry.title.isComplete, isTrue);
        expect(entry.culturalNote.isComplete, isTrue);
      }
    });

    test('Regaib terminology does not imply source-backed special worship', () {
      final regaib = religiousNightTerm(ReligiousNightTerminologyId.regaib);
      expect(regaib.culturalNote.tr, contains('sahih özel ibadet'));
      expect(regaib.culturalNote.en.toLowerCase(), contains('does not by itself imply'));
      expect(regaib.culturalNote.ar, contains('لا يعني الاسم بذاته'));
    });
  });
}
