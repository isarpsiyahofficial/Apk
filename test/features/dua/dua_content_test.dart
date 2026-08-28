import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';

const _text = LocalizedReligiousText(
  tr: 'Doğrulanmış dua metni',
  en: 'Verified dua text',
  ar: 'نص دعاء موثق',
);

SourceReference _source(ReligiousSourceClass sourceClass) => SourceReference(
  id: 'source-1',
  title: 'Verified source fixture',
  sourceClass: sourceClass,
  licenseId: 'test-license',
);

DuaContent _dua({
  required DuaSourceStatus status,
  required List<SourceReference> sources,
  String? hadithReference,
  String? hadithGrade,
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
}) => DuaContent(
  id: 'dua-1',
  sourceStatus: status,
  lengthClass: DuaLengthClass.short,
  text: _text,
  reviewStatus: reviewStatus,
  version: 1,
  lastReviewedAt: DateTime.utc(2026, 8, 28),
  sources: sources,
  hadithReference: hadithReference,
  hadithGrade: hadithGrade,
);

void main() {
  test('Quran dua requires Quran-class source', () {
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.quran)],
      ).canEnterProductionDataset,
      isTrue,
    );
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.classicalTraditional)],
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('sunnah dua requires reference, grade and sahih-hasan source class', () {
    expect(
      _dua(
        status: DuaSourceStatus.sahihHasanSunnah,
        sources: [_source(ReligiousSourceClass.sahihHasanHadith)],
        hadithReference: 'fixture:1',
        hadithGrade: 'sahih',
      ).canEnterProductionDataset,
      isTrue,
    );
    expect(
      _dua(
        status: DuaSourceStatus.sahihHasanSunnah,
        sources: [_source(ReligiousSourceClass.sahihHasanHadith)],
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('general editorial dua is explicitly disclaimer-bearing and never hadith', () {
    final dua = _dua(
      status: DuaSourceStatus.generalEditorial,
      sources: [_source(ReligiousSourceClass.meaningBasedDua)],
    );

    expect(dua.requiresEditorialDisclaimer, isTrue);
    expect(dua.requiresHadithMetadata, isFalse);
    expect(dua.canEnterProductionDataset, isTrue);
    expect(
      dua.toGovernedRecord().sourceStatus,
      ReligiousSourceClass.meaningBasedDua,
    );
  });

  test('unreviewed dua cannot enter production regardless of source', () {
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.quran)],
        reviewStatus: ContentReviewStatus.religiousReview,
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('classical-traditional dua cannot masquerade as Quran or sunnah', () {
    final dua = _dua(
      status: DuaSourceStatus.classicalTraditional,
      sources: [_source(ReligiousSourceClass.classicalTraditional)],
    );

    expect(dua.canEnterProductionDataset, isTrue);
    expect(
      dua.toGovernedRecord().sourceStatus,
      ReligiousSourceClass.classicalTraditional,
    );
  });
}
