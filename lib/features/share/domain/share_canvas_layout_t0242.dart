enum ShareCanvasFormatT0242 {
  instagramStory916,
  whatsappStatus916,
  instagramPost45,
  square11,
}

class ShareCanvasLayoutT0242 {
  const ShareCanvasLayoutT0242._({
    required this.format,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.safeHorizontalFraction,
    required this.safeTopFraction,
    required this.safeBottomFraction,
  });

  factory ShareCanvasLayoutT0242.forFormat(ShareCanvasFormatT0242 format) {
    return switch (format) {
      ShareCanvasFormatT0242.instagramStory916 => const ShareCanvasLayoutT0242._(
          format: ShareCanvasFormatT0242.instagramStory916,
          pixelWidth: 1080,
          pixelHeight: 1920,
          safeHorizontalFraction: 0.075,
          safeTopFraction: 0.10,
          safeBottomFraction: 0.16,
        ),
      ShareCanvasFormatT0242.whatsappStatus916 => const ShareCanvasLayoutT0242._(
          format: ShareCanvasFormatT0242.whatsappStatus916,
          pixelWidth: 1080,
          pixelHeight: 1920,
          safeHorizontalFraction: 0.075,
          safeTopFraction: 0.09,
          safeBottomFraction: 0.12,
        ),
      ShareCanvasFormatT0242.instagramPost45 => const ShareCanvasLayoutT0242._(
          format: ShareCanvasFormatT0242.instagramPost45,
          pixelWidth: 1080,
          pixelHeight: 1350,
          safeHorizontalFraction: 0.07,
          safeTopFraction: 0.07,
          safeBottomFraction: 0.09,
        ),
      ShareCanvasFormatT0242.square11 => const ShareCanvasLayoutT0242._(
          format: ShareCanvasFormatT0242.square11,
          pixelWidth: 1080,
          pixelHeight: 1080,
          safeHorizontalFraction: 0.07,
          safeTopFraction: 0.07,
          safeBottomFraction: 0.08,
        ),
    };
  }

  final ShareCanvasFormatT0242 format;
  final int pixelWidth;
  final int pixelHeight;
  final double safeHorizontalFraction;
  final double safeTopFraction;
  final double safeBottomFraction;

  double get aspectRatio => pixelWidth / pixelHeight;

  void validate() {
    if (pixelWidth <= 0 || pixelHeight <= 0) {
      throw StateError('T0242 export dimensions must be positive.');
    }
    final fractions = <double>[
      safeHorizontalFraction,
      safeTopFraction,
      safeBottomFraction,
    ];
    if (fractions.any((value) => value < 0 || value >= 0.5)) {
      throw StateError('T0242 safe-area fractions must stay within the canvas.');
    }
    if (safeTopFraction + safeBottomFraction >= 0.8) {
      throw StateError('T0242 vertical safe area leaves too little content space.');
    }
  }
}
