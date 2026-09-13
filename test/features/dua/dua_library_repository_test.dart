import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';

SourceReference _source() => const SourceReference(
      id: 'quran-fixture',
      title: 'Quran fixture',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'fixture-license',
    );

DuaContent _dua({
  required String id,
  required LocalizedReligiousText text,
  required Set<DuaCategory> categories,
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
}) => DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: categories,
      text: text,
      reviewStatus: reviewStatus,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 28),
      sources: [_source()],
    );

void main() {
  final morning = _dua(
    id: 'dua-morning',
    text: const LocalizedReligiousText(
      tr: 'Rabbimiz bize iyilik ver',
      en: 'Our Lord grant us goodness',
      ar: 'ربنا آتنا خيرا',
    ),
    categories: const {DuaCategory.morning, DuaCategory.gratitude},
  );
  final patience = _dua(
    id: 'dua-patience',
    text: const LocalizedReligiousText(
      tr: 'Rabbimiz üzerimize sabır yağdır',
      en: 'Our Lord pour patience upon us',
      ar: 'ربنا أفرغ علينا صبرا',
    ),
    categories: const {DuaCategory.patience, DuaCategory.distress},
  );

  test('search uses only requested locale and supports category filter', () {
    final repository = DuaLibraryRepository([morning, patience]);

    expect(
      repository.search(query: 'sabır', languageCode: 'tr').single.id,
      'dua-patience',
    );
    expect(
      repository.search(query: 'goodness', languageCode: 'en').single.id,
      'dua-morning',
    );
    expect(
      repository.search(
        query: '',
        languageCode: 'tr',
        category: DuaCategory.gratitude,
      ).single.id,
      'dua-morning',
    );
  });

  test('Arabic search tolerates harakat and alif variants without mutating text', () {
    final repository = DuaLibraryRepository([morning, patience]);
    final original = patience.text.ar;

    expect(
      repository.search(query: 'رَبَّنَا', languageCode: 'ar').length,
      2,
    );
    expect(patience.text.ar, original);
  });

  test('unsupported locale fails closed', () {
    final repository = DuaLibraryRepository([morning]);

    expect(
      () => repository.search(query: 'x', languageCode: 'de'),
      throwsUnsupportedError,
    );
  });

  test('non-production record rejects the whole library', () {
    final researchOnly = _dua(
      id: 'research-only',
      text: const LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR'),
      categories: const {DuaCategory.morning},
      reviewStatus: ContentReviewStatus.research,
    );

    expect(
      () => DuaLibraryRepository([morning, researchOnly]),
      throwsStateError,
    );
  });

  test('duplicate content ids reject the whole library', () {
    expect(
      () => DuaLibraryRepository([morning, morning]),
      throwsStateError,
    );
  });
}
