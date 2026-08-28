import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';

class DhikrIntentionPage extends StatelessWidget {
  const DhikrIntentionPage({
    super.key,
    this.categories = dhikrIntentionCategories,
    this.suggestions = const [],
    this.divineNames = const [],
  });

  final List<DhikrIntentionCategory> categories;
  final List<DhikrIntentionSuggestion> suggestions;
  final List<DivineNameEntry> divineNames;

  String _localized(BuildContext context, dynamic value) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return switch (languageCode) {
      'ar' => value.ar as String,
      'en' => value.en as String,
      _ => value.tr as String,
    };
  }

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  @override
  Widget build(BuildContext context) {
    final publishedNames = <String, DivineNameEntry>{
      for (final entry in divineNames)
        if (entry.canEnterProductionDataset) entry.id: entry,
    };
    final publishedSuggestions = suggestions
        .where((item) =>
            item.canEnterProductionDataset &&
            publishedNames.containsKey(item.divineNameId))
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _text(context, 'Niyetime Göre', 'By intention', 'بحسب نيتي'),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final category = categories[index];
            final categorySuggestions = publishedSuggestions
                .where((item) => item.categoryId == category.id)
                .toList(growable: false);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _localized(context, category.title),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _localized(context, category.description),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 14),
                        if (categorySuggestions.isEmpty)
                          Text(
                            _text(
                              context,
                              'Kaynak ve üç dil incelemesi tamamlanmış öneriler hazır olduğunda burada görünecek.',
                              'Suggestions will appear here after source verification and three-language review are complete.',
                              'ستظهر الاقتراحات هنا بعد اكتمال توثيق المصادر ومراجعة اللغات الثلاث.',
                            ),
                            key: ValueKey('intention-empty-${category.id.name}'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          ...categorySuggestions.map((suggestion) {
                            final divineName =
                                publishedNames[suggestion.divineNameId]!;
                            final transliteration =
                                Localizations.localeOf(context).languageCode ==
                                        'en'
                                    ? divineName.transliterationEn
                                    : divineName.transliterationTr;
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          divineName.arabic,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        transliteration,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _localized(context, suggestion.rationale),
                                        key: ValueKey(
                                          'intention-rationale-${suggestion.id}',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _text(
                                          context,
                                          'Bu ilişki anlam/dayanak bağlantısıdır; sonuç garantisi değildir.',
                                          'This is a meaning/evidence connection, not a guaranteed outcome.',
                                          'هذه علاقة قائمة على المعنى والدليل وليست ضمانًا لنتيجة.',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
