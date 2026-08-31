import 'pre_islam_world_context.dart';

enum IslamicHistoryTheme {
  science,
  medicine,
  mathematicsAstronomy,
  philosophyThought,
  hadithTafsirFiqh,
  artArchitecture,
  tradeUrbanization,
  education,
  womenHistoricalRoles,
}

enum HorizontalThemeCertainty { broadDevelopment, contestedInterpretation }

class HorizontalThemeSource {
  const HorizontalThemeSource({required this.locator, required this.workFamilyId});

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class IslamicHistoryThemeEntry {
  const IslamicHistoryThemeEntry({
    required this.id,
    required this.theme,
    required this.title,
    required this.summary,
    required this.startYearCe,
    required this.endYearCe,
    required this.certainty,
    required this.caveat,
    required this.sourceIds,
    required this.status,
  });

  final String id;
  final IslamicHistoryTheme theme;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final HorizontalThemeCertainty certainty;
  final LocalizedHistorySummary caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class IslamicHistoryHorizontalThemesDataset {
  IslamicHistoryHorizontalThemesDataset._({required this.sources, required this.entries});

  factory IslamicHistoryHorizontalThemesDataset.validated({
    required List<HorizontalThemeSource> sources,
    required List<IslamicHistoryThemeEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0219 horizontal history dataset must not be empty.');
    }

    final sourcesById = <String, HorizontalThemeSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0219 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final ids = <String>{};
    final themes = <IslamicHistoryTheme>{};
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !ids.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          !entry.caveat.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((id) => !sourcesById.containsKey(id))) {
        throw StateError('T0219 entry failed identity/content/date/source validation.');
      }
      final families = entry.sourceIds.map((id) => sourcesById[id]!.workFamilyId).toSet();
      if (families.length < 2) {
        throw StateError('T0219 entries require two independent academic work families.');
      }
      themes.add(entry.theme);
    }

    final missingThemes = IslamicHistoryTheme.values.toSet().difference(themes);
    if (missingThemes.isNotEmpty) {
      throw StateError('Missing required T0219 horizontal themes: $missingThemes');
    }

    return IslamicHistoryHorizontalThemesDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  final List<HorizontalThemeSource> sources;
  final List<IslamicHistoryThemeEntry> entries;

  List<IslamicHistoryThemeEntry> get productionEntries => List.unmodifiable(
        entries.where((entry) => entry.status == HistoryResearchStatus.reviewedForProduction),
      );
}

const islamicHistoryT0219Sources = <HorizontalThemeSource>[
  HorizontalThemeSource(
    workFamilyId: 'saliba_islamic_science',
    locator: HistorySourceLocator(
      id: 'saliba_islamic_science',
      kind: HistorySourceKind.academicMonograph,
      citation: 'George Saliba, Islamic Science and the Making of the European Renaissance, MIT Press, 2007.',
      locator: 'doi:10.7551/mitpress/3981.001.0001',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'pormann_savage_smith_medicine',
    locator: HistorySourceLocator(
      id: 'pormann_savage_smith_medicine',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Peter E. Pormann and Emilie Savage-Smith, Medieval Islamic Medicine, Edinburgh University Press, 2007.',
      locator: 'ISBN:9780748620678',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'adamson_philosophy_islamic_world',
    locator: HistorySourceLocator(
      id: 'adamson_philosophy_islamic_world',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Peter Adamson, Philosophy in the Islamic World, Oxford University Press, 2016.',
      locator: 'ISBN:9780199577491',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'hallaq_origins_islamic_law',
    locator: HistorySourceLocator(
      id: 'hallaq_origins_islamic_law',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Wael B. Hallaq, The Origins and Evolution of Islamic Law, Cambridge University Press, 2005.',
      locator: 'doi:10.1017/CBO9780511818783',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'melchert_sunni_schools',
    locator: HistorySourceLocator(
      id: 'melchert_sunni_schools',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Christopher Melchert, The Formation of the Sunni Schools of Law, 9th-10th Centuries C.E., Brill, 1997.',
      locator: 'ISBN:9789004109520',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'ettinghausen_grabar_jenkins_art',
    locator: HistorySourceLocator(
      id: 'ettinghausen_grabar_jenkins_art',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Richard Ettinghausen, Oleg Grabar and Marilyn Jenkins-Madina, Islamic Art and Architecture, 650-1250, Yale University Press, 2002.',
      locator: 'doi:10.37862/aaeportal.00202',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'lapidus_history_islamic_societies',
    locator: HistorySourceLocator(
      id: 'lapidus_societies_horizontal',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Ira M. Lapidus, A History of Islamic Societies, 3rd ed., Cambridge University Press, 2014.',
      locator: 'doi:10.1017/CBO9781139048828',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'makdisi_rise_colleges',
    locator: HistorySourceLocator(
      id: 'makdisi_rise_colleges',
      kind: HistorySourceKind.academicMonograph,
      citation: 'George Makdisi, The Rise of Colleges: Institutions of Learning in Islam and the West, Edinburgh University Press, 1981.',
      locator: 'ISBN:9780852243756',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'sayeed_women_knowledge',
    locator: HistorySourceLocator(
      id: 'sayeed_women_knowledge',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Asma Sayeed, Women and the Transmission of Religious Knowledge in Islam, Cambridge University Press, 2013.',
      locator: 'doi:10.1017/CBO9781139381871',
    ),
  ),
  HorizontalThemeSource(
    workFamilyId: 'ahmed_women_gender',
    locator: HistorySourceLocator(
      id: 'ahmed_women_gender',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Leila Ahmed, Women and Gender in Islam: Historical Roots of a Modern Debate, Yale University Press.',
      locator: 'ISBN:9780300257311',
    ),
  ),
];

const islamicHistoryT0219Entries = <IslamicHistoryThemeEntry>[
  IslamicHistoryThemeEntry(
    id: 'science_history', theme: IslamicHistoryTheme.science,
    title: LocalizedHistorySummary(tr: 'Bilim tarihi', en: 'History of science', ar: 'تاريخ العلوم'),
    summary: LocalizedHistorySummary(
      tr: 'İslam dünyasındaki bilimsel faaliyetler çeviri, gözlem, hesap, eleştiri ve yeni araştırma gelenekleriyle farklı merkezlerde gelişti; tek bir yükseliş ve çöküş anlatısına indirgenmez.',
      en: 'Scientific activity in Islamic societies developed through translation, observation, calculation, criticism and new research traditions across multiple centres; it should not be reduced to one rise-and-decline story.',
      ar: 'تطورت الأنشطة العلمية في المجتمعات الإسلامية عبر الترجمة والرصد والحساب والنقد وتقاليد بحثية جديدة في مراكز متعددة، ولا ينبغي اختزالها في قصة صعود وانحدار واحدة.'),
    startYearCe: 750, endYearCe: 1600, certainty: HorizontalThemeCertainty.broadDevelopment,
    caveat: LocalizedHistorySummary(tr: 'Dönem sınırları öğreticidir ve bölgelere göre değişir.', en: 'Period boundaries are pedagogical and vary by region.', ar: 'حدود الفترات تعليمية وتختلف باختلاف المناطق.'),
    sourceIds: ['saliba_islamic_science', 'lapidus_societies_horizontal'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'medicine_history', theme: IslamicHistoryTheme.medicine,
    title: LocalizedHistorySummary(tr: 'Tıp tarihi', en: 'History of medicine', ar: 'تاريخ الطب'),
    summary: LocalizedHistorySummary(tr: 'Tıp bilgisi çeviri, klinik gözlem, farmakoloji, hastane uygulamaları ve farklı dinî-kültürel toplulukların katkılarıyla gelişti.', en: 'Medical knowledge developed through translation, clinical observation, pharmacology, hospital practice and contributions from diverse religious and cultural communities.', ar: 'تطورت المعرفة الطبية عبر الترجمة والملاحظة السريرية وعلم الأدوية وممارسات المستشفيات وإسهامات جماعات دينية وثقافية متعددة.'),
    startYearCe: 750, endYearCe: 1500, certainty: HorizontalThemeCertainty.broadDevelopment,
    caveat: LocalizedHistorySummary(tr: 'Tıp tarihi yalnız saray hekimleri veya tek bir şehir üzerinden anlatılamaz.', en: 'Medical history cannot be represented only through court physicians or a single city.', ar: 'لا يمكن تمثيل تاريخ الطب من خلال أطباء البلاط أو مدينة واحدة فقط.'),
    sourceIds: ['pormann_savage_smith_medicine', 'lapidus_societies_horizontal'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'mathematics_astronomy_history', theme: IslamicHistoryTheme.mathematicsAstronomy,
    title: LocalizedHistorySummary(tr: 'Matematik ve astronomi', en: 'Mathematics and astronomy', ar: 'الرياضيات والفلك'),
    summary: LocalizedHistorySummary(tr: 'Matematik ve astronomi; hesap, cebir, geometrik yöntemler, gözlem ve astronomik modellerin geliştirilmesiyle uzun süreli bir araştırma alanı oluşturdu.', en: 'Mathematics and astronomy formed long-running fields of inquiry through calculation, algebra, geometrical methods, observation and the development of astronomical models.', ar: 'شكّلت الرياضيات والفلك مجالين ممتدين للبحث عبر الحساب والجبر والأساليب الهندسية والرصد وتطوير النماذج الفلكية.'),
    startYearCe: 780, endYearCe: 1600, certainty: HorizontalThemeCertainty.broadDevelopment,
    caveat: LocalizedHistorySummary(tr: 'Katkılar farklı diller, bölgeler ve kurumlar arasında dolaşmıştır.', en: 'Contributions circulated across different languages, regions and institutions.', ar: 'تداولت الإسهامات بين لغات ومناطق ومؤسسات مختلفة.'),
    sourceIds: ['saliba_islamic_science', 'lapidus_societies_horizontal'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'philosophy_thought_history', theme: IslamicHistoryTheme.philosophyThought,
    title: LocalizedHistorySummary(tr: 'Felsefe ve düşünce tarihi', en: 'History of philosophy and thought', ar: 'تاريخ الفلسفة والفكر'),
    summary: LocalizedHistorySummary(tr: 'Felsefi düşünce Müslüman, Hristiyan ve Yahudi düşünürlerin yer aldığı çok dilli bir entelektüel ortamda mantık, metafizik, etik ve doğa felsefesi tartışmalarıyla gelişti.', en: 'Philosophical thought developed in a multilingual intellectual environment involving Muslim, Christian and Jewish thinkers, with debates in logic, metaphysics, ethics and natural philosophy.', ar: 'تطور الفكر الفلسفي في بيئة فكرية متعددة اللغات شارك فيها مفكرون مسلمون ومسيحيون ويهود، وشملت مباحث المنطق والميتافيزيقا والأخلاق والفلسفة الطبيعية.'),
    startYearCe: 800, endYearCe: 1900, certainty: HorizontalThemeCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(tr: 'Felsefe ile kelâmın ilişkisi dönem ve düşünürlere göre değişir; tek bir çatışma modeli kurulmaz.', en: 'Relations between philosophy and kalam vary by period and thinker; no single conflict model is assumed.', ar: 'تختلف العلاقة بين الفلسفة وعلم الكلام بحسب الفترات والمفكرين، ولا يُفترض نموذج صراع واحد.'),
    sourceIds: ['adamson_philosophy_islamic_world', 'lapidus_societies_horizontal'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'hadith_tafsir_fiqh_history', theme: IslamicHistoryTheme.hadithTafsirFiqh,
    title: LocalizedHistorySummary(tr: 'Hadis, tefsir ve fıkıh ilimlerinin gelişimi', en: 'Development of hadith, tafsir and fiqh', ar: 'تطور علوم الحديث والتفسير والفقه'),
    summary: LocalizedHistorySummary(tr: 'Hadis aktarımı, tefsir gelenekleri ve hukuk ekolleri erken dönemden itibaren farklı yöntemler, öğretim ağları ve bölgesel gelenekler içinde kurumsallaştı.', en: 'Hadith transmission, tafsir traditions and schools of law developed through differing methods, teaching networks and regional traditions from the early centuries onward.', ar: 'تطورت رواية الحديث وتقاليد التفسير والمدارس الفقهية منذ القرون الأولى ضمن مناهج وشبكات تعليمية وتقاليد إقليمية متعددة.'),
    startYearCe: 650, endYearCe: 1200, certainty: HorizontalThemeCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(tr: 'Mezhep ve yöntemlerin oluşumu tek bir tarih veya tek çizgili süreç değildir.', en: 'The formation of schools and methods is not reducible to one date or a single linear process.', ar: 'لا يمكن اختزال نشوء المدارس والمناهج في تاريخ واحد أو مسار خطي واحد.'),
    sourceIds: ['hallaq_origins_islamic_law', 'melchert_sunni_schools'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'art_architecture_history', theme: IslamicHistoryTheme.artArchitecture,
    title: LocalizedHistorySummary(tr: 'Sanat ve mimari', en: 'Art and architecture', ar: 'الفن والعمارة'),
    summary: LocalizedHistorySummary(tr: 'Mimari, kitap sanatları, seramik, metal, tekstil ve süsleme gelenekleri farklı bölgesel merkezlerde birbirinden farklı biçimlerde gelişti.', en: 'Architecture, arts of the book, ceramics, metalwork, textiles and ornament developed in distinct ways across different regional centres.', ar: 'تطورت العمارة وفنون الكتاب والخزف والأعمال المعدنية والمنسوجات والزخرفة بطرائق متباينة في مراكز إقليمية مختلفة.'),
    startYearCe: 650, endYearCe: 1800, certainty: HorizontalThemeCertainty.broadDevelopment,
    caveat: LocalizedHistorySummary(tr: '“İslam sanatı” tek ve değişmez bir üslup değildir; dönemsel ve bölgesel çeşitlilik korunur.', en: '“Islamic art” is not one fixed style; chronological and regional diversity must be preserved.', ar: 'ليس «الفن الإسلامي» أسلوبًا واحدًا ثابتًا؛ بل يجب حفظ التنوع الزمني والإقليمي.'),
    sourceIds: ['ettinghausen_grabar_jenkins_art', 'lapidus_societies_horizontal'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'trade_urbanization_history', theme: IslamicHistoryTheme.tradeUrbanization,
    title: LocalizedHistorySummary(tr: 'Ticaret ve şehirleşme', en: 'Trade and urbanization', ar: 'التجارة والتحضر'),
    summary: LocalizedHistorySummary(tr: 'Şehirler, pazarlar, deniz ve kara ticaret ağları; siyasi sınırları aşan mal, insan ve bilgi dolaşımının önemli düğümleriydi.', en: 'Cities, markets, and maritime and overland trade networks were important nodes for the movement of goods, people and knowledge across political boundaries.', ar: 'كانت المدن والأسواق وشبكات التجارة البحرية والبرية عقدًا مهمة لحركة السلع والناس والمعرفة عبر الحدود السياسية.'),
    startYearCe: 650, endYearCe: 1800, certainty: HorizontalThemeCertainty.broadDevelopment,
    caveat: LocalizedHistorySummary(tr: 'Ticaret ağları tek merkezden yönetilen sabit sistemler değildi.', en: 'Trade networks were not fixed systems controlled from a single centre.', ar: 'لم تكن شبكات التجارة أنظمة ثابتة تُدار من مركز واحد.'),
    sourceIds: ['lapidus_societies_horizontal', 'makdisi_rise_colleges'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'education_history', theme: IslamicHistoryTheme.education,
    title: LocalizedHistorySummary(tr: 'Eğitim kurumları', en: 'Educational institutions', ar: 'المؤسسات التعليمية'),
    summary: LocalizedHistorySummary(tr: 'Cami halkaları, öğretmen-öğrenci ağları, medreseler ve diğer öğrenim ortamları farklı dönemlerde ilim aktarımının kurumsal biçimlerini oluşturdu.', en: 'Mosque circles, teacher-student networks, madrasas and other learning settings formed changing institutional contexts for transmitting knowledge.', ar: 'شكّلت حلقات المساجد وشبكات الشيوخ والطلاب والمدارس وغيرها من بيئات التعلم أطرًا مؤسسية متغيرة لنقل المعرفة.'),
    startYearCe: 700, endYearCe: 1800, certainty: HorizontalThemeCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(tr: 'Medrese bütün İslam dünyasında aynı tarihte veya aynı yapıyla ortaya çıkmış tek tip kurum değildir.', en: 'The madrasa was not one uniform institution that appeared everywhere at the same date or in the same form.', ar: 'لم تكن المدرسة مؤسسة موحدة ظهرت في جميع أنحاء العالم الإسلامي في التاريخ نفسه أو بالشكل نفسه.'),
    sourceIds: ['makdisi_rise_colleges', 'sayeed_women_knowledge'], status: HistoryResearchStatus.researchDraft),
  IslamicHistoryThemeEntry(
    id: 'women_historical_roles', theme: IslamicHistoryTheme.womenHistoricalRoles,
    title: LocalizedHistorySummary(tr: 'Kadınların tarihsel rolleri', en: 'Women’s historical roles', ar: 'الأدوار التاريخية للنساء'),
    summary: LocalizedHistorySummary(tr: 'Kadınlar hadis aktarımı, eğitim, vakıf, aile-ekonomi ilişkileri, saray ve kamusal yaşam gibi farklı alanlarda dönem ve bölgeye göre değişen roller üstlendi.', en: 'Women took historically varying roles in hadith transmission, education, endowments, household economies, courts and public life, depending on period and region.', ar: 'اضطلعت النساء بأدوار تاريخية متغيرة في رواية الحديث والتعليم والأوقاف واقتصاد الأسرة والبلاط والحياة العامة بحسب الفترة والمنطقة.'),
    startYearCe: 610, endYearCe: 1900, certainty: HorizontalThemeCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(tr: 'Kadınların deneyimleri sınıf, bölge, dönem ve kaynak türüne göre değişir; tek bir genelleme yapılmaz.', en: 'Women’s experiences varied by class, region, period and source type; they must not be reduced to one generalization.', ar: 'اختلفت تجارب النساء بحسب الطبقة والمنطقة والفترة ونوع المصدر، ولا يجوز اختزالها في تعميم واحد.'),
    sourceIds: ['sayeed_women_knowledge', 'ahmed_women_gender'], status: HistoryResearchStatus.researchDraft),
];

final islamicHistoryHorizontalThemesT0219 = IslamicHistoryHorizontalThemesDataset.validated(
  sources: islamicHistoryT0219Sources,
  entries: islamicHistoryT0219Entries,
);
