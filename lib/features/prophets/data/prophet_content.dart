import '../../../core/content/content_governance.dart';

enum ProphetDateStatus {
  exact,
  approximate,
  traditional,
  disputed,
  unknown,
}

enum ProphetLocationPrecision {
  exact,
  approximateRegion,
  disputed,
  unknown,
}

enum ProphetRelationType {
  parent,
  child,
  sibling,
  spouse,
  ancestor,
  descendant,
  other,
}

enum ProphetTimelineRelationType {
  before,
  after,
  overlaps,
  sameEra,
  unknown,
}

class ProphetDateEvidence {
  const ProphetDateEvidence({
    required this.label,
    required this.status,
    required this.certainty,
    required this.sources,
    this.startYear,
    this.endYear,
  });

  final LocalizedReligiousText label;
  final ProphetDateStatus status;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;
  final int? startYear;
  final int? endYear;

  bool get isValid {
    if (!label.isComplete || !_hasProphetSourceMetadata(sources)) return false;
    if (startYear != null && endYear != null && startYear! > endYear!) return false;

    switch (status) {
      case ProphetDateStatus.exact:
        return startYear != null &&
            endYear != null &&
            startYear == endYear &&
            certainty == CertaintyLevel.explicitSource &&
            sources.every((source) =>
                source.sourceClass != ReligiousSourceClass.classicalTraditional &&
                source.sourceClass != ReligiousSourceClass.israiliyat &&
                source.sourceClass != ReligiousSourceClass.laterTradition &&
                source.sourceClass != ReligiousSourceClass.disputed &&
                source.sourceClass != ReligiousSourceClass.unknown);
      case ProphetDateStatus.approximate:
        return (startYear != null || endYear != null) &&
            certainty == CertaintyLevel.approximate;
      case ProphetDateStatus.traditional:
        return certainty == CertaintyLevel.traditional &&
            sources.every((source) =>
                source.sourceClass == ReligiousSourceClass.classicalTraditional ||
                source.sourceClass == ReligiousSourceClass.laterTradition ||
                source.sourceClass == ReligiousSourceClass.israiliyat);
      case ProphetDateStatus.disputed:
        return certainty == CertaintyLevel.disputed;
      case ProphetDateStatus.unknown:
        return startYear == null &&
            endYear == null &&
            certainty == CertaintyLevel.unknown;
    }
  }
}

class ProphetGeography {
  const ProphetGeography({
    required this.name,
    required this.precision,
    required this.certainty,
    required this.sources,
    this.latitude,
    this.longitude,
  });

  final LocalizedReligiousText name;
  final ProphetLocationPrecision precision;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;
  final double? latitude;
  final double? longitude;

  bool get isValid {
    if (!name.isComplete || !_hasProphetSourceMetadata(sources)) return false;
    if ((latitude == null) != (longitude == null)) return false;
    if (latitude != null && (latitude! < -90 || latitude! > 90)) return false;
    if (longitude != null && (longitude! < -180 || longitude! > 180)) return false;

    switch (precision) {
      case ProphetLocationPrecision.exact:
        return latitude != null &&
            longitude != null &&
            certainty == CertaintyLevel.explicitSource &&
            sources.every((source) =>
                source.sourceClass != ReligiousSourceClass.disputed &&
                source.sourceClass != ReligiousSourceClass.unknown &&
                source.sourceClass != ReligiousSourceClass.israiliyat);
      case ProphetLocationPrecision.approximateRegion:
        return certainty == CertaintyLevel.approximate;
      case ProphetLocationPrecision.disputed:
        return certainty == CertaintyLevel.disputed;
      case ProphetLocationPrecision.unknown:
        return latitude == null &&
            longitude == null &&
            certainty == CertaintyLevel.unknown;
    }
  }
}

class ProphetFamilyRelation {
  const ProphetFamilyRelation({
    required this.relatedPersonId,
    required this.type,
    required this.certainty,
    required this.sources,
  });

  final String relatedPersonId;
  final ProphetRelationType type;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid =>
      relatedPersonId.trim().isNotEmpty &&
      certainty != CertaintyLevel.unknown &&
      _hasProphetSourceMetadata(sources) &&
      sources.every((source) => source.sourceClass != ReligiousSourceClass.unknown);
}

class ProphetVerseReference {
  const ProphetVerseReference({
    required this.surah,
    required this.ayah,
  });

  final int surah;
  final int ayah;

  bool get isValid => surah >= 1 && surah <= 114 && ayah > 0;
  String get stableId => '$surah:$ayah';
}

class ProphetDuaReference {
  const ProphetDuaReference({required this.duaId});

  final String duaId;
  bool get isValid => duaId.trim().isNotEmpty;
}

class ProphetTimelineRelation {
  const ProphetTimelineRelation({
    required this.relatedProphetId,
    required this.type,
    required this.certainty,
    required this.sources,
  });

  final String relatedProphetId;
  final ProphetTimelineRelationType type;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid =>
      relatedProphetId.trim().isNotEmpty &&
      _hasProphetSourceMetadata(sources) &&
      (type == ProphetTimelineRelationType.unknown
          ? certainty == CertaintyLevel.unknown
          : certainty != CertaintyLevel.unknown);
}

class ProphetClaim {
  const ProphetClaim({
    required this.text,
    required this.certainty,
    required this.sources,
  });

  final LocalizedReligiousText text;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid =>
      text.isComplete &&
      certainty != CertaintyLevel.unknown &&
      _hasProphetSourceMetadata(sources) &&
      sources.every((source) => source.sourceClass != ReligiousSourceClass.unknown);
}

class ProphetContent {
  const ProphetContent({
    required this.record,
    required this.canonicalId,
    required this.name,
    required this.arabicName,
    required this.quranReferences,
    required this.dateEvidence,
    required this.geography,
    required this.family,
    required this.duaReferences,
    required this.timelineRelations,
    required this.claims,
  });

  final ReligiousContentRecord record;
  final String canonicalId;
  final LocalizedReligiousText name;
  final String arabicName;
  final List<ProphetVerseReference> quranReferences;
  final List<ProphetDateEvidence> dateEvidence;
  final List<ProphetGeography> geography;
  final List<ProphetFamilyRelation> family;
  final List<ProphetDuaReference> duaReferences;
  final List<ProphetTimelineRelation> timelineRelations;
  final List<ProphetClaim> claims;

  bool get canEnterProductionDataset {
    if (record.type != ContentType.prophetBiography ||
        !record.canEnterProductionDataset ||
        (record.reviewer?.trim().isEmpty ?? true) ||
        !_hasProphetSourceMetadata(record.sources) ||
        canonicalId.trim().isEmpty ||
        !name.isComplete ||
        arabicName.trim().isEmpty ||
        quranReferences.isEmpty ||
        claims.isEmpty) {
      return false;
    }

    if (quranReferences.any((reference) => !reference.isValid) ||
        quranReferences.map((e) => e.stableId).toSet().length !=
            quranReferences.length) {
      return false;
    }
    if (dateEvidence.any((value) => !value.isValid) ||
        geography.any((value) => !value.isValid) ||
        family.any((value) => !value.isValid) ||
        duaReferences.any((value) => !value.isValid) ||
        timelineRelations.any((value) => !value.isValid) ||
        claims.any((value) => !value.isValid)) {
      return false;
    }
    if (family.any((value) => value.relatedPersonId == canonicalId) ||
        timelineRelations.any((value) => value.relatedProphetId == canonicalId)) {
      return false;
    }

    return true;
  }
}

const Set<ReligiousSourceClass> _prophetSourceClasses = {
  ReligiousSourceClass.quran,
  ReligiousSourceClass.sahihHasanHadith,
  ReligiousSourceClass.earlyIslamicHistoryTafsir,
  ReligiousSourceClass.classicalTraditional,
  ReligiousSourceClass.israiliyat,
  ReligiousSourceClass.laterTradition,
  ReligiousSourceClass.modernHistoryArchaeology,
  ReligiousSourceClass.disputed,
  ReligiousSourceClass.unknown,
};

bool _hasProphetSourceMetadata(List<SourceReference> sources) =>
    sources.isNotEmpty &&
    sources.every((source) =>
        _prophetSourceClasses.contains(source.sourceClass) &&
        source.id.trim().isNotEmpty &&
        source.title.trim().isNotEmpty &&
        source.licenseId.trim().isNotEmpty);
