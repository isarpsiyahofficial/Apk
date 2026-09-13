import '../../../core/content/content_governance.dart';
import 'religious_day_content.dart';

/// T0177 research record for Isra and Mi'raj.
final ReligiousDayContent mirajResearchContent = ReligiousDayContent(
  record: ReligiousContentRecord(
    id: 'religious-night-isra-miraj',
    type: ContentType.religiousDay,
    sourceStatus: ReligiousSourceClass.quran,
    version: 1,
    reviewStatus: ContentReviewStatus.research,
    certainty: CertaintyLevel.explicitSource,
    text: _title,
    sources: const [_quran171, _muslim162a, _tdvMiraj],
    lastReviewedAt: DateTime.utc(2026, 9, 4),
  ),
  title: _title,
  whatIsIt: const LocalizedReligiousText(
    tr: 'İsrâ, Hz. Peygamber’in gece Mescid-i Harâm’dan Mescid-i Aksâ’ya götürülmesini; mi‘rac ise sahih rivayetlerde aktarılan semaya yükseliş safhasını ifade eder. Türkiye’de bu hatıra yaygın olarak “Miraç Kandili” adıyla anılır.',
    en: 'Isra refers to the Prophet’s night journey from al-Masjid al-Haram to al-Masjid al-Aqsa; Mi‘raj refers to the ascent described in sound hadith reports. In Turkish religious culture the commemoration is commonly called “Miraç Kandili”.',
    ar: 'الإسراء هو انتقال النبي ﷺ ليلاً من المسجد الحرام إلى المسجد الأقصى، والمعراج هو الصعود الذي ترويه الأحاديث الصحيحة. ويشيع في الثقافة الدينية التركية إحياء هذه الذكرى باسم «ليلة المعراج/ميراچ قنديلي».',
  ),
  history: const LocalizedReligiousText(
    tr: 'Olayın kesin takvim tarihi konusunda kaynaklar aynı değildir. TDV Mi‘rac maddesi, hicretten yaklaşık bir yıl önceki dönemi güçlü kabul edilen tarihsel çerçeve olarak aktarırken Rebîülevvel ve ramazan rivayetlerinin de bulunduğunu, çoğunluğun ise 27 Receb gecesini kutladığını belirtir. Bu nedenle uygulama 27 Receb’i kesin tarihsel gün diye sunmaz.',
    en: 'The sources do not agree on an exact calendar date for the event. The TDV Mi‘raj article presents the period roughly one year before the Hijra as a strongly transmitted historical frame, notes reports placing it in Rabi al-Awwal or Ramadan, and states that most Muslims commemorate it on 27 Rajab. The app therefore does not present 27 Rajab as an undisputed historical date.',
    ar: 'لا تتفق المصادر على تاريخ تقويمي قطعي للحادثة. وتعرض مادة المعراج في الموسوعة الإسلامية التركية الإطار التاريخي الأقوى بأنه قبل الهجرة بنحو سنة، مع وجود روايات في ربيع الأول ورمضان، بينما جرى عند جمهور المسلمين إحياؤها في ليلة 27 رجب. لذلك لا يعرض التطبيق 27 رجب كتاريخ تاريخي قطعي.',
  ),
  evidence: const [
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.quranBasis,
      text: LocalizedReligiousText(
        tr: 'İsrâ 17:1, kulunun gece Mescid-i Harâm’dan çevresi bereketli kılınan Mescid-i Aksâ’ya götürülmesini açıkça bildirir. Uygulama Kur’an’ın söylediği bu kısmı, sonraki tarih ve kutlama ayrıntılarından ayrı tutar.',
        en: 'Al-Isra 17:1 explicitly states the night journey of Allah’s servant from al-Masjid al-Haram to al-Masjid al-Aqsa, whose surroundings are blessed. The app keeps this Qur’anic statement distinct from later dating and commemoration details.',
        ar: 'تذكر سورة الإسراء 17:1 صراحة الإسراء بعبد الله ليلاً من المسجد الحرام إلى المسجد الأقصى الذي بورك حوله. ويفصل التطبيق هذا النص القرآني عن تفاصيل التأريخ والاحتفال اللاحقة.',
      ),
      certainty: CertaintyLevel.explicitSource,
      sources: [_quran171],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.hadithBasis,
      text: LocalizedReligiousText(
        tr: 'Sahih Müslim 162a, Mescid-i Aksâ’ya yolculuk ve ardından semalara yükseliş anlatısını sahih hadis katmanında aktarır. Hadis ayrıca namazların farz kılınması bağlamını içerir; uygulama metni yeni yorum veya kehanete dönüştürmez.',
        en: 'Sahih Muslim 162a reports the journey to al-Masjid al-Aqsa and the subsequent ascent through the heavens in the sound-hadith layer. It also contains the context of the prescribed prayers; the app does not turn the report into a new interpretation or omen.',
        ar: 'يروي صحيح مسلم 162a رحلة بيت المقدس ثم العروج في السماوات ضمن طبقة الحديث الصحيح، ويتضمن سياق فرض الصلوات. ولا يحول التطبيق الرواية إلى تفسير جديد أو دلالة غيبية شخصية.',
      ),
      certainty: CertaintyLevel.stronglyAttested,
      sources: [_muslim162a],
    ),
    ReligiousDayEvidenceSection(
      kind: ReligiousDayEvidenceKind.tradition,
      text: LocalizedReligiousText(
        tr: '27 Receb gecesinin “Miraç Kandili” olarak ihya edilmesi yaygın bir gelenektir; olayın kesin tarihine dair rivayetler farklı olduğundan bu tarih tarihsel kesinlik rozetiyle gösterilmez.',
        en: 'Commemorating the night of 27 Rajab as the night of Mi‘raj is a widespread tradition. Because reports about the event’s exact date differ, that date is not shown with a historical-certainty badge.',
        ar: 'إحياء ليلة 27 رجب بوصفها ليلة المعراج تقليد واسع الانتشار، لكن اختلاف الروايات في التاريخ الدقيق يمنع عرض هذا التاريخ على أنه يقين تاريخي.',
      ),
      certainty: CertaintyLevel.traditional,
      sources: [_tdvMiraj],
    ),
  ],
  specificWorshipStatus: SpecificWorshipStatus.noSpecificPracticeEstablished,
  reviewedEvidenceKinds: ReligiousDayContent.requiredReviewedEvidenceKinds,
);

const _title = LocalizedReligiousText(
  tr: 'Miraç Gecesi',
  en: 'Night of Isra and Mi‘raj',
  ar: 'ليلة الإسراء والمعراج',
);

const _quran171 = SourceReference(
  id: 'quran-17-1-isra',
  title: 'Qur’an — Al-Isra 17:1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'tanzil-uthmani-v1.1-cc-by-3.0',
  locator: '17:1',
);

const _muslim162a = SourceReference(
  id: 'muslim-162a-isra-miraj',
  title: 'Sahih Muslim 162a',
  sourceClass: ReligiousSourceClass.sahihHasanHadith,
  licenseId: 'reference-only-no-verbatim-translation-copied',
  locator: 'Book 1, Hadith 316',
);

const _tdvMiraj = SourceReference(
  id: 'tdv-islam-ansiklopedisi-mirac',
  title: 'TDV İslâm Ansiklopedisi — Mi‘rac',
  sourceClass: ReligiousSourceClass.laterTradition,
  licenseId: 'reference-only-no-verbatim-text-copied',
  locator: 'Mi‘rac maddesi — olayın tarihine ilişkin farklı rivayetler ve 27 Receb geleneği',
);
