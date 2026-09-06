import 'package:islami_hayat/core/content/content_governance.dart';

/// Blocks language that turns a meaning/evidence connection into a promised
/// worldly outcome. This is a release guard, not a substitute for religious
/// and native-language review.
final class DhikrOutcomeClaimPolicy {
  const DhikrOutcomeClaimPolicy._();

  static const List<String> _trBlocked = <String>[
    'kesin para getirir',
    'para getirir',
    'kesin zengin eder',
    'zengin eder',
    'kesin âşık eder',
    'âşık eder',
    'asik eder',
    'kişiyi sana bağlar',
    'kisiyi sana baglar',
    'kesin şifa verir',
    'şifa garantisi',
    'hastalığı iyileştirir',
    'hastaligi iyilestirir',
    'sonucu garanti eder',
  ];

  static const List<String> _enBlocked = <String>[
    'guarantees money',
    'brings money',
    'will make you rich',
    'guarantees wealth',
    'will make them love you',
    'makes them love you',
    'binds a person to you',
    'guarantees healing',
    'healing guarantee',
    'cures the disease',
    'guarantees the outcome',
  ];

  static const List<String> _arBlocked = <String>[
    'يضمن المال',
    'يجلب المال حتما',
    'يجلب المال حتمًا',
    'يجعله يحبك حتما',
    'يجعله يحبك حتمًا',
    'يربط الشخص بك',
    'يضمن الشفاء',
    'ضمان الشفاء',
    'يشفي المرض حتما',
    'يشفي المرض حتمًا',
    'يضمن النتيجة',
  ];

  static bool allows(LocalizedReligiousText rationale) {
    return !_containsBlocked(rationale.tr, _trBlocked) &&
        !_containsBlocked(rationale.en, _enBlocked) &&
        !_containsBlocked(rationale.ar, _arBlocked);
  }

  static void requireAllowed(LocalizedReligiousText rationale) {
    if (!allows(rationale)) {
      throw StateError(
        'Dhikr intention content contains a prohibited guaranteed-outcome claim.',
      );
    }
  }

  static bool _containsBlocked(String value, List<String> blocked) {
    final normalized = value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    return blocked.any(normalized.contains);
  }
}
