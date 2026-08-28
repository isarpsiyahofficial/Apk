import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_counter_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_page.dart';

class DhikrHubPage extends StatelessWidget {
  const DhikrHubPage({
    super.key,
    this.guideEntries = const [],
  });

  final List<DhikrGuideEntry> guideEntries;

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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: TabBar(
              tabs: [
                Tab(text: _text(context, 'Sayaç', 'Counter', 'العداد')),
                Tab(text: _text(context, 'Zikirler', 'Dhikrs', 'الأذكار')),
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
