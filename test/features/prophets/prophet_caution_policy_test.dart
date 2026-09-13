import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_caution_policy.dart';

void main() {
  group('T0200 prophet caution policy', () {
    test('Nuh keeps later-tradition detail below Quran-level certainty', () {
      final allowed = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'later flood narrative detail',
        sourceClass: ReligiousSourceClass.laterTradition,
        certainty: CertaintyLevel.traditional,
        layer: ProphetKnowledgeLayer.laterTradition,
      );
      final forbidden = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.noahNarrative,
        canonicalProphetId: 'nuh',
        topic: 'later flood narrative detail promoted as revelation',
        sourceClass: ReligiousSourceClass.laterTradition,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.laterTradition,
      );

      expect(ProphetCautionPolicy.allows(allowed), isTrue);
      expect(ProphetCautionPolicy.allows(forbidden), isFalse);
    });

    test('Musa does not promote a Pharaoh hypothesis to a certain identity', () {
      final hypothesis = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'musa',
        topic: 'historical Pharaoh identity hypothesis',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.disputed,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        namedHistoricalIdentity: 'Example hypothesis',
      );
      final falseCertainty = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'musa',
        topic: 'historical Pharaoh identity presented as certain',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        namedHistoricalIdentity: 'Example hypothesis',
      );

      expect(ProphetCautionPolicy.allows(hypothesis), isTrue);
      expect(ProphetCautionPolicy.allows(falseCertainty), isFalse);
    });

    test('Ibrahim cannot receive an invented exact Gregorian birth year', () {
      final forbidden = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.abrahamChronology,
        canonicalProphetId: 'ibrahim',
        topic: 'birth chronology',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        exactGregorianYear: -1900,
      );
      final cautious = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.abrahamChronology,
        canonicalProphetId: 'ibrahim',
        topic: 'birth chronology remains non-exact',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
      );

      expect(ProphetCautionPolicy.allows(forbidden), isFalse);
      expect(ProphetCautionPolicy.allows(cautious), isTrue);
    });

    test('Adam scientific or historical dating cannot become religious fact', () {
      final forbidden = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.adamChronology,
        canonicalProphetId: 'adam',
        topic: 'scientific dating presented as exact religious chronology',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        exactGregorianYear: -10000,
      );
      final cautious = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.adamChronology,
        canonicalProphetId: 'adam',
        topic: 'historical discussion kept separate and approximate',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
      );

      expect(ProphetCautionPolicy.allows(forbidden), isFalse);
      expect(ProphetCautionPolicy.allows(cautious), isTrue);
    });

    test('Isa Islamic belief and Roman-period research stay in separate layers', () {
      final islamic = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.jesusHistoricalLayering,
        canonicalProphetId: 'isa',
        topic: 'Islamic belief statement',
        sourceClass: ReligiousSourceClass.quran,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );
      final historical = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.jesusHistoricalLayering,
        canonicalProphetId: 'isa',
        topic: 'Roman-period historical research',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.approximate,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
      );
      final mixed = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.jesusHistoricalLayering,
        canonicalProphetId: 'isa',
        topic: 'historical claim mislabeled as revelation',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.explicitSource,
        layer: ProphetKnowledgeLayer.islamicRevelation,
      );

      expect(ProphetCautionPolicy.allows(islamic), isTrue);
      expect(ProphetCautionPolicy.allows(historical), isTrue);
      expect(ProphetCautionPolicy.allows(mixed), isFalse);
      expect(() => ProphetCautionPolicy.requireAllowed(mixed), throwsStateError);
    });

    test('wrong canonical prophet id fails closed for every special case', () {
      final wrong = ProphetCautionAssertion(
        cautionCase: ProphetCautionCase.mosesPharaohIdentity,
        canonicalProphetId: 'harun',
        topic: 'Pharaoh identity',
        sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
        certainty: CertaintyLevel.disputed,
        layer: ProphetKnowledgeLayer.modernHistoricalResearch,
        namedHistoricalIdentity: 'Example hypothesis',
      );

      expect(ProphetCautionPolicy.allows(wrong), isFalse);
    });
  });
}
