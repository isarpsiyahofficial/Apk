import 'package:flutter/material.dart';
import 'package:islami_hayat/features/prophets/presentation/discover_prophets_entry.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        Text(
          l10n.discoverTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.discoverSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const DiscoverProphetsEntry(),
      ],
    );
  }
}
