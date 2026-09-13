import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_verse_mappings.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_health_safety_policy.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_religious_output_boundary.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_confidence_gate.dart';

enum TopicResultLocale { tr, en, ar }

class TopicVerseResult {
  const TopicVerseResult({
    required this.themeIds,
    required this.verses,
    required this.whyShown,
    this.safetyNotice,
  });

  final List<String> themeIds;
  final List<QuranVerseReference> verses;
  final String whyShown;

  /// Non-null only for result themes that require an explicit high-risk safety
  /// message. This copy is fixed by policy; it is not generated from the user
  /// question and is not a medical diagnosis or treatment recommendation.
  final String? safetyNotice;
}

/// Resolves a confident topic decision only against explicitly expert-reviewed
/// taxonomy entries and verse mappings.
///
/// This layer does not interpret Quran text and does not create a new religious
/// judgement. It only joins canonical theme IDs to pre-reviewed verse
/// references. If any requested theme lacks complete review evidence the whole
/// result fails closed instead of silently showing a partial interpretation.
final class TopicVerseResultResolver {
  TopicVerseResultResolver({
    required Iterable<QuranThemeDefinition> themes,
    required Iterable<QuranThemeVerseMapping> mappings,
  })  : _themes = {for (final theme in themes) theme.id: theme},
        _mappings = {for (final mapping in mappings) mapping.themeId: mapping};

  factory TopicVerseResultResolver.productionCatalog() {
    return TopicVerseResultResolver(
      themes: QuranThemeTaxonomy.themes,
      mappings: QuranThemeVerseCatalog.mappings,
    );
  }

  final Map<String, QuranThemeDefinition> _themes;
  final Map<String, QuranThemeVerseMapping> _mappings;

  TopicVerseResult? resolve(
    TopicThemeDecision decision, {
    required TopicResultLocale locale,
    int maximumVerses = 5,
  }) {
    if (maximumVerses < 3 || maximumVerses > 5) {
      throw ArgumentError.value(
        maximumVerses,
        'maximumVerses',
        'must be between 3 and 5',
      );
    }

    // T0160 boundary: algorithm-owned output must collapse to canonical theme
    // IDs before any reviewed religious content may be resolved. Unknown,
    // duplicate, or structurally inconsistent decisions fail closed here.
    final selection = TopicReligiousOutputBoundary.enforce(decision);
    if (!selection.mayResolveReviewedVerses) return null;

    final reviewedThemes = <QuranThemeDefinition>[];
    final reviewedMappings = <QuranThemeVerseMapping>[];

    for (final themeId in selection.themeIds) {
      final theme = _themes[themeId];
      final mapping = _mappings[themeId];
      if (theme == null ||
          !theme.isProductionReady ||
          mapping == null ||
          !mapping.hasRequiredVerseCount ||
          !mapping.hasUniqueCanonicalReferences ||
          !mapping.hasExpertReviewEvidence) {
        return null;
      }
      reviewedThemes.add(theme);
      reviewedMappings.add(mapping);
    }

    final verses = <QuranVerseReference>[];
    final seenVerseKeys = <String>{};

    // Round-robin preserves multi-theme representation instead of allowing the
    // first theme to consume the whole 3–5 verse result window.
    var index = 0;
    while (verses.length < maximumVerses) {
      var addedAny = false;
      for (final mapping in reviewedMappings) {
        if (index >= mapping.verses.length) continue;
        final verse = mapping.verses[index];
        if (seenVerseKeys.add(verse.key)) {
          verses.add(verse);
          addedAny = true;
          if (verses.length == maximumVerses) break;
        }
      }
      if (!addedAny && reviewedMappings.every((m) => index >= m.verses.length)) {
        break;
      }
      index++;
    }

    if (verses.length < 3) return null;

    final resolvedThemeIds = List<String>.unmodifiable(
      reviewedThemes.map((theme) => theme.id),
    );

    return TopicVerseResult(
      themeIds: resolvedThemeIds,
      verses: List<QuranVerseReference>.unmodifiable(verses),
      whyShown: _whyShown(reviewedThemes, locale),
      safetyNotice: TopicHealthSafetyPolicy.noticeFor(
        resolvedThemeIds,
        locale: _safetyLocale(locale),
      ),
    );
  }

  static TopicSafetyLocale _safetyLocale(TopicResultLocale locale) {
    return switch (locale) {
      TopicResultLocale.tr => TopicSafetyLocale.tr,
      TopicResultLocale.en => TopicSafetyLocale.en,
      TopicResultLocale.ar => TopicSafetyLocale.ar,
    };
  }

  static String _whyShown(
    List<QuranThemeDefinition> themes,
    TopicResultLocale locale,
  ) {
    final labels = themes.map((theme) {
      return switch (locale) {
        TopicResultLocale.tr => theme.labelTr,
        TopicResultLocale.en => theme.labelEn,
        TopicResultLocale.ar => theme.labelAr,
      };
    }).toList(growable: false);

    final joined = switch (locale) {
      TopicResultLocale.tr => labels.join(' ve '),
      TopicResultLocale.en => labels.join(' and '),
      TopicResultLocale.ar => labels.join(' و '),
    };
    final isSingleTheme = labels.length == 1;

    return switch (locale) {
      TopicResultLocale.tr => isSingleTheme
          ? 'Bu neden gösterildi? Sorunda $joined teması tespit edildi.'
          : 'Bu neden gösterildi? Sorunda $joined temaları tespit edildi.',
      TopicResultLocale.en => isSingleTheme
          ? 'Why was this shown? Your query matched the $joined theme.'
          : 'Why was this shown? Your query matched the $joined themes.',
      TopicResultLocale.ar => isSingleTheme
          ? 'لماذا ظهر هذا؟ تم رصد موضوع $joined في سؤالك.'
          : 'لماذا ظهر هذا؟ تم رصد موضوعات $joined في سؤالك.',
    };
  }
}
