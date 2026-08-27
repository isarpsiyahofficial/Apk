import 'package:flutter/material.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class SourcesLicensesPage extends StatelessWidget {
  const SourcesLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sourcesLicensesTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            _SourceSection(
              icon: Icons.menu_book_outlined,
              title: l10n.quranSourceTitle,
              children: [
                Text(
                  l10n.quranSourceName,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(l10n.quranSourceLicense),
                const SizedBox(height: 10),
                Text(
                  l10n.quranSourceStatus,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                const SelectableText('https://tanzil.net/'),
              ],
            ),
            const SizedBox(height: 16),
            _SourceSection(
              icon: Icons.verified_outlined,
              title: l10n.sourceTransparencyTitle,
              children: [Text(l10n.sourceTransparencyBody)],
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
