import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_23.dart';
import 'prophet_content.dart';

final _cambridgeFirstCenturySource = SourceReference(
  id: 'cambridge-impact-jesus-first-century-palestine-2019',
  title: 'The Impact of Jesus in First-Century Palestine — Cambridge University Press',
  sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
  licenseId: 'COPYRIGHT-CAMBRIDGE-CITATION-ONLY',
  locator: 'Book description; DOI 10.1017/9781108612364',
  url: Uri.parse(
    'https://doi.org/10.1017/9781108612364',
  ),
);

/// Twenty-second T0194 source-reviewed batch.
///
/// This batch fills only Isa's broad historical period. The source is modern
/// historical/archaeological scholarship, not Quran or hadith evidence, and is
/// intentionally labelled as such. It places the historical Jesus in the
/// early first-century Galilee/Judea setting without turning scholarly
/// chronology into a Quranic claim or inventing an exact birth/death year.
///
/// The twenty-third source-reviewed supplement is composed here as the next
/// chronological layer so the stable dataset import chain also carries
/// Muhammad's Sahih Muslim 1162e birth-weekday evidence.
final t0194ProphetBiographySupplements22 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  ...t0194ProphetBiographySupplements23,
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.period: ProphetBiographyField(
      text: const LocalizedReligiousText(
        tr: 'Modern tarih ve arkeoloji literatürü, tarihsel Îsâ’yı miladî birinci yüzyılın Galile ve Yahudiye bağlamında ele alır. Bu dönemlendirme Kur’an’ın verdiği bir tarih değildir; bu alan kesin bir doğum veya vefat yılı iddia etmez.',
        en: 'Modern historical and archaeological scholarship places the historical Jesus in the first-century setting of Galilee and Judea. This periodization is not a date supplied by the Quran, and this field does not claim an exact birth or death year.',
        ar: 'تضع الدراسات التاريخية والأثرية الحديثة عيسى التاريخي في سياق الجليل واليهودية في القرن الأول للميلاد. وهذا التأطير الزمني ليس تاريخًا يورده القرآن، ولا يدّعي هذا الحقل سنةً قطعية للميلاد أو الوفاة.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_cambridgeFirstCenturySource],
    ),
  },
};

final t0194ProphetSupplementReferences22 = <String, List<ProphetVerseReference>>{
  ...t0194ProphetSupplementReferences23,
};
