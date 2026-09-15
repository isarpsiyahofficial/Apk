import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

/// Canonical sura names transcribed from Tanzil Quran Metadata v1.0.
///
/// Upstream: https://tanzil.net/res/text/metadata/quran-data.xml
/// Documentation: https://tanzil.net/docs/Quran_Metadata
/// License: CC BY 3.0.
///
/// This metadata is search/navigation-only and never alters Quran source text.
final class QuranSuraNameMetadata {
  const QuranSuraNameMetadata({
    required this.index,
    required this.arabicName,
    required this.transliteratedName,
  });

  final int index;
  final String arabicName;
  final String transliteratedName;

  String displayNameForLocale(String languageCode) =>
      languageCode == 'ar' ? arabicName : transliteratedName;
}

const List<QuranSuraNameMetadata> canonicalQuranSuraNames = [
  QuranSuraNameMetadata(index: 1, arabicName: 'الفاتحة', transliteratedName: 'Al-Faatiha'),
  QuranSuraNameMetadata(index: 2, arabicName: 'البقرة', transliteratedName: 'Al-Baqara'),
  QuranSuraNameMetadata(index: 3, arabicName: 'آل عمران', transliteratedName: 'Aal-i-Imraan'),
  QuranSuraNameMetadata(index: 4, arabicName: 'النساء', transliteratedName: 'An-Nisaa'),
  QuranSuraNameMetadata(index: 5, arabicName: 'المائدة', transliteratedName: 'Al-Maaida'),
  QuranSuraNameMetadata(index: 6, arabicName: 'الأنعام', transliteratedName: "Al-An'aam"),
  QuranSuraNameMetadata(index: 7, arabicName: 'الأعراف', transliteratedName: "Al-A'raaf"),
  QuranSuraNameMetadata(index: 8, arabicName: 'الأنفال', transliteratedName: 'Al-Anfaal'),
  QuranSuraNameMetadata(index: 9, arabicName: 'التوبة', transliteratedName: 'At-Tawba'),
  QuranSuraNameMetadata(index: 10, arabicName: 'يونس', transliteratedName: 'Yunus'),
  QuranSuraNameMetadata(index: 11, arabicName: 'هود', transliteratedName: 'Hud'),
  QuranSuraNameMetadata(index: 12, arabicName: 'يوسف', transliteratedName: 'Yusuf'),
  QuranSuraNameMetadata(index: 13, arabicName: 'الرعد', transliteratedName: "Ar-Ra'd"),
  QuranSuraNameMetadata(index: 14, arabicName: 'ابراهيم', transliteratedName: 'Ibrahim'),
  QuranSuraNameMetadata(index: 15, arabicName: 'الحجر', transliteratedName: 'Al-Hijr'),
  QuranSuraNameMetadata(index: 16, arabicName: 'النحل', transliteratedName: 'An-Nahl'),
  QuranSuraNameMetadata(index: 17, arabicName: 'الإسراء', transliteratedName: 'Al-Israa'),
  QuranSuraNameMetadata(index: 18, arabicName: 'الكهف', transliteratedName: 'Al-Kahf'),
  QuranSuraNameMetadata(index: 19, arabicName: 'مريم', transliteratedName: 'Maryam'),
  QuranSuraNameMetadata(index: 20, arabicName: 'طه', transliteratedName: 'Taa-Haa'),
  QuranSuraNameMetadata(index: 21, arabicName: 'الأنبياء', transliteratedName: 'Al-Anbiyaa'),
  QuranSuraNameMetadata(index: 22, arabicName: 'الحج', transliteratedName: 'Al-Hajj'),
  QuranSuraNameMetadata(index: 23, arabicName: 'المؤمنون', transliteratedName: 'Al-Muminoon'),
  QuranSuraNameMetadata(index: 24, arabicName: 'النور', transliteratedName: 'An-Noor'),
  QuranSuraNameMetadata(index: 25, arabicName: 'الفرقان', transliteratedName: 'Al-Furqaan'),
  QuranSuraNameMetadata(index: 26, arabicName: 'الشعراء', transliteratedName: "Ash-Shu'araa"),
  QuranSuraNameMetadata(index: 27, arabicName: 'النمل', transliteratedName: 'An-Naml'),
  QuranSuraNameMetadata(index: 28, arabicName: 'القصص', transliteratedName: 'Al-Qasas'),
  QuranSuraNameMetadata(index: 29, arabicName: 'العنكبوت', transliteratedName: 'Al-Ankaboot'),
  QuranSuraNameMetadata(index: 30, arabicName: 'الروم', transliteratedName: 'Ar-Room'),
  QuranSuraNameMetadata(index: 31, arabicName: 'لقمان', transliteratedName: 'Luqman'),
  QuranSuraNameMetadata(index: 32, arabicName: 'السجدة', transliteratedName: 'As-Sajda'),
  QuranSuraNameMetadata(index: 33, arabicName: 'الأحزاب', transliteratedName: 'Al-Ahzaab'),
  QuranSuraNameMetadata(index: 34, arabicName: 'سبإ', transliteratedName: 'Saba'),
  QuranSuraNameMetadata(index: 35, arabicName: 'فاطر', transliteratedName: 'Faatir'),
  QuranSuraNameMetadata(index: 36, arabicName: 'يس', transliteratedName: 'Yaseen'),
  QuranSuraNameMetadata(index: 37, arabicName: 'الصافات', transliteratedName: 'As-Saaffaat'),
  QuranSuraNameMetadata(index: 38, arabicName: 'ص', transliteratedName: 'Saad'),
  QuranSuraNameMetadata(index: 39, arabicName: 'الزمر', transliteratedName: 'Az-Zumar'),
  QuranSuraNameMetadata(index: 40, arabicName: 'غافر', transliteratedName: 'Al-Ghaafir'),
  QuranSuraNameMetadata(index: 41, arabicName: 'فصلت', transliteratedName: 'Fussilat'),
  QuranSuraNameMetadata(index: 42, arabicName: 'الشورى', transliteratedName: 'Ash-Shura'),
  QuranSuraNameMetadata(index: 43, arabicName: 'الزخرف', transliteratedName: 'Az-Zukhruf'),
  QuranSuraNameMetadata(index: 44, arabicName: 'الدخان', transliteratedName: 'Ad-Dukhaan'),
  QuranSuraNameMetadata(index: 45, arabicName: 'الجاثية', transliteratedName: 'Al-Jaathiya'),
  QuranSuraNameMetadata(index: 46, arabicName: 'الأحقاف', transliteratedName: 'Al-Ahqaf'),
  QuranSuraNameMetadata(index: 47, arabicName: 'محمد', transliteratedName: 'Muhammad'),
  QuranSuraNameMetadata(index: 48, arabicName: 'الفتح', transliteratedName: 'Al-Fath'),
  QuranSuraNameMetadata(index: 49, arabicName: 'الحجرات', transliteratedName: 'Al-Hujuraat'),
  QuranSuraNameMetadata(index: 50, arabicName: 'ق', transliteratedName: 'Qaaf'),
  QuranSuraNameMetadata(index: 51, arabicName: 'الذاريات', transliteratedName: 'Adh-Dhaariyat'),
  QuranSuraNameMetadata(index: 52, arabicName: 'الطور', transliteratedName: 'At-Tur'),
  QuranSuraNameMetadata(index: 53, arabicName: 'النجم', transliteratedName: 'An-Najm'),
  QuranSuraNameMetadata(index: 54, arabicName: 'القمر', transliteratedName: 'Al-Qamar'),
  QuranSuraNameMetadata(index: 55, arabicName: 'الرحمن', transliteratedName: 'Ar-Rahmaan'),
  QuranSuraNameMetadata(index: 56, arabicName: 'الواقعة', transliteratedName: 'Al-Waaqia'),
  QuranSuraNameMetadata(index: 57, arabicName: 'الحديد', transliteratedName: 'Al-Hadid'),
  QuranSuraNameMetadata(index: 58, arabicName: 'المجادلة', transliteratedName: 'Al-Mujaadila'),
  QuranSuraNameMetadata(index: 59, arabicName: 'الحشر', transliteratedName: 'Al-Hashr'),
  QuranSuraNameMetadata(index: 60, arabicName: 'الممتحنة', transliteratedName: 'Al-Mumtahana'),
  QuranSuraNameMetadata(index: 61, arabicName: 'الصف', transliteratedName: 'As-Saff'),
  QuranSuraNameMetadata(index: 62, arabicName: 'الجمعة', transliteratedName: "Al-Jumu'a"),
  QuranSuraNameMetadata(index: 63, arabicName: 'المنافقون', transliteratedName: 'Al-Munaafiqoon'),
  QuranSuraNameMetadata(index: 64, arabicName: 'التغابن', transliteratedName: 'At-Taghaabun'),
  QuranSuraNameMetadata(index: 65, arabicName: 'الطلاق', transliteratedName: 'At-Talaaq'),
  QuranSuraNameMetadata(index: 66, arabicName: 'التحريم', transliteratedName: 'At-Tahrim'),
  QuranSuraNameMetadata(index: 67, arabicName: 'الملك', transliteratedName: 'Al-Mulk'),
  QuranSuraNameMetadata(index: 68, arabicName: 'القلم', transliteratedName: 'Al-Qalam'),
  QuranSuraNameMetadata(index: 69, arabicName: 'الحاقة', transliteratedName: 'Al-Haaqqa'),
  QuranSuraNameMetadata(index: 70, arabicName: 'المعارج', transliteratedName: "Al-Ma'aarij"),
  QuranSuraNameMetadata(index: 71, arabicName: 'نوح', transliteratedName: 'Nooh'),
  QuranSuraNameMetadata(index: 72, arabicName: 'الجن', transliteratedName: 'Al-Jinn'),
  QuranSuraNameMetadata(index: 73, arabicName: 'المزمل', transliteratedName: 'Al-Muzzammil'),
  QuranSuraNameMetadata(index: 74, arabicName: 'المدثر', transliteratedName: 'Al-Muddaththir'),
  QuranSuraNameMetadata(index: 75, arabicName: 'القيامة', transliteratedName: 'Al-Qiyaama'),
  QuranSuraNameMetadata(index: 76, arabicName: 'الانسان', transliteratedName: 'Al-Insaan'),
  QuranSuraNameMetadata(index: 77, arabicName: 'المرسلات', transliteratedName: 'Al-Mursalaat'),
  QuranSuraNameMetadata(index: 78, arabicName: 'النبإ', transliteratedName: 'An-Naba'),
  QuranSuraNameMetadata(index: 79, arabicName: 'النازعات', transliteratedName: "An-Naazi'aat"),
  QuranSuraNameMetadata(index: 80, arabicName: 'عبس', transliteratedName: 'Abasa'),
  QuranSuraNameMetadata(index: 81, arabicName: 'التكوير', transliteratedName: 'At-Takwir'),
  QuranSuraNameMetadata(index: 82, arabicName: 'الإنفطار', transliteratedName: 'Al-Infitaar'),
  QuranSuraNameMetadata(index: 83, arabicName: 'المطففين', transliteratedName: 'Al-Mutaffifin'),
  QuranSuraNameMetadata(index: 84, arabicName: 'الإنشقاق', transliteratedName: 'Al-Inshiqaaq'),
  QuranSuraNameMetadata(index: 85, arabicName: 'البروج', transliteratedName: 'Al-Burooj'),
  QuranSuraNameMetadata(index: 86, arabicName: 'الطارق', transliteratedName: 'At-Taariq'),
  QuranSuraNameMetadata(index: 87, arabicName: 'الأعلى', transliteratedName: "Al-A'laa"),
  QuranSuraNameMetadata(index: 88, arabicName: 'الغاشية', transliteratedName: 'Al-Ghaashiya'),
  QuranSuraNameMetadata(index: 89, arabicName: 'الفجر', transliteratedName: 'Al-Fajr'),
  QuranSuraNameMetadata(index: 90, arabicName: 'البلد', transliteratedName: 'Al-Balad'),
  QuranSuraNameMetadata(index: 91, arabicName: 'الشمس', transliteratedName: 'Ash-Shams'),
  QuranSuraNameMetadata(index: 92, arabicName: 'الليل', transliteratedName: 'Al-Lail'),
  QuranSuraNameMetadata(index: 93, arabicName: 'الضحى', transliteratedName: 'Ad-Dhuhaa'),
  QuranSuraNameMetadata(index: 94, arabicName: 'الشرح', transliteratedName: 'Ash-Sharh'),
  QuranSuraNameMetadata(index: 95, arabicName: 'التين', transliteratedName: 'At-Tin'),
  QuranSuraNameMetadata(index: 96, arabicName: 'العلق', transliteratedName: 'Al-Alaq'),
  QuranSuraNameMetadata(index: 97, arabicName: 'القدر', transliteratedName: 'Al-Qadr'),
  QuranSuraNameMetadata(index: 98, arabicName: 'البينة', transliteratedName: 'Al-Bayyina'),
  QuranSuraNameMetadata(index: 99, arabicName: 'الزلزلة', transliteratedName: 'Az-Zalzala'),
  QuranSuraNameMetadata(index: 100, arabicName: 'العاديات', transliteratedName: 'Al-Aadiyaat'),
  QuranSuraNameMetadata(index: 101, arabicName: 'القارعة', transliteratedName: "Al-Qaari'a"),
  QuranSuraNameMetadata(index: 102, arabicName: 'التكاثر', transliteratedName: 'At-Takaathur'),
  QuranSuraNameMetadata(index: 103, arabicName: 'العصر', transliteratedName: 'Al-Asr'),
  QuranSuraNameMetadata(index: 104, arabicName: 'الهمزة', transliteratedName: 'Al-Humaza'),
  QuranSuraNameMetadata(index: 105, arabicName: 'الفيل', transliteratedName: 'Al-Fil'),
  QuranSuraNameMetadata(index: 106, arabicName: 'قريش', transliteratedName: 'Quraish'),
  QuranSuraNameMetadata(index: 107, arabicName: 'الماعون', transliteratedName: "Al-Maa'un"),
  QuranSuraNameMetadata(index: 108, arabicName: 'الكوثر', transliteratedName: 'Al-Kawthar'),
  QuranSuraNameMetadata(index: 109, arabicName: 'الكافرون', transliteratedName: 'Al-Kaafiroon'),
  QuranSuraNameMetadata(index: 110, arabicName: 'النصر', transliteratedName: 'An-Nasr'),
  QuranSuraNameMetadata(index: 111, arabicName: 'المسد', transliteratedName: 'Al-Masad'),
  QuranSuraNameMetadata(index: 112, arabicName: 'الإخلاص', transliteratedName: 'Al-Ikhlaas'),
  QuranSuraNameMetadata(index: 113, arabicName: 'الفلق', transliteratedName: 'Al-Falaq'),
  QuranSuraNameMetadata(index: 114, arabicName: 'الناس', transliteratedName: 'An-Naas'),
];

QuranSuraNameMetadata quranSuraName(int surah) {
  if (surah < 1 || surah > canonicalQuranSuraCount) {
    throw RangeError.range(surah, 1, canonicalQuranSuraCount, 'surah');
  }
  return canonicalQuranSuraNames[surah - 1];
}

void validateCanonicalQuranSuraNames() {
  if (canonicalQuranSuraNames.length != canonicalQuranSuraCount) {
    throw StateError('Canonical Quran metadata must contain exactly 114 sura names');
  }
  for (var i = 0; i < canonicalQuranSuraNames.length; i++) {
    final entry = canonicalQuranSuraNames[i];
    if (entry.index != i + 1 ||
        entry.arabicName.trim().isEmpty ||
        entry.transliteratedName.trim().isEmpty) {
      throw StateError('Invalid canonical sura name metadata at index ${i + 1}');
    }
  }
}
