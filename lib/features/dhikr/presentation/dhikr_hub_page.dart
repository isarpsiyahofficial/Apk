import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_counter_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/divine_name_guide_page.dart';

class DhikrHubPage extends StatelessWidget {
  const DhikrHubPage({
    super.key,
    this.guideEntries = const [],
    this.divineNameEntries = const [],
  });

  final List<DhikrGuideEntry> guideEntries;
  final List<DivineNameEntry> divineNameEntries;

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: _text(context, 'Sayaç', 'Counter', 'العداد')),
                      Tab(text: _text(context, 'Zikirler', 'Dhikrs', 'الأذكار')),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const ValueKey('open-divine-name-guide'),
                  tooltip: _text(
                    context,
                    'Esmâü’l-Hüsnâ rehberi',
                    'Beautiful Names guide',
                    'دليل أسماء الله الحسنى',
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DivineNameGuidePage(
                          entries: divineNameEntries,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_stories_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const DhikrCounterPage(),
                DhikrGuidePage(entries: guideEntries),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
