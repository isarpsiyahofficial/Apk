import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';

/// T0207 fail-closed scan for calendar-year claims embedded in prophet
/// biography prose.
///
/// Calendar chronology may only appear when it is explicitly presented as an
/// approximation/periodization and backed by a traceable modern-history source.
/// Quran or hadith evidence must never be stretched into an unsupported civil
/// calendar year, and wording that upgrades an approximation into an exact
/// claim remains release-blocking.
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
    r'\b(?:miladi|miladî|gregorian|hijri|hicri)\s+(?:year\s+)?\d{2,4}\b|\b\d{2,4}\s+(?:miladi|miladî|gregorian|hijri|hicri)\b',
    caseSensitive: false,
  );
  static final RegExp _arabicCalendarYear = RegExp(
    r'(?:عام|سنة)\s*[0-9٠-٩]{2,4}\s*(?:ق\.?\s*م\.?|م|هـ|ميلادي(?:ة)?|هجري(?:ة)?)|[0-9٠-٩]{2,4}\s*(?:ق\.?\s*م\.?|م|هـ|ميلادي(?:ة)?|هجري(?:ة)?)',
  );

  static final RegExp _approximationQualifier = RegExp(
    r'\b(?:yaklaşık|tahminen|circa|ca\.|approximately|around|roughly)\b|(?:تقريبًا|تقريبا|نحو|قرابة|تقارب)',
    caseSensitive: false,
  );

  /// Positive exact-year wording is intentionally narrower than a generic
  /// search for words such as `exact`/`kesin`/`قطعي`. Canonical biographies may
  /// contain explicit disclaimers such as "not presented as an exact birth
  /// year" or "kesin bir doğum yılı ... sunulmaz"; those statements lower
  /// certainty and must not themselves trigger this release gate.
  static final RegExp _positiveExactCalendarClaim = RegExp(
    r'(?:\b(?:kesin(?:likle)?|tam\s+olarak)\b.{0,48}(?:MÖ|M\.Ö\.|MS|M\.S\.|BC|BCE|AD|CE|AH|H\.|miladi|miladî|hicri|hijri)?\s*\d{2,4}\b)'
    r'|(?:\b(?:exactly|precisely|definitively)\b.{0,32}(?:in\s+)?\d{2,4}\s*(?:BC|BCE|AD|CE|AH)?\b)'
    r'|(?:[0-9٠-٩]{2,4}\s*(?:ق\.?\s*م\.?|م|هـ|ميلادي(?:ة)?|هجري(?:ة)?)?\s*(?:بالضبط|بدقة))'
    r'|(?:(?:بالضبط|بدقة)\s*(?:عام|سنة)?\s*[0-9٠-٩]{2,4})',
    caseSensitive: false,
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
          if (_containsUnsupportedCalendarYear(text, field)) {
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

  bool _containsUnsupportedCalendarYear(
    String text,
    ProphetBiographyField field,
  ) {
    if (!_containsCalendarYear(text)) return false;

    final hasTraceableModernHistoryEvidence =
        field.status == ProphetBiographyFieldStatus.sourceBacked &&
            field.sources.any(
              (source) =>
                  source.sourceClass ==
                      ReligiousSourceClass.modernHistoryArchaeology &&
                  (source.locator?.trim().isNotEmpty ?? false) &&
                  source.url != null &&
                  source.licenseId.trim().isNotEmpty,
            );
    if (!hasTraceableModernHistoryEvidence) return true;

    if (_positiveExactCalendarClaim.hasMatch(text)) return true;
    return !_approximationQualifier.hasMatch(text);
  }

  bool _containsCalendarYear(String text) =>
      _latinPrefix.hasMatch(text) ||
      _latinSuffix.hasMatch(text) ||
      _wordedCalendarYear.hasMatch(text) ||
      _arabicCalendarYear.hasMatch(text);
}
