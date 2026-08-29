import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0177 research record for the Prophet's birth / Mawlid.
final ReligiousDayContent mawlidResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-night-mawlid',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.sahihHasanHadith,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.stronglyAttested,
    text: _title,
    sources: const [_muslim1162e, _tdvMawlid, _tdvRabiAlAwwal],
    lastReviewedAt: DateTime.utc(2026, 8, 29),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Mevlid, Hz. Muhammed’in doğumunu ve sonraki Müslüman toplumlarda onun doğumunu anma geleneğini ifade eder. Yaygın kabul 12 Rebîülevvel olsa da erken kaynaklarda gün konusunda farklı rivayetler vardır; uygulama 12 Rebîülevvel’i tartışmasız tarihsel kesinlik olarak sunmaz.',
    en: 'Mawlid refers to the birth of Prophet Muhammad and to later Muslim traditions commemorating his birth. Although 12 Rabi al-Awwal is the widely accepted date, early sources contain differing reports about the day, so the app does not present 12 Rabi al-Awwal as undisputed historical certainty.',
    ar: 'يشير المولد إلى ولادة النبي محمد ﷺ وإلى تقاليد المسلمين اللاحقة في إحياء ذكرى مولده. ورغم شيوع القول بالثاني عشر من ربيع الأول، فقد وردت روايات مختلفة في تحديد اليوم، لذلك لا يعرض التطبيق هذا التاريخ كيقين تاريخي لا خلاف فيه.',
  ),
  history: const LocalizedReligiousText(
    tr: 'TDV Mevlid maddesi, Hz. Peygamber’in Fil yılında doğduğuna dair güçlü tarih geleneğini aktarır; milâdî yıl için 569, 570 ve 571, Rebîülevvel günü için de 2, 8, 10, 12 veya 17 gibi farklı rivayetler bulunduğunu belirtir. Doğumun pazartesi oluşu ise sahih hadisle daha güçlü biçimde sabittir. Mevlid törenleri Hz. Peygamber döneminde değil, sonraki yüzyıllarda gelişen tarihî bir gelenektir.',
    en: 'The TDV Mawlid article reports the strong historical tradition that the Prophet was born in the Year of the Elephant, while noting differing estimates such as 569, 570 or 571 CE and differing Rabi al-Awwal dates including 2, 8, 10, 12 and 17. His birth on a Monday has stronger sound-hadith support. Mawlid ceremonies were not a practice of the Prophet’s lifetime but developed as a later historical tradition.',
    ar: 'تذكر مادة المولد في الموسوعة الإسلامية التركية قوة التقليد التاريخي القائل بولادة النبي ﷺ في عام الفيل، مع اختلاف التقديرات الميلادية بين 569 و570 و571 واختلاف أيام ربيع الأول بين 2 و8 و10 و12 و17. أما كون الولادة يوم الاثنين فله سند أصح في الحديث. واحتفالات المولد لم تكن ممارسة في حياة النبي ﷺ، بل تطورت كتقليد تاريخي في عصور لاحقة.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 1162e’de Hz. Peygamber pazartesi orucu sorulduğunda o gün doğduğunu ve vahyin o gün kendisine indirildiğini bildirir. Bu rivayet doğumun haftanın hangi günü olduğuna güçlü dayanak sağlar; ayın hangi günü olduğuna dair kesin bir tarih vermez.',
        en: 'In Sahih Muslim 1162e, when asked about fasting on Monday, the Prophet states that it was the day on which he was born and revelation came to him. This strongly supports the weekday of his birth but does not give an exact day of the lunar month.',
        ar: 'في صحيح مسلم 1162e، سئل النبي ﷺ عن صيام يوم الاثنين فذكر أنه اليوم الذي ولد فيه ونزل عليه فيه الوحي. وهذا دليل قوي على يوم الأسبوع، لكنه لا يحدد يوماً قطعياً من الشهر القمري.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1162e],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: '12 Rebîülevvel’i mevlid günü olarak anma, farklı coğrafyalarda zamanla gelişen bir gelenektir. Uygulama mevlid okuma, kandil yakma veya yerel tören biçimlerini tarihî-kültürel katmanda gösterir; bunları Hz. Peygamber döneminde sabitlenmiş özel ibadet diye sunmaz.',
        en: 'Commemorating 12 Rabi al-Awwal as Mawlid developed over time in different Muslim regions. The app places recitations, lights and local ceremonial forms in the historical-cultural layer rather than presenting them as a special ritual established in the Prophet’s lifetime.',
        ar: 'تطور إحياء الثاني عشر من ربيع الأول بوصفه يوم المولد عبر الزمن في مناطق إسلامية متعددة. ويعرض التطبيق قراءة المولد والإضاءة وأشكال الاحتفال المحلية ضمن الطبقة التاريخية والثقافية، لا كعبادة مخصوصة ثابتة في عهد النبي ﷺ.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvMawlid, _tdvRabiAlAwwal],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.noSpecificPracticeEstablished,
);

const _title = LocalizedReligiousText(
  tr: 'Mevlid Gecesi',
  en: 'Mawlid — The Prophet’s Birth',
  ar: 'المولد النبوي',
);

const _muslim1162e = SourceReference(
  id: 'muslim-1162e-monday-birth',
  title: 'Sahih Muslim 1162e',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 256',
);

const _tdvMawlid = SourceReference(
  id: 'tdv-islam-ansiklopedisi-mevlid',
  title: 'TDV İslâm Ansiklopedisi — Mevlid',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Mevlid maddesi — doğum tarihine dair rivayetler ve mevlid törenlerinin tarihi',
);

const _tdvRabiAlAwwal = SourceReference(
  id: 'tdv-islam-ansiklopedisi-rebiulevvel',
  title: 'TDV İslâm Ansiklopedisi — Rebîülevvel',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Rebîülevvel maddesi — 12 Rebîülevvel genel kabulü ve mevlid geleneği',
);
