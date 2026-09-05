import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_counter_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_preferences_view.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_intention_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/divine_name_guide_page.dart';

class DhikrHubPage extends StatelessWidget {
  const DhikrHubPage({
    super.key,
    this.guideEntries = const [],
    this.divineNameEntries = const [],
    this.intentionSuggestions = const [],
  });

  final List<DhikrGuideEntry> guideEntries;
  final List<DivineNameEntry> divineNameEntries;
  final List<DhikrIntentionSuggestion> intentionSuggestions;

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
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: _text(context, 'Sayaç', 'Counter', 'العداد')),
                      Tab(text: _text(context, 'Zikirler', 'Dhikrs', 'الأذكار')),
                      Tab(
                        text: _text(
                          context,
                          'Niyetime Göre',
                          'By intention',
                          'بحسب نيتي',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
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
                DhikrGuidePreferencesView(entries: guideEntries),
                DhikrIntentionPage(
                  suggestions: intentionSuggestions,
                  divineNames: divineNameEntries,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
