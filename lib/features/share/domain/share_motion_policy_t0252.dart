enum ShareExportModeT0252 {
  stillImage,
  reelsMotion,
}

/// Release-level capability switch for SPEC 410-412 / TODO T0252.
///
/// V1 intentionally ships only still-image share exports. Motion/Reels output
/// is a later-version capability and must not become reachable through an
/// accidental UI or exporter path. Embedded music is independently gated so a
/// future motion implementation cannot silently introduce copyrighted audio.
final class ShareMotionPolicyT0252 {
  const ShareMotionPolicyT0252._({
    required this.reelsMotionExportEnabled,
    required this.embeddedMusicEnabled,
  });

  /// Production V1 policy. Keep both capabilities disabled until a later
  /// release deliberately changes the product scope and adds matching tests.
  static const v1 = ShareMotionPolicyT0252._(
    reelsMotionExportEnabled: false,
    embeddedMusicEnabled: false,
  );

  final bool reelsMotionExportEnabled;
  final bool embeddedMusicEnabled;

  bool canExport(ShareExportModeT0252 mode) {
    return switch (mode) {
      ShareExportModeT0252.stillImage => true,
      ShareExportModeT0252.reelsMotion => reelsMotionExportEnabled,
    };
  }

  void requireExportAllowed(ShareExportModeT0252 mode) {
    if (!canExport(mode)) {
      throw StateError(
        'T0252 Reels motion export is outside the V1 release scope.',
      );
    }
  }

  /// Music may never be embedded merely because motion export is enabled.
  /// A future release must opt in separately and prove redistribution rights.
  bool canEmbedMusic({required bool hasDocumentedRedistributionRights}) {
    return embeddedMusicEnabled && hasDocumentedRedistributionRights;
  }

  void requireMusicEmbeddingAllowed({
    required bool hasDocumentedRedistributionRights,
  }) {
    if (!canEmbedMusic(
      hasDocumentedRedistributionRights: hasDocumentedRedistributionRights,
    )) {
      throw StateError(
        'T0252 embedded music is disabled unless the release explicitly '
        'enables it and redistribution rights are documented.',
      );
    }
  }
}
