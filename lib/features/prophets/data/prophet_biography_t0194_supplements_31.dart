import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';

const _adamFridayHadithSource = SourceReference(
  id: 'sahih-muslim-854b-adam-friday',
  title: 'Sahih Muslim',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'REFERENCE-ONLY',
  locator: 'Sahih Muslim 854b',
);

/// Thirty-first T0194 source-reviewed batch.
///
/// Adds a reference-only Sahih Muslim anchor for Adam. The localized text is a
/// concise editorial paraphrase of the claim, not a copied translation. It
/// records only the hadith-owned Friday/creation/Paradise relation and does not
/// infer a year, era, earthly location, genealogy, or chronology band.
final t0194ProphetBiographySupplements31 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'adam': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: const ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim’deki bir rivayet, Âdem’in cuma günü yaratıldığını; aynı gün cennete konulduğunu ve oradan çıkarıldığını bildirir. Rivayet bu olaylar için miladî bir tarih veya yeryüzü konumu vermez.',
        en: 'A report in Sahih Muslim states that Adam was created on Friday, entered Paradise on that day, and was expelled from it on that day. The report does not provide a calendar year or an earthly location for these events.',
        ar: 'تذكر رواية في صحيح مسلم أن آدم خُلق يوم الجمعة، وأُدخل الجنة في ذلك اليوم، وأُخرج منها فيه. ولا تعطي الرواية سنةً تاريخية محددة ولا موقعًا أرضيًا لهذه الأحداث.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_adamFridayHadithSource],
    ),
  },
};
