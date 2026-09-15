/// Arabic preprocessing for the on-device Quran topic matcher.
///
/// The output is a disposable search key only. It must never be written back
/// to Quran, meal, dua, hadith, or any other governed religious source text.
/// Normalization is intentionally narrow: comparison-only harakat/tatweel
/// removal and alef-shape convergence, as required by the product spec.
abstract final class ArabicTopicQueryNormalizer {
  static final RegExp _harakat = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]',
  );

  // Android keyboards, browsers and copied RTL text may inject invisible
  // shaping/direction metadata. None of these code points carries topic-query
  // meaning, so they are removed rather than allowed to create visually
  // identical but byte-different search keys.
  static final RegExp _formatControls = RegExp(
    r'[\u061C\u200B-\u200F\u202A-\u202E\u2060\u2066-\u2069\uFEFF]',
  );

  static final RegExp _punctuation = RegExp(
    r'''[!"#$%&'()*+,\-./:;<=>?@\[\\\]^_`{|}~،؛؟۔٪٫٬]''',
  );

  static String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var value = input;

    // Comparison-only diacritic removal. The canonical Quran source is never
    // passed through this API and therefore remains byte-for-byte untouched.
    value = value.replaceAll(_harakat, '');
    value = value.replaceAll('\u0640', ''); // Arabic tatweel / kashida.

    // Converge the common alef forms for matching only. Hamza-bearing letters
    // such as waw/ya are deliberately not rewritten because SPEC only asks for
    // alef variants and broader rewriting could change user intent.
    value = value
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا');

    // Direction, zero-width shaping and BOM controls are presentation metadata,
    // not query meaning. Deleting them preserves logical token order while
    // preventing hidden RTL/LTR controls from producing distinct search keys.
    value = value.replaceAll(_formatControls, '');

    // Punctuation becomes a boundary rather than being deleted so separate
    // Arabic words can never be accidentally concatenated during matching.
    value = value.replaceAll(_punctuation, ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();

    return value;
  }
}
