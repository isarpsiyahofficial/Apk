import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0171 research record for Laylat al-Qadr.
///
/// Third-party material is paraphrased and cited by locator; no third-party
/// translation is copied. The record stays `research` until religious and
/// native-language review evidence is attached, so it cannot enter production.
final ReligiousDayContent laylatAlQadrResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-laylat-al-qadr',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [
      _quran97,
      _bukhari2014,
      _bukhari2017,
      _tirmidhi3513,
      _tdvLaylatAlQadr,
    ],
    lastReviewedAt: DateTime.utc(2026, 8, 29),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Kadir Gecesi, Kur’an’ın indirildiğinin bildirildiği ve Kadr sûresinde bin aydan daha hayırlı olduğu açıklanan mübarek gecedir.',
    en: 'Laylat al-Qadr is the blessed night on which the Qur’an is stated to have been sent down and which Surah al-Qadr describes as better than a thousand months.',
    ar: 'ليلة القدر هي الليلة المباركة التي أخبر القرآن بنزوله فيها، ووصفها في سورة القدر بأنها خير من ألف شهر.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Gecenin fazileti Kur’an ve sahih hadislerle sabittir. Kesin gecesi bildirilmemiştir; sahih rivayetler onu Ramazan’ın son on gecesinde, özellikle tek gecelerde aramayı öğretir. Yirmi yedinci geceyi ihya etme uygulaması birçok toplumda yaygınlaşmıştır; bu yaygınlık kesin tarih delili olarak sunulmaz.',
    en: 'Its virtue is established by the Qur’an and authentic hadith. Its exact night is not fixed in the strongest evidence; authentic reports instruct Muslims to seek it in the last ten nights of Ramadan, especially the odd nights. Observing the twenty-seventh night has become widespread in many communities, but that convention is not presented as proof of an exact date.',
    ar: 'فضل الليلة ثابت بالقرآن والأحاديث الصحيحة، أما تعيين ليلتها على وجه القطع فليس ثابتاً في أقوى الأدلة؛ وتدل الأحاديث الصحيحة على تحريها في العشر الأواخر من رمضان، ولا سيما الليالي الوترية. واشتهر إحياء ليلة السابع والعشرين في مجتمعات كثيرة، لكن هذا الاشتهار لا يُعرض دليلاً قطعياً على التعيين.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Kadr sûresi 97:1–5, Kur’an’ın Kadir Gecesi’nde indirildiğini, gecenin bin aydan hayırlı olduğunu, meleklerin indiğini ve tan yeri ağarıncaya kadar esenlik olduğunu bildirir.',
        en: 'Surah al-Qadr 97:1–5 states that the Qur’an was sent down on Laylat al-Qadr, describes the night as better than a thousand months, mentions the descent of the angels, and describes peace until dawn.',
        ar: 'تقرر سورة القدر 97:1–5 نزول القرآن في ليلة القدر، وأنها خير من ألف شهر، وتنزل الملائكة فيها، وأنها سلام حتى مطلع الفجر.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quran97],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih rivayetlerde Kadir Gecesi’nin Ramazan’ın son on gecesinin tek gecelerinde aranması öğretilir.',
        en: 'Authentic reports instruct believers to seek Laylat al-Qadr among the odd nights of the last ten nights of Ramadan.',
        ar: 'تدل الأحاديث الصحيحة على تحري ليلة القدر في أوتار العشر الأواخر من رمضان.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari2017],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Kadir Gecesi’ni imanla ve sevabını Allah’tan umarak namazla ihya etmenin fazileti sahih hadiste bildirilmiştir.',
        en: 'Authentic hadith reports the virtue of spending Laylat al-Qadr in prayer with faith and hope for reward from Allah.',
        ar: 'ثبت في الحديث الصحيح فضل قيام ليلة القدر إيماناً واحتساباً.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari2014],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Hz. Âişe’nin Kadir Gecesi’ne eriştiğinde ne söylemesi gerektiğini sorması üzerine bağışlanma istemeyi öğreten dua rivayet edilmiştir.',
        en: 'A report from Aishah records a supplication asking Allah for pardon when seeking Laylat al-Qadr.',
        ar: 'ورد عن عائشة رضي الله عنها دعاءٌ في سؤال الله العفو عند موافقة ليلة القدر.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_tirmidhi3513],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Yirmi yedinci geceyi Kadir Gecesi olarak ihya etme uygulaması yaygındır; ancak sahih rivayetlerdeki son on gece/tek geceler arama öğretisinin yerine kesin tarih iddiası olarak konulmaz.',
        en: 'Observing the twenty-seventh night as Laylat al-Qadr is widespread, but it is not treated as a certain date that overrides the authentic instruction to seek the night in the last ten, especially odd, nights.',
        ar: 'اشتهر إحياء ليلة السابع والعشرين على أنها ليلة القدر، لكن لا يُجعل هذا الاشتهار تعييناً قطعياً ينسخ توجيه الأحاديث الصحيحة إلى تحريها في العشر الأواخر ولا سيما الأوتار.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvLaylatAlQadr],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Bu geceyi iman ve sevap ümidiyle namazla ihya etmek sahih hadisle sabittir. Ayrıca Hz. Âişe’ye öğretilen bağışlanma duası güçlü bir rivayetle aktarılmıştır.',
        en: 'Spending the night in prayer with faith and hope for reward is established by authentic hadith. A supplication for pardon taught to Aishah is also transmitted in a strong report.',
        ar: 'قيام هذه الليلة إيماناً واحتساباً ثابت بالحديث الصحيح، كما ورد دعاء العفو الذي عُلِّم لعائشة رضي الله عنها برواية قوية.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari2014, _tirmidhi3513],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Kur’an tilaveti, dua, zikir, tövbe ve diğer genel ibadetler yapılabilir; uygulama bunlar için kaynaksız özel sayı, kesin sonuç veya zorunlu ritüel üretmez.',
        en: 'Qur’an recitation, supplication, remembrance, repentance and other general acts of worship may be performed; the app does not invent unsupported special counts, guaranteed outcomes, or mandatory rituals.',
        ar: 'يمكن الإكثار من تلاوة القرآن والدعاء والذكر والتوبة وسائر العبادات العامة، ولا ينشئ التطبيق أعداداً خاصة بلا دليل ولا نتائج مضمونة ولا طقوساً ملزمة.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quran97, _bukhari2014],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Kadir Gecesi',
  en: 'Laylat al-Qadr',
  ar: 'ليلة القدر',
);

const _quran97 = SourceReference(
  id: 'quran-97-al-qadr',
  title: 'Qur’an — Surah al-Qadr 97:1–5',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '97:1-5',
);

const _bukhari2014 = SourceReference(
  id: 'bukhari-2014',
  title: 'Sahih al-Bukhari 2014',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 32, Hadith 1',
);

const _bukhari2017 = SourceReference(
  id: 'bukhari-2017',
  title: 'Sahih al-Bukhari 2017',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 32, Hadith 4',
);

const _tirmidhi3513 = SourceReference(
  id: 'tirmidhi-3513',
  title: 'Jami at-Tirmidhi 3513',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 48, Hadith 144',
);

const _tdvLaylatAlQadr = SourceReference(
  id: 'tdv-kadir-gecesi-2001',
  title: 'TDV İslâm Ansiklopedisi — Kadir Gecesi',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'M. Sait Özervarlı, 2001',
);
