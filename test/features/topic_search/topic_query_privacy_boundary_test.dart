import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_stop_words.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_scorer.dart';

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
    test('TR EN AR full lexical pipeline creates zero outbound HTTP clients', () {
      final overrides = _FailOnHttpOverrides();
      final printedLines = <String>[];
      const rawQueries = <(String, TopicQueryLanguage)>[
        ('Borç yüzünden çok kaygılıyım, ne yapacağım?', TopicQueryLanguage.tr),
        ('I feel anxious because of debt; what should I do?', TopicQueryLanguage.en),
        ('أشعر بالقلق بسبب الدَّين، ماذا أفعل؟', TopicQueryLanguage.ar),
      ];
      final themes = <TopicThemeSignalSet>[
        TopicThemeSignalSet(
          themeId: 'anxiety',
          tokenSignals: const <String>['kaygili', 'anxious', 'القلق'],
        ),
        TopicThemeSignalSet(
          themeId: 'debt',
          tokenSignals: const <String>['borc', 'debt', 'الدين'],
        ),
      ];

      final results = runZoned(
        () => HttpOverrides.runZoned(
          () => rawQueries.map((entry) {
            final tokens = TopicStopWords.contentTokensFromRawQuery(
              entry.$1,
              entry.$2,
            );
            return TopicThemeScorer.score(
              queryTokens: tokens,
              themes: themes,
              minimumScore: 0,
            );
          }).toList(growable: false),
          createHttpClient: overrides.createHttpClient,
        ),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) => printedLines.add(line),
        ),
      );

      expect(results, hasLength(3));
      expect(results, everyElement(predicate<TopicThemeScoringResult>(
        (result) => result.matches.isNotEmpty,
      )));
      expect(overrides.createClientAttempts, 0);
      expect(printedLines, isEmpty);
      for (final entry in rawQueries) {
        expect(printedLines.any((line) => line.contains(entry.$1)), isFalse);
      }
    });

    test('topic-search production source has no network, ad, analytics or log sink', () {
      final domainDirectory = Directory('lib/features/topic_search');
      expect(domainDirectory.existsSync(), isTrue);

      const forbiddenSourceTokens = <String>[
        "import 'dart:io'",
        "import 'dart:developer'",
        'package:http/',
        'package:dio/',
        'firebase_analytics',
        'firebase_crashlytics',
        'google_mobile_ads',
        'sentry_flutter',
        'amplitude_flutter',
        'Uri.http(',
        'Uri.https(',
        'HttpClient(',
        'Socket.connect(',
        'RawSocket.connect(',
        'WebSocket.connect(',
        'debugPrint(',
        'print(',
        'developer.log(',
        'logEvent(',
        'recordError(',
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

    test('pubspec has no general network, ad, analytics or remote crash SDK dependency', () {
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

    test('privacy audit covers the whole production topic-search tree', () {
      final dartFiles = Directory('lib/features/topic_search')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .map((file) => file.path)
          .toList(growable: false);

      expect(dartFiles, isNotEmpty);
      expect(dartFiles.any((path) => path.endsWith('topic_theme_scorer.dart')), isTrue);
      expect(dartFiles.any((path) => path.endsWith('topic_crisis_safety_gate.dart')), isTrue);
      expect(dartFiles.any((path) => path.endsWith('topic_verse_result_resolver.dart')), isTrue);
    });
  });
}
