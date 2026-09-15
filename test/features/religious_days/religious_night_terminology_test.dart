import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/religious_night_terminology.dart';

void main() {
  group('T0178 religious-night terminology', () {
    test('covers the five nights commonly grouped as kandil in Turkish usage', () {
      expect(religiousNightTerminology, hasLength(5));
      expect(
        religiousNightTerminology.map((entry) => entry.id).toSet(),
        ReligiousNightTerminologyId.values.toSet(),
      );
      expect(religiousNightTerminology.every((entry) => entry.isLocaleSafe), isTrue);
    });

    test('Turkish keeps cultural kandil labels without forcing them into main titles', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.title.tr, isNot(contains('Kandili')));
        expect(entry.turkishKandilLabel, endsWith('Kandili'));
        expect(entry.culturalNote.tr.toLowerCase(), contains('türk'));
      }
    });

    test('English titles never mistranslate kandil as a lamp-night religious term', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.title.en.toLowerCase(), isNot(contains('lamp night')));
        expect(entry.title.en.toLowerCase(), isNot(contains('kandil')));
      }
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.israMiraj).title.en,
        'Night of Isra and Mi‘raj',
      );
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.laylatAlQadr).title.en,
        'Laylat al-Qadr',
      );
      expect(
        religiousNightTerm(ReligiousNightTerminologyId.laylatAlQadr)
            .culturalNote
            .en
            .toLowerCase(),
        contains('not translated as “lamp night”'),
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

    test('cultural terminology has non-empty source/license/locator metadata', () {
      for (final entry in religiousNightTerminology) {
        expect(entry.sources, isNotEmpty);
        for (final source in entry.sources) {
          expect(source.id.trim(), isNotEmpty);
          expect(source.title.trim(), isNotEmpty);
          expect(source.licenseId.trim(), isNotEmpty);
          expect(source.locator?.trim(), isNotEmpty);
        }
      }
    });

    test('locale gate rejects literal English and Arabic kandil translations', () {
      const validSource = SourceReference(
        id: 'source',
        title: 'Source',
        sourceClass: ReligiousSourceClass.laterTradition,
        licenseId: 'reference-only',
        locator: 'terminology',
      );

      const badEnglish = ReligiousNightTerminology(
        id: ReligiousNightTerminologyId.israMiraj,
        title: LocalizedReligiousText(
          tr: 'Miraç Gecesi',
          en: 'Miraj Lamp Night',
          ar: 'ليلة الإسراء والمعراج',
        ),
        turkishKandilLabel: 'Miraç Kandili',
        culturalNote: LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR'),
        sources: [validSource],
      );
      const badArabic = ReligiousNightTerminology(
        id: ReligiousNightTerminologyId.israMiraj,
        title: LocalizedReligiousText(
          tr: 'Miraç Gecesi',
          en: 'Night of Isra and Mi‘raj',
          ar: 'ليلة قنديل الإسراء والمعراج',
        ),
        turkishKandilLabel: 'Miraç Kandili',
        culturalNote: LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR'),
        sources: [validSource],
      );

      expect(badEnglish.isLocaleSafe, isFalse);
      expect(badArabic.isLocaleSafe, isFalse);
    });

    test('locale gate rejects incomplete cultural source metadata', () {
      const invalidSource = SourceReference(
        id: 'source',
        title: 'Source',
        sourceClass: ReligiousSourceClass.laterTradition,
        licenseId: 'reference-only',
      );
      const entry = ReligiousNightTerminology(
        id: ReligiousNightTerminologyId.mawlid,
        title: LocalizedReligiousText(
          tr: 'Mevlid Gecesi',
          en: 'Mawlid',
          ar: 'المولد النبوي',
        ),
        turkishKandilLabel: 'Mevlid Kandili',
        culturalNote: LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR'),
        sources: [invalidSource],
      );

      expect(entry.isLocaleSafe, isFalse);
    });

    test('Regaib terminology does not imply source-backed special worship', () {
      final regaib = religiousNightTerm(ReligiousNightTerminologyId.regaib);
      expect(regaib.culturalNote.tr, contains('sahih özel ibadet'));
      expect(regaib.culturalNote.en.toLowerCase(), contains('does not by itself imply'));
      expect(regaib.culturalNote.ar, contains('لا يعني الاسم بذاته'));
    });
  });
}
