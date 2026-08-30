import 'package:flutter/material.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';

class DailyProphetLearningCard extends StatelessWidget {
  const DailyProphetLearningCard({
    super.key,
    required this.suggestion,
    required this.title,
    required this.prophetName,
    required this.sourceLabel,
    required this.openLabel,
    required this.onOpen,
  });

  final DailyProphetLearningSuggestion suggestion;
  final String title;
  final String prophetName;
  final String sourceLabel;
  final String openLabel;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final text = switch (languageCode) {
      'ar' => suggestion.field.text.ar,
      'en' => suggestion.field.text.en,
      _ => suggestion.field.text.tr,
    };
    final locators = suggestion.field.sources
        .map((source) => source.locator?.trim())
        .whereType<String>()
        .where((locator) => locator.isNotEmpty)
        .toList(growable: false);

    assert(locators.isNotEmpty);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Container(
        key: const ValueKey('daily-prophet-learning-card'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.dividerColor),
            bottom: BorderSide(color: theme.dividerColor),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.school_outlined,
                size: 22,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    key: const ValueKey('daily-prophet-learning-title'),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(prophetName, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    key: const ValueKey('daily-prophet-learning-body'),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$sourceLabel: ${locators.join(' · ')}',
                    key: const ValueKey('daily-prophet-learning-source'),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (onOpen != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      key: const ValueKey('daily-prophet-learning-open'),
                      onPressed: () => onOpen!(suggestion.prophetId),
                      icon: const Icon(Icons.auto_stories_outlined),
                      label: Text(openLabel),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
