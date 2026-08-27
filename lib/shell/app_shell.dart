import 'package:flutter/material.dart';
import 'package:islami_hayat/core/responsive/app_breakpoints.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/profile/presentation/profile_page.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_hub_page.dart';
import 'package:islami_hayat/features/shared/presentation/section_placeholder_page.dart';
import 'package:islami_hayat/features/today/presentation/today_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.quranProgressRepository,
  });

  final QuranReadingProgressRepository? quranProgressRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  late final QuranReadingProgressRepository _quranProgressRepository;

  @override
  void initState() {
    super.initState();
    _quranProgressRepository = widget.quranProgressRepository ??
        QuranReadingProgressRepository(SecurePrivateUserStore());
  }

  void _select(int value) {
    if (_selectedIndex == value) return;
    setState(() => _selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = <_DestinationData>[
      _DestinationData(
        id: 'today',
        icon: Icons.today_outlined,
        selectedIcon: Icons.today,
        label: l10n.navToday,
      ),
      _DestinationData(
        id: 'quran',
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: l10n.navQuran,
      ),
      _DestinationData(
        id: 'discover',
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: l10n.navDiscover,
      ),
      _DestinationData(
        id: 'dhikr',
        icon: Icons.touch_app_outlined,
        selectedIcon: Icons.touch_app,
        label: l10n.navDhikr,
      ),
      _DestinationData(
        id: 'profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.navProfile,
      ),
    ];

    final pages = <Widget>[
      TodayPage(
        quranProgressRepository: _quranProgressRepository,
        onContinueQuran: () => _select(1),
      ),
      QuranHubPage(progressRepository: _quranProgressRepository),
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
      const ProfilePage(),
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
                    key: ValueKey('nav-${item.id}'),
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
                        icon: KeyedSubtree(
                          key: ValueKey('nav-${item.id}'),
                          child: Icon(item.icon),
                        ),
                        selectedIcon: KeyedSubtree(
                          key: ValueKey('nav-${item.id}-selected'),
                          child: Icon(item.selectedIcon),
                        ),
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
    required this.id,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String id;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
