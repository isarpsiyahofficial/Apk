import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_content.dart';

const _muhammadBirthSource = SourceReference(
  id: 'sahih-muslim-1162e-muhammad-birth',
  title: 'Sahih Muslim',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih Muslim 1162e',
);

/// Twenty-third T0194 source-reviewed batch.
///
/// Sahih Muslim 1162e records the Prophet Muhammad saying, when asked about
/// fasting on Monday, that it was the day on which he was born and revelation
/// was sent down to him. This field therefore records only the weekday claim.
/// It does not infer an exact Gregorian/Hijri date, year, birthplace, or any
/// later chronological detail from this hadith.
final t0194ProphetBiographySupplements23 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: ProphetBiographyField(
      text: const LocalizedReligiousText(
        tr: 'Sahih Muslim’de aktarılan rivayette Hz. Muhammed, Pazartesi günü oruç hakkında sorulduğunda o günün doğduğu ve kendisine vahyin indirildiği gün olduğunu bildirir. Bu alan yalnız doğumun Pazartesi günü olduğu bilgisini aktarır; rivayetin vermediği kesin tarih, yıl veya doğum yeri eklenmez.',
        en: 'In the report recorded in Sahih Muslim, when Prophet Muhammad was asked about fasting on Monday, he stated that it was the day on which he was born and revelation was sent down to him. This field records only that his birth was on a Monday and adds no exact date, year, or birthplace not supplied by the report.',
        ar: 'في الرواية التي أخرجها صحيح مسلم، سُئل النبي محمد عن صيام يوم الاثنين فقال إنه اليوم الذي وُلد فيه وأُنزل عليه فيه الوحي. ويقتصر هذا الحقل على أن مولده كان يوم الاثنين، ولا يضيف تاريخًا أو سنةً أو مكان ولادة لم تذكره الرواية.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_muhammadBirthSource],
    ),
  },
};

const t0194ProphetSupplementReferences23 =
    <String, List<ProphetVerseReference>>{};
