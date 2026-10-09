import 'pre_islam_world_context.dart';

enum ModernGlobalHistoryTrack {
  colonialImperialRule,
  decolonizationNationStates,
  twentiethCenturyTransformations,
  contemporaryGlobalMuslimSocieties,
}

enum ModernGlobalHistoryCertainty { broadPeriod, contestedInterpretation, snapshotBounded }

class ModernHistoryResearchSource {
  const ModernHistoryResearchSource({
    required this.locator,
    required this.workFamilyId,
  });

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class ModernGlobalHistoryEntry {
  const ModernGlobalHistoryEntry({
    required this.id,
    required this.track,
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
  final ModernGlobalHistoryTrack track;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final ModernGlobalHistoryCertainty certainty;
  final LocalizedHistorySummary caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class ModernGlobalIslamicHistoryDataset {
  ModernGlobalIslamicHistoryDataset._({required this.sources, required this.entries});

  factory ModernGlobalIslamicHistoryDataset.validated({
    required List<ModernHistoryResearchSource> sources,
    required List<ModernGlobalHistoryEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0218 modern history dataset must not be empty.');
    }

    final sourcesById = <String, ModernHistoryResearchSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0218 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final ids = <String>{};
    final tracks = <ModernGlobalHistoryTrack>{};
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !ids.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          !entry.caveat.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((id) => !sourcesById.containsKey(id))) {
        throw StateError('T0218 entry failed identity/content/date/source validation.');
      }

      final families = entry.sourceIds.map((id) => sourcesById[id]!.workFamilyId).toSet();
      if (families.length < 2) {
        throw StateError('T0218 entries require two independent academic work families.');
      }
      tracks.add(entry.track);
    }

    final missingTracks = ModernGlobalHistoryTrack.values.toSet().difference(tracks);
    if (missingTracks.isNotEmpty) {
      throw StateError('Missing required T0218 modern-history tracks: $missingTracks');
    }
    final missingEntries = requiredEntryIds.difference(ids);
    if (missingEntries.isNotEmpty) {
      throw StateError('Missing required T0218 entries: $missingEntries');
    }

    final ordered = [...entries]..sort((a, b) => a.startYearCe.compareTo(b.startYearCe));
    for (var i = 1; i < ordered.length; i++) {
      if (ordered[i].startYearCe < ordered[i - 1].startYearCe) {
        throw StateError('T0218 chronology cannot run backwards.');
      }
    }

    return ModernGlobalIslamicHistoryDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'colonial_imperial_rule',
    'decolonization_nation_states',
    'twentieth_century_transformations',
    'contemporary_global_muslim_societies',
  };

  final List<ModernHistoryResearchSource> sources;
  final List<ModernGlobalHistoryEntry> entries;

  List<ModernGlobalHistoryEntry> get productionEntries => List.unmodifiable(
        entries.where((entry) => entry.status == HistoryResearchStatus.reviewedForProduction),
      );
}

const modernGlobalHistoryT0218Sources = <ModernHistoryResearchSource>[
  ModernHistoryResearchSource(
    workFamilyId: 'motadel_islam_european_empires',
    locator: HistorySourceLocator(
      id: 'motadel_islam_european_empires',
      kind: HistorySourceKind.academicMonograph,
      citation: 'David Motadel (ed.), Islam and the European Empires, Oxford University Press, 2014.',
      locator: 'doi:10.1093/acprof:oso/9780199668311.001.0001',
    ),
  ),
  ModernHistoryResearchSource(
    workFamilyId: 'new_cambridge_history_islam_v5',
    locator: HistorySourceLocator(
      id: 'nchi_v5_western_dominance',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Francis Robinson (ed.), The New Cambridge History of Islam, Volume 5: The Islamic World in the Age of Western Dominance, Cambridge University Press, 2010.',
      locator: 'doi:10.1017/CHOL9780521838269',
    ),
  ),
  ModernHistoryResearchSource(
    workFamilyId: 'lapidus_history_islamic_societies',
    locator: HistorySourceLocator(
      id: 'lapidus_modern_muslim_societies',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Ira M. Lapidus, A History of Islamic Societies, 3rd ed., Cambridge University Press, 2014.',
      locator: 'doi:10.1017/CBO9781139048828',
    ),
  ),
  ModernHistoryResearchSource(
    workFamilyId: 'ali_islam_colonialism',
    locator: HistorySourceLocator(
      id: 'ali_islam_colonialism_indonesia_malaya',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Muhamad Ali, Islam and Colonialism: Becoming Modern in Indonesia and Malaya, Edinburgh University Press, 2016.',
      locator: 'doi:10.3366/edinburgh/9781474409209.001.0001',
    ),
  ),
  ModernHistoryResearchSource(
    workFamilyId: 'ansari_islam_west',
    locator: HistorySourceLocator(
      id: 'ansari_islam_west',
      kind: HistorySourceKind.academicChapter,
      citation: 'Humayun Ansari, “Islam in the West”, The New Cambridge History of Islam, Volume 5, Cambridge University Press, 2010.',
      locator: 'doi:10.1017/CHOL9780521838269.026',
    ),
  ),
  ModernHistoryResearchSource(
    workFamilyId: 'greble_modern_europe',
    locator: HistorySourceLocator(
      id: 'greble_muslims_modern_europe',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Emily Greble, Muslims and the Making of Modern Europe, Oxford University Press, 2021.',
      locator: 'doi:10.1093/oso/9780197538807.001.0001',
    ),
  ),
];

const modernGlobalHistoryT0218Entries = <ModernGlobalHistoryEntry>[
  ModernGlobalHistoryEntry(
    id: 'colonial_imperial_rule',
    track: ModernGlobalHistoryTrack.colonialImperialRule,
    title: LocalizedHistorySummary(
      tr: 'Sömürgecilik ve imparatorluk yönetimleri',
      en: 'Colonialism and imperial rule',
      ar: 'الاستعمار والحكم الإمبراطوري',
    ),
    summary: LocalizedHistorySummary(
      tr: '19. yüzyılda ve 20. yüzyılın başında çok sayıda Müslüman toplum Britanya, Fransa, Rusya, Hollanda ve diğer imparatorlukların doğrudan ya da dolaylı yönetimleriyle karşılaştı. Yönetim biçimleri, yerel kurumlarla uzlaşma, ekonomik dönüşüm ve direniş bölgeden bölgeye farklılaştı.',
      en: 'During the nineteenth and early twentieth centuries, many Muslim societies encountered direct or indirect rule by the British, French, Russian, Dutch and other empires. Forms of rule, accommodation with local institutions, economic change and resistance differed substantially by region.',
      ar: 'خلال القرن التاسع عشر وبدايات القرن العشرين خضعت مجتمعات إسلامية كثيرة لأشكال مباشرة أو غير مباشرة من حكم الإمبراطوريات البريطانية والفرنسية والروسية والهولندية وغيرها. واختلفت أنماط الحكم والتفاهم مع المؤسسات المحلية والتحولات الاقتصادية والمقاومة من منطقة إلى أخرى.',
    ),
    startYearCe: 1800,
    endYearCe: 1919,
    certainty: ModernGlobalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1800–1919 öğretici bir dönem sınırıdır; sömürgeleşme her bölgede aynı tarihte başlamadı veya bitmedi ve bütün Müslüman toplumlar sömürge yönetimine aynı biçimde girmedi.',
      en: '1800–1919 is a teaching period boundary: colonial rule did not begin or end at the same time everywhere, and Muslim societies did not experience empire in a single uniform form.',
      ar: 'الفترة 1800–1919 حد تعليمي تقريبي؛ فلم يبدأ الحكم الاستعماري أو ينته في وقت واحد في جميع المناطق، كما لم تعش المجتمعات الإسلامية التجربة الإمبراطورية بصورة واحدة موحدة.',
    ),
    sourceIds: ['motadel_islam_european_empires', 'nchi_v5_western_dominance'],
    status: HistoryResearchStatus.researchDraft,
  ),
  ModernGlobalHistoryEntry(
    id: 'decolonization_nation_states',
    track: ModernGlobalHistoryTrack.decolonizationNationStates,
    title: LocalizedHistorySummary(
      tr: 'Bağımsızlık, dekolonizasyon ve modern ulus devletler',
      en: 'Independence, decolonization and modern nation-states',
      ar: 'الاستقلال وإنهاء الاستعمار والدول القومية الحديثة',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Birinci Dünya Savaşı sonrasından 20. yüzyılın ikinci yarısına uzanan süreçte imparatorlukların çözülmesi, manda ve sömürge düzenlerinin dönüşmesi ve bağımsız devletlerin kurulması Müslüman toplumların siyasi kurumlarını yeniden şekillendirdi. Bu süreç tek bir model izlemedi.',
      en: 'From the aftermath of the First World War into the second half of the twentieth century, imperial dissolution, changes to mandate and colonial systems, and the creation of independent states reshaped political institutions across Muslim societies. There was no single path.',
      ar: 'منذ ما بعد الحرب العالمية الأولى وحتى النصف الثاني من القرن العشرين أعادت تفككات الإمبراطوريات وتحولات أنظمة الانتداب والاستعمار وقيام الدول المستقلة تشكيل المؤسسات السياسية في المجتمعات الإسلامية، ولم تتبع هذه العملية مسارًا واحدًا.',
    ),
    startYearCe: 1919,
    endYearCe: 1970,
    certainty: ModernGlobalHistoryCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(
      tr: 'Bağımsızlık ve ulus devlet oluşumu bölgelere göre farklı tarihlerde ve farklı toplumsal maliyetlerle gerçekleşti; 1919 ve 1970 evrensel başlangıç/bitiş tarihleri değildir.',
      en: 'Independence and nation-state formation occurred at different times and with different social costs across regions; 1919 and 1970 are not universal start or end dates.',
      ar: 'حدث الاستقلال وتشكّل الدول القومية في تواريخ مختلفة وبتكاليف اجتماعية متباينة حسب المناطق؛ لذلك لا تمثل سنتا 1919 و1970 بداية أو نهاية عالمية موحدة.',
    ),
    sourceIds: ['nchi_v5_western_dominance', 'lapidus_modern_muslim_societies'],
    status: HistoryResearchStatus.researchDraft,
  ),
  ModernGlobalHistoryEntry(
    id: 'twentieth_century_transformations',
    track: ModernGlobalHistoryTrack.twentiethCenturyTransformations,
    title: LocalizedHistorySummary(
      tr: '20. yüzyılda toplumsal ve dinî dönüşümler',
      en: 'Social and religious transformations in the twentieth century',
      ar: 'التحولات الاجتماعية والدينية في القرن العشرين',
    ),
    summary: LocalizedHistorySummary(
      tr: '20. yüzyılda kentleşme, eğitim, basın ve kitle iletişimi, hukuk ve devlet kurumları, reform hareketleri, göç ve yeni örgütlenme biçimleri Müslüman toplumlarda farklı etkiler üretti. Modernleşme ile dinî dönüşüm basit bir karşıtlık olarak okunamaz.',
      en: 'During the twentieth century, urbanization, education, print and mass communication, law and state institutions, reform movements, migration and new forms of organization produced different effects across Muslim societies. Modernization and religious change cannot be reduced to a simple opposition.',
      ar: 'أنتج التمدّن والتعليم والصحافة ووسائل الاتصال الجماهيري ومؤسسات القانون والدولة وحركات الإصلاح والهجرة وأشكال التنظيم الجديدة آثارًا مختلفة في المجتمعات الإسلامية خلال القرن العشرين، ولا يمكن اختزال الحداثة والتحول الديني في ثنائية بسيطة.',
    ),
    startYearCe: 1900,
    endYearCe: 2000,
    certainty: ModernGlobalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: 'Bu başlık küresel bir sentezdir; Endonezya ve Malaya gibi örneklerde sömürgecilik, reform ve modern kurumlar farklı biçimlerde iç içe geçmiştir. Bölgesel ayrıntılar ayrı timeline’larda ele alınmalıdır.',
      en: 'This is a global synthesis. In settings such as Indonesia and Malaya, colonialism, reform and modern institutions interacted in distinct ways; regional detail belongs in the separate regional timelines.',
      ar: 'هذا العنوان تركيب عالمي عام؛ ففي أمثلة مثل إندونيسيا والملايو تداخل الاستعمار والإصلاح والمؤسسات الحديثة بطرق مختلفة، ولذلك ينبغي عرض التفاصيل الإقليمية في الخطوط الزمنية الخاصة بكل منطقة.',
    ),
    sourceIds: ['ali_islam_colonialism_indonesia_malaya', 'nchi_v5_western_dominance'],
    status: HistoryResearchStatus.researchDraft,
  ),
  ModernGlobalHistoryEntry(
    id: 'contemporary_global_muslim_societies',
    track: ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
    title: LocalizedHistorySummary(
      tr: 'Günümüze uzanan küresel Müslüman toplumlar',
      en: 'Global Muslim societies into the present',
      ar: 'المجتمعات الإسلامية العالمية حتى الحاضر',
    ),
    summary: LocalizedHistorySummary(
      tr: '20. yüzyılın sonlarından 21. yüzyıla uzanan dönemde Müslüman toplumlar yalnız Müslüman çoğunluklu devletlerle sınırlı değildir. Göç, vatandaşlık, şehirleşme, ulusötesi ağlar ve Avrupa ile diğer Batı toplumlarındaki kalıcı Müslüman topluluklar modern İslam tarihinin de parçasıdır.',
      en: 'From the late twentieth century into the twenty-first, Muslim societies are not limited to Muslim-majority states. Migration, citizenship, urbanization, transnational networks and established Muslim communities in Europe and other Western societies are also part of modern Islamic history.',
      ar: 'منذ أواخر القرن العشرين وحتى القرن الحادي والعشرين لا تقتصر المجتمعات الإسلامية على الدول ذات الأغلبية المسلمة؛ فالهجرة والمواطنة والتمدّن والشبكات العابرة للحدود والجماعات الإسلامية المستقرة في أوروبا وغيرها من المجتمعات الغربية جزء من تاريخ الإسلام الحديث أيضًا.',
    ),
    startYearCe: 1970,
    endYearCe: 2026,
    certainty: ModernGlobalHistoryCertainty.snapshotBounded,
    caveat: LocalizedHistorySummary(
      tr: '2026 yalnız bu veri sürümünün güncellik sınırıdır; yaşayan toplumlar ve güncel siyasi gelişmeler için kalıcı bir tarihsel bitiş değildir. Güncel olaylar doğrulanmadan tarihsel kesinlik diliyle eklenmemelidir.',
      en: '2026 is only the currency boundary of this dataset version, not a historical endpoint for living societies or current politics. Current events must not be added with historical certainty before verification.',
      ar: 'تمثل سنة 2026 حد تحديث هذه النسخة من البيانات فقط، وليست نهاية تاريخية للمجتمعات الحية أو للسياسة المعاصرة. ولا يجوز إضافة الأحداث الجارية بصيغة اليقين التاريخي قبل التحقق منها.',
    ),
    sourceIds: ['ansari_islam_west', 'greble_muslims_modern_europe', 'lapidus_modern_muslim_societies'],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final modernGlobalIslamicHistoryT0218 = ModernGlobalIslamicHistoryDataset.validated(
  sources: modernGlobalHistoryT0218Sources,
  entries: modernGlobalHistoryT0218Entries,
);
