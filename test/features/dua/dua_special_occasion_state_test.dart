import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/dua/data/dua_special_occasion_state.dart';

SourceReference _source(ReligiousSourceClass sourceClass) => SourceReference(
      id: 'fixture-${sourceClass.name}',
      title: 'Fixture source',
      sourceClass: sourceClass,
      licenseId: 'fixture-license',
    );

DuaContent _dua({
  required String id,
  required DuaSourceStatus status,
  required DuaCategory category,
}) {
  final sourceClass = switch (status) {
    DuaSourceStatus.quran => ReligiousSourceClass.quran,
    DuaSourceStatus.sahihHasanSunnah => ReligiousSourceClass.sahihHasanHadith,
    DuaSourceStatus.classicalTraditional =>
      ReligiousSourceClass.classicalTraditional,
    DuaSourceStatus.generalEditorial => ReligiousSourceClass.meaningBasedDua,
  };

  return DuaContent(
    id: id,
    sourceStatus: status,
    lengthClass: DuaLengthClass.short,
    categories: {category},
    text: const LocalizedReligiousText(
      tr: 'Doğrulanmış test duası',
      en: 'Verified test dua',
      ar: 'دعاء اختبار موثّق',
    ),
    reviewStatus: ContentReviewStatus.published,
    version: 1,
    lastReviewedAt: DateTime.utc(2026, 8, 28),
    sources: [_source(sourceClass)],
    hadithReference:
        status == DuaSourceStatus.sahihHasanSunnah ? 'Fixture 1' : null,
    hadithGrade:
        status == DuaSourceStatus.sahihHasanSunnah ? 'sahih' : null,
  );
}

void main() {
  test('reports authenticated special dua only when verified library has one', () {
    final library = DuaLibraryRepository([
      _dua(
        id: 'eid-sunnah',
        status: DuaSourceStatus.sahihHasanSunnah,
        category: DuaCategory.eid,
      ),
      _dua(
        id: 'eid-editorial',
        status: DuaSourceStatus.generalEditorial,
        category: DuaCategory.eid,
      ),
    ]);

    final state = DuaSpecialOccasionEvaluator.evaluate(
      library: library,
      category: DuaCategory.eid,
    );

    expect(state.hasAuthenticatedSpecialDua, isTrue);
    expect(state.shouldShowNoAuthenticatedSpecialDuaNotice, isFalse);
    expect(state.authenticatedSpecialDuas.single.id, 'eid-sunnah');
    expect(state.otherVerifiedDuas.single.id, 'eid-editorial');
  });

  test('empty authenticated set becomes an explicit honest absence state', () {
    final library = DuaLibraryRepository([
      _dua(
        id: 'night-traditional',
        status: DuaSourceStatus.classicalTraditional,
        category: DuaCategory.religiousNights,
      ),
    ]);

    final state = DuaSpecialOccasionEvaluator.evaluate(
      library: library,
      category: DuaCategory.religiousNights,
    );

    expect(state.hasAuthenticatedSpecialDua, isFalse);
    expect(state.shouldShowNoAuthenticatedSpecialDuaNotice, isTrue);
    expect(state.authenticatedSpecialDuas, isEmpty);
    expect(state.otherVerifiedDuas.single.id, 'night-traditional');
  });

  test('no records also stays honest instead of inventing a special dua', () {
    final state = DuaSpecialOccasionEvaluator.evaluate(
      library: DuaLibraryRepository(const []),
      category: DuaCategory.friday,
    );

    expect(state.shouldShowNoAuthenticatedSpecialDuaNotice, isTrue);
    expect(state.authenticatedSpecialDuas, isEmpty);
    expect(state.otherVerifiedDuas, isEmpty);
  });

  test('non-occasion categories are rejected instead of overgeneralized', () {
    expect(
      () => DuaSpecialOccasionEvaluator.evaluate(
        library: DuaLibraryRepository(const []),
        category: DuaCategory.debt,
      ),
      throwsArgumentError,
    );
  });
}
