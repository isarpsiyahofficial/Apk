import '../domain/history_event_contract.dart';
import 'pre_islam_world_context.dart';
import 'rashidun_first_fitna_timeline.dart';

const _medina = HistoryGeographyRef(
  id: 'medina',
  label: LocalizedHistorySummary(tr: 'Medine', en: 'Medina', ar: 'المدينة'),
  precision: HistoryGeographyPrecision.exact,
);

const _arabia = HistoryGeographyRef(
  id: 'arabia',
  label: LocalizedHistorySummary(
    tr: 'Arabistan ve erken hilafet coğrafyası',
    en: 'Arabia and the early caliphate region',
    ar: 'الجزيرة العربية ومجال الخلافة المبكرة',
  ),
  precision: HistoryGeographyPrecision.regional,
);

const _iraqSyria = HistoryGeographyRef(
  id: 'iraq_syria_early_caliphate',
  label: LocalizedHistorySummary(
    tr: 'Irak ve Suriye çevresi',
    en: 'Iraq and Syria region',
    ar: 'منطقة العراق والشام',
  ),
  precision: HistoryGeographyPrecision.regional,
);

const _abuBakr = HistoryPersonRef(
  id: 'abu_bakr',
  name: LocalizedHistorySummary(tr: 'Hz. Ebû Bekir', en: 'Abu Bakr', ar: 'أبو بكر'),
);
const _umar = HistoryPersonRef(
  id: 'umar_ibn_al_khattab',
  name: LocalizedHistorySummary(tr: 'Hz. Ömer', en: 'Umar ibn al-Khattab', ar: 'عمر بن الخطاب'),
);
const _uthman = HistoryPersonRef(
  id: 'uthman_ibn_affan',
  name: LocalizedHistorySummary(tr: 'Hz. Osman', en: 'Uthman ibn Affan', ar: 'عثمان بن عفان'),
);
const _ali = HistoryPersonRef(
  id: 'ali_ibn_abi_talib',
  name: LocalizedHistorySummary(tr: 'Hz. Ali', en: 'Ali ibn Abi Talib', ar: 'علي بن أبي طالب'),
);
const _muawiya = HistoryPersonRef(
  id: 'muawiya_ibn_abi_sufyan',
  name: LocalizedHistorySummary(tr: 'Muâviye b. Ebû Süfyân', en: 'Muawiya ibn Abi Sufyan', ar: 'معاوية بن أبي سفيان'),
);

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownEarlyCaliphateSourceIds =
    earlyCaliphateResearchSources.map((source) => source.id).toSet();

HistoryEventRecord _eventFor(EarlyCaliphateTimelineEntry entry) {
  switch (entry.id) {
    case 'abu_bakr_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: HistoryDateCertainty.approximate,
        dateCaveat: _l(
          '632–634 tarihleri genel kronolojiyi gösterir; hicrî/miladî gün düzeyi dönüşümler bu kayıtta kesinleştirilmez.',
          '632–634 represents the broad chronology; day-level Hijri/CE conversions are not asserted here as exact.',
          'يمثل نطاق 632–634 التسلسل الزمني العام، ولا تُعرض التحويلات اليومية بين الهجري والميلادي هنا على أنها قطعية.',
        ),
        beforeContext: _l(
          'Hz. Muhammed’in 632’de vefatı, Müslüman topluluğun siyasi liderliğinin nasıl sürdürüleceği sorununu gündeme getirdi.',
          'Muhammad’s death in 632 raised the question of how the Muslim community’s political leadership would continue.',
          'أثارت وفاة النبي محمد سنة 632 مسألة استمرار القيادة السياسية للمجتمع المسلم.',
        ),
        causes: [
          _l(
            'Topluluğun vefat sonrasında siyasi liderlik ve idari süreklilik ihtiyacı ortaya çıktı.',
            'The community faced an immediate need for political leadership and administrative continuity after Muhammad’s death.',
            'واجه المجتمع حاجة مباشرة إلى القيادة السياسية واستمرار الإدارة بعد وفاة النبي محمد.',
          ),
        ],
        consequences: [
          _l(
            'Ebû Bekir’in halifeliği, erken hilafet yönetiminin ilk dönemini oluşturdu ve 634’te Ömer’in halifeliğine geçişle sona erdi.',
            'Abu Bakr’s caliphate formed the first period of early caliphal rule and ended with the transition to Umar in 634.',
            'شكّلت خلافة أبي بكر المرحلة الأولى من الحكم الخلافي المبكر وانتهت بالانتقال إلى خلافة عمر سنة 634.',
          ),
        ],
        people: const [_abuBakr],
        geographies: const [_medina, _arabia],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownEarlyCaliphateSourceIds,
        status: entry.status,
      );
    case 'umar_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: HistoryDateCertainty.approximate,
        dateCaveat: _l(
          '634–644 genel kabul gören dönem aralığıdır; bu kayıt gün düzeyinde kesin tarih iddiası taşımaz.',
          '634–644 is the conventionally accepted period range; this record does not claim day-level precision.',
          'يُعد نطاق 634–644 الإطار الزمني المتعارف عليه، ولا يدّعي هذا السجل دقة على مستوى اليوم.',
        ),
        beforeContext: _l(
          'Ebû Bekir’in halifeliğinin sona ermesinin ardından siyasi liderlik Ömer’e geçti.',
          'After Abu Bakr’s caliphate ended, political leadership passed to Umar.',
          'بعد انتهاء خلافة أبي بكر انتقلت القيادة السياسية إلى عمر.',
        ),
        causes: [
          _l(
            'Erken hilafet yönetiminde liderlik devri ve hızla genişleyen idari ihtiyaçlar yeni dönemi şekillendirdi.',
            'Leadership succession and the administrative needs of a rapidly expanding polity shaped the new period.',
            'شكّل انتقال القيادة والحاجات الإدارية لكيان سياسي سريع الاتساع ملامح المرحلة الجديدة.',
          ),
        ],
        consequences: [
          _l(
            'Müslüman yönetimin siyasi ve idari sahası Arabistan dışına genişledi; 644’te liderlik Osman’a geçti.',
            'Muslim political and administrative rule expanded beyond Arabia; leadership passed to Uthman in 644.',
            'اتسع نطاق الحكم السياسي والإداري للمسلمين خارج الجزيرة العربية، ثم انتقلت القيادة إلى عثمان سنة 644.',
          ),
        ],
        people: const [_umar],
        geographies: const [_medina, _arabia, _iraqSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownEarlyCaliphateSourceIds,
        status: entry.status,
      );
    case 'uthman_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: HistoryDateCertainty.approximate,
        dateCaveat: _l(
          '644–656 dönem aralığı yerleşik kronolojiyi özetler; olayların nedenleri ve sorumlulukları tek yoruma indirgenmez.',
          'The 644–656 range summarizes the established chronology; causes and responsibility are not reduced to one interpretation.',
          'يلخص نطاق 644–656 التسلسل الزمني المستقر، ولا تُختزل أسباب الأحداث ومسؤولياتها في تفسير واحد.',
        ),
        beforeContext: _l(
          'Ömer’in ölümünün ardından Osman halife oldu; erken hilafet genişlemiş bir siyasi ve idari alanı yönetiyordu.',
          'Uthman became caliph after Umar’s death, inheriting an early caliphate governing a much enlarged political and administrative realm.',
          'تولى عثمان الخلافة بعد وفاة عمر، في وقت كانت فيه الخلافة المبكرة تدير مجالًا سياسيًا وإداريًا أوسع بكثير.',
        ),
        causes: [
          _l(
            'Liderlik devri ile genişleyen yönetimin siyasi ve idari gerilimleri dönemin bağlamını oluşturdu.',
            'Leadership succession and the political-administrative tensions of an expanding polity formed the period’s context.',
            'شكّل انتقال القيادة والتوترات السياسية والإدارية في كيان متسع سياق هذه المرحلة.',
          ),
        ],
        consequences: [
          _l(
            'Dönemin sonlarında siyasi muhalefet ve gerilim yoğunlaştı; Osman’ın 656’da Medine’de öldürülmesi İlk Fitne’nin doğrudan bağlamına dönüştü.',
            'Political opposition and tension intensified late in the period; Uthman’s killing in Medina in 656 became the immediate context for the First Fitna.',
            'اشتدت المعارضة والتوترات السياسية في أواخر العهد، وأصبح مقتل عثمان في المدينة سنة 656 السياق المباشر للفتنة الأولى.',
          ),
        ],
        people: const [_uthman],
        geographies: const [_medina, _arabia],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownEarlyCaliphateSourceIds,
        status: entry.status,
      );
    case 'ali_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: HistoryDateCertainty.contested,
        dateCaveat: _l(
          '656–661 kronolojisi yerleşiktir; tarafların niyet, sorumluluk ve meşruiyet değerlendirmeleri kaynak geleneği ve araştırmaya göre değişebilir.',
          'The 656–661 chronology is well established, while assessments of motives, responsibility and legitimacy vary across source traditions and scholarship.',
          'الإطار الزمني 656–661 ثابت إلى حد كبير، بينما تختلف تقييمات الدوافع والمسؤولية والشرعية باختلاف تقاليد المصادر والدراسات.',
        ),
        beforeContext: _l(
          'Osman’ın 656’da öldürülmesinin ardından Ali halife oldu; siyasi otorite ve hesap verme talepleri etrafındaki anlaşmazlıklar büyüdü.',
          'Ali became caliph after Uthman was killed in 656, amid widening disputes over political authority and demands for accountability.',
          'تولى علي الخلافة بعد مقتل عثمان سنة 656 في ظل اتساع الخلافات حول السلطة السياسية والمطالبة بالمحاسبة.',
        ),
        causes: [
          _l(
            'Osman’ın öldürülmesi sonrasındaki siyasi kriz ve otorite anlaşmazlıkları Ali döneminin çatışmalı bağlamını oluşturdu.',
            'The political crisis after Uthman’s killing and disputes over authority formed the conflict-ridden context of Ali’s caliphate.',
            'شكّلت الأزمة السياسية بعد مقتل عثمان والخلافات حول السلطة سياقًا صراعيًا لخلافة علي.',
          ),
        ],
        consequences: [
          _l(
            'Ali’nin halifeliği Cemel ve Sıffîn gibi çatışmalarla aynı döneme rastladı; 661’de öldürülmesi erken hilafetin siyasi düzeninde yeni bir aşamaya geçişin parçası oldu.',
            'Ali’s caliphate coincided with conflicts including the Camel and Siffin; his killing in 661 formed part of the transition to a new phase in early caliphal politics.',
            'تزامنت خلافة علي مع صراعات منها الجمل وصفين، وكان مقتله سنة 661 جزءًا من الانتقال إلى مرحلة جديدة في سياسة الخلافة المبكرة.',
          ),
        ],
        people: const [_ali, _muawiya],
        geographies: const [_medina, _iraqSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownEarlyCaliphateSourceIds,
        status: entry.status,
      );
    case 'first_fitna':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: HistoryDateCertainty.contested,
        dateCaveat: entry.caveat!,
        beforeContext: _l(
          'Osman’ın 656’da öldürülmesi, Ali’nin halifeliği ve siyasi otorite üzerindeki anlaşmazlıklar ilk büyük Müslüman iç çatışmasının doğrudan bağlamını oluşturdu.',
          'Uthman’s killing in 656, Ali’s accession and disputes over political authority formed the immediate setting of the first major Muslim civil conflict.',
          'شكّل مقتل عثمان سنة 656 وتولي علي الخلافة والخلاف حول السلطة السياسية السياق المباشر لأول صراع أهلي كبير بين المسلمين.',
        ),
        causes: [
          _l(
            'Osman’ın öldürülmesinin ardından hesap verme, liderlik ve siyasi meşruiyet üzerindeki anlaşmazlıklar silahlı çatışmalara dönüştü.',
            'After Uthman’s killing, disputes over accountability, leadership and political legitimacy developed into armed conflicts.',
            'بعد مقتل عثمان تحولت الخلافات حول المحاسبة والقيادة والشرعية السياسية إلى صراعات مسلحة.',
          ),
        ],
        consequences: [
          _l(
            'Cemel ve Sıffîn gibi çatışmalar siyasi bölünmeleri derinleştirdi; 661’e gelindiğinde erken hilafet siyasetinde yeni bir dönem başladı.',
            'Conflicts including the Camel and Siffin deepened political divisions; by 661 a new phase of early caliphal politics had begun.',
            'عمّقت صراعات مثل الجمل وصفين الانقسامات السياسية، وبحلول سنة 661 بدأت مرحلة جديدة في سياسة الخلافة المبكرة.',
          ),
        ],
        people: const [_ali, _muawiya, _uthman],
        geographies: const [_medina, _iraqSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownEarlyCaliphateSourceIds,
        status: entry.status,
      );
    default:
      throw StateError('T0220 has no migration mapping for early-caliphate entry ${entry.id}.');
  }
}

final earlyCaliphateT0220Events = earlyCaliphateResearchEntries.map(_eventFor).toList(growable: false);

final earlyCaliphateT0220Dataset =
    HistoryEventContractDataset.validated(earlyCaliphateT0220Events);
