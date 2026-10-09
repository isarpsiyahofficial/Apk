import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/privacy/crash_diagnostic_redactor_t0301.dart';

void main() {
  const redactor = CrashDiagnosticRedactorT0301();

  test('T0301 allows bounded machine-only crash metadata', () {
    final sanitized = redactor.sanitize(
      code: 'storage_integrity_failure',
      component: 'trusted_content_store',
      fingerprint: 'sha256:deadbeef',
    );

    expect(sanitized.code, 'storage_integrity_failure');
    expect(sanitized.component, 'trusted_content_store');
    expect(sanitized.fingerprint, 'sha256:deadbeef');
  });

  test('T0301 rejects free-form user question text', () {
    expect(
      () => redactor.sanitize(
        code: 'query_failure',
        component: 'topic_search',
        fingerprint: 'Kendimi çok kötü hissediyorum ne yapmalıyım?',
      ),
      throwsArgumentError,
    );
  });

  test('T0301 rejects note and religious-interest text', () {
    expect(
      () => redactor.sanitize(
        code: 'note_failure',
        component: 'notes',
        fingerprint: 'Yasin suresini her gece okumayı not ettim',
      ),
      throwsArgumentError,
    );
  });

  test('T0301 rejects multiline exception or stack payloads', () {
    expect(
      () => redactor.sanitize(
        code: 'runtime_error',
        component: 'daily',
        fingerprint: 'Exception: raw user text\n#0 stack frame',
      ),
      throwsArgumentError,
    );
  });
}
