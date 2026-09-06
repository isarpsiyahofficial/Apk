import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final muhammad = canonicalProphetBiographyT0194Dataset.singleWhere(
    (entry) => entry.identity.canonicalId == 'muhammad',
  );

  test('T0194 Muhammad Isra field is pinned to Quran 17:1', () {
    final field = muhammad.sections[ProphetBiographySectionKey.miracles]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-muhammad-q17-1-night-journey');
    expect(field.sources.single.title, 'Tanzil Project — Uthmani Quran Text v1.1');
    expect(field.sources.single.sourceClass, ReligiousSourceClass.quran);
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.sources.single.locator, 'Quran 17:1');
    expect(prophetBiographyT0194DraftHasTraceableProvenance(muhammad), isTrue);
  });

  test('T0194 Muhammad Isra wording stays inside the verse boundary in TR EN AR', () {
    final text = muhammad.sections[ProphetBiographySectionKey.miracles]!.text;

    expect(text.tr, contains('Mescid-i Harâm'));
    expect(text.tr, contains('Mescid-i Aksâ'));
    expect(text.tr, contains('kesin tarih'));
    expect(text.tr, contains('Mi‘rac ayrıntıları'));

    expect(text.en, contains('al-Masjid al-Haram'));
    expect(text.en, contains('al-Masjid al-Aqsa'));
    expect(text.en, contains('no exact date'));
    expect(text.en, contains('Ascension details'));

    expect(text.ar, contains('المسجد الحرام'));
    expect(text.ar, contains('المسجد الأقصى'));
    expect(text.ar, contains('تاريخًا دقيقًا'));
    expect(text.ar, contains('المعراج'));
  });

  test('T0194 Muhammad Quran 17:1 reference is indexed once', () {
    final matches = muhammad.quranReferences
        .where((entry) => entry.surah == 17 && entry.ayah == 1)
        .toList(growable: false);

    expect(matches, hasLength(1));
  });

  test('T0194 Muhammad unresolved period remains fail-closed', () {
    final period = muhammad.sections[ProphetBiographySectionKey.period]!;
    expect(period.status, ProphetBiographyFieldStatus.unknownPendingResearch);
    expect(period.sources, isEmpty);
  });
}
