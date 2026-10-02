import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  CanonicalProphetBiographyDraft yahya() =>
      canonicalProphetBiographyT0194Dataset.singleWhere(
        (draft) => draft.identity.canonicalId == 'yahya',
      );

  test('Yahya extraordinary birth field keeps exact Quran provenance', () {
    final field = yahya().sections[ProphetBiographySectionKey.miracles]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    final source = field.sources.single;
    expect(source.sourceClass, ReligiousSourceClass.quran);
    expect(
      source.id,
      'tanzil-uthmani-v1.1-yahya-q19-8-9-q21-90-extraordinary-birth',
    );
    expect(source.title, 'Tanzil Project — Uthmani Quran Text v1.1');
    expect(source.licenseId, 'CC-BY-3.0');
    expect(source.locator, 'Quran 19:8-9; 21:90');
    expect(prophetBiographyT0194DraftHasTraceableProvenance(yahya()), isTrue);
  });

  test('Yahya extraordinary birth copy stays within Quranic boundaries', () {
    final text = yahya().sections[ProphetBiographySectionKey.miracles]!.text;

    expect(text.tr, contains('ileri yaşına'));
    expect(text.tr, contains('eşinin kısır'));
    expect(text.tr, contains('Yahyâ'));
    expect(text.en, contains('old age'));
    expect(text.en, contains('wife is barren'));
    expect(text.en, contains('John'));
    expect(text.ar, contains('الكبر'));
    expect(text.ar, contains('عاقر'));
    expect(text.ar, contains('يحيى'));

    final all = '${text.tr} ${text.en} ${text.ar}'.toLowerCase();
    expect(all, isNot(contains('year')));
    expect(all, isNot(contains('century')));
    expect(all, isNot(contains('hükümdar')));
    expect(all, isNot(contains('doktor')));
    expect(all, isNot(contains('medical diagnosis')));
  });

  test('Yahya Quran reference index includes birth verses once each', () {
    final references = yahya().quranReferences;
    for (final stableId in <String>['19:8', '19:9', '21:90']) {
      expect(
        references.where((reference) => reference.stableId == stableId),
        hasLength(1),
        reason: stableId,
      );
    }
  });

  test('unresolved Yahya fields remain pending instead of inferred', () {
    final sections = yahya().sections;
    for (final key in <ProphetBiographySectionKey>[
      ProphetBiographySectionKey.geography,
      ProphetBiographySectionKey.communityResponse,
      ProphetBiographySectionKey.dua,
    ]) {
      expect(
        sections[key]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
        reason: key.name,
      );
    }
  });
}
