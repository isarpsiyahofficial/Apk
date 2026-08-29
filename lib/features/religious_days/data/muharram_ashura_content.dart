import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0176 research record for Muharram and the Day of Ashura.
///
/// Third-party material is paraphrased and cited by locator. No third-party
/// translation is copied. The record intentionally remains `research` until
/// religious and native TR/EN/AR review evidence is attached.
final ReligiousDayContent muharramAshuraResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-muharram-ashura',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [
      _quranSacredMonths,
      _muslim1163b,
      _muslim1162b,
      _muslim1134b,
      _tdvAshura,
      _tdvKarbala,
    ],
    lastReviewedAt: DateTime.utc(2026, 8, 29),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Muharrem hicrî yılın ilk ayıdır ve haram aylardan biridir. Âşûrâ, Muharrem ayının onuncu günüdür. Bu rehber, Muharrem ayının genel faziletini, Âşûrâ orucuna dair sahih rivayetleri ve 10 Muharrem 61’deki Kerbelâ faciasının tarihî hatırasını birbirine karıştırmadan ele alır.',
    en: 'Muharram is the first month of the Hijri year and one of the sacred months. Ashura is the tenth day of Muharram. This guide keeps distinct the general virtue of Muharram, the sound reports about fasting Ashura, and the historical memory of the tragedy of Karbala on 10 Muharram 61 AH.',
    ar: 'المحرّم هو الشهر الأول من السنة الهجرية وأحد الأشهر الحرم، وعاشوراء هو اليوم العاشر منه. ويفصل هذا الدليل بين فضل شهر المحرّم عموماً، والروايات الصحيحة في صيام عاشوراء، والذكرى التاريخية لمأساة كربلاء في العاشر من المحرّم سنة 61هـ.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Âşûrâ, erken İslâm kaynaklarında oruçla ilişkili olarak yer alır. Daha sonra 10 Muharrem 61’de (10 Ekim 680) Hz. Hüseyin ve beraberindekilerin Kerbelâ’da öldürülmesi, günün İslâm tarihindeki anlamına çok güçlü bir yas ve Ehl-i beyt hatırası ekledi. Uygulama bu tarihî olayı küçültmez; fakat tarihî matem geleneklerini sahih hadisle sabit özel ibadetlerle aynı kaynak sınıfında da göstermez.',
    en: 'Ashura appears in early Islamic sources in connection with fasting. The killing of Husayn ibn Ali and his companions at Karbala on 10 Muharram 61 AH (10 October 680) later added a profound historical memory of mourning and remembrance of the Prophet’s family. The app does not minimize that tragedy, but it also does not classify later mourning customs as though they were the same type of evidence as worship established by sound hadith.',
    ar: 'وردت عاشوراء في المصادر الإسلامية المبكرة في سياق الصيام. ثم أضاف استشهاد الحسين بن علي ومن معه في كربلاء يوم 10 محرّم سنة 61هـ (10 أكتوبر 680م) بعداً تاريخياً عميقاً من الحزن وذكر أهل البيت. ولا يقلل التطبيق من هذه المأساة، كما لا يساوي بين تقاليد الحداد اللاحقة وبين العبادات الثابتة بحديث صحيح من جهة نوع الدليل.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Tevbe 9:36, yılın on iki ay olduğunu ve bunlardan dördünün haram aylar olduğunu bildirir. Ayet Muharrem veya Âşûrâ adını tek başına söylemez; bu nedenle uygulama ayeti doğrudan “Âşûrâ orucu emri” gibi sunmaz.',
        en: 'At-Tawbah 9:36 states that the year has twelve months and that four of them are sacred. The verse does not itself name Muharram or Ashura, so the app does not present it as a direct command to fast Ashura.',
        ar: 'تقرر سورة التوبة 9:36 أن السنة اثنا عشر شهراً وأن منها أربعة حرم. ولا تسمي الآية المحرّم أو عاشوراء بذاتهما، لذلك لا يعرضها التطبيق كأمر قرآني مباشر بصيام عاشوراء.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranSacredMonths],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 1163b’de Ramazan’dan sonra en faziletli orucun Allah’ın ayı Muharrem’de tutulan oruç olduğu aktarılır. Bu rivayet ayın genel faziletine ilişkindir; uygulama bundan Muharrem’in her gününün zorunlu oruç olduğu sonucunu üretmez.',
        en: 'Sahih Muslim 1163b reports that the best fasting after Ramadan is fasting in Allah’s month of Muharram. This concerns the month’s general virtue; the app does not turn it into a claim that every day of Muharram must be fasted.',
        ar: 'يروي صحيح مسلم 1163b أن أفضل الصيام بعد رمضان صيام شهر الله المحرّم. وهذا في فضل الشهر عموماً، ولا يحوله التطبيق إلى قول بوجوب صيام كل أيام المحرّم.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1163b],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 1162b’de Âşûrâ günü orucunun önceki yılın günahlarına kefaret olmasının umulduğu bildirilir. Uygulama rivayetin sınırını korur ve bunu bütün günahların şart gözetmeksizin kesin silineceği garantisine dönüştürmez.',
        en: 'Sahih Muslim 1162b reports the hope that fasting Ashura expiates the sins of the preceding year. The app keeps the report within its source and does not convert it into an unconditional guarantee that every sin is automatically erased.',
        ar: 'يروي صحيح مسلم 1162b رجاء تكفير صيام عاشوراء لذنوب السنة الماضية. ويحفظ التطبيق حدود الرواية ولا يحولها إلى ضمان مطلق بمحو كل الذنوب آلياً بلا قيد.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1162b],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 1134b’de Hz. Peygamber’in bir sonraki yıla ulaşırsa dokuzuncu günü de oruç tutacağını söylediği aktarılır. Uygulama bu rivayeti kaynaklı uygulama olarak gösterir; kaynaksız özel gün kombinasyonları icat etmez.',
        en: 'Sahih Muslim 1134b reports that the Prophet intended to fast the ninth day if he lived to the following year. The app presents this as a sourced report and does not invent additional day combinations without evidence.',
        ar: 'يروي صحيح مسلم 1134b أن النبي ﷺ عزم على صيام اليوم التاسع إن بقي إلى العام المقبل. ويعرض التطبيق ذلك كرواية موثقة ولا ينشئ تركيبات أيام إضافية بلا دليل.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1134b],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Kerbelâ sonrasında gelişen matem biçimleri ile Anadolu ve başka bölgelerdeki aşure yemeği gibi kültürel uygulamalar tarihî ve geleneksel katmanda gösterilir. TDV Âşûrâ maddesi, Âşûrâ’ya özgü yıkanma, sürme çekme, kına, özel yemek, kurban ve benzeri birçok popüler uygulama için sahih rivayet bulunmadığını özellikle belirtir.',
        en: 'Mourning forms that developed after Karbala and cultural practices such as preparing ashura pudding in Anatolia and elsewhere are shown in the historical/traditional layer. The TDV Encyclopaedia of Islam specifically notes that many popular Ashura-specific practices—such as ritual washing, kohl, henna, special foods or sacrifice—are not established by sound reports.',
        ar: 'تعرض أشكال الحداد التي تطورت بعد كربلاء والعادات الثقافية مثل إعداد طعام عاشوراء في الأناضول وغيرها ضمن طبقة التاريخ والتقاليد. وتنبّه مادة «عاشوراء» في الموسوعة الإسلامية التركية إلى أن كثيراً من الممارسات الشعبية الخاصة بعاشوراء، كالغسل والكحل والحناء والأطعمة الخاصة والذبح، لا تثبت برواية صحيحة.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvAshura],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Âşûrâ orucu sahih hadislerle sabittir; ayrıca dokuzuncu günü oruç tutma niyeti Sahih Müslim 1134b’de yer alır. Uygulama bunları kaynaklarıyla gösterir, orucu farz gibi sunmaz ve sahih kaynağı olmayan özel dua, özel namaz veya özel tekrar sayısı eklemez.',
        en: 'Fasting Ashura is established by sound hadith, and the intention to fast the ninth is reported in Sahih Muslim 1134b. The app presents these with their sources, does not label the fast as obligatory, and does not add a special prayer, special salah or repetition count without sound evidence.',
        ar: 'ثبت صيام عاشوراء بأحاديث صحيحة، كما ورد العزم على صيام التاسع في صحيح مسلم 1134b. ويعرض التطبيق ذلك بمصادره، ولا يصف الصيام بأنه فرض، ولا يضيف دعاءً أو صلاةً أو عدداً خاصاً بلا دليل صحيح.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1162b, _muslim1134b],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Muharrem’de dua, tövbe, Kur’an okuma, sadaka ve diğer genel ibadetler yapılabilir. Bunlar Âşûrâ’ya özgü yeni bir ibadet formu veya kesin sonuç garantisi olarak sunulmaz.',
        en: 'Supplication, repentance, Qur’an reading, charity and other general acts of worship may be practiced in Muharram. They are not presented as a newly invented Ashura-specific ritual or as a guaranteed route to a particular outcome.',
        ar: 'يمكن في المحرّم الدعاء والتوبة وقراءة القرآن والصدقة وسائر العبادات العامة، ولا تعرض هذه الأعمال كطقس جديد مخصوص بعاشوراء أو كضمان لنتيجة معينة.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranSacredMonths, _muslim1163b],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Muharrem ve Âşûrâ',
  en: 'Muharram and Ashura',
  ar: 'المحرّم وعاشوراء',
);

const _quranSacredMonths = SourceReference(
  id: 'quran-9-36-sacred-months',
  title: 'Qur’an — At-Tawbah 9:36',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '9:36',
);

const _muslim1163b = SourceReference(
  id: 'muslim-1163b-muharram-fast',
  title: 'Sahih Muslim 1163b',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 262',
);

const _muslim1162b = SourceReference(
  id: 'muslim-1162b-ashura-fast',
  title: 'Sahih Muslim 1162b',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 253',
);

const _muslim1134b = SourceReference(
  id: 'muslim-1134b-ninth-ashura',
  title: 'Sahih Muslim 1134b',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 173',
);

const _tdvAshura = SourceReference(
  id: 'tdv-islam-ansiklopedisi-asura',
  title: 'TDV İslâm Ansiklopedisi — Âşûrâ',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Âşûrâ maddesi — 10 Muharrem, oruç ve gelenek ayrımı',
);

const _tdvKarbala = SourceReference(
  id: 'tdv-islam-ansiklopedisi-kerbela',
  title: 'TDV İslâm Ansiklopedisi — Kerbelâ',
  sourceClass: ReligiousSourceClass.earlyIslamicHistoryTafsir,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Kerbelâ maddesi — 10 Muharrem 61 / 10 Ekim 680',
);
