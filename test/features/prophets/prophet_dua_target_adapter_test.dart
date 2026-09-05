import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_deep_links.dart';
import 'package:islami_hayat/features/prophets/domain/prophet_dua_target_adapter.dart';

DuaContent _reviewedDua(String id) => DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: const {DuaCategory.repentance},
      text: const LocalizedReligiousText(
        tr: 'Rabbimiz, kendimize zulmettik.',
        en: 'Our Lord, we have wronged ourselves.',
        ar: 'ربنا ظلمنا أنفسنا',
      ),
      reviewStatus: ContentReviewStatus.published,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 30),
      sources: const [
        SourceReference(
          id: 'tanzil-q7-23-fixture',
          title: 'Tanzil Quran fixture',
          sourceClass: ReligiousSourceClass.quran,
          licenseId: 'CC-BY-3.0',
          locator: 'Quran 7:23',
        ),
      ],
    );

void main() {
  test('resolves exact stable dua id only from reviewed production library', () {
    final dua = _reviewedDua('adam-q7-23');
    final adapter = ProphetDuaTargetAdapter(DuaLibraryRepository([dua]));
    final link = ProphetDeepLink.dua(
      prophetId: 'adam',
      duaId: 'adam-q7-23',
    );

    expect(adapter.canOpen(link), isTrue);
    expect(adapter.resolve(link), same(dua));
  });

  test('missing target id fails closed without text or prophet-name fallback', () {
    final adapter = ProphetDuaTargetAdapter(
      DuaLibraryRepository([_reviewedDua('adam-q7-23')]),
    );
    final link = ProphetDeepLink.dua(
      prophetId: 'adam',
      duaId: 'invented-adam-dua',
    );

    expect(adapter.canOpen(link), isFalse);
    expect(adapter.resolve(link), isNull);
  });

  test('non-dua deep link cannot be resolved by dua adapter', () {
    final adapter = ProphetDuaTargetAdapter(
      DuaLibraryRepository([_reviewedDua('adam-q7-23')]),
    );
    final link = ProphetDeepLink.quranVerse(
      prophetId: 'adam',
      verse: const ProphetVerseReference(surah: 7, ayah: 23),
    );

    expect(adapter.resolve(link), isNull);
  });

  test('open dispatches exact reviewed record and reports success', () async {
    final dua = _reviewedDua('adam-q7-23');
    final adapter = ProphetDuaTargetAdapter(DuaLibraryRepository([dua]));
    final link = ProphetDeepLink.dua(
      prophetId: 'adam',
      duaId: 'adam-q7-23',
    );
    DuaContent? opened;

    final result = await adapter.open(
      link,
      onOpen: (record) async => opened = record,
    );

    expect(result, isTrue);
    expect(opened, same(dua));
  });

  test('open does not call destination when reviewed target is unavailable', () async {
    final adapter = ProphetDuaTargetAdapter(
      DuaLibraryRepository([_reviewedDua('adam-q7-23')]),
    );
    var called = false;

    final result = await adapter.open(
      ProphetDeepLink.dua(prophetId: 'nuh', duaId: 'missing-reviewed-dua'),
      onOpen: (_) async => called = true,
    );

    expect(result, isFalse);
    expect(called, isFalse);
  });
}
