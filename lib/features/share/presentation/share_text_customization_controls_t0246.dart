import 'package:flutter/material.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';

class ShareTextCustomizationControlsT0246 extends StatelessWidget {
  const ShareTextCustomizationControlsT0246({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final ShareTextPreferencesT0246 preferences;
  final ValueChanged<ShareTextPreferencesT0246> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: const ValueKey('t0246-share-text-controls'),
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final preset in ShareFontSizePresetT0246.values)
          ChoiceChip(
            key: ValueKey('t0246-font-${preset.name}'),
            label: Text(switch (preset) {
              ShareFontSizePresetT0246.compact => 'A−',
              ShareFontSizePresetT0246.standard => 'A',
              ShareFontSizePresetT0246.large => 'A+',
            }),
            selected: preferences.fontSizePreset == preset,
            onSelected: (_) {
              onChanged(preferences.copyWith(fontSizePreset: preset));
            },
          ),
        for (final alignment in ShareTextAlignmentT0246.values)
          IconButton(
            key: ValueKey('t0246-align-${alignment.name}'),
            onPressed: () {
              onChanged(preferences.copyWith(alignment: alignment));
            },
            icon: Icon(switch (alignment) {
              ShareTextAlignmentT0246.start => Icons.format_align_left,
              ShareTextAlignmentT0246.center => Icons.format_align_center,
              ShareTextAlignmentT0246.end => Icons.format_align_right,
            }),
          ),
      ],
    );
  }
}
