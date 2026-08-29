import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0177 research record for Regaib Night.
final ReligiousDayContent regaibResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-night-regaib',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.laterTradition,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.traditional,
    text: _title,
    sources: const [_bukhari4662, _tdvRegaib, _tdvRegaibDisputed],
    lastReviewedAt: DateTime.utc(2026, 8, 29),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Regaib Gecesi, Receb ayının ilk cuma gecesine Türk-İslâm geleneğinde verilen addır. Receb sahih hadiste dört haram aydan biri olarak açıkça isimlendirilir; ancak Regaib gecesine özgü fazilet ve ibadet iddiaları ayrıca kaynak değerlendirmesine tabidir.',
    en: 'Regaib Night is the Turkish-Islamic name for the first Friday night of Rajab. Rajab is explicitly named in sound hadith as one of the four sacred months, but claims about special merits or rituals unique to Regaib require separate source evaluation.',
    ar: 'ليلة الرغائب هي الاسم المتداول في الثقافة الإسلامية التركية لأول ليلة جمعة من رجب. وقد سُمّي رجب صراحة في الحديث الصحيح ضمن الأشهر الحرم الأربعة، أما الادعاءات بفضائل أو عبادات مخصوصة بليلة الرغائب فتحتاج إلى تقييم مستقل لمصادرها.',
  ),
  history: const LocalizedReligiousText(
    tr: 'TDV Regaib Gecesi maddesi, bu geceye özgü kutlama ve özel ibadetlerin hicrî IV. yüzyılda görünür hale geldiğini aktarır. Hz. Peygamber’in bu gecede ana rahmine düştüğü veya Regaib namazına dair rivayetlerin hadis âlimlerince asılsız ya da uydurma sayıldığını da belirtir.',
    en: 'The TDV Regaib Night article reports that special celebrations and rituals connected with this night became visible in the fourth Islamic century. It also notes that hadith scholars judged reports about the Prophet being conceived on this night or a special Regaib prayer as baseless or fabricated.',
    ar: 'تذكر مادة ليلة الرغائب في الموسوعة الإسلامية التركية أن الاحتفالات والعبادات الخاصة بهذه الليلة ظهرت في القرن الرابع الهجري، وأن علماء الحديث حكموا على روايات تخصيصها بحمل النبي ﷺ أو بصلاة الرغائب بأنها لا أصل لها أو موضوعة.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Buhârî 4662, Receb-i Mudar’ı dört haram aydan biri olarak açıkça isimlendirir. Bu sahih dayanak Receb ayının statüsüne ilişkindir; Regaib gecesine özel namaz veya kesin fazilet iddiası oluşturmaz.',
        en: 'Sahih al-Bukhari 4662 explicitly names Rajab of Mudar among the four sacred months. This sound evidence concerns Rajab itself; it does not establish a Regaib-specific prayer or guaranteed merit.',
        ar: 'يسمي صحيح البخاري 4662 رجب مضر ضمن الأشهر الحرم الأربعة صراحة. وهذا الدليل الصحيح يتعلق بشهر رجب نفسه، ولا يثبت صلاة خاصة بليلة الرغائب أو فضلاً مضموناً لها.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari4662],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.disputedReport,
      text: LocalizedReligiousText(
        tr: 'Regaib gecesinde özel oruç ve “Regaib namazı” kılınmasına dair rivayet TDV’nin aktardığı hadis tenkidinde uydurma kabul edilir. İsrâ ve mi‘racın Regaib gecesinde gerçekleştiği iddiasının da sağlam dayanağı bulunmadığı belirtilir.',
        en: 'The report prescribing a special fast and “Regaib prayer” is treated as fabricated in the hadith criticism summarized by TDV. The claim that Isra and Mi‘raj occurred on Regaib Night is likewise reported as lacking a sound basis.',
        ar: 'تعد الرواية التي تخص ليلة الرغائب بصيام وصلاة تسمى «صلاة الرغائب» موضوعة في نقد الحديث الذي تنقله الموسوعة، كما يذكر أن القول بوقوع الإسراء والمعراج في ليلة الرغائب لا يقوم على أصل صحيح.',
      ),
      certainty: CertaintyLevel.disputed,
      sources: [_tdvRegaibDisputed],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Regaib gecesini Kur’an okuma, dua ve genel nâfile ibadetlerle değerlendirme uygulaması sonraki Müslüman toplumlarda bir gelenek olarak yaşamıştır. Uygulama bunu sahih sünnetle sabit özel bir gece ibadeti olarak etiketlemez.',
        en: 'Later Muslim communities have maintained traditions of Qur’an reading, supplication and general voluntary worship on Regaib Night. The app does not label these customs as a special night ritual established by sound Sunnah.',
        ar: 'استمرت في مجتمعات إسلامية لاحقة عادات إحياء ليلة الرغائب بقراءة القرآن والدعاء والنوافل العامة، ولا يصنفها التطبيق كعبادة ليلية مخصوصة ثابتة بالسنة الصحيحة.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvRegaib],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.noSpecificPracticeEstablished,
);

const _title = LocalizedReligiousText(
  tr: 'Regaib Gecesi',
  en: 'Regaib Night',
  ar: 'ليلة الرغائب',
);

const _bukhari4662 = SourceReference(
  id: 'bukhari-4662-rajab-sacred-month',
  title: 'Sahih al-Bukhari 4662',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 65, Hadith 184',
);

const _tdvRegaib = SourceReference(
  id: 'tdv-islam-ansiklopedisi-regaib',
  title: 'TDV İslâm Ansiklopedisi — Regaib Gecesi',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Regaib Gecesi maddesi — tarihsel kutlama ve görüş ayrılıkları',
);

const _tdvRegaibDisputed = SourceReference(
  id: 'tdv-islam-ansiklopedisi-regaib-disputed-reports',
  title: 'TDV İslâm Ansiklopedisi — Regaib Gecesi, rivayetlerin tenkidi',
  sourceClass: ReligiousSourceClass.disputed,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Regaib Gecesi maddesi — özel oruç/namaz rivayetleri ve mi‘rac bağlantısının tenkidi',
);
