import '../../quran/data/canonical_quran_source.dart';
import '../data/prophet_content.dart';
import '../data/prophet_deep_links.dart';
import 'prophet_deep_link_authorization_t0202.dart';

/// Fail-closed resolver for T0202 Prophet -> Quran verse navigation.
///
/// A deep link must satisfy three independent checks before navigation:
/// 1) its serialized verse identity must be internally valid,
/// 2) the exact prophet -> verse relationship must be present in the reviewed
///    T0202 authorization bundle,
/// 3) the verse must exist in the canonical 114-sura Tanzil structure.
///
/// This prevents a syntactically valid but impossible reference such as 2:999,
/// or a valid verse belonging to another prophet, from reaching the reader.
final class ProphetQuranTargetAdapterT0202 {
  const ProphetQuranTargetAdapterT0202(this.authorization);

  final ProphetDeepLinkAuthorization authorization;

  ProphetVerseReference? resolve(ProphetDeepLink link) {
    if (!link.isValid || link.kind != ProphetDeepLinkKind.quranVerse) {
      return null;
    }
    if (!authorization.authorizes(link)) return null;

    final surah = link.surah;
    final ayah = link.ayah;
    if (surah == null || ayah == null) return null;
    if (surah < 1 || surah > canonicalQuranSuraCount) return null;
    final maxAyah = canonicalQuranAyahCountForSura(surah);
    if (ayah < 1 || ayah > maxAyah) return null;

    return ProphetVerseReference(surah: surah, ayah: ayah);
  }

  bool canOpen(ProphetDeepLink link) => resolve(link) != null;

  Future<bool> open(
    ProphetDeepLink link, {
    required Future<void> Function(ProphetVerseReference verse) onOpen,
  }) async {
    final verse = resolve(link);
    if (verse == null) return false;
    await onOpen(verse);
    return true;
  }
}
