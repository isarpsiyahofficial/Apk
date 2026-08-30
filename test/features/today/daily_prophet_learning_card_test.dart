import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';
import 'package:islami_hayat/features/today/presentation/daily_prophet_learning_card.dart';

void main() {
  testWidgets('dispatches canonical prophet id from a source-backed card', (
    tester,
  ) async {
    final suggestion = dailyProphetLearningForDate(DateTime(2026, 8, 30))!;
    String? opened;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DailyProphetLearningCard(
            suggestion: suggestion,
            title: 'Bugün ne öğrenelim?',
            prophetName: suggestion.prophetId,
            sourceLabel: 'Kaynak',
            openLabel: 'Kıssayı aç',
            onOpen: (id) => opened = id,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('daily-prophet-learning-source')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('daily-prophet-learning-open')));
    await tester.pump();
    expect(opened, suggestion.prophetId);
  });

  testWidgets('320px Arabic RTL with 1.6x text scale has no overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final suggestion = dailyProphetLearningForDate(DateTime(2026, 8, 30))!;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: DailyProphetLearningCard(
                  suggestion: suggestion,
                  title: 'ماذا نتعلّم اليوم؟',
                  prophetName: suggestion.prophetId,
                  sourceLabel: 'المصدر',
                  openLabel: 'افتح القصة',
                  onOpen: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('daily-prophet-learning-card')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
