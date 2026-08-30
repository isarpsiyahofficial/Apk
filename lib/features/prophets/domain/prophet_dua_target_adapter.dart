import '../../dua/data/dua_content.dart';
import '../../dua/data/dua_library_repository.dart';
import '../data/prophet_deep_links.dart';

/// Resolves a prophet -> dua deep link only against the production-approved
/// [DuaLibraryRepository].
///
/// The adapter deliberately has no fallback search by title, prophet name or
/// localized text. If the exact stable dua ID is not present in the reviewed
/// library, navigation stays unavailable instead of inventing or guessing a
/// religious-content destination.
final class ProphetDuaTargetAdapter {
  const ProphetDuaTargetAdapter(this.library);

  final DuaLibraryRepository library;

  DuaContent? resolve(ProphetDeepLink link) {
    if (!link.isValid || link.kind != ProphetDeepLinkKind.dua) return null;
    return library.byId(link.targetId);
  }

  bool canOpen(ProphetDeepLink link) => resolve(link) != null;

  Future<bool> open(
    ProphetDeepLink link, {
    required Future<void> Function(DuaContent dua) onOpen,
  }) async {
    final dua = resolve(link);
    if (dua == null) return false;
    await onOpen(dua);
    return true;
  }
}
