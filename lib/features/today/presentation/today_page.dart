import 'package:flutter/material.dart';
import 'package:islami_hayat/core/responsive/app_breakpoints.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final padding = AppBreakpoints.horizontalPadding(width);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            title: l10n.todayGreeting,
            subtitle: l10n.todaySubtitle,
          ),
          const SizedBox(height: 36),
          _EditorialBlock(
            eyebrow: l10n.dailyVerseTitle,
            icon: Icons.menu_book_outlined,
            body: l10n.contentPending,
          ),
          const SizedBox(height: 22),
          _EditorialBlock(
            eyebrow: l10n.dailyDuaTitle,
            icon: Icons.volunteer_activism_outlined,
            body: l10n.contentPending,
          ),
          const SizedBox(height: 22),
          _EditorialBlock(
            eyebrow: l10n.historyTodayTitle,
            icon: Icons.history_edu_outlined,
            body: l10n.contentPending,
          ),
          const SizedBox(height: 34),
          _QuickActions(
            items: [
              _QuickActionData(Icons.search, l10n.quickTopicSearch),
              _QuickActionData(Icons.volunteer_activism_outlined, l10n.quickDuas),
              _QuickActionData(Icons.touch_app_outlined, l10n.quickDhikr),
              _QuickActionData(Icons.explore_outlined, l10n.quickExplore),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 10),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _EditorialBlock extends StatelessWidget {
  const _EditorialBlock({
    required this.eyebrow,
    required this.icon,
    required this.body,
  });

  final String eyebrow;
  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor),
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 22, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(body, style: theme.textTheme.titleLarge),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.items});

  final List<_QuickActionData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 4 : 2;
        final gap = 12.0;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * gap)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _QuickAction(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.item});

  final _QuickActionData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(item.icon, color: theme.colorScheme.primary, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: Text(item.label, style: theme.textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData(this.icon, this.label);

  final IconData icon;
  final String label;
}
