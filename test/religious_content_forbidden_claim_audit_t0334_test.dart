import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/forbidden_religious_claim_audit_t0334.dart';

void main() {
  test('T0334 blocks guaranteed money/love/healing and personal-answer claims', () {
    const unsafe = <String>[
      'Bu zikri söylemek kesin para getirir.',
      'Bu uygulama Allah sana bunu söyledi der.',
      'Reciting this guarantees healing.',
      'This verse is your definite answer.',
      'هذا الذكر يضمن الشفاء.',
      'هذا جواب الله لك.',
    ];

    for (final text in unsafe) {
      expect(
        ForbiddenReligiousClaimAuditT0334.containsForbiddenClaim(text),
        isTrue,
        reason: text,
      );
    }
  });

  test('T0334 does not reject cautious non-guarantee wording', () {
    const safe = <String>[
      'Bu içerik bir sonuç garantisi vermez; yalnız kaynaklı anlam bağını açıklar.',
      'This content does not promise a worldly outcome.',
      'هذا المحتوى لا يَعِد بنتيجة دنيوية مضمونة.',
    ];

    for (final text in safe) {
      expect(
        ForbiddenReligiousClaimAuditT0334.containsForbiddenClaim(text),
        isFalse,
        reason: text,
      );
    }
  });

  test('T0334 scans production religious datasets and fails closed on a hit', () {
    const productionDataDirectories = <String>[
      'lib/features/dua/data',
      'lib/features/dhikr/data',
      'lib/features/religious_days/data',
      'lib/features/prophets/data',
      'lib/features/history/data',
      'lib/features/topic_search/data',
      'lib/features/today/data',
    ];

    ForbiddenReligiousClaimAuditT0334.requireClean(productionDataDirectories);
  });

  test('T0334 scanner reports exact file and line and cannot silently skip hits', () {
    final root = Directory.systemTemp.createTempSync('t0334_claim_audit_');
    addTearDown(() => root.deleteSync(recursive: true));

    final nested = Directory('${root.path}/data')..createSync(recursive: true);
    File('${nested.path}/unsafe.dart').writeAsStringSync(
      "const claim = 'Bu zikir kesin para getirir.';\n",
    );

    final findings = ForbiddenReligiousClaimAuditT0334.auditDirectories(
      <String>[nested.path],
    );

    expect(findings, hasLength(1));
    expect(findings.single.path, endsWith('/unsafe.dart'));
    expect(findings.single.line, 1);
    expect(findings.single.matchedFragment, 'kesin para getirir');
    expect(
      () => ForbiddenReligiousClaimAuditT0334.requireClean(<String>[nested.path]),
      throwsStateError,
    );
  });

  test('T0334 fails closed when a configured dataset directory disappears', () {
    expect(
      () => ForbiddenReligiousClaimAuditT0334.requireClean(
        const <String>['lib/features/__missing_t0334_dataset__'],
      ),
      throwsStateError,
    );
  });
}
