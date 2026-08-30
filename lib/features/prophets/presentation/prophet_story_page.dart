import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 840 ? 32.0 : 16.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 36),
              children: [
                ConstrainedBox(
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
                    ],
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

class _ProphetStoryCopy {
  const _ProphetStoryCopy({
    required this.title,
    required this.researchNotice,
    required this.sourceLabel,
  });

  final String title;
  final String researchNotice;
  final String sourceLabel;

  static _ProphetStoryCopy forLocale(String languageCode) => switch (languageCode) {
        'ar' => const _ProphetStoryCopy(
            title: 'القصة الموثقة',
            researchNotice:
                'تُعرض هنا فقط الفقرات التي لها مصدر موثوق. التفاصيل التي لا تزال قيد البحث لا تُعرض كحقائق.',
            sourceLabel: 'المصدر',
          ),
        'en' => const _ProphetStoryCopy(
            title: 'Source-backed story',
            researchNotice:
                'Only passages backed by reviewed sources are shown here. Details still under research are not presented as facts.',
            sourceLabel: 'Source',
          ),
        _ => const _ProphetStoryCopy(
            title: 'Kaynaklı kıssa',
            researchNotice:
                'Burada yalnız güvenilir kaynağı doğrulanmış bölümler gösterilir. Araştırması süren ayrıntılar kesin bilgi gibi sunulmaz.',
            sourceLabel: 'Kaynak',
          ),
      };
}
