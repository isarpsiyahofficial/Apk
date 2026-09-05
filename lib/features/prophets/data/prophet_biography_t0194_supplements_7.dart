import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_content.dart';

SourceReference _quranSource(String stableId, String locator) => SourceReference(
      id: 'tanzil-uthmani-v1.1-$stableId',
      title: 'Tanzil Project — Uthmani Quran Text v1.1',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'CC-BY-3.0',
      locator: locator,
    );

ProphetBiographyField _quranField({
  required String tr,
  required String en,
  required String ar,
  required String stableId,
  required String locator,
}) =>
    ProphetBiographyField(
      text: LocalizedReligiousText(tr: tr, en: en, ar: ar),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_quranSource(stableId, locator)],
    );

/// Seventh T0194 source-reviewed batch.
///
/// These additions stay inside claims stated directly by the pinned Quran
/// source. They do not infer a childhood chronology, exact map coordinate,
/// calendar date, or extra-Quranic episode from the verses.
final t0194ProphetBiographySupplements7 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranField(
      tr: 'Kur’an, Mekke adını anarak Allah’ın Mekke’nin içinde karşı tarafın ellerini müminlerden, müminlerin ellerini de onlardan çektiğini bildirir; bu ayetten modern bir koordinat veya daha ayrıntılı güzergâh türetilmez.',
      en: 'The Quran names Mecca while stating that Allah withheld their hands from the believers and the believers’ hands from them within Mecca; no modern coordinate or more detailed route is inferred from this verse.',
      ar: 'يذكر القرآن مكة بالاسم، ويبين أن الله كف أيديهم عن المؤمنين وأيدي المؤمنين عنهم ببطن مكة؛ ولا يُستنبط من الآية إحداثي حديث أو مسار جغرافي أدق.',
      stableId: 'muhammad-q48-24-geography',
      locator: 'Quran 48:24',
    ),
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Hz. Muhammed’e hitaben Allah’ın onu yetim bulup barındırdığını hatırlatır; ayet çocukluk yıllarına ilişkin ayrıntılı bir kronoloji vermez.',
      en: 'Addressing Prophet Muhammad, the Quran reminds him that Allah found him an orphan and gave him shelter; the verse does not provide a detailed chronology of his childhood.',
      ar: 'يذكّر القرآن النبي محمد بأن الله وجده يتيمًا فآواه، من غير أن يقدم تفصيلًا زمنيًا دقيقًا لسنوات طفولته.',
      stableId: 'muhammad-q93-6-childhood',
      locator: 'Quran 93:6',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, inkâr edenlerin vahiy hakkında onun uydurduğu bir yalan olduğu ve eskilerin masalları olduğu yönünde itirazlar ileri sürdüklerini aktarır.',
      en: 'The Quran records disbelievers objecting to the revelation by claiming that he had fabricated it and by calling it tales of the ancients.',
      ar: 'ينقل القرآن اعتراض الذين كفروا على الوحي بزعم أنه افتراه، ووصفهم إياه بأنه أساطير الأولين.',
      stableId: 'muhammad-q25-4-5-response',
      locator: 'Quran 25:4-5',
    ),
  },
};

final t0194ProphetSupplementReferences7 = <String, List<ProphetVerseReference>>{
  'muhammad': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 25, ayah: 4),
    ProphetVerseReference(surah: 25, ayah: 5),
    ProphetVerseReference(surah: 48, ayah: 24),
    ProphetVerseReference(surah: 93, ayah: 6),
  ],
};
