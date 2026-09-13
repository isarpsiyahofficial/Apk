import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_content.dart';

final _oxfordPrincetonMuhammadPeriodSource = SourceReference(
  id: 'oxford-princeton-islamic-political-thought-muhammad-2015',
  title: 'Muhammad — Islamic Political Thought: An Introduction',
  sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
  licenseId: 'COPYRIGHT-PRINCETON-CITATION-ONLY',
  locator: 'Chapter 10, pp. 152-168; DOI 10.23943/princeton/9780691164823.003.0010',
  url: Uri.parse(
    'https://doi.org/10.23943/princeton/9780691164823.003.0010',
  ),
);

/// Twenty-fourth T0194 source-reviewed batch.
///
/// This batch fills only Muhammad's broad historical period. The source is
/// modern historical scholarship, not Quran or hadith evidence. It places his
/// life approximately from ca. 570 to 632 CE, with the prophetic career in the
/// first third of the seventh century and the familiar Mecca/Medina division.
/// These dates are presented as historical periodization rather than dates
/// supplied by the Quran, and the wording intentionally preserves the source's
/// approximate chronology instead of turning ca. 570 into an exact birth year.
final t0194ProphetBiographySupplements24 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.period: ProphetBiographyField(
      text: const LocalizedReligiousText(
        tr: 'Modern tarih literatürü Hz. Muhammed’in hayatını yaklaşık miladî 570–632 dönemine, peygamberlik faaliyetini ise yedinci yüzyılın ilk üçte birlik bölümüne yerleştirir; Mekke dönemi yaklaşık 610–622, Medine dönemi 622–632 olarak ele alınır. Bu tarihler Kur’an’ın verdiği tarihler değildir; özellikle yaklaşık 570 tarihi kesin bir doğum yılı iddiası olarak sunulmaz.',
        en: 'Modern historical scholarship places Muhammad’s life approximately in the period ca. 570–632 CE and his prophetic career in the first third of the seventh century, with a Meccan phase around 610–622 and a Medinan phase from 622–632. These are historical periodizations rather than dates supplied by the Quran, and ca. 570 is not presented as an exact birth year.',
        ar: 'تضع الدراسات التاريخية الحديثة حياة محمد ﷺ تقريبًا في الفترة من نحو 570 إلى 632م، ومسيرته النبوية في الثلث الأول من القرن السابع، مع مرحلة مكية تقارب 610–622م ومرحلة مدنية من 622 إلى 632م. وهذه تواريخ تأريخية حديثة وليست تواريخ يوردها القرآن، ولا يُعرض نحو سنة 570 بوصفه سنة ميلاد قطعية.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_oxfordPrincetonMuhammadPeriodSource],
    ),
  },
};

final t0194ProphetSupplementReferences24 = <String, List<ProphetVerseReference>>{};
