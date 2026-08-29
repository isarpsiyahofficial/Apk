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

  static final RegExp _bidiControls = RegExp(
    r'[\u200E\u200F\u202A-\u202E\u2066-\u2069]',
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

    // Directional formatting marks are presentation metadata, not query
    // meaning. Removing them avoids invisible RTL/LTR controls creating
    // different search keys while preserving the user's logical word order.
    value = value.replaceAll(_bidiControls, '');
    value = value.replaceAll(_punctuation, ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();

    return value;
  }
}
