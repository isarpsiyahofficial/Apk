import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

/// Verified Quran structural metadata derived from Tanzil Quran Metadata v1.0.
///
/// Source: https://tanzil.net/res/text/metadata/quran-data.xml
/// License: Creative Commons Attribution 3.0 (CC BY 3.0).
///
/// These entries are structural pointers only. They never modify the canonical
/// Quran text and are validated against the canonical 114-sura / 6236-ayah
/// contract before use.
final class QuranJuzStart {
  const QuranJuzStart({
    required this.juz,
    required this.surah,
    required this.ayah,
  });

  final int juz;
  final int surah;
  final int ayah;
}

const String quranMetadataSourceName = 'Tanzil Quran Metadata';
const String quranMetadataVersion = '1.0';
const String quranMetadataSourceUrl =
    'https://tanzil.net/res/text/metadata/quran-data.xml';
const String quranMetadataLicense = 'CC BY 3.0';

const List<QuranJuzStart> canonicalQuranJuzStarts = [
  QuranJuzStart(juz: 1, surah: 1, ayah: 1),
  QuranJuzStart(juz: 2, surah: 2, ayah: 142),
  QuranJuzStart(juz: 3, surah: 2, ayah: 253),
  QuranJuzStart(juz: 4, surah: 3, ayah: 93),
  QuranJuzStart(juz: 5, surah: 4, ayah: 24),
  QuranJuzStart(juz: 6, surah: 4, ayah: 148),
  QuranJuzStart(juz: 7, surah: 5, ayah: 82),
  QuranJuzStart(juz: 8, surah: 6, ayah: 111),
  QuranJuzStart(juz: 9, surah: 7, ayah: 88),
  QuranJuzStart(juz: 10, surah: 8, ayah: 41),
  QuranJuzStart(juz: 11, surah: 9, ayah: 93),
  QuranJuzStart(juz: 12, surah: 11, ayah: 6),
  QuranJuzStart(juz: 13, surah: 12, ayah: 53),
  QuranJuzStart(juz: 14, surah: 15, ayah: 1),
  QuranJuzStart(juz: 15, surah: 17, ayah: 1),
  QuranJuzStart(juz: 16, surah: 18, ayah: 75),
  QuranJuzStart(juz: 17, surah: 21, ayah: 1),
  QuranJuzStart(juz: 18, surah: 23, ayah: 1),
  QuranJuzStart(juz: 19, surah: 25, ayah: 21),
  QuranJuzStart(juz: 20, surah: 27, ayah: 56),
  QuranJuzStart(juz: 21, surah: 29, ayah: 46),
  QuranJuzStart(juz: 22, surah: 33, ayah: 31),
  QuranJuzStart(juz: 23, surah: 36, ayah: 28),
  QuranJuzStart(juz: 24, surah: 39, ayah: 32),
  QuranJuzStart(juz: 25, surah: 41, ayah: 47),
  QuranJuzStart(juz: 26, surah: 46, ayah: 1),
  QuranJuzStart(juz: 27, surah: 51, ayah: 31),
  QuranJuzStart(juz: 28, surah: 58, ayah: 1),
  QuranJuzStart(juz: 29, surah: 67, ayah: 1),
  QuranJuzStart(juz: 30, surah: 78, ayah: 1),
];

QuranJuzStart quranJuzStart(int juz) {
  if (juz < 1 || juz > canonicalQuranJuzStarts.length) {
    throw RangeError.range(juz, 1, canonicalQuranJuzStarts.length, 'juz');
  }
  return canonicalQuranJuzStarts[juz - 1];
}

int quranJuzForPosition({required int surah, required int ayah}) {
  if (surah < 1 || surah > canonicalQuranSuraCount) {
    throw RangeError.range(surah, 1, canonicalQuranSuraCount, 'surah');
  }
  final maxAyah = canonicalQuranAyahCountForSura(surah);
  if (ayah < 1 || ayah > maxAyah) {
    throw RangeError.range(ayah, 1, maxAyah, 'ayah');
  }

  var activeJuz = 1;
  for (final start in canonicalQuranJuzStarts) {
    final beginsBeforeOrAt = start.surah < surah ||
        (start.surah == surah && start.ayah <= ayah);
    if (!beginsBeforeOrAt) break;
    activeJuz = start.juz;
  }
  return activeJuz;
}

void validateCanonicalQuranJuzMetadata() {
  if (canonicalQuranJuzStarts.length != 30) {
    throw StateError('Canonical Quran metadata must contain exactly 30 juz');
  }

  QuranJuzStart? previous;
  for (final start in canonicalQuranJuzStarts) {
    if (start.juz < 1 || start.juz > 30) {
      throw StateError('Invalid juz index ${start.juz}');
    }
    if (start.surah < 1 || start.surah > canonicalQuranSuraCount) {
      throw StateError('Invalid surah ${start.surah} for juz ${start.juz}');
    }
    final maxAyah = canonicalQuranAyahCountForSura(start.surah);
    if (start.ayah < 1 || start.ayah > maxAyah) {
      throw StateError('Invalid ayah ${start.ayah} for juz ${start.juz}');
    }
    if (previous != null) {
      final strictlyLater = start.surah > previous.surah ||
          (start.surah == previous.surah && start.ayah > previous.ayah);
      if (!strictlyLater) {
        throw StateError('Juz starts must be strictly increasing');
      }
    }
    previous = start;
  }

  const first = QuranJuzStart(juz: 1, surah: 1, ayah: 1);
  const last = QuranJuzStart(juz: 30, surah: 78, ayah: 1);
  final actualFirst = canonicalQuranJuzStarts.first;
  final actualLast = canonicalQuranJuzStarts.last;
  if (actualFirst.juz != first.juz ||
      actualFirst.surah != first.surah ||
      actualFirst.ayah != first.ayah ||
      actualLast.juz != last.juz ||
      actualLast.surah != last.surah ||
      actualLast.ayah != last.ayah) {
    throw StateError('Canonical Quran juz boundary anchors are invalid');
  }
}
