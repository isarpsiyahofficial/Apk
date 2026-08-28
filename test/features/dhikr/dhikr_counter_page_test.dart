import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_counter_repository.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_history_repository.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_counter_page.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_feedback.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class _MemoryStore implements PrivateUserStore {
  final Map<String, String> values = {};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;
  @override
  Future<void> clear() async => values.clear();
  @override
  Future<void> delete(String key) async => values.remove(key);
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

final class _FakeFeedbackPlayer implements DhikrFeedbackPlayer {
  int vibrationCalls = 0;
  int soundCalls = 0;

  @override
  Future<void> playSound() async {
    soundCalls += 1;
  }

  @override
  Future<void> vibrate() async {
    vibrationCalls += 1;
  }
}

Widget _app({
  required Locale locale,
  required DhikrCounterRepository repository,
  DhikrHistoryRepository? historyRepository,
  DhikrFeedbackPlayer? feedbackPlayer,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SafeArea(
        child: DhikrCounterPage(
          repository: repository,
          historyRepository: historyRepository,
          feedbackPlayer: feedbackPlayer ?? const SystemDhikrFeedbackPlayer(),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('large touch target increments and persists', (tester) async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    await tester.pumpWidget(
      _app(locale: const Locale('tr'), repository: repository),
    );
    await tester.pumpAndSettle();

    final target = find.byKey(const ValueKey('dhikr-counter-tap-area'));
    expect(target, findsOneWidget);
    expect(tester.getSize(target).height, greaterThanOrEqualTo(240));

    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect((await repository.load()).count, 1);
  });

  testWidgets('saving session updates local-only summary and resets counter',
      (tester) async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    final history = DhikrHistoryRepository(
      store,
      now: () => DateTime(2026, 8, 28, 12),
    );
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        repository: repository,
        historyRepository: history,
      ),
    );
    await tester.pumpAndSettle();

    final target = find.byKey(const ValueKey('dhikr-counter-tap-area'));
    for (var i = 0; i < 3; i += 1) {
      await tester.tap(target);
      await tester.pumpAndSettle();
    }
    expect((await repository.load()).count, 3);

    final save = find.byKey(const ValueKey('dhikr-save-session'));
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect((await repository.load()).count, 0);
    final summary = await history.summary(now: DateTime(2026, 8, 28, 18));
    expect(summary.todayTotal, 3);
    expect(summary.lastSevenDaysTotal, 3);
    expect(summary.currentStreakDays, 1);
    expect(summary.entries, hasLength(1));
    expect(find.byKey(const ValueKey('dhikr-history-summary')), findsOneWidget);
  });

  testWidgets('vibration and sound are separate opt-in behavior', (tester) async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    final feedback = _FakeFeedbackPlayer();
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        repository: repository,
        feedbackPlayer: feedback,
      ),
    );
    await tester.pumpAndSettle();

    final target = find.byKey(const ValueKey('dhikr-counter-tap-area'));
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(feedback.vibrationCalls, 0);
    expect(feedback.soundCalls, 0);

    final vibrationToggle =
        find.byKey(const ValueKey('dhikr-vibration-toggle'));
    await tester.ensureVisible(vibrationToggle);
    await tester.tap(vibrationToggle);
    await tester.pumpAndSettle();
    var state = await repository.load();
    expect(state.vibrationEnabled, isTrue);
    expect(state.soundEnabled, isFalse);

    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(feedback.vibrationCalls, 1);
    expect(feedback.soundCalls, 0);

    final soundToggle = find.byKey(const ValueKey('dhikr-sound-toggle'));
    await tester.ensureVisible(soundToggle);
    await tester.tap(soundToggle);
    await tester.pumpAndSettle();
    state = await repository.load();
    expect(state.vibrationEnabled, isTrue);
    expect(state.soundEnabled, isTrue);

    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(feedback.vibrationCalls, 2);
    expect(feedback.soundCalls, 1);
  });

  testWidgets('Arabic RTL survives narrow screen with 1.6x text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = DhikrCounterRepository(_MemoryStore());
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: _app(locale: const Locale('ar'), repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('العداد الشخصي'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final list = find.byType(ListView);
    expect(list, findsOneWidget);
    await tester.drag(list, const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('dhikr-vibration-toggle')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dhikr-sound-toggle')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet layout renders without overflow', (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = DhikrCounterRepository(_MemoryStore());
    await tester.pumpWidget(
      _app(locale: const Locale('en'), repository: repository),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personal Counter'), findsOneWidget);
    expect(find.text('Personal progress'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
