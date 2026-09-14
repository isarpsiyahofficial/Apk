import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/localization/localization_release_evidence_t0340.dart';

void main() {
  const proofFiles = <String, String>{
    'localization_primary_surface_crawl_t0340_t0343_test.dart':
        'test/localization_primary_surface_crawl_t0340_t0343_test.dart',
    'localization_dua_surface_t0344_test.dart':
        'test/localization_dua_surface_t0344_test.dart',
    'premium_value_page_t0279_test.dart':
        'test/features/premium/premium_value_page_t0279_test.dart',
    'app_startup_access_t0262_test.dart':
        'test/app_startup_access_t0262_test.dart',
    'free_connection_drop_t0263_test.dart':
        'test/features/premium/free_connection_drop_t0263_test.dart',
    'notification_settings_page_t0290_test.dart':
        'test/features/notifications/notification_settings_page_t0290_test.dart',
  };

  test('every canonical verified localization proof points to a real test file', () {
    final referenced = <String>{};

    for (final evidence in LocalizationReleaseEvidenceT0340.verified) {
      final proofFileId = evidence.proofId.split('::').first;
      final path = proofFiles[proofFileId];
      expect(
        path,
        isNotNull,
        reason: 'Unknown localization proof file ID: $proofFileId',
      );

      final file = File(path!);
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Localization proof file does not exist: $path',
      );
      expect(
        file.readAsStringSync().trim(),
        isNotEmpty,
        reason: 'Localization proof file is empty: $path',
      );
      referenced.add(proofFileId);
    }

    expect(referenced, proofFiles.keys.toSet());
  });
}
