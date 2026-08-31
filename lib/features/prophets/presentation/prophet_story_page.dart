import 'package:flutter/material.dart';

import '../../history/domain/biography_timeline_link_t0222.dart';
import '../../history/domain/history_event_contract.dart';
import '../data/canonical_prophet_biographies.dart';
import '../data/prophet_biography_t0194_dataset.dart';

class ProphetStoryPage extends StatelessWidget {
  const ProphetStoryPage({required this.prophetId, super.key});

  final String prophetId;

  @override
  Widget build(BuildContext context) {
    final biography = canonicalProphetBiographyT0194Dataset.firstWhere(
      (entry) => entry.identity.canonicalId == prophetId,
    );
    final languageCode = Localizations.localeOf(context).languageCode;
    final name = switch (languageCode) {
      'ar' => biography.identity.name.ar,
      'en' => biography.identity.name.en,
      _ => biography.identity.name.tr,
    };
    final copy = _ProphetStoryCopy.forLocale(languageCode);
    final sourceBacked = biography.sections.entries
        .where(
          (entry) =>
              entry.value.status == ProphetBiographyFieldStatus.sourceBacked,
        )
        .toList(growable: false);
    final timelineEvents = historyBiographyTimelineT0222.eventsForBiography(
      'prophet:${biography.identity.canonicalId}',
    );

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 840 ? 32.0 : 16.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 36),
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(copy.researchNotice),
                        const SizedBox(height: 24),
                        for (final entry in sourceBacked) ...[
                          _SourceBackedStorySection(
                            field: entry.value,
                            languageCode: languageCode,
                            sourceLabel: copy.sourceLabel,
                          ),
                          const SizedBox(height: 18),
                        ],
                        if (timelineEvents.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            copy.timelineTitle,
                            key: const ValueKey('prophet-story-history-title'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(copy.timelineNotice),
                          const SizedBox(height: 14),
                          for (final event in timelineEvents) ...[
                            _HistoryTimelineEventRow(
                              event: event,
                              languageCode: languageCode,
                              approximateLabel: copy.approximateLabel,
                              contestedLabel: copy.contestedLabel,
                              unknownDateLabel: copy.unknownDateLabel,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SourceBackedStorySection extends StatelessWidget {
  const _SourceBackedStorySection({
    required this.field,
    required this.languageCode,
    required this.sourceLabel,
  });

  final ProphetBiographyField field;
  final String languageCode;
  final String sourceLabel;

  @override
  Widget build(BuildContext context) {
    final text = switch (languageCode) {
      'ar' => field.text.ar,
      'en' => field.text.en,
      _ => field.text.tr,
    };
    final locators = field.sources
        .map((source) => source.locator?.trim())
        .whereType<String>()
        .where((locator) => locator.isNotEmpty)
        .toSet()
        .join(' · ');

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              textDirection: languageCode == 'ar' ? TextDirection.rtl : null,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            if (locators.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '$sourceLabel: $locators',
                key: ValueKey('prophet-story-source-${field.hashCode}'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryTimelineEventRow extends StatelessWidget {
  const _HistoryTimelineEventRow({
    required this.event,
    required this.languageCode,
    required this.approximateLabel,
    required this.contestedLabel,
    required this.unknownDateLabel,
  });

  final HistoryEventRecord event;
  final String languageCode;
  final String approximateLabel;
  final String contestedLabel;
  final String unknownDateLabel;

  @override
  Widget build(BuildContext context) {
    final title = switch (languageCode) {
      'ar' => event.title.ar,
      'en' => event.title.en,
      _ => event.title.tr,
    };
    final date = _dateLabel();

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12, top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                key: ValueKey('prophet-history-date-${event.id}'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 3),
              Text(
                title,
                key: ValueKey('prophet-history-event-${event.id}'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateLabel() {
    if (event.dateCertainty == HistoryDateCertainty.unknown ||
        event.startYearCe == null ||
        event.endYearCe == null) {
      return unknownDateLabel;
    }
    final range = event.startYearCe == event.endYearCe
        ? '${event.startYearCe}'
        : '${event.startYearCe}–${event.endYearCe}';
    return switch (event.dateCertainty) {
      HistoryDateCertainty.exact => range,
      HistoryDateCertainty.approximate || HistoryDateCertainty.broadRange =>
        '$approximateLabel $range',
      HistoryDateCertainty.contested => '$contestedLabel · $range',
      HistoryDateCertainty.unknown => unknownDateLabel,
    };
  }
}

class _ProphetStoryCopy {
  const _ProphetStoryCopy({
    required this.title,
    required this.researchNotice,
    required this.sourceLabel,
    required this.timelineTitle,
    required this.timelineNotice,
    required this.approximateLabel,
    required this.contestedLabel,
    required this.unknownDateLabel,
  });

  final String title;
  final String researchNotice;
  final String sourceLabel;
  final String timelineTitle;
  final String timelineNotice;
  final String approximateLabel;
  final String contestedLabel;
  final String unknownDateLabel;

  static _ProphetStoryCopy forLocale(String languageCode) => switch (languageCode) {
        'ar' => const _ProphetStoryCopy(
            title: 'القصة الموثقة',
            researchNotice:
                'تُعرض هنا فقط الفقرات التي لها مصدر موثوق. التفاصيل التي لا تزال قيد البحث لا تُعرض كحقائق.',
            sourceLabel: 'المصدر',
            timelineTitle: 'في التسلسل التاريخي',
            timelineNotice:
                'تظهر فقط الأحداث المرتبطة بهذه السيرة عبر معرّف شخص موثق ومطابق، من دون إنشاء روابط تخمينية.',
            approximateLabel: 'تقريبًا',
            contestedLabel: 'التأريخ/التفسير محل خلاف',
            unknownDateLabel: 'التاريخ غير محسوم',
          ),
        'en' => const _ProphetStoryCopy(
            title: 'Source-backed story',
            researchNotice:
                'Only passages backed by reviewed sources are shown here. Details still under research are not presented as facts.',
            sourceLabel: 'Source',
            timelineTitle: 'In the history timeline',
            timelineNotice:
                'Only events joined to this biography by an exact, verified person identifier are shown; speculative links are not created.',
            approximateLabel: 'Approx.',
            contestedLabel: 'Dating/interpretation contested',
            unknownDateLabel: 'Date unresolved',
          ),
        _ => const _ProphetStoryCopy(
            title: 'Kaynaklı kıssa',
            researchNotice:
                'Burada yalnız güvenilir kaynağı doğrulanmış bölümler gösterilir. Araştırması süren ayrıntılar kesin bilgi gibi sunulmaz.',
            sourceLabel: 'Kaynak',
            timelineTitle: 'Tarih kronolojisinde',
            timelineNotice:
                'Yalnız doğrulanmış ve birebir kişi kimliğiyle bu biyografiye bağlanan olaylar gösterilir; tahminî bağlantı üretilmez.',
            approximateLabel: 'Yaklaşık',
            contestedLabel: 'Tarih/yorum ihtilaflı',
            unknownDateLabel: 'Tarih kesinleştirilmedi',
          ),
      };
}
