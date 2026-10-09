import '../../dua/data/dua_content.dart';
import '../../dua/data/dua_library_repository.dart';
import '../data/prophet_deep_links.dart';
import 'prophet_deep_link_authorization_t0202.dart';

/// Resolves a prophet -> dua deep link only against the production-approved
/// [DuaLibraryRepository].
///
/// The adapter deliberately has no fallback search by title, prophet name or
/// localized text. If the exact stable dua ID is not present in the reviewed
/// library, navigation stays unavailable instead of inventing or guessing a
/// religious-content destination.
///
/// When [authorization] is supplied, the adapter also requires the exact
/// prophet -> dua relationship to exist in the reviewed T0202 bundle. This
/// prevents a valid dua belonging to one prophet from being rebound to another
/// prophet merely by changing the `prophet` deep-link parameter.
final class ProphetDuaTargetAdapter {
  const ProphetDuaTargetAdapter(
    this.library, {
    this.authorization,
  });

  final DuaLibraryRepository library;
  final ProphetDeepLinkAuthorization? authorization;

  DuaContent? resolve(ProphetDeepLink link) {
    if (!link.isValid || link.kind != ProphetDeepLinkKind.dua) return null;
    final gate = authorization;
    if (gate != null && !gate.authorizes(link)) return null;
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
