import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0177 research record for the night of mid-Sha'ban (Berat Gecesi).
final ReligiousDayContent beratResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-night-berat-mid-shaban',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.laterTradition,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.traditional,
    text: _title,
    sources: const [_tdvBerat, _tdvBeratDisputed],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Berat Gecesi, Türk-İslâm geleneğinde Şâban ayının on beşinci gecesine verilen addır. Arapça kaynaklarda “Şâbanın ortasındaki gece” gibi adlarla da anılır. Uygulama gecenin kültürel-dinî önemini, rivayetlerin sıhhat derecesinden ayrı gösterir.',
    en: 'Berat Night is the Turkish-Islamic name commonly given to the fifteenth night of Sha‘ban, also described in Arabic sources as the night of mid-Sha‘ban. The app keeps the night’s cultural-religious significance distinct from the authenticity level of individual reports about it.',
    ar: 'ليلة البراءة اسم شائع في الثقافة الإسلامية التركية لليلة النصف من شعبان، وتعرف في المصادر العربية أيضاً بليلة النصف من شعبان. ويفصل التطبيق بين أهميتها الثقافية والدينية وبين درجة صحة الروايات المفردة المتعلقة بها.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Berat adı, Allah’ın bağışlamasına erişme ümidiyle ilişkilendirilmiştir. TDV Berat Gecesi maddesi bu gece hakkında aktarılan bazı hadislerin isnad bakımından zayıf değerlendirildiğini, ayrıca daha sonraki dönemlerde özel namaz biçimleri ve sayıların ortaya çıktığını belirtir. Uygulama bu sonraki uygulamaları sahih sünnet gibi etiketlemez.',
    en: 'The name Berat became associated with hope for divine forgiveness. The TDV Berat Night article notes that some reports transmitted about the night have been judged weak in their chains and that later periods produced special prayer forms and fixed counts. The app does not label those later practices as established Sunnah.',
    ar: 'ارتبط اسم ليلة البراءة برجاء المغفرة الإلهية. وتشير مادة ليلة البراءة في الموسوعة الإسلامية التركية إلى تضعيف أسانيد بعض الروايات الواردة فيها، وإلى ظهور صلوات وأعداد مخصوصة في عصور لاحقة. ولا يصنف التطبيق تلك الممارسات المتأخرة على أنها سنة ثابتة.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.disputedReport,
      text: LocalizedReligiousText(
        tr: 'Berat gecesine dair bazı fazilet rivayetleri hadis kaynaklarında yer almakla birlikte TDV, bunların bir kısmının isnad yönünden zayıf olduğunu aktarır. Ayrıca Duhân 44:3’teki “mübarek gece”yi Berat gecesi sayan görüş vardır; çoğunluk bunu Kadir Gecesi olarak yorumlar. Bu bağ uygulamada tartışmalı olarak kalır.',
        en: 'Some merit reports about mid-Sha‘ban appear in hadith literature, but TDV notes that a number of them are weak in chain. There is also a view identifying the “blessed night” of Qur’an 44:3 with mid-Sha‘ban, while the majority interpretation identifies it with Laylat al-Qadr. The app therefore keeps this linkage explicitly disputed.',
        ar: 'وردت روايات في فضل ليلة النصف من شعبان، إلا أن الموسوعة الإسلامية التركية تنقل تضعيف أسانيد عدد منها. كما يوجد قول يربط «الليلة المباركة» في الدخان 44:3 بليلة النصف من شعبان، بينما يفسرها جمهور العلماء بليلة القدر؛ لذلك يبقى هذا الربط في التطبيق ضمن قسم المختلف فيه.',
      ),
      certainty: CertaintyLevel.disputed,
      sources: [_tdvBeratDisputed],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Şâban’ın on beşinci gecesini ibadet ve dua ile değerlendirme geleneği birçok Müslüman toplumda yaşamaktadır. Gelenek statüsü, tek tek özel ibadet biçimlerinin sahih kaynakla sabit olduğu anlamına gelmez.',
        en: 'Many Muslim communities maintain a tradition of spending the fifteenth night of Sha‘ban in prayer and devotion. Its traditional status does not mean that every specific ritual attached to the night is established by sound evidence.',
        ar: 'توجد في مجتمعات إسلامية كثيرة عادة إحياء ليلة النصف من شعبان بالدعاء والعبادة، لكن وصفها بالتقليد لا يعني ثبوت كل عبادة مخصوصة نُسبت إليها بدليل صحيح.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvBerat],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.noSpecificPracticeEstablished,
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
);

const _title = LocalizedReligiousText(
  tr: 'Berat Gecesi',
  en: 'Mid-Sha‘ban Night (Berat)',
  ar: 'ليلة النصف من شعبان (ليلة البراءة)',
);

const _tdvBerat = SourceReference(
  id: 'tdv-islam-ansiklopedisi-berat',
  title: 'TDV İslâm Ansiklopedisi — Berat Gecesi',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Berat Gecesi maddesi — 15 Şâban geleneği ve tarihsel uygulamalar',
);

const _tdvBeratDisputed = SourceReference(
  id: 'tdv-islam-ansiklopedisi-berat-disputed-reports',
  title: 'TDV İslâm Ansiklopedisi — Berat Gecesi, rivayetlerin değerlendirilmesi',
  sourceClass: ReligiousSourceClass.disputed,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Berat Gecesi maddesi — zayıf rivayetler, Duhân 44:3 ihtilafı ve özel namaz eleştirileri',
);
