class SourceManifestEntry {
  const SourceManifestEntry({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.licenseId,
    required this.retrievedAt,
    required this.sha256,
    required this.attribution,
    this.version,
    this.licenseEvidenceUrl,
  });

  final String id;
  final String title;
  final Uri sourceUrl;
  final String licenseId;
  final DateTime retrievedAt;
  final String sha256;
  final String attribution;
  final String? version;
  final Uri? licenseEvidenceUrl;

  bool get isComplete =>
      id.trim().isNotEmpty &&
      title.trim().isNotEmpty &&
      licenseId.trim().isNotEmpty &&
      attribution.trim().isNotEmpty &&
      _isSha256(sha256);

  static bool _isSha256(String value) =>
      RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(value);
}

class VisualAssetManifestEntry extends SourceManifestEntry {
  const VisualAssetManifestEntry({
    required super.id,
    required super.title,
    required super.sourceUrl,
    required super.licenseId,
    required super.retrievedAt,
    required super.sha256,
    required super.attribution,
    required this.canRedistributeInApp,
    required this.canExportRepeatedly,
    required this.isAiGenerated,
    required this.isCanvaProContent,
    super.version,
    super.licenseEvidenceUrl,
  });

  final bool canRedistributeInApp;
  final bool canExportRepeatedly;
  final bool isAiGenerated;
  final bool isCanvaProContent;

  bool get canBeFinalReusableBackground =>
      isComplete &&
      canRedistributeInApp &&
      canExportRepeatedly &&
      !isAiGenerated &&
      !isCanvaProContent;
}
