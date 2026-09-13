import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_interfaith_comparison.dart';

void main() {
  const islamicRef = ProphetComparisonReference(
    stableId: 'quran-4-157-158-isa-crucifixion',
    tradition: ProphetComparisonTradition.islamic,
    title: 'Tanzil Project — Quran Uthmani v1.1',
    locator: 'Quran 4:157-158',
    licenseId: 'CC-BY-3.0',
    sourceUrl: 'https://tanzil.net/docs/Text_License',
  );
  const christianRef = ProphetComparisonReference(
    stableId: 'world-english-bible-2020-isa-crucifixion',
    tradition: ProphetComparisonTradition.christian,
    title: 'World English Bible — 2020 stable text edition',
    locator: 'Matthew 27:35; Mark 15:24; Luke 23:33; John 19:18',
    licenseId: 'PUBLIC-DOMAIN',
    sourceUrl: 'https://ebible.org/engwebp/',
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
    expect(
      prophetInterfaithComparisonHasApprovedProvenance(
        prophetInterfaithComparisons.single,
      ),
      isTrue,
    );
  });

  test('production source metadata stays exact and licensed', () {
    final entry = prophetInterfaithComparisons.single;
    final islamic = entry.islamicSources.single;
    final christian = entry.comparisonSources.single;

    expect(islamic.title, 'Tanzil Project — Quran Uthmani v1.1');
    expect(islamic.locator, 'Quran 4:157-158');
    expect(islamic.licenseId, 'CC-BY-3.0');
    expect(islamic.sourceUrl, 'https://tanzil.net/docs/Text_License');

    expect(christian.title, 'World English Bible — 2020 stable text edition');
    expect(
      christian.locator,
      'Matthew 27:35; Mark 15:24; Luke 23:33; John 19:18',
    );
    expect(christian.licenseId, 'PUBLIC-DOMAIN');
    expect(christian.sourceUrl, 'https://ebible.org/engwebp/');
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
      stableId: 'quran-4-157-158-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'External reference',
      locator: 'John 19:18',
      licenseId: 'PUBLIC-DOMAIN',
      sourceUrl: 'https://ebible.org/engwebp/',
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
      stableId: 'world-english-bible-2020-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'World English Bible — 2020 stable text edition',
      locator: ' ',
      licenseId: 'PUBLIC-DOMAIN',
      sourceUrl: 'https://ebible.org/engwebp/',
    );
    expect(
      build(
        comparisonSources: const <ProphetComparisonReference>[missingLocator],
      ).isValid,
      isFalse,
    );
  });

  test('non-HTTPS or missing source URL fails structural validation', () {
    const insecureSource = ProphetComparisonReference(
      stableId: 'world-english-bible-2020-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'World English Bible — 2020 stable text edition',
      locator: 'John 19:18',
      licenseId: 'PUBLIC-DOMAIN',
      sourceUrl: 'http://ebible.org/engwebp/',
    );
    expect(
      build(
        comparisonSources: const <ProphetComparisonReference>[insecureSource],
      ).isValid,
      isFalse,
    );
  });

  test('source URL tampering fails the production provenance gate', () {
    const tamperedSource = ProphetComparisonReference(
      stableId: 'world-english-bible-2020-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'World English Bible — 2020 stable text edition',
      locator: 'Matthew 27:35; Mark 15:24; Luke 23:33; John 19:18',
      licenseId: 'PUBLIC-DOMAIN',
      sourceUrl: 'https://example.com/bible',
    );
    final entry = build(
      comparisonSources: const <ProphetComparisonReference>[tamperedSource],
    );
    expect(entry.isValid, isTrue);
    expect(prophetInterfaithComparisonHasApprovedProvenance(entry), isFalse);
  });

  test('license or locator tampering fails the production provenance gate', () {
    const wrongLicense = ProphetComparisonReference(
      stableId: 'world-english-bible-2020-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'World English Bible — 2020 stable text edition',
      locator: 'Matthew 27:35; Mark 15:24; Luke 23:33; John 19:18',
      licenseId: 'REFERENCE-ONLY',
      sourceUrl: 'https://ebible.org/engwebp/',
    );
    const wrongLocator = ProphetComparisonReference(
      stableId: 'world-english-bible-2020-isa-crucifixion',
      tradition: ProphetComparisonTradition.christian,
      title: 'World English Bible — 2020 stable text edition',
      locator: 'John 19:18',
      licenseId: 'PUBLIC-DOMAIN',
      sourceUrl: 'https://ebible.org/engwebp/',
    );

    expect(
      prophetInterfaithComparisonHasApprovedProvenance(
        build(comparisonSources: const <ProphetComparisonReference>[wrongLicense]),
      ),
      isFalse,
    );
    expect(
      prophetInterfaithComparisonHasApprovedProvenance(
        build(comparisonSources: const <ProphetComparisonReference>[wrongLocator]),
      ),
      isFalse,
    );
  });
}
