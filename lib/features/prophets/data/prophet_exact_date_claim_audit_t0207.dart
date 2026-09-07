import 'canonical_prophet_biographies.dart';

/// T0207 fail-closed scan for unstructured calendar-year claims in prophet
/// biography prose.
///
/// Prophet chronology is deliberately structured as approximate/unknown unless
/// exact evidence exists. A calendar year embedded directly in biography prose
/// bypasses that structured certainty model, so this audit rejects such claims
/// before release QA can treat the draft as clean.
final class ProphetExactDateClaimAuditT0207 {
  const ProphetExactDateClaimAuditT0207();

  static final RegExp _latinPrefix = RegExp(
    r'\b(?:MÖ|M\.Ö\.|MS|M\.S\.|BC|BCE|AD|CE|AH|H\.)\s*\d{2,4}\b',
    caseSensitive: false,
  );
  static final RegExp _latinSuffix = RegExp(
    r'\b\d{2,4}\s*(?:MÖ|M\.Ö\.|MS|M\.S\.|BC|BCE|AD|CE|AH|H\.)\b',
    caseSensitive: false,
  );
  static final RegExp _wordedCalendarYear = RegExp(
    r'\b(?:miladi|gregorian|hijri|hicri)\s+(?:year\s+)?\d{2,4}\b|\b\d{2,4}\s+(?:miladi|gregorian|hijri|hicri)\b',
    caseSensitive: false,
  );
  static final RegExp _arabicCalendarYear = RegExp(
    r'(?:عام|سنة)\s*[0-9٠-٩]{2,4}\s*(?:ق\.?\s*م\.?|م|هـ|ميلادي(?:ة)?|هجري(?:ة)?)|[0-9٠-٩]{2,4}\s*(?:ق\.?\s*م\.?|م|هـ|ميلادي(?:ة)?|هجري(?:ة)?)',
  );

  List<String> audit(Iterable<CanonicalProphetBiographyDraft> drafts) {
    final errors = <String>[];
    for (final draft in drafts) {
      for (final entry in draft.sections.entries) {
        final field = entry.value;
        final texts = <String>[
          field.text.tr,
          field.text.en,
          field.text.ar,
        ];
        for (final text in texts) {
          if (_containsUnstructuredCalendarYear(text)) {
            errors.add(
              '${draft.identity.canonicalId}/${entry.key.name}: '
              'unstructured exact calendar-year claim in biography prose',
            );
            break;
          }
        }
      }
    }
    return List.unmodifiable(errors);
  }

  bool _containsUnstructuredCalendarYear(String text) =>
      _latinPrefix.hasMatch(text) ||
      _latinSuffix.hasMatch(text) ||
      _wordedCalendarYear.hasMatch(text) ||
      _arabicCalendarYear.hasMatch(text);
}
