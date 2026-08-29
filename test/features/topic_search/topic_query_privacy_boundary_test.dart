import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/arabic_topic_query_normalizer.dart';
import 'package:islami_hayat/features/topic_search/domain/english_topic_query_normalizer.dart';
import 'package:islami_hayat/features/topic_search/domain/turkish_topic_query_normalizer.dart';

final class _FailOnHttpOverrides extends HttpOverrides {
  int createClientAttempts = 0;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    createClientAttempts += 1;
    throw StateError('Topic search attempted to create an outbound HTTP client');
  }
}

void main() {
  group('T0163 raw topic query privacy boundary', () {
    test('TR EN AR preprocessing performs zero outbound HTTP attempts', () {
      final overrides = _FailOnHttpOverrides();

      final results = HttpOverrides.runZoned(
        () => <String>[
          TurkishTopicQueryNormalizer.normalize(
            'Kendimi çok yalnız hissediyorum, ne yapacağım?',
          ),
          EnglishTopicQueryNormalizer.normalize(
            'I feel anxious and lonely; what should I do?',
          ),
          ArabicTopicQueryNormalizer.normalize(
            'أشعر بالقلق والوحدة، ماذا أفعل؟',
          ),
        ],
        createHttpClient: overrides.createHttpClient,
      );

      expect(results, everyElement(isNotEmpty));
      expect(overrides.createClientAttempts, 0);
    });

    test('topic-search production source has no network, ad, analytics or log sink', () {
      final domainDirectory = Directory('lib/features/topic_search');
      expect(domainDirectory.existsSync(), isTrue);

      const forbiddenSourceTokens = <String>[
        "import 'dart:io'",
        'package:http/',
        'package:dio/',
        'firebase_analytics',
        'firebase_crashlytics',
        'google_mobile_ads',
        'Uri.http(',
        'Uri.https(',
        'HttpClient(',
        'Socket.connect(',
        'WebSocket.connect(',
        'debugPrint(',
        'print(',
        'developer.log(',
      ];

      final violations = <String>[];
      for (final entity in domainDirectory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final source = entity.readAsStringSync();
        for (final token in forbiddenSourceTokens) {
          if (source.contains(token)) {
            violations.add('${entity.path}: $token');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Raw religious questions must remain inside the on-device '
            'topic-search boundary and must not reach network/ad/analytics/log sinks.',
      );
    });

    test('pubspec has no general network, ad or analytics SDK dependency', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      const forbiddenDependencies = <String>[
        '\n  http:',
        '\n  dio:',
        '\n  firebase_analytics:',
        '\n  firebase_crashlytics:',
        '\n  google_mobile_ads:',
        '\n  sentry_flutter:',
        '\n  amplitude_flutter:',
      ];

      for (final dependency in forbiddenDependencies) {
        expect(
          pubspec.contains(dependency),
          isFalse,
          reason: 'T0163 privacy gate forbids $dependency while raw topic '
              'queries are processed locally.',
        );
      }
    });
  });
}
