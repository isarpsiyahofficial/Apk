import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/quran_sura_name_metadata.dart';

void main() {
  test('contains exactly 114 ordered Tanzil sura names', () {
    validateCanonicalQuranSuraNames();
    expect(canonicalQuranSuraNames, hasLength(114));
    expect(canonicalQuranSuraNames.first.index, 1);
    expect(canonicalQuranSuraNames.first.arabicName, 'الفاتحة');
    expect(canonicalQuranSuraNames.first.transliteratedName, 'Al-Faatiha');
    expect(canonicalQuranSuraNames.last.index, 114);
    expect(canonicalQuranSuraNames.last.arabicName, 'الناس');
    expect(canonicalQuranSuraNames.last.transliteratedName, 'An-Naas');
  });

  test('lookup is fail-closed outside canonical sura range', () {
    expect(quranSuraName(2).transliteratedName, 'Al-Baqara');
    expect(() => quranSuraName(0), throwsRangeError);
    expect(() => quranSuraName(115), throwsRangeError);
  });
}
