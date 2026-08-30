import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_quran_reference_validator.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const validator = ProphetQuranReferenceValidator();

  test('all canonical prophet Quran references resolve in pinned ayah DB', () async {
    final result = await validator.validateBundledCanonicalDrafts();

    expect(result.prophetCount, 25);
    expect(result.referenceCount, greaterThanOrEqualTo(25));
  });

  test('rejects an ayah that passes broad model checks but is absent in DB', () async {
    final quran = await CanonicalQuranAssetLoader().load();
    final first = canonicalProphetBiographyDrafts.first;
    final invalid = CanonicalProphetBiographyDraft(
      identity: first.identity,
      quranReferences: const [
        ProphetVerseReference(surah: 1, ayah: 8),
      ],
      sections: first.sections,
    );

    expect(invalid.quranReferences.single.isValid, isTrue);
    expect(
      () => validator.validate(drafts: [invalid], quran: quran),
      throwsA(isA<ProphetQuranReferenceValidationException>()),
    );
  });

  test('rejects duplicate references even when both resolve in ayah DB', () async {
    final quran = await CanonicalQuranAssetLoader().load();
    final first = canonicalProphetBiographyDrafts.first;
    final reference = first.quranReferences.first;
    final invalid = CanonicalProphetBiographyDraft(
      identity: first.identity,
      quranReferences: [reference, reference],
      sections: first.sections,
    );

    expect(
      () => validator.validate(drafts: [invalid], quran: quran),
      throwsA(isA<ProphetQuranReferenceValidationException>()),
    );
  });

  test('rejects an empty cross-validation input', () async {
    final quran = await CanonicalQuranAssetLoader().load();

    expect(
      () => validator.validate(drafts: const [], quran: quran),
      throwsA(isA<ProphetQuranReferenceValidationException>()),
    );
  });
}
