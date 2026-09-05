import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final zakariya = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'zakariya',
  );

  test('T0194 Zakariya community stays inside Quran 19:11 evidence', () {
    final field = zakariya.sections[ProphetBiographySectionKey.community]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-zakariya-q19-11-community',
    );
    expect(field.sources.single.locator, 'Quran 19:11');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('kavminin/toplumunun'));
    expect(field.text.en, contains('to his people'));
    expect(field.text.ar, contains('على قومه'));

    expect(field.text.tr, contains('etnik, kabilevî veya şehir adı vermez'));
    expect(field.text.en, contains('does not additionally assign'));
    expect(field.text.ar, contains('اسمًا عرقيًا أو قبليًا'));

    expect(prophetBiographyT0194DraftHasTraceableProvenance(zakariya), isTrue);
  });

  test('T0194 Zakariya Quran 19:11 reference remains deduplicated', () {
    final matches = zakariya.quranReferences
        .where((reference) => reference.surah == 19 && reference.ayah == 11)
        .toList(growable: false);

    expect(matches, hasLength(1));
  });

  test('T0194 Zakariya unresolved fields remain pending research', () {
    expect(
      zakariya.sections.values.any(
        (field) =>
            field.status == ProphetBiographyFieldStatus.unknownPendingResearch,
      ),
      isTrue,
    );
  });
}
