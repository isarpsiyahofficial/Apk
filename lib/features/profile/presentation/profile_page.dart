import 'package:flutter/material.dart';
import 'package:islami_hayat/features/premium/presentation/premium_value_page.dart';
import 'package:islami_hayat/features/profile/presentation/sources_licenses_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: [
        Text(l10n.profileTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(l10n.profileSubtitle, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 28),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16,
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.premiumProfileTitle),
            subtitle: Text(l10n.premiumProfileSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PremiumValuePage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16,
            leading: const Icon(Icons.fact_check_outlined),
            title: Text(l10n.sourcesLicensesTitle),
            subtitle: Text(l10n.sourcesLicensesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SourcesLicensesPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
