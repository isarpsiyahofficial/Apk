import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';

const _text = LocalizedReligiousText(
  tr: 'Doğrulanmış dua metni',
  en: 'Verified dua text',
  ar: 'نص دعاء موثق',
);

const _disputeNote = LocalizedReligiousText(
  tr: 'Kaynak değerlendirmesinde görüş farklılığı vardır.',
  en: 'There is a difference of assessment regarding the source.',
  ar: 'يوجد اختلاف في تقييم المصدر.',
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
  Set<DuaCategory> categories = const {DuaCategory.morning},
  String? hadithReference,
  String? hadithGrade,
  bool hasSourceDispute = false,
  LocalizedReligiousText? disputeNote,
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
}) => DuaContent(
  id: 'dua-1',
  sourceStatus: status,
  lengthClass: DuaLengthClass.short,
  categories: categories,
  text: _text,
  reviewStatus: reviewStatus,
  version: 1,
  lastReviewedAt: DateTime.utc(2026, 8, 28),
  sources: sources,
  hadithReference: hadithReference,
  hadithGrade: hadithGrade,
  hasSourceDispute: hasSourceDispute,
  disputeNote: disputeNote,
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

  test('non-hadith dua cannot carry hadith metadata', () {
    final quranDua = _dua(
      status: DuaSourceStatus.quran,
      sources: [_source(ReligiousSourceClass.quran)],
      hadithReference: 'must-not-be-here',
      hadithGrade: 'sahih',
    );

    expect(quranDua.canEnterProductionDataset, isFalse);
  });

  test('general editorial dua is explicitly disclaimer-bearing and never hadith', () {
    final dua = _dua(
      status: DuaSourceStatus.generalEditorial,
      sources: [_source(ReligiousSourceClass.meaningBasedDua)],
    );

    expect(dua.requiresEditorialDisclaimer, isTrue);
    expect(dua.requiresHadithMetadata, isFalse);
    expect(dua.disclosure, DuaSourceDisclosure.generalEditorial);
    expect(dua.canEnterProductionDataset, isTrue);
    expect(
      dua.toGovernedRecord().sourceStatus,
      ReligiousSourceClass.meaningBasedDua,
    );
  });

  test('source dispute requires complete TR EN AR disclosure note', () {
    final missingNote = _dua(
      status: DuaSourceStatus.classicalTraditional,
      sources: [_source(ReligiousSourceClass.classicalTraditional)],
      hasSourceDispute: true,
    );
    const incompleteNote = LocalizedReligiousText(
      tr: 'Görüş farklılığı vardır.',
      en: 'There is a difference of assessment.',
      ar: '',
    );
    final partial = _dua(
      status: DuaSourceStatus.classicalTraditional,
      sources: [_source(ReligiousSourceClass.classicalTraditional)],
      hasSourceDispute: true,
      disputeNote: incompleteNote,
    );
    final complete = _dua(
      status: DuaSourceStatus.classicalTraditional,
      sources: [_source(ReligiousSourceClass.classicalTraditional)],
      hasSourceDispute: true,
      disputeNote: _disputeNote,
    );

    expect(missingNote.canEnterProductionDataset, isFalse);
    expect(partial.canEnterProductionDataset, isFalse);
    expect(complete.canEnterProductionDataset, isTrue);
  });

  test('even optional dispute note must be complete if supplied', () {
    const incompleteNote = LocalizedReligiousText(
      tr: 'Not',
      en: '',
      ar: 'ملاحظة',
    );
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.quran)],
        disputeNote: incompleteNote,
      ).canEnterProductionDataset,
      isFalse,
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
    expect(dua.disclosure, DuaSourceDisclosure.classicalTraditional);
    expect(
      dua.toGovernedRecord().sourceStatus,
      ReligiousSourceClass.classicalTraditional,
    );
  });

  test('dua must have at least one explicit category before publication', () {
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.quran)],
        categories: const {},
      ).canEnterProductionDataset,
      isFalse,
    );
  });

  test('SPEC 238 category taxonomy stays complete', () {
    expect(DuaCategory.values, hasLength(24));
    expect(DuaCategory.values, contains(DuaCategory.religiousNights));
    expect(
      DuaCategory.values,
      contains(DuaCategory.spiritualSupportDuringIllness),
    );
    expect(DuaCategory.values, contains(DuaCategory.debt));
  });

  test('all four source statuses map to distinct disclosure semantics', () {
    expect(
      _dua(
        status: DuaSourceStatus.quran,
        sources: [_source(ReligiousSourceClass.quran)],
      ).disclosure,
      DuaSourceDisclosure.quran,
    );
    expect(
      _dua(
        status: DuaSourceStatus.sahihHasanSunnah,
        sources: [_source(ReligiousSourceClass.sahihHasanHadith)],
        hadithReference: 'fixture:1',
        hadithGrade: 'hasan',
      ).disclosure,
      DuaSourceDisclosure.authenticatedSunnah,
    );
  });
}
