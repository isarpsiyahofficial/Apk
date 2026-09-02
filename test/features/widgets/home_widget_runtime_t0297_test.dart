import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/features/widgets/data/android_home_widget_bridge_t0297.dart';
import 'package:islami_hayat/features/widgets/data/home_widget_runtime_t0297.dart';
import 'package:islami_hayat/features/widgets/domain/home_widget_content_t0297.dart';

void main() {
  group('T0297 production-reviewed widget runtime', () {
    test('dua library adapter rotates deterministically by civil date', () {
      final source = DuaLibraryHomeWidgetSourceT0297(
        DuaLibraryRepository(<DuaContent>[
          _publishedDua(id: 'dua-a', tr: 'Dua A'),
          _publishedDua(id: 'dua-b', tr: 'Dua B'),
        ]),
      );

      final first = source.forDate(DateTime(2030, 1, 2, 1));
      final sameCivilDate = source.forDate(DateTime(2030, 1, 2, 23, 59));
      final nextDay = source.forDate(DateTime(2030, 1, 3, 12));

      expect(sameCivilDate.id, first.id);
      expect(nextDay.id, isNot(first.id));
    });

    test('empty production library fails closed', () {
      final source = DuaLibraryHomeWidgetSourceT0297(
        DuaLibraryRepository(const <DuaContent>[]),
      );

      expect(
        () => source.forDate(DateTime(2030, 1, 2)),
        throwsStateError,
      );
    });

    test('non-production dua cannot enter runtime source', () {
      expect(
        () => DuaLibraryRepository(<DuaContent>[
          _publishedDua(
            id: 'draft-dua',
            tr: 'Taslak',
            reviewStatus: ContentReviewStatus.draft,
          ),
        ]),
        throwsStateError,
      );
    });

    test('runtime sync persists the validated snapshot and propagates success', () async {
      final sink = _RecordingSink(result: true);
      final runtime = _runtime(sink);

      final result = await runtime.sync(
        civilDate: DateTime(2030, 1, 2, 15, 30),
        languageCode: 'tr',
        hasLifetimePro: false,
      );

      expect(result, isTrue);
      expect(sink.lastSnapshot, isNotNull);
      expect(sink.lastSnapshot!.civilDateKey, '2030-01-02');
      expect(sink.lastSnapshot!.duaId, 'dua-runtime');
      expect(sink.lastSnapshot!.duaText, 'Güvenilir dua');
      expect(sink.lastSnapshot!.proVisualsEnabled, isFalse);
    });

    test('native persistence failure is not converted into success', () async {
      final sink = _RecordingSink(result: false);
      final result = await _runtime(sink).sync(
        civilDate: DateTime(2030, 1, 2),
        languageCode: 'en',
        hasLifetimePro: true,
      );

      expect(result, isFalse);
      expect(sink.lastSnapshot, isNotNull);
      expect(sink.lastSnapshot!.proVisualsEnabled, isTrue);
    });
  });
}

HomeWidgetRuntimeSyncT0297 _runtime(HomeWidgetSnapshotSinkT0297 sink) {
  final duaSource = DuaLibraryHomeWidgetSourceT0297(
    DuaLibraryRepository(<DuaContent>[
      _publishedDua(id: 'dua-runtime', tr: 'Güvenilir dua'),
    ]),
  );
  return HomeWidgetRuntimeSyncT0297(
    coordinator: HomeWidgetContentCoordinatorT0297(
      dailyVerseSource: _FakeVerseSource(),
      dailyDuaSource: duaSource,
    ),
    sink: sink,
  );
}

final class _FakeVerseSource implements DailyVerseDataSource {
  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    return const DailyVerse(
      address: QuranAddress(surah: 1, ayah: 5),
      arabic: 'نص الآية',
      translation: 'Verified translation',
      surahDisplayName: 'Al-Fatiha',
    );
  }
}

final class _RecordingSink implements HomeWidgetSnapshotSinkT0297 {
  _RecordingSink({required this.result});

  final bool result;
  HomeWidgetSnapshotT0297? lastSnapshot;

  @override
  Future<bool> persistSnapshot(HomeWidgetSnapshotT0297 snapshot) async {
    lastSnapshot = snapshot;
    return result;
  }
}

DuaContent _publishedDua({
  required String id,
  required String tr,
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
}) =>
    DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.generalEditorial,
      lengthClass: DuaLengthClass.short,
      categories: const {DuaCategory.gratitude},
      text: LocalizedReligiousText(
        tr: tr,
        en: 'Reviewed English dua',
        ar: 'دعاء عربي مراجع',
      ),
      reviewStatus: reviewStatus,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 1),
      sources: const [
        SourceReference(
          id: 'editorial-review',
          title: 'Editorial review',
          sourceClass: ReligiousSourceClass.meaningBasedDua,
          licenseId: 'internal-reviewed',
        ),
      ],
    );
