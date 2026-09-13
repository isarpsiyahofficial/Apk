import 'package:flutter/material.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

/// Safe presentation surface for religious content that failed integrity or
/// manifest validation. The unverified text is intentionally never rendered.
final class TrustedContentErrorView extends StatelessWidget {
  const TrustedContentErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      liveRegion: true,
      label: l10n.trustedContentErrorTitle,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user_outlined, size: 40),
                const SizedBox(height: 16),
                Text(
                  l10n.trustedContentErrorTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.trustedContentErrorBody,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
