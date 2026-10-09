/// Turkish sura-name aliases verified against the official Diyanet Qur'an portal.
///
/// These aliases are search/navigation metadata only. They never modify the
/// canonical Tanzil Qur'an text or bundled meal content.
///
/// Verified source pages (retrieved 2026-08-28):
/// - 9: Tevbe — https://kuran.diyanet.gov.tr/tefsir/sure/9-tevbe-suresi
/// - 40: Mü'min — https://kuran.diyanet.gov.tr/tefsir/sure/40-mumin-suresi
/// - 42: Şûrâ — https://kuran.diyanet.gov.tr/tefsir/sure/42-sura-suresi
/// - 49: Hucurât — https://kuran.diyanet.gov.tr/tefsir/sure/49-hucurat-suresi
///
/// Only aliases whose official spelling has been checked are listed here.
const Map<int, List<String>> verifiedTurkishSuraAliases = {
  9: ['Tevbe'],
  40: ["Mü'min", 'Mümin'],
  42: ['Şûrâ', 'Şura'],
  49: ['Hucurât', 'Hucurat'],
};

List<String> turkishSuraAliases(int sura) =>
    verifiedTurkishSuraAliases[sura] ?? const <String>[];
