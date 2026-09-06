import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0174 research record for Eid al-Adha (Kurban Bayramı).
///
/// Third-party material is paraphrased and cited by locator. No third-party
/// translation is copied. The record intentionally remains `research` until
/// religious and native TR/EN/AR review evidence is attached.
final ReligiousDayContent eidAlAdhaResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-eid-al-adha',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [
      _quranSacrifice,
      _quranPiety,
      _bukhari5558,
      _bukhari5560,
      _tdvKurban,
      _tdvBayram,
    ],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Kurban Bayramı (Îdü’l-adhâ), bayram namazı ve kurban ibadetinin öne çıktığı İslami bayramdır. Kur’an kurbanlık hayvanları Allah’ın şiarlarından sayar; et ve kanın değil takvanın esas olduğunu vurgular. Uygulama ibadetin kaynak dayanağını, mezheplere göre değişebilen fıkhî yükümlülük derecesinden ayrı tutar.',
    en: 'Eid al-Adha is the Islamic festival in which the Eid prayer and ritual sacrifice are prominent. The Qur’an describes sacrificial animals among Allah’s symbols and stresses that piety—not meat or blood—is what matters. The app keeps the sourced practice separate from juristic classifications that can differ between schools.',
    ar: 'عيد الأضحى هو العيد الإسلامي الذي تبرز فيه صلاة العيد وشعيرة الأضحية. ويجعل القرآن بهيمة الأنعام المعدّة للنحر من شعائر الله، ويؤكد أن المقصود هو التقوى لا اللحم ولا الدم. ويفصل التطبيق بين أصل العبادة الموثق وبين درجة حكمها الفقهي التي قد تختلف بين المذاهب.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Kurban ibadeti Kur’an ve sahih sünnette açık dayanaklara sahiptir ve Kurban Bayramı uygulaması Hz. Peygamber döneminde bayram namazı ile kurban kesiminin aynı gün içindeki sırasıyla da aktarılmıştır. Sonraki Müslüman toplumlarda aile ziyaretleri, ikram ve yerel bayramlaşma biçimleri gelişmiştir; bunlar kaynakta sabit ibadetlerle aynı statüde sunulmaz.',
    en: 'Ritual sacrifice has explicit Qur’anic and authentic-Sunnah foundations, and reports from the Prophet’s time describe the order of Eid prayer followed by sacrifice on the festival day. Later Muslim communities developed family visits, hospitality and local greeting customs; these are not presented with the same status as sourced acts of worship.',
    ar: 'للأضحية أصل صريح في القرآن والسنة الصحيحة، وتصف الروايات من عهد النبي ﷺ ترتيب صلاة العيد ثم النحر في يوم العيد. ثم نشأت في المجتمعات الإسلامية عادات للزيارة والضيافة والتهنئة المحلية، ولا تُعرض هذه العادات بالمرتبة نفسها للعبادات الثابتة بالمصادر.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Hac 22:36 kurbanlık büyükbaş hayvanları Allah’ın şiarlarından sayar; Allah’ın adının anılmasını, etinden yenmesini ve ihtiyaç sahiplerinin doyurulmasını bildirir. Hac 22:37 ise et ve kanın Allah’a ulaşmadığını, esas olanın takva olduğunu vurgular.',
        en: 'Al-Hajj 22:36 describes sacrificial animals among Allah’s symbols, mentions pronouncing Allah’s name, eating from them and feeding people in need. Al-Hajj 22:37 stresses that neither meat nor blood reaches Allah; what matters is piety.',
        ar: 'تجعل سورة الحج 22:36 البدن من شعائر الله، وتذكر اسم الله عليها والأكل منها وإطعام المحتاج. وتؤكد الآية 22:37 أن لحومها ودماءها لا تنال الله وإنما تناله التقوى.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranSacrifice, _quranPiety],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Buhârî 5560’ta bayram günü önce namazın kılındığı, ardından kurban kesildiği aktarılır; namazdan önce yapılan kesimin bayram kurbanı hükmünde olmadığı belirtilir.',
        en: 'Sahih al-Bukhari 5560 reports that the Eid prayer came first and the sacrifice followed; a slaughter made before the prayer was not treated as the festival sacrifice.',
        ar: 'يروي صحيح البخاري 5560 أن صلاة العيد كانت أولاً ثم يأتي النحر، وأن الذبح قبل الصلاة لا يكون أضحية العيد.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari5560],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahih Buhârî 5558’de Hz. Peygamber’in iki koçu kurban ettiği, Allah’ın adını anıp tekbir getirdiği rivayet edilir. Bu rivayet ibadetin sahih sünnetteki uygulama örneğidir; sayı bütün kullanıcılar için zorunlu hedefe dönüştürülmez.',
        en: 'Sahih al-Bukhari 5558 reports that the Prophet sacrificed two rams while mentioning Allah’s name and saying takbir. This is an authentic-Sunnah practice report; the number is not converted into a mandatory target for every user.',
        ar: 'يروي صحيح البخاري 5558 أن النبي ﷺ ضحى بكبشين وسمّى الله وكبّر. وهذه رواية صحيحة في صفة الفعل، ولا يحوّل التطبيق عدد الأضاحي فيها إلى هدف إلزامي لكل مستخدم.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari5558],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Aile ve akraba ziyaretleri, bayramlaşma, ikram ve farklı yerel kutlama biçimleri Müslüman toplumlarda gelişen kültürel geleneklerdir. Uygulama bunları Kur’an veya sahih hadisle sabit özel ibadet gibi etiketlemez.',
        en: 'Family visits, greetings, hospitality and local celebration forms are cultural customs that developed in Muslim societies. The app does not label them as specific acts of worship established by the Qur’an or authentic hadith.',
        ar: 'زيارة الأهل والأقارب والتهنئة والضيافة وصور الاحتفال المحلية عادات ثقافية نشأت في المجتمعات الإسلامية. ولا يصنفها التطبيق عبادات خاصة ثابتة بالقرآن أو الحديث الصحيح.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvBayram],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Bayram namazı ve kurban ibadeti güçlü kaynaklarla sabittir. Kurbanın kim için hangi fıkhî derecede yükümlülük olduğu mezheplere ve kişisel şartlara göre değişebileceğinden uygulama tek başına farz/vacip/sünnet fetvası üretmez; kişisel hüküm için ehil dinî otoriteye başvurulmasını önerir.',
        en: 'The Eid prayer and ritual sacrifice are established by strong sources. Because the juristic degree of obligation for sacrifice can differ by school and personal circumstances, the app does not independently issue a farḍ/wājib/sunnah ruling for an individual; users should consult a qualified religious authority for personal rulings.',
        ar: 'صلاة العيد والأضحية ثابتتان بأدلة قوية. ولأن درجة حكم الأضحية قد تختلف باختلاف المذهب وحال الشخص، فلا يصدر التطبيق من تلقاء نفسه حكماً شخصياً بأنها فرض أو واجب أو سنة، ويوصي بالرجوع إلى جهة علمية مؤهلة في المسائل الفردية.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_quranSacrifice, _quranPiety, _bukhari5560],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Şükür, Allah’ı anma, ihtiyaç sahibini doyurma, sadaka ve akrabalık bağlarını gözetme gibi genel hayırlar bayramda da sürdürülebilir. Uygulama bunlara kaynaksız özel sayı, kesin kabul, kesin şifa veya maddi sonuç garantisi eklemez.',
        en: 'General good deeds such as gratitude, remembrance of Allah, feeding people in need, charity and maintaining family ties may continue during Eid. The app does not attach unsupported special counts or guarantees of acceptance, healing or material outcomes.',
        ar: 'تستمر في العيد أعمال الخير العامة كالشكر وذكر الله وإطعام المحتاج والصدقة وصلة الرحم. ولا يضيف التطبيق إليها أعداداً خاصة بلا دليل ولا ضماناً للقبول أو الشفاء أو النتائج المادية.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranSacrifice, _quranPiety],
    ),
  ],
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Kurban Bayramı',
  en: 'Eid al-Adha',
  ar: 'عيد الأضحى',
);

const _quranSacrifice = SourceReference(
  id: 'quran-22-36-sacrificial-symbols',
  title: 'Qur’an — Al-Hajj 22:36',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '22:36',
);

const _quranPiety = SourceReference(
  id: 'quran-22-37-piety',
  title: 'Qur’an — Al-Hajj 22:37',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '22:37',
);

const _bukhari5558 = SourceReference(
  id: 'bukhari-5558-prophetic-sacrifice',
  title: 'Sahih al-Bukhari 5558',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 73, Hadith 14',
);

const _bukhari5560 = SourceReference(
  id: 'bukhari-5560-sacrifice-after-eid-prayer',
  title: 'Sahih al-Bukhari 5560',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 73, Hadith 16',
);

const _tdvKurban = SourceReference(
  id: 'tdv-islam-ansiklopedisi-kurban',
  title: 'TDV İslâm Ansiklopedisi — Kurban',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Kurban maddesi — İslâm’da kurban ve fıkhî değerlendirmeler',
);

const _tdvBayram = SourceReference(
  id: 'tdv-islam-ansiklopedisi-bayram',
  title: 'TDV İslâm Ansiklopedisi — Bayram',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Bayram maddesi — dinî ve sosyal uygulamalar',
);
