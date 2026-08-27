import 'package:flutter/material.dart';
import 'package:islami_hayat/core/responsive/app_breakpoints.dart';
import 'package:islami_hayat/features/shared/presentation/section_placeholder_page.dart';
import 'package:islami_hayat/features/today/presentation/today_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _select(int value) {
    if (_selectedIndex == value) return;
    setState(() => _selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = <_DestinationData>[
      _DestinationData(
        icon: Icons.today_outlined,
        selectedIcon: Icons.today,
        label: l10n.navToday,
      ),
      _DestinationData(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: l10n.navQuran,
      ),
      _DestinationData(
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: l10n.navDiscover,
      ),
      _DestinationData(
        icon: Icons.touch_app_outlined,
        selectedIcon: Icons.touch_app,
        label: l10n.navDhikr,
      ),
      _DestinationData(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.navProfile,
      ),
    ];

    final pages = <Widget>[
      const TodayPage(),
      SectionPlaceholderPage(
        title: l10n.quranTitle,
        subtitle: l10n.quranSubtitle,
        icon: Icons.menu_book_outlined,
      ),
      SectionPlaceholderPage(
        title: l10n.discoverTitle,
        subtitle: l10n.discoverSubtitle,
        icon: Icons.explore_outlined,
      ),
      SectionPlaceholderPage(
        title: l10n.dhikrTitle,
        subtitle: l10n.dhikrSubtitle,
        icon: Icons.touch_app_outlined,
      ),
      SectionPlaceholderPage(
        title: l10n.profileTitle,
        subtitle: l10n.profileSubtitle,
        icon: Icons.person_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final useRail = AppBreakpoints.useNavigationRail(width);
        final currentPage = KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: pages[_selectedIndex],
        );

        if (!useRail) {
          return Scaffold(
            body: SafeArea(child: currentPage),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _select,
              destinations: [
                for (final item in destinations)
                  NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
              ],
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _select,
                  labelType: width >= 1100
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.selected,
                  extended: width >= 1100,
                  groupAlignment: -0.65,
                  destinations: [
                    for (final item in destinations)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppBreakpoints.contentMaxWidth,
                      ),
                      child: currentPage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DestinationData {
  const _DestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
