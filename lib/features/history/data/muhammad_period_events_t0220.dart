import '../../../core/content/content_governance.dart';
import '../../prophets/data/muhammad_seerah_timeline.dart';
import '../domain/history_event_contract.dart';
import '../domain/muhammad_history_seerah_bridge.dart';
import 'pre_islam_world_context.dart';

LocalizedHistorySummary _historyText(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

LocalizedHistorySummary _fromReligiousText(LocalizedReligiousText value) =>
    LocalizedHistorySummary(tr: value.tr, en: value.en, ar: value.ar);

const _muhammadPerson = HistoryPersonRef(
  id: 'prophet:muhammad',
  name: LocalizedHistorySummary(
    tr: 'Hz. Muhammed',
    en: 'Prophet Muhammad',
    ar: 'النبي محمد',
  ),
);

HistoryGeographyRef _geographyFor(MuhammadSeerahEvent event) {
  if (event.kind == SeerahEventKind.abyssiniaMigration) {
    return const HistoryGeographyRef(
      id: 'region:abyssinia',
      label: LocalizedHistorySummary(
        tr: 'Habeşistan / Aksum bölgesi',
        en: 'Abyssinia / Aksum region',
        ar: 'منطقة الحبشة / أكسوم',
      ),
      precision: HistoryGeographyPrecision.regional,
    );
  }
  if (event.kind == SeerahEventKind.conquestOfMecca) {
    return const HistoryGeographyRef(
      id: 'city:mecca',
      label: LocalizedHistorySummary(tr: 'Mekke', en: 'Mecca', ar: 'مكة'),
      precision: HistoryGeographyPrecision.regional,
    );
  }
  if (event.kind == SeerahEventKind.hijrah ||
      event.kind == SeerahEventKind.medinaArrival ||
      event.phase == SeerahPhase.medinan ||
      event.phase == SeerahPhase.finalYears) {
    return const HistoryGeographyRef(
      id: 'city:medina',
      label: LocalizedHistorySummary(tr: 'Medine', en: 'Medina', ar: 'المدينة'),
      precision: HistoryGeographyPrecision.regional,
    );
  }
  return const HistoryGeographyRef(
    id: 'city:mecca',
    label: LocalizedHistorySummary(tr: 'Mekke', en: 'Mecca', ar: 'مكة'),
    precision: HistoryGeographyPrecision.regional,
  );
}

LocalizedHistorySummary _beforeContextFor(MuhammadSeerahEvent event) =>
    switch (event.phase) {
      SeerahPhase.birthAndEarlyLife => _historyText(
          'Bu kayıt, vahiy öncesi biyografik kronoloji içinde yer alır; kaynakta bulunmayan takvim ayrıntısı eklenmez.',
          'This record belongs to the pre-revelation biographical chronology; calendar detail absent from the cited source is not added.',
          'ينتمي هذا السجل إلى التسلسل السيري السابق للوحي، ولا تضاف تفاصيل تقويمية لا يذكرها المصدر.',
        ),
      SeerahPhase.meccan => _historyText(
          'Bu kayıt Mekke dönemi kronolojisi içinde, önceki canonical siyer olaylarının ardından okunur.',
          'This record is read within the Meccan chronology after the preceding canonical seerah events.',
          'يقرأ هذا السجل ضمن التسلسل المكي بعد أحداث السيرة الموثقة السابقة.',
        ),
      SeerahPhase.hijrah => _historyText(
          'Bu kayıt Mekke döneminden Medine dönemine geçiş bağlamında yer alır.',
          'This record belongs to the transition from the Meccan period to the Medinan period.',
          'ينتمي هذا السجل إلى سياق الانتقال من العهد المكي إلى العهد المدني.',
        ),
      SeerahPhase.medinan => _historyText(
          'Bu kayıt Medine dönemi içindeki canonical siyer sırasını korur.',
          'This record preserves the canonical seerah ordering within the Medinan period.',
          'يحافظ هذا السجل على ترتيب السيرة الموثق داخل العهد المدني.',
        ),
      SeerahPhase.finalYears => _historyText(
          'Bu kayıt siyer kronolojisinin son yılları içinde, önceki Medine dönemi kayıtlarının ardından yer alır.',
          'This record belongs to the final years of the seerah chronology after the preceding Medinan records.',
          'ينتمي هذا السجل إلى السنوات الأخيرة من تسلسل السيرة بعد السجلات المدنية السابقة.',
        ),
    };

LocalizedHistorySummary _causeFor(MuhammadSeerahEvent event) => switch (event.kind) {
      SeerahEventKind.firstRevelation => _historyText(
          'Canonical kaynak olayın vahyin başlangıcı olduğunu bildirir; kaynakta açıklanmayan metafizik bir neden ayrıca üretilmez.',
          'The canonical source identifies this as the beginning of revelation; no additional metaphysical cause absent from the source is manufactured.',
          'يثبت المصدر الموثق أن هذا الحدث هو بدء الوحي، ولا يُنشأ سبب غيبي إضافي لا يذكره المصدر.',
        ),
      SeerahEventKind.meccanPreaching => _historyText(
          'Kaynak, yakınları uyarma emrini tebliğ faaliyetinin açık dayanağı olarak verir.',
          'The source gives the command to warn close kindred as an explicit basis for the preaching activity.',
          'يجعل المصدر أمر إنذار العشيرة الأقربين أساسًا صريحًا لنشاط الدعوة.',
        ),
      SeerahEventKind.abyssiniaMigration => _historyText(
          'Canonical rivayet Habeşistan’a hicret eden topluluğu doğrular; ayrıntılı siyasi nedenler bu kaynağın söylemediği ölçüde kesinleştirilmez.',
          'The canonical report confirms the community that migrated to Abyssinia; detailed political causes are not asserted beyond what the source states.',
          'تثبت الرواية الموثقة جماعة المهاجرين إلى الحبشة، ولا يجزم بتفاصيل الأسباب السياسية بما يتجاوز نص المصدر.',
        ),
      SeerahEventKind.hijrah || SeerahEventKind.medinaArrival => _historyText(
          'Kayıt, canonical siyer içinde Mekke’den Medine’ye geçiş sürecinin bir parçasıdır; kaynak dışı neden ayrıntısı eklenmez.',
          'The record is part of the canonical transition from Mecca to Medina; causal detail absent from the cited sources is not added.',
          'السجل جزء من الانتقال الموثق من مكة إلى المدينة، ولا تضاف تفاصيل سببية خارج المصادر المذكورة.',
        ),
      SeerahEventKind.hudaybiyyahTreaty => _historyText(
          'Kayıt, Hudeybiye sürecini canonical kaynakların verdiği sınırlar içinde antlaşma bağlamıyla ilişkilendirir.',
          'The record relates the Hudaybiyyah process to its treaty context only within the bounds supplied by the canonical sources.',
          'يربط السجل الحديبية بسياق الصلح ضمن الحدود التي تقررها المصادر الموثقة.',
        ),
      SeerahEventKind.conquestOfMecca => _historyText(
          'Olay, canonical siyer sıralamasında Hudeybiye sonrasındaki Mekke safhasında yer alır; kaynakta bulunmayan tek-neden açıklaması kurulmaz.',
          'The event belongs to the post-Hudaybiyyah Meccan stage of the canonical seerah; no single-cause explanation absent from the sources is asserted.',
          'يقع الحدث في المرحلة المكية التالية للحديبية ضمن السيرة الموثقة، ولا يفرض تفسير أحادي للسبب لا تقرره المصادر.',
        ),
      SeerahEventKind.farewellPilgrimage => _historyText(
          'Kayıt, siyerin son yıllarındaki hac bağlamını kaynakların açıkça verdiği ölçüde taşır.',
          'The record carries the pilgrimage context of the final years only to the extent explicitly supported by its sources.',
          'يحمل السجل سياق الحج في السنوات الأخيرة بقدر ما تثبته مصادره صراحة.',
        ),
      SeerahEventKind.death => _historyText(
          'Bu biyografik dönüm noktası için kaynakta bulunmayan tıbbi veya nedensel ayrıntı üretilmez.',
          'No medical or causal detail absent from the cited source is manufactured for this biographical milestone.',
          'لا تُنشأ لهذا المنعطف السيري تفاصيل طبية أو سببية لا يذكرها المصدر.',
        ),
      _ => _historyText(
          'Bu biyografik olayın nedeni yalnız canonical kaynakların açıkça desteklediği sınırda tutulur; ek neden iddiası üretilmez.',
          'The cause field for this biographical event is bounded by what the canonical sources explicitly support; no extra causal claim is manufactured.',
          'يقتصر حقل سبب هذا الحدث السيري على ما تدعمه المصادر الموثقة صراحة، ولا تُنشأ دعوى سببية إضافية.',
        ),
    };

LocalizedHistorySummary _consequenceFor() => _historyText(
      'Sonuç alanı olayın canonical siyer sırasındaki bir sonraki bağlama bağlanmasıyla sınırlıdır; kaynakta olmayan sonuç iddiası eklenmez.',
      'The consequence field is limited to this event’s placement before the next canonical seerah context; no unsupported downstream claim is added.',
      'يقتصر حقل النتيجة على موضع الحدث قبل السياق التالي في السيرة الموثقة، ولا تضاف دعوى لاحقة لا يدعمها المصدر.',
    );

/// T0212 -> T0220 migration.
///
/// The history module remains a 1:1 projection of the canonical T0201 seerah.
/// T0201 intentionally stores relative order rather than invented Gregorian/Hijri
/// years, so these migrated records use `HistoryDateCertainty.unknown` with
/// null year bounds. This is deliberately stricter than using a sentinel year.
final muhammadPeriodEventsT0220 = (() {
  final seerah = muhammadSeerahT0201Events;
  final knownSourceIds = seerah
      .expand((event) => event.sources)
      .map((source) => source.id)
      .toSet();

  final events = <HistoryEventRecord>[];
  for (var index = 0; index < seerah.length; index++) {
    final event = seerah[index];
    final bridgeLink = canonicalMuhammadHistorySeerahBridge.links[index];
    if (bridgeLink.seerahEventId != event.id ||
        bridgeLink.historyEventId != 'history:${event.id}' ||
        bridgeLink.order != event.order ||
        bridgeLink.phase != event.phase) {
      throw StateError('T0212/T0220 seerah bridge drift: ${event.id}');
    }

    events.add(
      HistoryEventRecord.validated(
        id: bridgeLink.historyEventId,
        title: _fromReligiousText(event.title),
        startYearCe: null,
        endYearCe: null,
        dateCertainty: HistoryDateCertainty.unknown,
        dateCaveat: _historyText(
          'Canonical siyer kaydı göreli kronolojiyi doğrular; bu veri kaydı kaynakta bulunmayan kesin veya yaklaşık bir miladi yıl üretmez.',
          'The canonical seerah record establishes relative chronology; this dataset does not manufacture an exact or approximate CE year absent from the source record.',
          'يثبت سجل السيرة الموثق الترتيب النسبي، ولا ينشئ هذا السجل سنة ميلادية دقيقة أو تقريبية لا يذكرها المصدر.',
        ),
        beforeContext: _beforeContextFor(event),
        causes: <LocalizedHistorySummary>[_causeFor(event)],
        consequences: <LocalizedHistorySummary>[_consequenceFor()],
        people: const <HistoryPersonRef>[_muhammadPerson],
        geographies: <HistoryGeographyRef>[_geographyFor(event)],
        sourceIds: event.sources.map((source) => source.id).toList(growable: false),
        knownSourceIds: knownSourceIds,
        status: HistoryResearchStatus.researchDraft,
      ),
    );
  }

  return HistoryEventContractDataset.validated(events);
})();
