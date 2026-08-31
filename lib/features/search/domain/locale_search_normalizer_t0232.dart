import 'device_search_index_t0230.dart';

enum SearchLocaleT0232 { tr, en, ar }

SearchTextNormalizerT0230 localeAwareSearchNormalizerT0232(
  SearchLocaleT0232 locale,
) {
  return (value) => normalizeSearchTextT0232(value, locale: locale);
}

/// Search-only locale normalization for T0232.
///
/// This function never mutates canonical Quran/religious source data. It only
/// produces an ephemeral index/query representation. Arabic harakat, Quranic
/// annotation marks and tatweel are ignored for lookup; common alif/hamza and
/// seat variants are collapsed so unvocalized user queries can match indexed
/// Arabic text. Turkish casing explicitly preserves dotted/dotless-I rules.
String normalizeSearchTextT0232(
  String value, {
  required SearchLocaleT0232 locale,
}) {
  var normalized = value.trim();
  if (normalized.isEmpty) return '';

  switch (locale) {
    case SearchLocaleT0232.tr:
      normalized = normalized
          .replaceAll('İ', 'i')
          .replaceAll('I', 'ı')
          .toLowerCase();
    case SearchLocaleT0232.en:
      normalized = normalized.toLowerCase();
    case SearchLocaleT0232.ar:
      normalized = normalized.toLowerCase();
      normalized = _normalizeArabicSearchForm(normalized);
  }

  normalized = normalized
      .replaceAll(
        RegExp(
          r'''[\u060C\u061B\u061F\u2013\u2014,.;:!?()\[\]{}"'“”‘’/\\|_-]+''',
        ),
        ' ',
      )
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  return normalized;
}

String _normalizeArabicSearchForm(String value) {
  return value
      // Tatweel and Arabic combining vowel/Quranic annotation marks.
      .replaceAll('\u0640', '')
      .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      // Common orthographic variants used by users when typing searches.
      .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}
