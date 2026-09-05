import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_interfaith_comparison.dart';

void main() {
  const islamicRef = ProphetComparisonReference(
    stableId: 'quran-4-157-158',
    tradition: ProphetComparisonTradition.islamic,
    title: 'Tanzil Quran',
    locator: 'Quran 4:157-158',
    licenseId: 'CC-BY-3.0',
  );
  const christianRef = ProphetComparisonReference(
    stableId: 'gospels-crucifixion',
    tradition: ProphetComparisonTradition.christian,
    title: 'Canonical Gospel references',
    locator: 'Matthew 27:35; John 19:18',
    licenseId: 'REFERENCE-ONLY',
  );
  const text = LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR');

  ProphetInterfaithComparison build({
    ProphetComparisonTradition tradition = ProphetComparisonTradition.christian,
    List<ProphetComparisonReference> islamicSources = const <ProphetComparisonReference>[islamicRef],
    List<ProphetComparisonReference> comparisonSources = const <ProphetComparisonReference>[christianRef],
  }) {
    return ProphetInterfaithComparison(
      canonicalProphetId: 'isa',
      topicId: 'crucifixion-account',
      islamicPerspective: text,
      comparisonPerspective: text,
      comparisonTradition: tradition,
      islamicSources: islamicSources,
      comparisonSources: comparisonSources,
      separationNotice: text,
    );
  }

  test('T0195 production comparison dataset stays valid and opt-in', () {
    expect(prophetInterfaithComparisonsAreValid, isTrue);
    expect(prophetInterfaithComparisons, hasLength(1));
    expect(prophetInterfaithComparisons.single.canonicalProphetId, 'isa');
  });

  test('Islamic and comparison source layers cannot be swapped', () {
    expect(
      build(islamicSources: const <ProphetComparisonReference>[christianRef]).isValid,
      isFalse,
    );
    expect(
      build(comparisonSources: const <ProphetComparisonReference>[islamicRef]).isValid,
      isFalse,
    );
  });

  test('comparison tradition cannot masquerade as Islamic perspective', () {
    expect(
      build(
        tradition: ProphetComparisonTradition.islamic,
        comparisonSources: const <ProphetComparisonReference>[islamicRef],
      ).isValid,
      isFalse,
    );
  });

  test('duplicate source identity across layers fails closed', () {
    const duplicateAcrossLayers = ProphetComparisonReference(
      stableId: 'quran-4-157-158',
      tradition: ProphetComparisonTradition.christian,
      title: 'External reference',
      locator: 'John 19:18',
      licenseId: 'REFERENCE-ONLY',
    );
    expect(
      build(
        comparisonSources: const <ProphetComparisonReference>[
          duplicateAcrossLayers,
        ],
      ).isValid,
      isFalse,
    );
  });

  test('missing bibliographic locator fails closed', () {
    const missingLocator = ProphetComparisonReference(
      stableId: 'gospels',
      tradition: ProphetComparisonTradition.christian,
      title: 'Canonical Gospel references',
      locator: ' ',
      licenseId: 'REFERENCE-ONLY',
    );
    expect(
      build(
        comparisonSources: const <ProphetComparisonReference>[missingLocator],
      ).isValid,
      isFalse,
    );
  });
}
