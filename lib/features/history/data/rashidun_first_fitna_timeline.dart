import 'pre_islam_world_context.dart';

enum EarlyCaliphateCertainty { establishedChronology, contestedInterpretation }

class EarlyCaliphateTimelineEntry {
  const EarlyCaliphateTimelineEntry({
    required this.id,
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
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final EarlyCaliphateCertainty certainty;
  final LocalizedHistorySummary? caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class EarlyCaliphateTimelineDataset {
  EarlyCaliphateTimelineDataset._({required this.sources, required this.entries});

  factory EarlyCaliphateTimelineDataset.validated({
    required List<HistorySourceLocator> sources,
    required List<EarlyCaliphateTimelineEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('Early caliphate research dataset must not be empty.');
    }

    final sourceIds = <String>{};
    for (final source in sources) {
      if (!source.isComplete || !sourceIds.add(source.id)) {
        throw StateError('Early caliphate sources must be unique and complete.');
      }
    }

    final entryIds = <String>{};
    var previousStart = 0;
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !entryIds.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.startYearCe < previousStart ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((sourceId) => !sourceIds.contains(sourceId))) {
        throw StateError('Early caliphate entries failed chronology/source validation.');
      }
      if (entry.certainty == EarlyCaliphateCertainty.contestedInterpretation &&
          (entry.caveat == null || !entry.caveat!.isComplete)) {
        throw StateError('Contested early-history entries require TR/EN/AR caveats.');
      }
      previousStart = entry.startYearCe;
    }

    final missing = requiredEntryIds.difference(entryIds);
    if (missing.isNotEmpty) {
      throw StateError('Missing required Rashidun/First Fitna entries: $missing');
    }

    return EarlyCaliphateTimelineDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'abu_bakr_caliphate',
    'umar_caliphate',
    'uthman_caliphate',
    'ali_caliphate',
    'first_fitna',
  };

  final List<HistorySourceLocator> sources;
  final List<EarlyCaliphateTimelineEntry> entries;

  List<EarlyCaliphateTimelineEntry> get productionEntries => List.unmodifiable(
        entries.where(
          (entry) => entry.status == HistoryResearchStatus.reviewedForProduction,
        ),
      );
}

const earlyCaliphateResearchSources = <HistorySourceLocator>[
  HistorySourceLocator(
    id: 'lapidus_caliphate_to_750',
    kind: HistorySourceKind.academicChapter,
    citation: 'Ira M. Lapidus, “The Caliphate to 750”, A History of Islamic Societies, Cambridge University Press.',
    locator: 'doi:10.1017/CBO9781139027670.012',
  ),
  HistorySourceLocator(
    id: 'madelung_succession_muhammad',
    kind: HistorySourceKind.academicMonograph,
    citation: 'Wilferd Madelung, The Succession to Muhammad: A Study of the Early Caliphate, Cambridge University Press.',
    locator: 'doi:10.1017/CBO9780511582042',
  ),
  HistorySourceLocator(
    id: 'hinds_early_islamic_history',
    kind: HistorySourceKind.academicMonograph,
    citation: 'Martin Hinds, Studies in Early Islamic History, Gerlach Press; Cambridge Core online edition.',
    locator: 'doi:10.1017/9783959940979',
  ),
];

const _sharedSources = <String>[
  'lapidus_caliphate_to_750',
  'madelung_succession_muhammad',
];

const earlyCaliphateResearchEntries = <EarlyCaliphateTimelineEntry>[
  EarlyCaliphateTimelineEntry(
    id: 'abu_bakr_caliphate',
    title: LocalizedHistorySummary(tr: 'Hz. Ebû Bekir Dönemi', en: 'Caliphate of Abu Bakr', ar: 'خلافة أبي بكر'),
    summary: LocalizedHistorySummary(
      tr: 'Hz. Muhammed’in vefatından sonra Ebû Bekir 632’de halife kabul edildi ve 634’e kadar Müslüman topluluğun siyasi liderliğini yürüttü.',
      en: 'After Muhammad’s death, Abu Bakr was accepted as caliph in 632 and led the Muslim community politically until 634.',
      ar: 'بعد وفاة النبي محمد، قُبل أبو بكر خليفة سنة 632 وتولى القيادة السياسية للمجتمع المسلم حتى سنة 634.',
    ),
    startYearCe: 632,
    endYearCe: 634,
    certainty: EarlyCaliphateCertainty.establishedChronology,
    caveat: null,
    sourceIds: _sharedSources,
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyCaliphateTimelineEntry(
    id: 'umar_caliphate',
    title: LocalizedHistorySummary(tr: 'Hz. Ömer Dönemi', en: 'Caliphate of Umar', ar: 'خلافة عمر'),
    summary: LocalizedHistorySummary(
      tr: 'Ömer’in halifeliği 634–644 yılları arasındadır; bu dönemde Müslüman yönetimin siyasi ve idari sahası Arabistan dışına genişledi.',
      en: 'Umar’s caliphate lasted from 634 to 644, when Muslim political and administrative rule expanded far beyond Arabia.',
      ar: 'امتدت خلافة عمر من سنة 634 إلى 644، واتسع خلالها نطاق الحكم السياسي والإداري للمسلمين خارج الجزيرة العربية.',
    ),
    startYearCe: 634,
    endYearCe: 644,
    certainty: EarlyCaliphateCertainty.establishedChronology,
    caveat: null,
    sourceIds: _sharedSources,
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyCaliphateTimelineEntry(
    id: 'uthman_caliphate',
    title: LocalizedHistorySummary(tr: 'Hz. Osman Dönemi', en: 'Caliphate of Uthman', ar: 'خلافة عثمان'),
    summary: LocalizedHistorySummary(
      tr: 'Osman’ın halifeliği 644–656 yılları arasındadır. Dönemin son yıllarında siyasi muhalefet ve gerilim arttı; Osman 656’da Medine’de öldürüldü.',
      en: 'Uthman’s caliphate lasted from 644 to 656. Political opposition and tension intensified in its later years, and Uthman was killed in Medina in 656.',
      ar: 'امتدت خلافة عثمان من سنة 644 إلى 656. واشتدت المعارضة والتوترات السياسية في أواخر عهده، وقُتل عثمان في المدينة سنة 656.',
    ),
    startYearCe: 644,
    endYearCe: 656,
    certainty: EarlyCaliphateCertainty.establishedChronology,
    caveat: null,
    sourceIds: _sharedSources,
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyCaliphateTimelineEntry(
    id: 'ali_caliphate',
    title: LocalizedHistorySummary(tr: 'Hz. Ali Dönemi', en: 'Caliphate of Ali', ar: 'خلافة علي'),
    summary: LocalizedHistorySummary(
      tr: 'Ali 656’da halife oldu ve 661’de öldürülmesine kadar görev yaptı. Halifeliği, ilk iç savaşın siyasi ve askerî çatışmalarıyla aynı döneme rastladı.',
      en: 'Ali became caliph in 656 and served until his killing in 661. His caliphate coincided with the political and military conflicts of the first civil war.',
      ar: 'تولى علي الخلافة سنة 656 واستمر حتى مقتله سنة 661. وتزامنت خلافته مع الصراعات السياسية والعسكرية للحرب الأهلية الأولى.',
    ),
    startYearCe: 656,
    endYearCe: 661,
    certainty: EarlyCaliphateCertainty.establishedChronology,
    caveat: null,
    sourceIds: _sharedSources,
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyCaliphateTimelineEntry(
    id: 'first_fitna',
    title: LocalizedHistorySummary(tr: 'İlk Fitne', en: 'First Fitna', ar: 'الفتنة الأولى'),
    summary: LocalizedHistorySummary(
      tr: '656–661 arasındaki ilk büyük Müslüman iç çatışma dönemi; Osman’ın öldürülmesinin ardından Ali’nin halifeliği, Cemel ve Sıffîn gibi çatışmalar ve siyasi otorite tartışmalarıyla şekillendi.',
      en: 'The first major period of Muslim civil conflict, conventionally dated 656–661, followed Uthman’s killing and included Ali’s caliphate, conflicts such as the Camel and Siffin, and disputes over political authority.',
      ar: 'تمثل الفترة 656–661 أول مرحلة كبرى من الصراع الأهلي بين المسلمين؛ أعقبت مقتل عثمان وشملت خلافة علي ووقائع مثل الجمل وصفين والنزاع حول السلطة السياسية.',
    ),
    startYearCe: 656,
    endYearCe: 661,
    certainty: EarlyCaliphateCertainty.contestedInterpretation,
    caveat: LocalizedHistorySummary(
      tr: 'Olayların temel kronolojisi tarih çalışmalarında yerleşiktir; tarafların niyetleri, sorumlulukları ve meşruiyet değerlendirmeleri kaynak geleneğine ve yoruma göre değişir. Uygulama tek bir mezhepsel yorumu kesin hüküm olarak sunmamalıdır.',
      en: 'The broad chronology is well established, but assessments of motives, responsibility and legitimacy vary across source traditions and scholarship. The app must not present one sectarian interpretation as an uncontested verdict.',
      ar: 'الإطار الزمني العام ثابت إلى حد كبير، لكن تقييم الدوافع والمسؤوليات والشرعية يختلف باختلاف تقاليد المصادر والدراسات. ولا ينبغي للتطبيق أن يعرض تفسيرًا مذهبيًا واحدًا بوصفه حكمًا غير قابل للنقاش.',
    ),
    sourceIds: <String>[
      'lapidus_caliphate_to_750',
      'madelung_succession_muhammad',
      'hinds_early_islamic_history',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final earlyCaliphateTimelineT0213 = EarlyCaliphateTimelineDataset.validated(
  sources: earlyCaliphateResearchSources,
  entries: earlyCaliphateResearchEntries,
);
