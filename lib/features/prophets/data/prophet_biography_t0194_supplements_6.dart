import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';

SourceReference _hadithSource({
  required String stableId,
  required String title,
  required String locator,
}) =>
    SourceReference(
      id: stableId,
      title: title,
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'REFERENCE-ONLY',
      locator: locator,
    );

ProphetBiographyField _hadithField({
  required String tr,
  required String en,
  required String ar,
  required SourceReference source,
}) =>
    ProphetBiographyField(
      text: LocalizedReligiousText(tr: tr, en: en, ar: ar),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[source],
    );

/// Sixth T0194 source-reviewed batch.
///
/// This layer deliberately uses hadith only as a bibliographic reference; no
/// third-party translation is copied into the app. It fills only details that
/// are explicit in sahih reports and does not infer a calendar birth date,
/// birth year, death year, or modern map coordinate.
final t0194ProphetBiographySupplements6 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _hadithField(
      tr: 'Sahih Müslim’de nakledilen rivayette Hz. Muhammed pazartesi gününün doğduğu ve kendisine vahyin indirildiği gün olduğunu bildirir; rivayet kesin bir takvim tarihi veya doğum yılı vermez.',
      en: 'A report in Sahih Muslim records Prophet Muhammad identifying Monday as the day on which he was born and revelation came to him; the report does not provide an exact calendar date or birth year.',
      ar: 'يروي صحيح مسلم أن النبي محمد ذكر أن يوم الاثنين هو اليوم الذي وُلد فيه ونزل عليه فيه الوحي، من غير تحديد تاريخ تقويمي دقيق أو سنة للميلاد.',
      source: _hadithSource(
        stableId: 'sahih-muslim-1162e-muhammad-birth',
        title: 'Sahih Muslim',
        locator: 'Sahih Muslim 1162e',
      ),
    ),
    ProphetBiographySectionKey.death: _hadithField(
      tr: 'Sahih Buhârî’de Âişe’den nakledilen rivayet, Hz. Muhammed’in vefatını ve son anlarında onun yanında bulunduğunu aktarır; bu alan rivayetten kesin bir miladi ölüm tarihi türetmez.',
      en: 'A report in Sahih al-Bukhari from Aisha records Prophet Muhammad’s death and her presence with him in his final moments; this field does not derive an exact Gregorian death date from the report.',
      ar: 'يروي صحيح البخاري عن عائشة وفاة النبي محمد وحضورها معه في ساعاته الأخيرة، ولا يستنبط هذا الحقل من الرواية تاريخًا ميلاديًا دقيقًا للوفاة.',
      source: _hadithSource(
        stableId: 'sahih-bukhari-4449-muhammad-death',
        title: 'Sahih al-Bukhari',
        locator: 'Sahih al-Bukhari 4449',
      ),
    ),
  },
};
