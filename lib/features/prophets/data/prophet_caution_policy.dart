import '../../../core/content/content_governance.dart';

enum ProphetCautionCase {
  noahNarrative,
  mosesPharaohIdentity,
  abrahamChronology,
  adamChronology,
  jesusHistoricalLayering,
}

enum ProphetKnowledgeLayer {
  islamicRevelation,
  earlyIslamicScholarship,
  laterTradition,
  modernHistoricalResearch,
  disputed,
  unknown,
}

class ProphetCautionAssertion {
  const ProphetCautionAssertion({
    required this.cautionCase,
    required this.canonicalProphetId,
    required this.topic,
    required this.sourceClass,
    required this.certainty,
    required this.layer,
    this.exactGregorianYear,
    this.namedHistoricalIdentity,
  });

  final ProphetCautionCase cautionCase;
  final String canonicalProphetId;
  final String topic;
  final ReligiousSourceClass sourceClass;
  final CertaintyLevel certainty;
  final ProphetKnowledgeLayer layer;
  final int? exactGregorianYear;
  final String? namedHistoricalIdentity;
}

class ProphetCautionPolicy {
  const ProphetCautionPolicy._();

  static bool allows(ProphetCautionAssertion assertion) {
    if (assertion.canonicalProphetId.trim().isEmpty ||
        assertion.topic.trim().isEmpty) {
      return false;
    }

    if (!_sourceMatchesLayer(assertion)) return false;

    return switch (assertion.cautionCase) {
      ProphetCautionCase.noahNarrative => _allowsNoah(assertion),
      ProphetCautionCase.mosesPharaohIdentity => _allowsMoses(assertion),
      ProphetCautionCase.abrahamChronology => _allowsAbraham(assertion),
      ProphetCautionCase.adamChronology => _allowsAdam(assertion),
      ProphetCautionCase.jesusHistoricalLayering => _allowsJesus(assertion),
    };
  }

  static void requireAllowed(ProphetCautionAssertion assertion) {
    if (!allows(assertion)) {
      throw StateError(
        'Prophet assertion violates the SPEC 878-882 caution policy.',
      );
    }
  }

  static bool _allowsNoah(ProphetCautionAssertion value) {
    if (value.canonicalProphetId != 'nuh') return false;

    if (value.sourceClass == ReligiousSourceClass.israiliyat ||
        value.sourceClass == ReligiousSourceClass.laterTradition ||
        value.sourceClass == ReligiousSourceClass.classicalTraditional) {
      return value.layer == ProphetKnowledgeLayer.laterTradition &&
          (value.certainty == CertaintyLevel.traditional ||
              value.certainty == CertaintyLevel.disputed);
    }

    return value.layer != ProphetKnowledgeLayer.laterTradition;
  }

  static bool _allowsMoses(ProphetCautionAssertion value) {
    if (value.canonicalProphetId != 'musa') return false;

    final identity = value.namedHistoricalIdentity?.trim();
    if (identity == null || identity.isEmpty) return true;

    return value.layer == ProphetKnowledgeLayer.modernHistoricalResearch &&
        value.sourceClass == ReligiousSourceClass.modernHistoryArchaeology &&
        (value.certainty == CertaintyLevel.disputed ||
            value.certainty == CertaintyLevel.approximate);
  }

  static bool _allowsAbraham(ProphetCautionAssertion value) {
    if (value.canonicalProphetId != 'ibrahim') return false;

    if (value.exactGregorianYear != null) return false;
    return value.certainty != CertaintyLevel.explicitSource ||
        value.sourceClass == ReligiousSourceClass.quran ||
        value.sourceClass == ReligiousSourceClass.sahihHasanHadith;
  }

  static bool _allowsAdam(ProphetCautionAssertion value) {
    if (value.canonicalProphetId != 'adam') return false;

    if (value.exactGregorianYear != null) return false;
    if (value.sourceClass == ReligiousSourceClass.modernHistoryArchaeology) {
      return value.layer == ProphetKnowledgeLayer.modernHistoricalResearch &&
          value.certainty != CertaintyLevel.explicitSource;
    }
    return true;
  }

  static bool _allowsJesus(ProphetCautionAssertion value) {
    if (value.canonicalProphetId != 'isa') return false;

    if (value.sourceClass == ReligiousSourceClass.quran ||
        value.sourceClass == ReligiousSourceClass.sahihHasanHadith) {
      return value.layer == ProphetKnowledgeLayer.islamicRevelation;
    }
    if (value.sourceClass == ReligiousSourceClass.modernHistoryArchaeology) {
      return value.layer == ProphetKnowledgeLayer.modernHistoricalResearch;
    }
    return value.layer != ProphetKnowledgeLayer.islamicRevelation;
  }

  static bool _sourceMatchesLayer(ProphetCautionAssertion value) {
    return switch (value.layer) {
      ProphetKnowledgeLayer.islamicRevelation =>
        value.sourceClass == ReligiousSourceClass.quran ||
            value.sourceClass == ReligiousSourceClass.sahihHasanHadith,
      ProphetKnowledgeLayer.earlyIslamicScholarship =>
        value.sourceClass == ReligiousSourceClass.earlyIslamicHistoryTafsir,
      ProphetKnowledgeLayer.laterTradition =>
        value.sourceClass == ReligiousSourceClass.israiliyat ||
            value.sourceClass == ReligiousSourceClass.laterTradition ||
            value.sourceClass == ReligiousSourceClass.classicalTraditional,
      ProphetKnowledgeLayer.modernHistoricalResearch =>
        value.sourceClass == ReligiousSourceClass.modernHistoryArchaeology,
      ProphetKnowledgeLayer.disputed =>
        value.sourceClass == ReligiousSourceClass.disputed,
      ProphetKnowledgeLayer.unknown =>
        value.sourceClass == ReligiousSourceClass.unknown,
    };
  }
}
