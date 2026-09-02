import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/notifications/domain/notification_content_policy_t0296.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/features/widgets/domain/home_widget_content_t0297.dart';

void main() {
  group('T0297 home widget religious-content boundary', () {
    test('FREE and PRO receive identical religious content', () async {
      final coordinator = _coordinator(_publishedDua());
      final free = await coordinator.buildSnapshot(
        civilDate: DateTime(2030, 1, 2), languageCode: 'tr', hasLifetimePro: false,
      );
      final pro = await coordinator.buildSnapshot(
        civilDate: DateTime(2030, 1, 2), languageCode: 'tr', hasLifetimePro: true,
      );

      expect(free.civilDateKey, '2030-01-02');
      expect(pro.civilDateKey, free.civilDateKey);
      expect(free.verse.address.key, pro.verse.address.key);
      expect(free.duaId, pro.duaId);
      expect(free.duaText, pro.duaText);
      expect(free.proVisualsEnabled, isFalse);
      expect(pro.proVisualsEnabled, isTrue);
    });

    test('civil date key is zero-padded and ignores time of day', () async {
      final snapshot = await _coordinator(_publishedDua()).buildSnapshot(
        civilDate: DateTime(2031, 3, 4, 23, 59, 58),
        languageCode: 'tr',
        hasLifetimePro: false,
      );
      expect(snapshot.civilDateKey, '2031-03-04');
    });

    test('widget content remains teaser/reference-safe for offline surfaces', () async {
      final snapshot = await _coordinator(_publishedDua()).buildSnapshot(
        civilDate: DateTime(2030, 1, 2), languageCode: 'en', hasLifetimePro: false,
      );
      expect(snapshot.contentExposure,
          NotificationContentExposureT0296.teaserReferenceOnly);
    });

    test('AR uses reviewed Arabic dua and preserves Quran Arabic', () async {
      final snapshot = await _coordinator(_publishedDua()).buildSnapshot(
        civilDate: DateTime(2030, 1, 2), languageCode: 'ar', hasLifetimePro: false,
      );
      expect(snapshot.duaText, 'دعاء عربي');
      expect(snapshot.verse.arabic, 'نص الآية');
    });

    test('unsupported locale fails closed before content exposure', () async {
      expect(
        () => _coordinator(_publishedDua()).buildSnapshot(
          civilDate: DateTime(2030, 1, 2), languageCode: 'de', hasLifetimePro: false,
        ),
        throwsUnsupportedError,
      );
    });

    test('non-production dua is rejected', () async {
      expect(
        () => _coordinator(_publishedDua(reviewStatus: ContentReviewStatus.draft))
            .buildSnapshot(
          civilDate: DateTime(2030, 1, 2), languageCode: 'tr', hasLifetimePro: false,
        ),
        throwsStateError,
      );
    });
  });
}

HomeWidgetContentCoordinatorT0297 _coordinator(DuaContent dua) =>
    HomeWidgetContentCoordinatorT0297(
      dailyVerseSource: _FakeVerseSource(),
      dailyDuaSource: _FakeDuaSource(dua),
    );

final class _FakeVerseSource implements DailyVerseDataSource {
  @override
  Future<DailyVerse> forDate({required DateTime date, required String languageCode}) async {
    return const DailyVerse(
      address: QuranAddress(surah: 1, ayah: 5),
      arabic: 'نص الآية',
      translation: 'Verified translation',
      surahDisplayName: 'Al-Fatiha',
    );
  }
}

final class _FakeDuaSource implements HomeWidgetDailyDuaSourceT0297 {
  const _FakeDuaSource(this.dua);
  final DuaContent dua;
  @override
  DuaContent forDate(DateTime civilDate) => dua;
}

DuaContent _publishedDua({
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
}) => DuaContent(
  id: 'dua-widget-1',
  sourceStatus: DuaSourceStatus.generalEditorial,
  lengthClass: DuaLengthClass.short,
  categories: const {DuaCategory.gratitude},
  text: const LocalizedReligiousText(
    tr: 'Türkçe dua', en: 'English dua', ar: 'دعاء عربي',
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