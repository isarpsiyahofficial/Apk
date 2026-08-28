import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/data/ebced_value.dart';

void main() {
  SourceReference quranSource() => const SourceReference(
        id: 'quran:example:1',
        title: 'Pinned Quran source',
        sourceClass: ReligiousSourceClass.quran,
        licenseId: 'quran-license',
        locator: 'surah:ayah',
      );

  SourceReference traditionalSource() => const SourceReference(
        id: 'tradition:example:1',
        title: 'Traditional reference',
        sourceClass: ReligiousSourceClass.laterTradition,
        licenseId: 'reference-license',
        locator: 'section 1',
      );

  SourceReference ebcedSource() => const SourceReference(
        id: 'ebced:example:1',
        title: 'Reviewed ebced reference',
        sourceClass: ReligiousSourceClass.ebcedHavasTradition,
        licenseId: 'reference-license',
        locator: 'entry 1',
      );

  EbcedValueMetadata ebced({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) => EbcedValueMetadata(
        value: 308,
        source: ebcedSource(),
        reviewStatus: reviewStatus,
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 8, 28),
      );

  DivineNameEntry entry({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
    List<SourceReference>? sources,
    EbcedValueMetadata? ebcedValue,
  }) => DivineNameEntry(
        id: 'esma:test:1',
        arabic: 'اسم عربي تجريبي',
        transliterationTr: 'Kaynak inceleme örneği',
        transliterationEn: 'Source review example',
        meaning: const LocalizedReligiousText(
          tr: 'İnceleme amaçlı anlam.',
          en: 'Meaning used for review testing.',
          ar: 'معنى مخصص لاختبار المراجعة.',
        ),
        whyRecited: const LocalizedReligiousText(
          tr: 'Yalnız kaynak bağlantısı davranışını test eder.',
          en: 'Only tests source-link behavior.',
          ar: 'يختبر سلوك ربط المصدر فقط.',
        ),
        sources: sources ?? [quranSource()],
        reviewStatus: reviewStatus,
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 8, 28),
        ebced: ebcedValue,
      );

  test('published entry with Quran link enters governed divine-name dataset', () {
    final value = entry();

    expect(value.canEnterProductionDataset, isTrue);
    final governed = value.toGovernedRecord();
    expect(governed.type, ContentType.divineName);
    expect(governed.sourceStatus, ReligiousSourceClass.quran);
    expect(governed.certainty, CertaintyLevel.explicitSource);
  });

  test('language or religious review not completed remains fail-closed', () {
    final value = entry(reviewStatus: ContentReviewStatus.languageReview);

    expect(value.canEnterProductionDataset, isFalse);
    expect(value.toGovernedRecord, throwsStateError);
  });

  test('traditional-only reference cannot masquerade as Quran or hadith link', () {
    final value = entry(sources: [traditionalSource()]);

    expect(value.hasPrimaryReligiousLink, isFalse);
    expect(value.canEnterProductionDataset, isFalse);
    expect(value.toGovernedRecord, throwsStateError);
  });

  test('invalid source metadata is rejected at construction', () {
    expect(
      () => entry(
        sources: const [
          SourceReference(
            id: 'quran:test',
            title: 'Source',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: '',
            locator: '1:1',
          ),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('reviewed ebced stays separate from governed religious source', () {
    final value = entry(ebcedValue: ebced());

    expect(value.canEnterProductionDataset, isTrue);
    expect(value.publishedEbced?.value, 308);
    expect(
      value.publishedEbced?.source.sourceClass,
      ReligiousSourceClass.ebcedHavasTradition,
    );
    expect(value.toGovernedRecord().sourceStatus, ReligiousSourceClass.quran);
  });

  test('unreviewed ebced is hidden without suppressing reviewed Esma core', () {
    final value = entry(
      ebcedValue: ebced(reviewStatus: ContentReviewStatus.religiousReview),
    );

    expect(value.canEnterProductionDataset, isTrue);
    expect(value.publishedEbced, isNull);
  });

  test('ebced cannot use Quran or hadith source class', () {
    expect(
      () => EbcedValueMetadata(
        value: 308,
        source: quranSource(),
        reviewStatus: ContentReviewStatus.published,
        version: 1,
        lastReviewedAt: DateTime.utc(2026, 8, 28),
      ),
      throwsArgumentError,
    );
  });
}
