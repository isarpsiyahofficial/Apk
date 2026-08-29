import '../../../core/content/content_governance.dart';

enum ReligiousNightTerminologyId {
  laylatAlQadr,
  israMiraj,
  midShabanBerat,
  regaib,
  mawlid,
}

/// Locale-safe naming for nights commonly grouped under the Turkish cultural
/// label “kandil”. The word `kandil` is intentionally not translated literally
/// into English or Arabic; those locales use the established name of the night.
class ReligiousNightTerminology {
  const ReligiousNightTerminology({
    required this.id,
    required this.title,
    required this.turkishKandilLabel,
    required this.culturalNote,
  });

  final ReligiousNightTerminologyId id;
  final LocalizedReligiousText title;
  final String turkishKandilLabel;
  final LocalizedReligiousText culturalNote;

  String titleFor(String languageCode) => switch (languageCode) {
        'tr' => title.tr,
        'en' => title.en,
        'ar' => title.ar,
        _ => title.en,
      };

  String culturalNoteFor(String languageCode) => switch (languageCode) {
        'tr' => culturalNote.tr,
        'en' => culturalNote.en,
        'ar' => culturalNote.ar,
        _ => culturalNote.en,
      };
}

const religiousNightTerminology = <ReligiousNightTerminology>[
  ReligiousNightTerminology(
    id: ReligiousNightTerminologyId.laylatAlQadr,
    title: LocalizedReligiousText(
      tr: 'Kadir Gecesi',
      en: 'Laylat al-Qadr',
      ar: 'ليلة القدر',
    ),
    turkishKandilLabel: 'Kadir Kandili',
    culturalNote: LocalizedReligiousText(
      tr: '“Kandil” burada Türk-Osmanlı dinî kültüründe kullanılan geleneksel gece adlandırmasıdır.',
      en: '“Kandil” is a Turkish-Ottoman cultural label for commemorated religious nights; it is not translated as “lamp night”.',
      ar: '«قنديل» تسمية ثقافية تركية عثمانية لليالٍ دينية يُحتفى بها، ولا تُترجم في الواجهة العربية إلى «ليلة القنديل».',
    ),
  ),
  ReligiousNightTerminology(
    id: ReligiousNightTerminologyId.israMiraj,
    title: LocalizedReligiousText(
      tr: 'Miraç Gecesi',
      en: 'Night of Isra and Mi‘raj',
      ar: 'ليلة الإسراء والمعراج',
    ),
    turkishKandilLabel: 'Miraç Kandili',
    culturalNote: LocalizedReligiousText(
      tr: 'Türkçede “Miraç Kandili” yaygın kültürel addır; içerik başlığı olayın dinî adını “Miraç Gecesi” olarak korur.',
      en: 'Turkish usage commonly says “Miraç Kandili”; English keeps the established religious terms Isra and Mi‘raj instead of translating kandil literally.',
      ar: 'يشيع في التركية اسم «Miraç Kandili»، بينما تحافظ العربية على الاسم الديني «ليلة الإسراء والمعراج» دون ترجمة لفظ قنديل ترجمة حرفية.',
    ),
  ),
  ReligiousNightTerminology(
    id: ReligiousNightTerminologyId.midShabanBerat,
    title: LocalizedReligiousText(
      tr: 'Berat Gecesi',
      en: 'Mid-Sha‘ban Night (Berat)',
      ar: 'ليلة النصف من شعبان (ليلة البراءة)',
    ),
    turkishKandilLabel: 'Berat Kandili',
    culturalNote: LocalizedReligiousText(
      tr: '“Berat Kandili” Türkçe geleneksel kullanımdır; Arapça karşılıkta yerleşik “Şâban’ın ortası gecesi / ليلة النصف من شعبان” adı öne çıkar.',
      en: '“Berat Kandili” is Turkish traditional usage; English identifies the night by mid-Sha‘ban and retains “Berat” only as a helpful Turkish-context label.',
      ar: '«Berat Kandili» استعمال تركي تقليدي؛ وتُقدَّم في العربية التسمية المألوفة «ليلة النصف من شعبان» مع إمكان ذكر «ليلة البراءة» توضيحاً.',
    ),
  ),
  ReligiousNightTerminology(
    id: ReligiousNightTerminologyId.regaib,
    title: LocalizedReligiousText(
      tr: 'Regaib Gecesi',
      en: 'Regaib Night',
      ar: 'ليلة الرغائب',
    ),
    turkishKandilLabel: 'Regaib Kandili',
    culturalNote: LocalizedReligiousText(
      tr: '“Regaib Kandili” Türk-İslâm kültüründeki yaygın addır; kaynak statüsü ayrıca gösterilir ve adlandırma tek başına sahih özel ibadet anlamına gelmez.',
      en: '“Regaib Kandili” is a Turkish-Islamic cultural label. The title does not by itself imply that a special ritual for the night is established by sound evidence.',
      ar: '«Regaib Kandili» تسمية ثقافية تركية إسلامية؛ ولا يعني الاسم بذاته ثبوت عبادة مخصوصة لهذه الليلة بدليل صحيح.',
    ),
  ),
  ReligiousNightTerminology(
    id: ReligiousNightTerminologyId.mawlid,
    title: LocalizedReligiousText(
      tr: 'Mevlid Gecesi',
      en: 'Mawlid — The Prophet’s Birth',
      ar: 'المولد النبوي',
    ),
    turkishKandilLabel: 'Mevlid Kandili',
    culturalNote: LocalizedReligiousText(
      tr: '“Mevlid Kandili” Türkçedeki yaygın geleneksel addır; İngilizce ve Arapçada “kandil” kelimesi yerine yerleşik Mevlid/Mawlid terminolojisi kullanılır.',
      en: '“Mevlid Kandili” is common Turkish traditional usage; English uses Mawlid rather than a literal translation of the word kandil.',
      ar: '«Mevlid Kandili» استعمال تركي شائع، أما الواجهة العربية فتستخدم المصطلح المستقر «المولد النبوي» بدلاً من ترجمة كلمة قنديل حرفياً.',
    ),
  ),
];

ReligiousNightTerminology religiousNightTerm(
  ReligiousNightTerminologyId id,
) => religiousNightTerminology.singleWhere((entry) => entry.id == id);
