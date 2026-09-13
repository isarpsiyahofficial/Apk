import 'package:flutter/material.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class PremiumValuePage extends StatelessWidget {
  const PremiumValuePage({super.key});

  static const Key benefitsKey = Key('premium-benefits');
  static const Key truthBoundaryKey = Key('premium-truth-boundary');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumTitle)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              children: [
                Text(
                  l10n.premiumLifetimeTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.premiumSubtitle,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                Semantics(
                  key: benefitsKey,
                  container: true,
                  label: l10n.premiumBenefitsSemantics,
                  child: Column(
                    children: [
                      _PremiumBenefit(
                        icon: Icons.block_outlined,
                        title: l10n.premiumNoAdsTitle,
                        body: l10n.premiumNoAdsBody,
                      ),
                      _PremiumBenefit(
                        icon: Icons.offline_bolt_outlined,
                        title: l10n.premiumOfflineTitle,
                        body: l10n.premiumOfflineBody,
                      ),
                      _PremiumBenefit(
                        icon: Icons.collections_outlined,
                        title: l10n.premiumDesignsTitle,
                        body: l10n.premiumDesignsBody,
                      ),
                      _PremiumBenefit(
                        icon: Icons.tune_outlined,
                        title: l10n.premiumPersonalizationTitle,
                        body: l10n.premiumPersonalizationBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                DecoratedBox(
                  key: truthBoundaryKey,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.premiumTruthTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.premiumTruthBody,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.premiumBillingNote,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumBenefit extends StatelessWidget {
  const _PremiumBenefit({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
