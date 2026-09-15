import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

/// Mandatory source/disclosure surface for every dua detail/card that renders
/// religious text. It intentionally derives its labels from localization and
/// its semantics from [DuaContent], so a general editorial dua cannot silently
/// look like Qur'an or hadith content.
final class DuaSourceDisclosureView extends StatelessWidget {
  const DuaSourceDisclosureView({
    required this.dua,
    super.key,
  });

  final DuaContent dua;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sourceLabel = switch (dua.disclosure) {
      DuaSourceDisclosure.quran => l10n.duaSourceQuran,
      DuaSourceDisclosure.authenticatedSunnah => l10n.duaSourceSunnah,
      DuaSourceDisclosure.classicalTraditional => l10n.duaSourceTraditional,
      DuaSourceDisclosure.generalEditorial => l10n.duaSourceEditorial,
    };

    final disputeText = dua.hasSourceDispute && dua.disputeNote != null
        ? _localizedText(dua.disputeNote!, Localizations.localeOf(context))
        : null;

    return Semantics(
      container: true,
      label: sourceLabel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  sourceLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            if (dua.requiresEditorialDisclaimer) ...[
              const SizedBox(height: 8),
              Text(
                l10n.duaEditorialDisclaimer,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (disputeText != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.duaSourceDisputeLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                disputeText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _localizedText(
    LocalizedReligiousText text,
    Locale locale,
  ) => switch (locale.languageCode) {
    'ar' => text.ar,
    'en' => text.en,
    _ => text.tr,
  };
}
