/// Sanitized crash diagnostic that can be recorded without carrying user text.
final class SanitizedCrashDiagnosticT0301 {
  const SanitizedCrashDiagnosticT0301({
    required this.code,
    required this.component,
    required this.fingerprint,
  });

  final String code;
  final String component;
  final String fingerprint;
}

/// Fail-closed boundary for any future remote crash reporter.
///
/// Raw exception messages, stack-frame arguments, user questions, notes,
/// dhikr history and religious-interest labels are intentionally excluded from
/// the output type. Only bounded machine identifiers survive the boundary.
final class CrashDiagnosticRedactorT0301 {
  const CrashDiagnosticRedactorT0301();

  static final RegExp _safeToken = RegExp(r'^[A-Za-z0-9_.:-]{1,80}$');

  SanitizedCrashDiagnosticT0301 sanitize({
    required String code,
    required String component,
    required String fingerprint,
  }) {
    _requireSafeToken(code, 'code');
    _requireSafeToken(component, 'component');
    _requireSafeToken(fingerprint, 'fingerprint');

    return SanitizedCrashDiagnosticT0301(
      code: code,
      component: component,
      fingerprint: fingerprint,
    );
  }

  void _requireSafeToken(String value, String field) {
    if (!_safeToken.hasMatch(value)) {
      throw ArgumentError.value(
        value,
        field,
        'must be a bounded machine identifier; free-form text is forbidden',
      );
    }
  }
}
