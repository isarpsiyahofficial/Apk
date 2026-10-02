import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/presentation/runtime_religious_share_card_t0243.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CanonicalQuranDataset canonicalDataset;

  setUpAll(() async {
    canonicalDataset = await CanonicalQuranAssetLoader().load();
  });

  ReligiousContentRecord publishedDua({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
    ReligiousSourceClass sourceStatus = ReligiousSourceClass.sahihHasanHadith,
    ContentType type = ContentType.dua,
  }) {
    return ReligiousContentRecord(
      id: 'dua:verified:1',
      type: type,
      sourceStatus: sourceStatus,
      version: 1,
      reviewStatus: reviewStatus,
      certainty: CertaintyLevel.stronglyAttested,
      text: const LocalizedReligiousText(
        tr: 'Doğrulanmış dua metni',
        en: 'Verified dua text',
        ar: 'نص دعاء موثق',
      ),
      sources: const [
        SourceReference(
          id: 'hadith:source:1',
          title: 'Verified source',
          sourceClass: ReligiousSourceClass.sahihHasanHadith,
          licenseId: 'reviewed-license',
          locator: 'Ref 1',
        ),
      ],
      lastReviewedAt: DateTime.utc(2026, 9, 1),
      reviewer: 'reviewed',
    );
  }

  ReligiousContentRecord publishedQuranLookalike() {
    return ReligiousContentRecord(
      id: 'quran:2:255',
      type: ContentType.quranVerse,
      sourceStatus: ReligiousSourceClass.quran,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.stronglyAttested,
      text: const LocalizedReligiousText(
        tr: 'Elle girilmiş Kur’an benzeri metin',
        en: 'Manually injected Quran-like text',
        ar: 'نص يدوي غير مأخوذ من مجموعة القرآن المثبتة',
      ),
      sources: const [
        SourceReference(
          id: 'quran:lookalike:2:255',
          title: 'Quran',
          sourceClass: ReligiousSourceClass.quran,
          licenseId: 'reviewed-license',
          locator: '2:255',
        ),
      ],
      lastReviewedAt: DateTime.utc(2026, 9, 1),
      reviewer: 'reviewed',
    );
  }

  test('T0243 accepts Quran text only through verified canonical dataset', () {
    final expected = canonicalDataset.ayah(1, 1);
    final content = RuntimeReligiousShareContentT0243.fromCanonicalQuranDataset(
      dataset: canonicalDataset,
      sura: 1,
      ayah: 1,
    );

    expect(content.contentId, 'quran:1:1');
    expect(content.text, expected.arabic);
    expect(content.sourceClass, ReligiousSourceClass.quran);
    expect(content.sourceLabel, 'Quran 1:1');
  });

  test('T0243 rejects Quran coordinates outside verified dataset bounds', () {
    expect(
      () => RuntimeReligiousShareContentT0243.fromCanonicalQuranDataset(
        dataset: canonicalDataset,
        sura: 1,
        ayah: 8,
      ),
      throwsRangeError,
    );
    expect(
      () => RuntimeReligiousShareContentT0243.fromCanonicalQuranDataset(
        dataset: canonicalDataset,
        sura: 115,
        ayah: 1,
      ),
      throwsRangeError,
    );
  });

  test('T0243 rejects published-record Quran lookalikes', () {
    final record = publishedQuranLookalike();
    expect(record.canEnterProductionDataset, isTrue);

    expect(
      () => RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: record,
        locale: ShareContentLocaleT0243.ar,
      ),
      throwsStateError,
    );
  });

  test('T0243 selects locale text only from published governed record', () {
    final record = publishedDua();

    final tr = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: record,
      locale: ShareContentLocaleT0243.tr,
    );
    final ar = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: record,
      locale: ShareContentLocaleT0243.ar,
    );

    expect(tr.text, 'Doğrulanmış dua metni');
    expect(ar.text, 'نص دعاء موثق');
    expect(tr.sourceLabel, 'Verified source · Ref 1');
  });

  test('draft, unknown-source and unrelated records fail closed', () {
    expect(
      () => RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: publishedDua(reviewStatus: ContentReviewStatus.draft),
        locale: ShareContentLocaleT0243.tr,
      ),
      throwsStateError,
    );
    expect(
      () => RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: publishedDua(sourceStatus: ReligiousSourceClass.unknown),
        locale: ShareContentLocaleT0243.tr,
      ),
      throwsStateError,
    );
    expect(
      () => RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: publishedDua(type: ContentType.historyEvent),
        locale: ShareContentLocaleT0243.tr,
      ),
      throwsStateError,
    );
  });

  testWidgets('share card renders verified text above visual background', (
    tester,
  ) async {
    final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: publishedDua(),
      locale: ShareContentLocaleT0243.en,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 270,
          child: RuntimeReligiousShareCardT0243(
            format: ShareCanvasFormatT0242.instagramPost45,
            background: const SizedBox.expand(key: ValueKey('visual-background')),
            content: content,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('visual-background')), findsOneWidget);
    expect(find.text('Verified dua text'), findsOneWidget);
    expect(find.text('Verified source · Ref 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
