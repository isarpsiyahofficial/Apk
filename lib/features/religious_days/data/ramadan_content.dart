import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0172 research record for Ramadan.
///
/// Third-party material is paraphrased and cited by locator; no third-party
/// translation is copied. The record remains `research` until religious and
/// native-language review evidence is attached, so it cannot enter production.
final ReligiousDayContent ramadanResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-ramadan',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [
      _quranRamadan,
      _bukhari38,
      _bukhari1923,
      _bukhari1957,
      _tdvRamazan,
    ],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Ramazan, hicrî takvimin dokuzuncu ayıdır. Kur’an bu ayı Kur’an’ın indirildiği ay olarak anar ve şartları taşıyan müminlere bu ayda orucu farz kılar.',
    en: 'Ramadan is the ninth month of the Hijri calendar. The Qur’an identifies it as the month in which the Qur’an was sent down and prescribes fasting in it for believers to whom the obligation applies.',
    ar: 'رمضان هو الشهر التاسع من التقويم الهجري. ويذكره القرآن شهراً أُنزل فيه القرآن، ويفرض صيامه على المؤمنين الذين تتوافر فيهم شروط الوجوب.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Ramazan orucu hicretin Medine döneminde farz kılınmış ve İslam toplumlarının yıllık ibadet hayatının temel unsurlarından biri olmuştur. Zamanla farklı toplumlarda mahya, davul, toplu iftar ve benzeri kültürel uygulamalar gelişmiştir; bu gelenekler orucun Kur’an ve sahih sünnetle sabit hükümleriyle aynı dini statüde sunulmaz.',
    en: 'The Ramadan fast was prescribed during the Medinan period and became one of the central annual acts of worship in Muslim life. Over time, communities developed cultural customs around the month; those customs are not presented with the same religious status as duties and practices established by the Qur’an and authentic Sunnah.',
    ar: 'فُرض صيام رمضان في العهد المدني، وأصبح من العبادات السنوية المركزية في حياة المسلمين. ومع مرور الزمن نشأت في مجتمعات مختلفة عادات ثقافية مرتبطة بالشهر، ولا تُعرض هذه العادات بالمرتبة الدينية نفسها للأحكام والعبادات الثابتة بالقرآن والسنة الصحيحة.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Bakara 2:183–185 orucun müminlere farz kılındığını, Ramazan’ın Kur’an’ın indirildiği ay olduğunu ve hastalık veya yolculuk gibi durumlarda Kur’an’ın ayrıca kolaylık hükümleri bildirdiğini açıklar.',
        en: 'Al-Baqarah 2:183–185 prescribes fasting for believers, identifies Ramadan as the month in which the Qur’an was sent down, and states concessions connected with circumstances such as illness or travel.',
        ar: 'تقرر سورة البقرة 2:183–185 فرض الصيام على المؤمنين، وتذكر رمضان شهراً أُنزل فيه القرآن، وتبين رخصاً تتعلق بأحوال مثل المرض والسفر.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranRamadan],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih hadiste Ramazan orucunu imanla ve sevabını Allah’tan umarak tutmanın fazileti bildirilir.',
        en: 'Authentic hadith reports the virtue of fasting Ramadan with faith and hope for reward from Allah.',
        ar: 'ثبت في الحديث الصحيح فضل صيام رمضان إيماناً واحتساباً.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari38],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahur yapmanın bereketli olduğu sahih hadiste bildirilmiştir. Bu rehber sahuru farz gibi göstermez.',
        en: 'Authentic hadith describes suhur as containing blessing. This guide does not present suhur as obligatory.',
        ar: 'ثبت في الحديث الصحيح أن في السحور بركة، ولا يعرض هذا الدليل السحور على أنه واجب.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari1923],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Güneş battığında iftarın geciktirilmemesi sahih rivayetle teşvik edilmiştir.',
        en: 'Authentic hadith encourages not delaying the breaking of the fast after sunset.',
        ar: 'حثت الأحاديث الصحيحة على تعجيل الفطر بعد غروب الشمس وعدم تأخيره.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari1957],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Ramazan çevresinde toplu iftarlar, mahya, davul, maniler ve farklı yerel uygulamalar oluşmuştur. Bunlar kültürel gelenek olarak belirtilir; orucun dinî hükümlerinin kaynağı gibi sunulmaz.',
        en: 'Communities have developed shared meals and many local Ramadan customs. They are identified as cultural traditions rather than sources for the religious rulings of the fast.',
        ar: 'نشأت في المجتمعات الإسلامية موائد جماعية وعادات محلية متعددة في رمضان. وتُعرَّف بوصفها تقاليد ثقافية، لا مصادر لأحكام الصيام الشرعية.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvRamazan],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Ramazan ayında oruç, Kur’an’ın açık hükmüyle farzdır. Uygulama hastalık, yolculuk ve diğer kişisel fıkhî durumlarda tek başına hüküm üretmez; kullanıcıyı güvenilir dinî danışmanlığa yönlendirecek sınırı korur.',
        en: 'Fasting in Ramadan is prescribed explicitly by the Qur’an. The app does not independently issue rulings for illness, travel, or other individual jurisprudential circumstances and keeps the boundary toward qualified religious guidance.',
        ar: 'صيام رمضان مفروض بنص القرآن. ولا يصدر التطبيق من تلقاء نفسه أحكاماً فردية في حالات المرض أو السفر أو غيرها من المسائل الفقهية الشخصية، ويحافظ على الإحالة إلى الإرشاد الديني المؤهل عند الحاجة.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranRamadan, _bukhari38],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Kur’an tilaveti, dua, zikir, sadaka, tövbe ve diğer genel ibadetler Ramazan’da artırılabilir; uygulama bunlara kaynaksız özel sayı veya garanti edilmiş sonuç eklemez.',
        en: 'Qur’an recitation, supplication, remembrance, charity, repentance and other general acts of worship may be increased in Ramadan; the app does not attach unsupported special counts or guaranteed outcomes to them.',
        ar: 'يمكن الإكثار في رمضان من تلاوة القرآن والدعاء والذكر والصدقة والتوبة وسائر العبادات العامة، ولا يضيف التطبيق إليها أعداداً خاصة بلا دليل ولا نتائج مضمونة.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranRamadan, _bukhari38],
    ),
  ],
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Ramazan',
  en: 'Ramadan',
  ar: 'رمضان',
);

const _quranRamadan = SourceReference(
  id: 'quran-2-183-185-ramadan',
  title: 'Qur’an — Al-Baqarah 2:183–185',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '2:183-185',
);

const _bukhari38 = SourceReference(
  id: 'bukhari-38-ramadan-fast',
  title: 'Sahih al-Bukhari 38',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 2, Hadith 31',
);

const _bukhari1923 = SourceReference(
  id: 'bukhari-1923-suhur',
  title: 'Sahih al-Bukhari 1923',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 30, Hadith 32',
);

const _bukhari1957 = SourceReference(
  id: 'bukhari-1957-iftar',
  title: 'Sahih al-Bukhari 1957',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 30, Hadith 64',
);

const _tdvRamazan = SourceReference(
  id: 'tdv-ramazan',
  title: 'TDV İslâm Ansiklopedisi — Ramazan',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Ramazan maddesi',
);
