import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0175 research record for the Day of Arafah (Arefe Günü / Yawm Arafah).
///
/// Third-party material is paraphrased and cited by locator. No third-party
/// translation is copied. The record intentionally remains `research` until
/// religious and native TR/EN/AR review evidence is attached.
final ReligiousDayContent arafahResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-day-arafah',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [
      _quranArafat,
      _muslim1162a,
      _bukhari1661,
      _tdvArefe,
      _tdvArafat,
    ],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'Arefe Günü, Zilhicce ayının dokuzuncu günüdür ve hacda Arafat vakfesinin yapıldığı gündür. Türkçede “arefe” sözü başka önemli günlerin arifesi için de kullanılabilse de bu rehber dinî anlamdaki 9 Zilhicce gününü anlatır.',
    en: 'The Day of Arafah is the ninth day of Dhu al-Hijjah and the day on which pilgrims perform the standing at Arafat. This guide uses “Day of Arafah” specifically for 9 Dhu al-Hijjah, not for the broader Turkish colloquial use of “arefe” meaning an eve before another important day.',
    ar: 'يوم عرفة هو اليوم التاسع من ذي الحجة، وفيه يقف الحجاج بعرفة. ويستعمل هذا الدليل اسم يوم عرفة بهذا المعنى الشرعي المحدد، لا بالاستعمال التركي الأوسع لكلمة «عرفة» للدلالة على اليوم السابق لبعض المناسبات.',
  ),
  history: const LocalizedReligiousText(
    tr: 'Arefe gününün merkezinde Arafat vakfesi bulunur. Kur’an Bakara 2:198’de Arafat’tan ayrılmayı açıkça anar. Klasik ve modern kaynaklarda günün adı, Arafat’ta vakfenin 9 Zilhicce’de yapılmasıyla açıklanır; ismin kökenine dair anlatılar ise kesin tarihsel gerçek gibi sunulmaz.',
    en: 'The standing at Arafat is central to the Day of Arafah. Qur’an 2:198 explicitly mentions departing from Arafat. Classical and modern reference works connect the day’s name with the standing at Arafat on 9 Dhu al-Hijjah; stories about the origin of the name are not presented as certain historical fact.',
    ar: 'يرتبط يوم عرفة أساساً بالوقوف بعرفات. وتذكر الآية 2:198 من سورة البقرة الإفاضة من عرفات صراحة. وتربط المصادر اسم اليوم بالوقوف بعرفات في التاسع من ذي الحجة، أما الروايات المتعلقة بأصل التسمية فلا يعرضها التطبيق كحقائق تاريخية قطعية.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'Bakara 2:198, Arafat’tan ayrıldıktan sonra Meş’ar-i Haram’da Allah’ın anılmasını bildirir. Ayet, Arafat’ın hac ibadeti içindeki yerini doğrudan Kur’an metnine bağlayan açık dayanaktır.',
        en: 'Al-Baqarah 2:198 instructs pilgrims to remember Allah at al-Mashʿar al-Haram after departing from Arafat. It is an explicit Qur’anic basis connecting Arafat with the rites of Hajj.',
        ar: 'تأمر سورة البقرة 2:198 بذكر الله عند المشعر الحرام بعد الإفاضة من عرفات، وهي دلالة قرآنية صريحة على ارتباط عرفات بمناسك الحج.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranArafat],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 1162a’da Arefe günü orucu için önceki ve sonraki yılın günahlarına kefaret olmasının Allah’tan umulduğu bildirilir. Uygulama bu rivayeti kaynağıyla verir; bütün günahların her şartta otomatik silineceği şeklinde sınırsız bir garanti üretmez.',
        en: 'Sahih Muslim 1162a reports the hope that fasting on the Day of Arafah atones for the preceding and following year. The app preserves the report with its source and does not convert it into an unlimited guarantee that every sin is automatically erased in every circumstance.',
        ar: 'يروي صحيح مسلم 1162a رجاء تكفير صيام يوم عرفة للسنة الماضية والقادمة. ويعرض التطبيق الرواية بمصدرها ولا يحولها إلى ضمان مطلق بأن كل ذنب يمحى آلياً في جميع الأحوال.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1162a],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.strongReport,
      text: LocalizedReligiousText(
        tr: 'Sahih Buhârî 1661’de Hz. Peygamber’in Arafat’ta vakfe hâlindeyken kendisine gönderilen sütü içtiği aktarılır. Bu güçlü rivayet, hacdaki Arafat vakfesi ile hacda olmayanların Arefe orucu uygulamasını aynı bağlam gibi göstermemek için korunur.',
        en: 'Sahih al-Bukhari 1661 reports that the Prophet drank milk while standing at Arafat. This strong report is kept to prevent the app from treating the pilgrim’s situation at Arafat and the non-pilgrim’s Arafah fast as though they were the same context.',
        ar: 'يروي صحيح البخاري 1661 أن النبي ﷺ شرب اللبن وهو واقف بعرفة. ويحفظ التطبيق هذا السياق حتى لا يخلط بين حال الحاج الواقف بعرفة وبين صيام غير الحاج يوم عرفة.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_bukhari1661],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: 'Türkçede “arefe” kelimesinin Ramazan Bayramı’ndan veya başka önemli günlerden önceki gün için de kullanılması dil ve kültür geleneğidir. Bu geniş kullanım, 9 Zilhicce’deki dinî Arefe Günü ile aynı kaynak statüsünde gösterilmez.',
        en: 'In Turkish, “arefe” is also used culturally for the day before Ramadan Eid or other important occasions. That broader linguistic custom is not given the same source status as the religious Day of Arafah on 9 Dhu al-Hijjah.',
        ar: 'يستعمل لفظ «عرفة/arefe» في التركية ثقافياً أيضاً لليوم السابق لعيد الفطر أو لبعض المناسبات المهمة. ولا يساوي التطبيق بين هذا الاستعمال اللغوي وبين يوم عرفة الشرعي في التاسع من ذي الحجة.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvArefe],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.specificWorship,
      text: LocalizedReligiousText(
        tr: 'Hacda olmayanlar için Arefe orucunun fazileti Sahih Müslim 1162a’da güçlü biçimde aktarılır. Hacdaki kişinin Arafat vakfesi bağlamı farklıdır; Buhârî 1661 Hz. Peygamber’in Arafat’ta oruçlu olmadığını gösterir. Uygulama bu iki bağlamı tek bir herkese-zorunlu hükme dönüştürmez.',
        en: 'The virtue of fasting on the Day of Arafah for non-pilgrims is strongly reported in Sahih Muslim 1162a. The pilgrim’s context at Arafat is different; Bukhari 1661 shows the Prophet was not fasting while standing there. The app does not collapse these two contexts into one compulsory rule for everyone.',
        ar: 'ثبتت فضيلة صيام يوم عرفة لغير الحاج في صحيح مسلم 1162a. أما سياق الحاج الواقف بعرفة فمختلف؛ ويبين البخاري 1661 أن النبي ﷺ لم يكن صائماً وهو واقف هناك. ولا يحول التطبيق السياقين إلى حكم إلزامي واحد لجميع الناس.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim1162a, _bukhari1661],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.generalWorship,
      text: LocalizedReligiousText(
        tr: 'Allah’ı anma, dua, tövbe ve diğer genel ibadetler Arefe gününde de yapılabilir. Uygulama sahih kaynakla sabit olmayan özel bir dua metni, özel tekrar sayısı, kesin kabul veya maddi sonuç garantisi üretmez.',
        en: 'Remembrance of Allah, supplication, repentance and other general acts of worship may also be practiced on the Day of Arafah. The app does not invent an Arafah-specific prayer formula, special repetition count, guaranteed acceptance or material outcome without a sound source.',
        ar: 'يمكن في يوم عرفة الإكثار من ذكر الله والدعاء والتوبة وسائر العبادات العامة. ولا ينشئ التطبيق دعاءً مخصوصاً لعرفات أو عدداً خاصاً للتكرار أو ضماناً للقبول أو للنتائج المادية بلا مصدر صحيح.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quranArafat, _muslim1162a],
    ),
  ],
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
  specificWorshipStatus: SpecificWorshipStatus.establishedByStrongSource,
);

const _title = LocalizedReligiousText(
  tr: 'Arefe Günü',
  en: 'Day of Arafah',
  ar: 'يوم عرفة',
);

const _quranArafat = SourceReference(
  id: 'quran-2-198-arafat',
  title: 'Qur’an — Al-Baqarah 2:198',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '2:198',
);

const _muslim1162a = SourceReference(
  id: 'muslim-1162a-arafah-fast',
  title: 'Sahih Muslim 1162a',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 13, Hadith 252',
);

const _bukhari1661 = SourceReference(
  id: 'bukhari-1661-arafat-not-fasting',
  title: 'Sahih al-Bukhari 1661',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 25, Hadith 142',
);

const _tdvArefe = SourceReference(
  id: 'tdv-islam-ansiklopedisi-arefe',
  title: 'TDV İslâm Ansiklopedisi — Arefe',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Arefe maddesi — 9 Zilhicce, vakfe ve Türkçe kullanım ayrımı',
);

const _tdvArafat = SourceReference(
  id: 'tdv-islam-ansiklopedisi-arafat',
  title: 'TDV İslâm Ansiklopedisi — Arafat',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Arafat maddesi — vakfenin yeri ve tarihsel açıklamalar',
);
