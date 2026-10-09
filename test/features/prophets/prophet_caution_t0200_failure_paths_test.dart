import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_caution_policy.dart';

void main() {
  group('T0200 SPEC 878-882 fail-closed matrix', () {
    test('Nuh: revelation and later tradition keep different certainty levels', () {
      final quranExplicit = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'Quran-explicit narrative point',
        sourceClass: ReligiousSourceClass.quran,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );
      final quranDowngradedIntoDisputed = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'Quran-explicit point mislabeled as disputed',
        sourceClass: ReligiousSourceClass.quran,
        certainty: CertaintyLevel.disputed,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );
      final laterTradition = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'later narrative detail',
        sourceClass: ReligiousSourceClass.israiliyat,
        certainty: CertaintyLevel.traditional,
        layer: ProphetKnowledgeLayer.laterTradition,
      );
      final promoted = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'later narrative detail promoted as revelation',
        sourceClass: ReligiousSourceClass.israiliyat,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.laterTradition,
      );
      final layerSwap = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'later narrative detail mislabeled as revelation layer',
        sourceClass: ReligiousSourceClass.israiliyat,
        certainty: CertaintyLevel.traditional,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );

      expect(ProphetCautionPolicy.allows(quranExplicit), isTrue);
      expect(ProphetCautionPolicy.allows(quranDowngradedIntoDisputed), isFalse);
      expect(ProphetCautionPolicy.allows(laterTradition), isTrue);
      expect(ProphetCautionPolicy.allows(promoted), isFalse);
      expect(ProphetCautionPolicy.allows(layerSwap), isFalse);
    });

    test('Musa: named Pharaoh identity stays hypothesis-level', () {
      final disputedIdentity = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'musa',
        topic: 'candidate Pharaoh identity',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.disputed,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        namedHistoricalIdentity: 'Candidate ruler',
      );
      final certainIdentity = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'musa',
        topic: 'candidate Pharaoh identity stated as certain',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.stronglyAttested,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        namedHistoricalIdentity: 'Candidate ruler',
      );
      final revelationSwap = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'musa',
        topic: 'candidate Pharaoh identity mislabeled as revelation',
        sourceClass: ReligiousSourceClass.quran,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.islamicRevelation,
        namedHistoricalIdentity: 'Candidate ruler',
      );

      expect(ProphetCautionPolicy.allows(disputedIdentity), isTrue);
      expect(ProphetCautionPolicy.allows(certainIdentity), isFalse);
      expect(ProphetCautionPolicy.allows(revelationSwap), isFalse);
    });

    test('Ibrahim: no exact Gregorian year may be synthesized', () {
      for (final year in <int>[-2200, -2000, -1800]) {
        final assertion = ProphetCautionAssertion(
          cautionCase: ProphetCautionCase.abrahamChronology,
          canonicalProphetId: 'ibrahim',
          topic: 'invented exact chronology',
          sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
          certainty: CertaintyLevel.approximate,
          layer: ProphetKnowledgeLayer.modernHistoricalResearch,
          exactGregorianYear: year,
        );
        expect(ProphetCautionPolicy.allows(assertion), isFalse);
      }
    });

    test('Adam: modern dating never becomes exact religious chronology', () {
      final exactModernDate = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.adamChronology,
        canonicalProphetId: 'adam',
        topic: 'exact modern dating',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        exactGregorianYear: -10000,
      );
      final modernClaimInRevelationLayer = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.adamChronology,
        canonicalProphetId: 'adam',
        topic: 'modern chronology mislabeled as revelation',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );

      expect(ProphetCautionPolicy.allows(exactModernDate), isFalse);
      expect(ProphetCautionPolicy.allows(modernClaimInRevelationLayer), isFalse);
    });

    test('Isa: Islamic revelation and Roman-period research cannot cross layers', () {
      final quranAsHistory = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.jesusHistoricalLayering,
        canonicalProphetId: 'isa',
        topic: 'Quran claim mislabeled as modern history',
        sourceClass: ReligiousSourceClass.quran,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
      );
      final historyAsRevelation = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.jesusHistoricalLayering,
        canonicalProphetId: 'isa',
        topic: 'Roman-period research mislabeled as revelation',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );

      expect(ProphetCautionPolicy.allows(quranAsHistory), isFalse);
      expect(ProphetCautionPolicy.allows(historyAsRevelation), isFalse);
      expect(
        () => ProphetCautionPolicy.requireAllowed(historyAsRevelation),
        throwsStateError,
      );
    });

    test('irrelevant source classes cannot enter any special-case layer', () {
      for (final cautionCase in ProphetCautionCase.values) {
        final canonicalId = switch (cautionCase) {
          ProphetCautionCase.noahNarrative => 'nuh',
          ProphetCautionCase.mosesPharaohIdentity => 'musa',
          ProphetCautionCase.abrahamChronology => 'ibrahim',
          ProphetCautionCase.adamChronology => 'adam',
          ProphetCautionCase.jesusHistoricalLayering => 'isa',
        };
        final assertion = ProphetCautionAssertion(
          cautionCase: cautionCase,
          canonicalProphetId: canonicalId,
          topic: 'irrelevant source-class injection',
          sourceClass: ReligiousSourceClass.meaningBasedDua,
          certainty: CertaintyLevel.explicitSource,
          layer: ProphetKnowledgeLayer.islamicRevelation,
        );
        expect(
          ProphetCautionPolicy.allows(assertion),
          isFalse,
          reason: '$cautionCase must reject non-prophet provenance classes',
        );
      }
    });
  });
}
