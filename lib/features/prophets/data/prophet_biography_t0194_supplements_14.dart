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

/// Fourteenth T0194 source-reviewed batch.
///
/// Quran 3:49 explicitly presents Jesus as a messenger to the Children of
/// Israel. Quran 3:49-51 records his call, including signs from his Lord,
/// confirmation of the Torah, calling people to be mindful of Allah and obey
/// the messenger, and worshipping Allah as his Lord and their Lord. These
/// fields do not infer a calendar date, city, ruler, or wider population label.
///
/// Quran 3:49 records the clay-bird sign, healing the blind and the leper,
/// bringing the dead to life, and informing people about what they ate and
/// stored in their homes. Quran 5:110 independently repeats the clay-bird,
/// healing, and bringing-forth-the-dead signs while repeatedly making Allah's
/// permission explicit. The miracles field preserves that permission boundary
/// and adds no mechanism, medical explanation, named patient, date, or place.
final t0194ProphetBiographySupplements14 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Îsâ’nın İsrailoğullarına elçi olarak gönderildiğini açıkça bildirir. Bu alan ayetin verdiği topluluk adını korur; şehir, devlet veya daha geniş bir tarihsel nüfus etiketi eklemez.',
      en: 'The Quran explicitly presents Jesus as a messenger to the Children of Israel. This field preserves the community named by the verse and adds no city, state, or broader historical population label.',
      ar: 'يذكر القرآن صراحة أن عيسى رسول إلى بني إسرائيل. ويحفظ هذا الحقل اسم الجماعة الوارد في الآية من غير إضافة مدينة أو دولة أو تسمية سكانية تاريخية أوسع.',
      stableId: 'isa-q3-49-community',
      locator: 'Quran 3:49',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Îsâ’nın İsrailoğullarına Rablerinden bir ayetle geldiğini, kendinden önceki Tevrat’ı doğruladığını, Allah’tan sakınıp kendisine itaat etmeye ve yalnız Allah’a kulluk etmeye çağırdığını bildirir. Ayetler bu tebliğ için kesin bir başlangıç tarihi vermez.',
      en: 'The Quran records Jesus coming to the Children of Israel with a sign from their Lord, confirming the Torah before him, calling them to be mindful of Allah and obey him, and to worship Allah alone. The verses give no exact calendar date for the beginning of this mission.',
      ar: 'يذكر القرآن أن عيسى جاء بني إسرائيل بآية من ربهم مصدقًا لما بين يديه من التوراة، ودعاهم إلى تقوى الله وطاعته وعبادة الله وحده. ولا تعطي الآيات تاريخًا تقويميًا دقيقًا لبداية هذه الدعوة.',
      stableId: 'isa-q3-49-51-mission',
      locator: 'Quran 3:49-51',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, Îsâ’nın Allah’ın izniyle çamurdan kuş biçiminde bir şekil yapıp ona üflemesiyle kuş olmasını, körü ve alacalı hastayı iyileştirmesini ve ölüleri diriltmesini; ayrıca insanlara yediklerini ve evlerinde biriktirdiklerini haber vermesini ayetler arasında sayar. Bu alan özellikle “Allah’ın izniyle” kaydını korur ve olaylara tıbbi ya da doğal bir mekanizma eklemez.',
      en: 'The Quran lists among Jesus’s signs that, by Allah’s permission, a clay form like a bird became a bird when he breathed into it, that he healed the blind and the leper and brought the dead to life, and that he informed people of what they ate and stored in their homes. This field explicitly preserves the “by Allah’s permission” qualification and adds no medical or natural mechanism.',
      ar: 'يذكر القرآن من آيات عيسى أنه بإذن الله يصنع من الطين كهيئة الطير ثم ينفخ فيه فيكون طيرًا، ويبرئ الأكمه والأبرص ويحيي الموتى، ويخبر الناس بما يأكلون وما يدخرون في بيوتهم. ويحفظ هذا الحقل صراحة قيد «بإذن الله» ولا يضيف تفسيرًا طبيًا أو طبيعيًا للكيفية.',
      stableId: 'isa-q3-49-q5-110-miracles',
      locator: 'Quran 3:49; 5:110',
    ),
  },
};

final t0194ProphetSupplementReferences14 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 49),
    ProphetVerseReference(surah: 3, ayah: 50),
    ProphetVerseReference(surah: 3, ayah: 51),
    ProphetVerseReference(surah: 5, ayah: 110),
  ],
};
