import 'package:flutter/services.dart';

abstract interface class DhikrFeedbackPlayer {
  Future<void> vibrate();
  Future<void> playSound();
}

final class SystemDhikrFeedbackPlayer implements DhikrFeedbackPlayer {
  const SystemDhikrFeedbackPlayer();

  @override
  Future<void> vibrate() => HapticFeedback.selectionClick();

  @override
  Future<void> playSound() => SystemSound.play(SystemSoundType.click);
}
