import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0173 research record for Eid al-Fitr (Ramazan Bayramı).
///
/// Third-party material is paraphrased and cited by locator. No third-party
/// translation is copied. The record intentionally remains `research` until
/// religious and native TR/EN/AR review evidence is attached.
final ReligiousDayContent eidAlFitrResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-eid-al-fitr',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.sahihHasanHadith,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.stronglyAttested,
    text: _title,
    sources: const [
      _quranCompleteRamadan,
      _bukhari953,
      _bukhari958,
      _bukhari964,
      _tdvDiyanetEid,
    ],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Ramazan Bayramı (Îdü’l-fıtr), Ramazan orucunun tamamlanmasının ardından başlayan İslami bayramdır. Uygulama bayramın dinî dayanaklarını sahih sünnetten, toplumlarda gelişen kutlama biçimlerini ise gelenek katmanından ayrı gösterir.',
    en: 'Eid al-Fitr is the Islamic festival that begins after the completion of Ramadan fasting. The app separates religious practices established by authentic Sunnah from celebration customs that developed in Muslim communities.',
    ar: 'عيد الفطر هو العيد الإسلامي الذي يأتي بعد إتمام صيام رمضان. ويفصل التطبيق بين العبادات الثابتة بالسنة الصحيحة وبين عادات الاحتفال التي نشأت في المجتمعات الإسلامية.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Ramazan Bayramı Hz. Peygamber döneminden itibaren bayram namazı, hutbe ve sosyal dayanışmayla birlikte yaşanmıştır. Sonraki Müslüman toplumlarda ziyaret, ikram, çocukları sevindirme ve yerel bayramlaşma biçimleri gelişmiştir; bunlar sahih sünnetle sabit ibadetlerle aynı kaynak statüsünde sunulmaz.',
    en: 'Eid al-Fitr was observed from the Prophet’s time with the Eid prayer, sermon and communal solidarity. Later Muslim societies developed visits, hospitality, gifts for children and local greeting customs; these are not presented with the same source status as acts established by authentic Sunnah.',
    ar: 'عُرف عيد الفطر منذ عهد النبي ﷺ بصلاة العيد والخطبة والتكافل الاجتماعي. ثم نشأت في المجتمعات الإسلامية عادات للزيارة والضيافة وإدخال السرور على الأطفال والتهنئة، ولا تُعرض هذه العادات بالمرتبة المصدرية نفسها للعبادات الثابتة بالسنة الصحيحة.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Bakara 2:185 Ramazan günlerinin sayısının tamamlanmasını ve Allah’ın hidayeti için yüceltilmesini bildirir. Ayet Ramazan Bayramı adını veya bayram namazının ayrıntılarını doğrudan vermez; bayrama özgü uygulamalar için sünnet kaynakları ayrıca gösterilir.',
        en: 'Al-Baqarah 2:185 speaks of completing the prescribed period of Ramadan and magnifying Allah for His guidance. The verse does not directly name Eid al-Fitr or detail the Eid prayer; Sunnah sources are therefore shown separately for Eid-specific practices.',
        ar: 'تذكر سورة البقرة 2:185 إكمال عدة رمضان وتكبير الله على هدايته. ولا تسمّي الآية عيد الفطر مباشرة ولا تفصل صلاة العيد، لذلك تُعرض مصادر السنة بصورة مستقلة للممارسات الخاصة بالعيد.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranCompleteRamadan],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Buhârî’de Hz. Peygamber’in Ramazan Bayramı günü bayram namazını kıldığı ve hutbeyi namazdan sonra verdiği rivayet edilir; bayram namazı için ezan ve kamet okunmadığı da aynı sahih rivayet grubunda bildirilir.',
        en: 'Sahih al-Bukhari reports that the Prophet performed the Eid al-Fitr prayer and delivered the sermon after the prayer; the same authentic report group states that there was no adhan or iqama for the Eid prayer.',
        ar: 'يروي صحيح البخاري أن النبي ﷺ صلى يوم الفطر ثم خطب بعد الصلاة، وتذكر الروايات الصحيحة نفسها أنه لم يكن لصلاة العيد أذان ولا إقامة.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari958],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Hz. Enes rivayetine göre Hz. Peygamber Ramazan Bayramı namazına çıkmadan önce hurma yerdi. Bu sünnet bir zorunluluk veya sonuç garantisi gibi sunulmaz.',
        en: 'According to the report of Anas, the Prophet ate dates before going out for the Eid al-Fitr prayer. This Sunnah is not presented as an obligation or as carrying a guaranteed outcome.',
        ar: 'بحسب رواية أنس رضي الله عنه كان النبي ﷺ يأكل تمرات قبل خروجه لصلاة عيد الفطر. ولا تُعرض هذه السنة على أنها واجب أو سبب لنتيجة مضمونة.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari953],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahih rivayette Ramazan Bayramı günü iki rekât bayram namazı kılındığı ve ardından sadakanın teşvik edildiği bildirilir.',
        en: 'An authentic report states that two rak‘ahs were performed on Eid al-Fitr and that charity was encouraged afterwards.',
        ar: 'ثبت في الرواية الصحيحة أن صلاة عيد الفطر كانت ركعتين، وأن الصدقة حُثّ عليها بعد ذلك.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari964],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Aile ve akraba ziyaretleri, bayramlaşma, ikram, çocukları sevindirme ve farklı yerel kutlama biçimleri Müslüman toplumlarda güçlü kültürel geleneklerdir. Bunlar kültür/gelenek olarak etiketlenir; sahih hadiste sabit bir ibadet hükmü gibi gösterilmez.',
        en: 'Family visits, greetings, hospitality, bringing joy to children and other local celebration forms are strong cultural customs in Muslim societies. They are labelled as culture/tradition rather than as worship rulings established by authentic hadith.',
        ar: 'تُعد زيارة الأهل والأقارب والتهنئة والضيافة وإدخال السرور على الأطفال وصور الاحتفال المحلية عادات ثقافية راسخة في مجتمعات مسلمة. وتُصنَّف كتقاليد، لا كأحكام عبادة ثابتة بحديث صحيح.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvDiyanetEid],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Bayram namazı Ramazan Bayramı gününe özgü, sahih sünnetle sabit bir ibadettir. Uygulama mezheplere göre hüküm derecesi veya kişisel yükümlülük konusunda kendi başına fetva üretmez.',
        en: 'The Eid prayer is an Eid-specific act established by authentic Sunnah. The app does not independently issue a fatwa about its juristic classification across schools or an individual user’s obligation.',
        ar: 'صلاة العيد عبادة خاصة بالعيد ثابتة بالسنة الصحيحة. ولا يصدر التطبيق من تلقاء نفسه فتوى في درجتها الفقهية بين المذاهب أو في حكمها على مستخدم بعينه.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari958, _bukhari964],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Şükür, dua, zikir, sadaka ve akrabalık bağlarını gözetme gibi genel hayırlar bayramda da sürdürülebilir; uygulama bunlara kaynaksız özel sayı, kesin kabul veya maddi/manevi sonuç garantisi eklemez.',
        en: 'General good deeds such as gratitude, supplication, remembrance, charity and maintaining family ties may continue on Eid; the app does not attach unsupported special counts, guaranteed acceptance or guaranteed worldly/spiritual outcomes.',
        ar: 'تستمر في العيد أعمال الخير العامة كالشكر والدعاء والذكر والصدقة وصلة الرحم، ولا يضيف التطبيق إليها أعداداً خاصة بلا دليل ولا ضماناً للقبول أو لنتائج دنيوية أو روحية.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari964],
    ),
  ],
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Ramazan Bayramı',
  en: 'Eid al-Fitr',
  ar: 'عيد الفطر',
);

const _quranCompleteRamadan = SourceReference(
  id: 'quran-2-185-complete-ramadan',
  title: 'Qur’an — Al-Baqarah 2:185',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '2:185',
);

const _bukhari953 = SourceReference(
  id: 'bukhari-953-eid-fitr-dates',
  title: 'Sahih al-Bukhari 953',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 5',
);

const _bukhari958 = SourceReference(
  id: 'bukhari-958-eid-prayer-khutba',
  title: 'Sahih al-Bukhari 958–961',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadiths 10–12',
);

const _bukhari964 = SourceReference(
  id: 'bukhari-964-eid-two-rakah-charity',
  title: 'Sahih al-Bukhari 964',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 13',
);

const _tdvDiyanetEid = SourceReference(
  id: 'diyanet-ramazan-gunlukleri-bayram-mahiyeti',
  title: 'Diyanet İşleri Başkanlığı — Ramazan Günlükleri, Bayram ve Mahiyeti',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Bayram ve Mahiyeti bölümü',
);
