import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';

void main() {
  const source = SourceReference(
    id: 'quran-source',
    title: 'Verified Qur\'an source',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'license-1',
  );

  test('published content requires all three languages and a source', () {
    final record = ReligiousContentRecord(
      id: 'verse-example',
      type: ContentType.quranVerse,
      sourceStatus: ReligiousSourceClass.quran,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.explicitSource,
      text: const LocalizedReligiousText(
        tr: 'Türkçe',
        en: 'English',
        ar: 'العربية',
      ),
      sources: const [source],
      lastReviewedAt: DateTime.utc(2026, 8, 27),
    );

    expect(record.canEnterProductionDataset, isTrue);
  });

  test('approved but not published content cannot enter production', () {
    final record = ReligiousContentRecord(
      id: 'history-example',
      type: ContentType.historyEvent,
      sourceStatus: ReligiousSourceClass.modernHistoryArchaeology,
      version: 1,
      reviewStatus: ContentReviewStatus.approved,
      certainty: CertaintyLevel.stronglyAttested,
      text: const LocalizedReligiousText(
        tr: 'Türkçe',
        en: 'English',
        ar: 'العربية',
      ),
      sources: const [source],
      lastReviewedAt: DateTime.utc(2026, 8, 27),
    );

    expect(record.canEnterProductionDataset, isFalse);
  });

  test('missing localization blocks production publication', () {
    final record = ReligiousContentRecord(
      id: 'dua-example',
      type: ContentType.dua,
      sourceStatus: ReligiousSourceClass.quran,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.explicitSource,
      text: const LocalizedReligiousText(tr: 'Türkçe', en: '', ar: 'العربية'),
      sources: const [source],
      lastReviewedAt: DateTime.utc(2026, 8, 27),
    );

    expect(record.canEnterProductionDataset, isFalse);
  });

  test('missing source blocks production publication', () {
    final record = ReligiousContentRecord(
      id: 'prophet-example',
      type: ContentType.prophetBiography,
      sourceStatus: ReligiousSourceClass.disputed,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.unknown,
      text: const LocalizedReligiousText(
        tr: 'Kesin tarih bilinmiyor.',
        en: 'The exact date is unknown.',
        ar: 'التاريخ الدقيق غير معروف.',
      ),
      sources: const [],
      lastReviewedAt: DateTime.utc(2026, 8, 27),
    );

    expect(record.canEnterProductionDataset, isFalse);
  });

  test('unknown source status blocks production publication', () {
    final record = ReligiousContentRecord(
      id: 'unknown-source-example',
      type: ContentType.editorial,
      sourceStatus: ReligiousSourceClass.unknown,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.unknown,
      text: const LocalizedReligiousText(
        tr: 'Türkçe',
        en: 'English',
        ar: 'العربية',
      ),
      sources: const [source],
      lastReviewedAt: DateTime.utc(2026, 8, 27),
    );

    expect(record.canEnterProductionDataset, isFalse);
  });

  test('source classes have stable serialization identifiers', () {
    expect(ReligiousSourceClass.israiliyat.stableId, 'israiliyat');
    expect(
      ReligiousSourceClass.modernHistoryArchaeology.stableId,
      'modern_history_archaeology',
    );
    expect(
      ReligiousSourceClass.ebcedHavasTradition.stableId,
      'ebced_havas_tradition',
    );
  });
}
