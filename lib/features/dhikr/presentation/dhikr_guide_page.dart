import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_counter_repository.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_history_repository.dart';
import 'package:islami_hayat/features/dhikr/domain/dhikr_counter_launch.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_counter_page.dart';

class DhikrGuidePage extends StatelessWidget {
  const DhikrGuidePage({
    super.key,
    this.entries = const [],
    this.counterRepository,
    this.historyRepository,
  });

  final List<DhikrGuideEntry> entries;
  final DhikrCounterRepository? counterRepository;
  final DhikrHistoryRepository? historyRepository;

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  String _transliteration(BuildContext context, DhikrGuideEntry entry) {
    return Localizations.localeOf(context).languageCode == 'en'
        ? entry.transliterationEn
        : entry.transliterationTr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final published = entries.where((entry) => entry.canEnterProductionDataset).toList(growable: false);

    if (published.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _text(
              context,
              'Kaynak ve inceleme kapısından geçmiş zikir rehberi kayıtları hazır olduğunda burada görünecek.',
              'Reviewed dhikr guide entries will appear here after they pass the source and content gates.',
              'ستظهر هنا أذكار الدليل بعد اجتياز مراجعة المصدر والمحتوى.',
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      itemCount: published.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = published[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    entry.arabic,
                    key: ValueKey('dhikr-guide-arabic-${entry.id}'),
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _transliteration(context, entry),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton.icon(
                    key: ValueKey('dhikr-start-${entry.id}'),
                    onPressed: () {
                      final launch = DhikrCounterLaunch.fromGuide(entry);
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DhikrGuidedCounterPage(
                            launch: launch,
                            counterRepository: counterRepository,
                            historyRepository: historyRepository,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.touch_app_outlined),
                    label: Text(
                      _text(context, 'Zikri Başlat', 'Start Dhikr', 'ابدأ الذكر'),
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

class DhikrGuidedCounterPage extends StatelessWidget {
  const DhikrGuidedCounterPage({
    super.key,
    required this.launch,
    this.counterRepository,
    this.historyRepository,
  });

  final DhikrCounterLaunch launch;
  final DhikrCounterRepository? counterRepository;
  final DhikrHistoryRepository? historyRepository;

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  String _transliteration(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en'
        ? launch.transliterationEn
        : launch.transliterationTr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = launch.target;
    return Scaffold(
      appBar: AppBar(
        title: Text(_text(context, 'Zikir Sayacı', 'Dhikr Counter', 'عداد الذكر')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          launch.arabic,
                          key: const ValueKey('guided-dhikr-arabic'),
                          textAlign: TextAlign.start,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_transliteration(context)),
                      const SizedBox(height: 8),
                      if (target != null)
                        Text(
                          _text(
                            context,
                            'Kaynaklı sayı: ${target.count} · ${target.sourceReference}',
                            'Source-backed target: ${target.count} · ${target.sourceReference}',
                            'عدد موثق بالمصدر: ${target.count} · ${target.sourceReference}',
                          ),
                          key: const ValueKey('guided-dhikr-source-target'),
                          style: theme.textTheme.bodySmall,
                        )
                      else
                        Text(
                          _text(
                            context,
                            'Bu kayıt için doğrulanmış kaynaklı sayı yok; sayaç hedef uydurmaz.',
                            'This entry has no verified source-backed count; the counter does not invent a target.',
                            'لا يوجد لهذا الذكر عدد موثق بالمصدر؛ ولا ينشئ العداد هدفًا من تلقاء نفسه.',
                          ),
                          key: const ValueKey('guided-dhikr-no-target'),
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: DhikrCounterPage(
                repository: counterRepository,
                historyRepository: historyRepository,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
