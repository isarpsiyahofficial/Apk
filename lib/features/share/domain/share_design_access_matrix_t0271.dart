import 'rewarded_share_unlock_t0269.dart';

enum ShareDesignAccessT0271 {
  permanentFree,
  rewardedRequired,
  proUnlimited,
}

class ShareDesignAccessEntryT0271 {
  const ShareDesignAccessEntryT0271({
    required this.designId,
    required this.freeAccess,
  });

  final String designId;
  final ShareDesignAccessT0271 freeAccess;

  ShareDesignAccessT0271 accessFor({required bool isPro}) {
    if (isPro) return ShareDesignAccessT0271.proUnlimited;
    return freeAccess;
  }
}

/// T0271 canonical access matrix for the 100 Canva design slots.
///
/// This class deliberately models access independently from final Canva asset
/// approval. A design slot being present here does not mean its candidate has
/// passed license/hash/AI/re-export or four-format visual QA.
class ShareDesignAccessMatrixT0271 {
  const ShareDesignAccessMatrixT0271._();

  static const int totalDesignCount = RewardedShareUnlockT0269.totalDesignCount;
  static const int permanentFreeDesignCount =
      RewardedShareUnlockT0269.permanentFreeDesignCount;
  static const int rewardedOrProDesignCount =
      totalDesignCount - permanentFreeDesignCount;

  static final List<ShareDesignAccessEntryT0271> entries =
      List<ShareDesignAccessEntryT0271>.unmodifiable(
    List<ShareDesignAccessEntryT0271>.generate(totalDesignCount, (index) {
      final number = index + 1;
      return ShareDesignAccessEntryT0271(
        designId: 'Canva-${number.toString().padLeft(3, '0')}',
        freeAccess: number <= permanentFreeDesignCount
            ? ShareDesignAccessT0271.permanentFree
            : ShareDesignAccessT0271.rewardedRequired,
      );
    }),
  );

  static ShareDesignAccessEntryT0271 entryFor(String designId) {
    final unlock = RewardedShareUnlockT0269(designId: designId, isPro: false);
    final index = int.parse(unlock.designId.substring('Canva-'.length)) - 1;
    return entries[index];
  }

  static ShareDesignAccessT0271 accessFor(
    String designId, {
    required bool isPro,
  }) {
    return entryFor(designId).accessFor(isPro: isPro);
  }
}
