enum ContentType {
  quranVerse,
  translation,
  dua,
  dhikr,
  divineName,
  religiousDay,
  prophetBiography,
  historyEvent,
  editorial,
}

enum ContentReviewStatus {
  draft,
  research,
  religiousReview,
  languageReview,
  approved,
  published,
  withdrawn,
}

enum ReligiousSourceClass {
  quran,
  sahihHasanHadith,
  earlyIslamicHistoryTafsir,
  meaningBasedDua,
  classicalTraditional,
  israiliyat,
  laterTradition,
  modernHistoryArchaeology,
  ebcedHavasTradition,
  disputed,
  unknown,
}

enum CertaintyLevel {
  explicitSource,
  stronglyAttested,
  approximate,
  traditional,
  disputed,
  unknown,
}

class SourceReference {
  const SourceReference({
    required this.id,
    required this.title,
    required this.sourceClass,
    required this.licenseId,
    this.locator,
    this.url,
  });

  final String id;
  final String title;
  final ReligiousSourceClass sourceClass;
  final String licenseId;
  final String? locator;
  final Uri? url;
}

class LocalizedReligiousText {
  const LocalizedReligiousText({
    required this.tr,
    required this.en,
    required this.ar,
  });

  final String tr;
  final String en;
  final String ar;

  bool get isComplete =>
      tr.trim().isNotEmpty && en.trim().isNotEmpty && ar.trim().isNotEmpty;
}

class ReligiousContentRecord {
  const ReligiousContentRecord({
    required this.id,
    required this.type,
    required this.sourceStatus,
    required this.version,
    required this.reviewStatus,
    required this.certainty,
    required this.text,
    required this.sources,
    required this.lastReviewedAt,
    this.reviewer,
  });

  final String id;
  final ContentType type;
  final ReligiousSourceClass sourceStatus;
  final int version;
  final ContentReviewStatus reviewStatus;
  final CertaintyLevel certainty;
  final LocalizedReligiousText text;
  final List<SourceReference> sources;
  final DateTime lastReviewedAt;
  final String? reviewer;

  bool get canEnterProductionDataset =>
      id.trim().isNotEmpty &&
      reviewStatus == ContentReviewStatus.published &&
      sourceStatus != ReligiousSourceClass.unknown &&
      text.isComplete &&
      sources.isNotEmpty &&
      version > 0;
}

extension ReligiousSourceClassLabel on ReligiousSourceClass {
  String get stableId => switch (this) {
        ReligiousSourceClass.quran => 'quran',
        ReligiousSourceClass.sahihHasanHadith => 'sahih_hasan_hadith',
        ReligiousSourceClass.earlyIslamicHistoryTafsir =>
          'early_islamic_history_tafsir',
        ReligiousSourceClass.meaningBasedDua => 'meaning_based_dua',
        ReligiousSourceClass.classicalTraditional => 'classical_traditional',
        ReligiousSourceClass.israiliyat => 'israiliyat',
        ReligiousSourceClass.laterTradition => 'later_tradition',
        ReligiousSourceClass.modernHistoryArchaeology =>
          'modern_history_archaeology',
        ReligiousSourceClass.ebcedHavasTradition => 'ebced_havas_tradition',
        ReligiousSourceClass.disputed => 'disputed',
        ReligiousSourceClass.unknown => 'unknown',
      };
}
