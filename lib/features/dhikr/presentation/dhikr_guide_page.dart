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

  String? _countLabel(BuildContext context, DhikrGuideEntry entry) {
    final count = entry.recommendedCount;
    final provenance = entry.countProvenance;
    final source = entry.countSourceReference;
    if (count == null || provenance == null || source == null) {
      return null;
    }
    return switch (provenance) {
      DhikrCountProvenance.strongSource => _text(
          context,
          'Kur’an / Sahih-Hasen Sünnet kaynaklı sayı: $count · $source',
          'Qur’an / sahih-hasan Sunnah sourced count: $count · $source',
          'عدد مستند إلى القرآن / السنة الصحيحة أو الحسنة: $count · $source',
        ),
      DhikrCountProvenance.traditional => _text(
          context,
          'Tasavvufî-geleneksel sayı: $count · $source — sünnetle sabit sayı değildir.',
          'Traditional/tasawwuf count: $count · $source — not a Sunnah-prescribed count.',
          'عدد تقليدي/صوفي: $count · $source — ليس عددًا ثابتًا بالسنة.',
        ),
      DhikrCountProvenance.ebcedHavasHistorical => _text(
          context,
          'Ebced-havas tarihsel sayısı: $count · $source — sünnetle sabit zikir sayısı değildir.',
          'Historical abjad/havas count: $count · $source — not a Sunnah-prescribed dhikr count.',
          'عدد تاريخي من حساب الأبجد/الخواص: $count · $source — ليس عددًا ثابتًا بالسنة للذكر.',
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final published = entries
        .where((entry) => entry.canEnterProductionDataset)
        .toList(growable: false);

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
        final countLabel = _countLabel(context, entry);
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
                if (countLabel != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    countLabel,
                    key: ValueKey('dhikr-count-provenance-${entry.id}'),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
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
                            'Kur’an / Sahih-Hasen Sünnet kaynaklı sayı: ${target.count} · ${target.sourceReference}',
                            'Qur’an / sahih-hasan Sunnah sourced count: ${target.count} · ${target.sourceReference}',
                            'عدد مستند إلى القرآن / السنة الصحيحة أو الحسنة: ${target.count} · ${target.sourceReference}',
                          ),
                          key: const ValueKey('guided-dhikr-source-target'),
                          style: theme.textTheme.bodySmall,
                        )
                      else
                        Text(
                          _text(
                            context,
                            'Bu kayıt için sünnetle sabit otomatik hedef yok. Geleneksel veya ebced/havas sayıları otomatik hedefe dönüştürülmez.',
                            'This entry has no Sunnah-backed automatic target. Traditional or abjad/havas counts are never converted into an automatic target.',
                            'لا يوجد لهذا الذكر هدف تلقائي ثابت بالسنة. ولا تتحول الأعداد التقليدية أو أعداد الأبجد/الخواص إلى هدف تلقائي.',
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
