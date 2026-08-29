import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

const _completeText = LocalizedReligiousText(
  tr: 'Doğrulanmış Türkçe içerik',
  en: 'Verified English content',
  ar: 'محتوى عربي موثق',
);

SourceReference _source(
  String id,
  ReligiousSourceClass sourceClass,
) {
  return SourceReference(
    id: id,
    title: 'Source $id',
    sourceClass: sourceClass,
    licenseId: 'license-$id',
    locator: 'locator-$id',
  );
}

ReligiousDayEvidenceSection _section(
  ReligiousDayEvidenceKind kind,
  ReligiousSourceClass sourceClass, {
  CertaintyLevel certainty = CertaintyLevel.explicitSource,
}) {
  return ReligiousDayEvidenceSection(
    kind: kind,
    text: _completeText,
    certainty: certainty,
    sources: [_source('${kind.name}-source', sourceClass)],
  );
}

ReligiousContentRecord _record({
  ContentType type = ContentType.religiousDay,
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  String? reviewer = 'religious-reviewer',
}) {
  return ReligiousContentRecord(
    id: 'religious-day-test',
    type: type,
    sourceStatus: ReligiousSourceClass.sahihHasanHadith,
    version: 1,
    reviewStatus: reviewStatus,
    certainty: CertaintyLevel.stronglyAttested,
    text: _completeText,
    sources: [_source('record-source', ReligiousSourceClass.sahihHasanHadith)],
    lastReviewedAt: DateTime.utc(2026, 8, 29),
    reviewer: reviewer,
  );
}

ReligiousDayContent _content({
  ReligiousContentRecord? record,
  List<ReligiousDayEvidenceSection>? evidence,
  SpecificWorshipStatus status =
      SpecificWorshipStatus.noSpecificPracticeEstablished,
}) {
  return ReligiousDayContent(
    record: record ?? _record(),
    title: _completeText,
    whatIsIt: _completeText,
    history: _completeText,
    evidence: evidence ??
        [
          _section(
            ReligiousDayEvidenceKind.quranBasis,
            ReligiousSourceClass.quran,
          ),
          _section(
            ReligiousDayEvidenceKind.hadithBasis,
            ReligiousSourceClass.sahihHasanHadith,
          ),
          _section(
            ReligiousDayEvidenceKind.strongReport,
            ReligiousSourceClass.sahihHasanHadith,
            certainty: CertaintyLevel.stronglyAttested,
          ),
          _section(
            ReligiousDayEvidenceKind.disputedReport,
            ReligiousSourceClass.disputed,
            certainty: CertaintyLevel.disputed,
          ),
          _section(
            ReligiousDayEvidenceKind.tradition,
            ReligiousSourceClass.classicalTraditional,
            certainty: CertaintyLevel.traditional,
          ),
          _section(
            ReligiousDayEvidenceKind.generalWorship,
            ReligiousSourceClass.quran,
          ),
        ],
    specificWorshipStatus: status,
  );
}

void main() {
  group('T0170 religious-day common content schema', () {
    test('published reviewed record keeps evidence classes separate', () {
      final content = _content();

      expect(content.canEnterProductionDataset, isTrue);
      expect(
        content.sectionsOf(ReligiousDayEvidenceKind.disputedReport).single.certainty,
        CertaintyLevel.disputed,
      );
    });

    test('non religious-day governed record is rejected', () {
      final content = _content(record: _record(type: ContentType.editorial));

      expect(content.canEnterProductionDataset, isFalse);
    });

    test('published status without reviewer evidence is rejected', () {
      final content = _content(record: _record(reviewer: null));

      expect(content.canEnterProductionDataset, isFalse);
    });

    test('Quran basis cannot be backed by a hadith source', () {
      final content = _content(
        evidence: [
          _section(
            ReligiousDayEvidenceKind.quranBasis,
            ReligiousSourceClass.sahihHasanHadith,
          ),
        ],
      );

      expect(content.canEnterProductionDataset, isFalse);
    });

    test('disputed report cannot be promoted to strong evidence', () {
      final content = _content(
        evidence: [
          _section(
            ReligiousDayEvidenceKind.disputedReport,
            ReligiousSourceClass.disputed,
            certainty: CertaintyLevel.stronglyAttested,
          ),
        ],
      );

      expect(content.canEnterProductionDataset, isFalse);
    });

    test('no-specific-practice status forbids a hidden specific worship claim', () {
      final content = _content(
        evidence: [
          _section(
            ReligiousDayEvidenceKind.specificWorship,
            ReligiousSourceClass.sahihHasanHadith,
          ),
        ],
      );

      expect(content.canEnterProductionDataset, isFalse);
    });

    test('established specific worship requires strong Quran or hadith evidence', () {
      final valid = _content(
        status: SpecificWorshipStatus.establishedByStrongSource,
        evidence: [
          _section(
            ReligiousDayEvidenceKind.specificWorship,
            ReligiousSourceClass.sahihHasanHadith,
            certainty: CertaintyLevel.stronglyAttested,
          ),
        ],
      );
      final invalid = _content(
        status: SpecificWorshipStatus.establishedByStrongSource,
        evidence: [
          _section(
            ReligiousDayEvidenceKind.specificWorship,
            ReligiousSourceClass.laterTradition,
            certainty: CertaintyLevel.traditional,
          ),
        ],
      );

      expect(valid.canEnterProductionDataset, isTrue);
      expect(invalid.canEnterProductionDataset, isFalse);
    });

    test('traditional specific practice stays explicitly traditional', () {
      final content = _content(
        status: SpecificWorshipStatus.traditionalOnly,
        evidence: [
          _section(
            ReligiousDayEvidenceKind.specificWorship,
            ReligiousSourceClass.laterTradition,
            certainty: CertaintyLevel.traditional,
          ),
        ],
      );

      expect(content.canEnterProductionDataset, isTrue);
    });

    test('disputed specific practice requires disputed source and certainty', () {
      final content = _content(
        status: SpecificWorshipStatus.disputed,
        evidence: [
          _section(
            ReligiousDayEvidenceKind.specificWorship,
            ReligiousSourceClass.disputed,
            certainty: CertaintyLevel.disputed,
          ),
        ],
      );

      expect(content.canEnterProductionDataset, isTrue);
    });
  });
}
