import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

void main() {
  const quranSource = SourceReference(
    id: 'quran-canonical',
    title: 'Canonical Quran',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'CC-BY-3.0',
    locator: '2:124',
  );
  const hadithSource = SourceReference(
    id: 'hadith-example',
    title: 'Hadith reference',
    sourceClass: ReligiousSourceClass.sahihHasanHadith,
    licenseId: 'reference-only',
    locator: 'book:1',
  );
  const traditionSource = SourceReference(
    id: 'tradition-example',
    title: 'Traditional report',
    sourceClass: ReligiousSourceClass.laterTradition,
    licenseId: 'reference-only',
  );
  const disputedSource = SourceReference(
    id: 'disputed-example',
    title: 'Disputed report',
    sourceClass: ReligiousSourceClass.disputed,
    licenseId: 'reference-only',
  );

  LocalizedReligiousText text(String value) => LocalizedReligiousText(
        tr: '$value TR',
        en: '$value EN',
        ar: '$value AR',
      );

  ReligiousContentRecord record({
    ContentReviewStatus status = ContentReviewStatus.published,
    ContentType type = ContentType.prophetBiography,
    List<SourceReference> sources = const [quranSource],
  }) => ReligiousContentRecord(
        id: 'prophet-ibrahim',
        type: type,
        sourceStatus: ReligiousSourceClass.quran,
        version: 1,
        reviewStatus: status,
        certainty: CertaintyLevel.explicitSource,
        text: text('İbrahim'),
        sources: sources,
        lastReviewedAt: DateTime.utc(2026, 8, 29),
        reviewer: 'religious-reviewer',
      );

  ProphetContent validContent({
    List<ProphetDateEvidence>? dates,
    List<ProphetGeography>? geography,
    List<ProphetFamilyRelation>? family,
    List<ProphetTimelineRelation>? timeline,
    List<ProphetClaim>? claims,
    List<ProphetVerseReference>? verses,
    ReligiousContentRecord? governedRecord,
  }) => ProphetContent(
        record: governedRecord ?? record(),
        canonicalId: 'ibrahim',
        name: const LocalizedReligiousText(
          tr: 'İbrahim',
          en: 'Abraham',
          ar: 'إبراهيم',
        ),
        arabicName: 'إبراهيم',
        quranReferences:
            verses ?? const [ProphetVerseReference(surah: 2, ayah: 124)],
        dateEvidence: dates ??
            [
              ProphetDateEvidence(
                label: text('Kesin tarih bilinmiyor'),
                status: ProphetDateStatus.unknown,
                certainty: CertaintyLevel.unknown,
                sources: const [traditionSource],
              ),
            ],
        geography: geography ??
            [
              ProphetGeography(
                name: text('Yaklaşık bölge'),
                precision: ProphetLocationPrecision.approximateRegion,
                certainty: CertaintyLevel.approximate,
                sources: const [traditionSource],
              ),
            ],
        family: family ??
            const [
              ProphetFamilyRelation(
                relatedPersonId: 'ismail',
                type: ProphetRelationType.child,
                certainty: CertaintyLevel.explicitSource,
                sources: [quranSource],
              ),
            ],
        duaReferences: const [ProphetDuaReference(duaId: 'dua-ibrahim-001')],
        timelineRelations: timeline ??
            const [
              ProphetTimelineRelation(
                relatedProphetId: 'lut',
                type: ProphetTimelineRelationType.sameEra,
                certainty: CertaintyLevel.stronglyAttested,
                sources: [quranSource],
              ),
            ],
        claims: claims ??
            [
              ProphetClaim(
                text: text('Kaynaklı biyografi iddiası'),
                certainty: CertaintyLevel.explicitSource,
                sources: const [quranSource],
              ),
            ],
      );

  group('ProphetContent production gate', () {
    test('accepts complete governed schema', () {
      expect(validContent().canEnterProductionDataset, isTrue);
    });

    test('rejects unpublished or wrong content type', () {
      expect(
        validContent(
          governedRecord: record(status: ContentReviewStatus.research),
        ).canEnterProductionDataset,
        isFalse,
      );
      expect(
        validContent(
          governedRecord: record(type: ContentType.historyEvent),
        ).canEnterProductionDataset,
        isFalse,
      );
    });

    test('rejects duplicate and invalid Quran references', () {
      expect(
        validContent(
          verses: const [
            ProphetVerseReference(surah: 2, ayah: 124),
            ProphetVerseReference(surah: 2, ayah: 124),
          ],
        ).canEnterProductionDataset,
        isFalse,
      );
      expect(
        validContent(
          verses: const [ProphetVerseReference(surah: 115, ayah: 1)],
        ).canEnterProductionDataset,
        isFalse,
      );
    });

    test('does not allow traditional evidence to become an exact date', () {
      final exactFromTradition = ProphetDateEvidence(
        label: text('Kesin yıl'),
        status: ProphetDateStatus.exact,
        certainty: CertaintyLevel.explicitSource,
        sources: const [traditionSource],
        startYear: -2000,
        endYear: -2000,
      );
      expect(
        validContent(dates: [exactFromTradition]).canEnterProductionDataset,
        isFalse,
      );
    });

    test('unknown date cannot carry a fabricated year', () {
      final unknownWithYear = ProphetDateEvidence(
        label: text('Bilinmiyor'),
        status: ProphetDateStatus.unknown,
        certainty: CertaintyLevel.unknown,
        sources: const [traditionSource],
        startYear: -3000,
      );
      expect(
        validContent(dates: [unknownWithYear]).canEnterProductionDataset,
        isFalse,
      );
    });

    test('approximate geography cannot masquerade as exact pin', () {
      final unsafeExactLocation = ProphetGeography(
        name: text('Exact pin'),
        precision: ProphetLocationPrecision.exact,
        certainty: CertaintyLevel.explicitSource,
        sources: const [disputedSource],
        latitude: 31.0,
        longitude: 35.0,
      );
      expect(
        validContent(geography: [unsafeExactLocation]).canEnterProductionDataset,
        isFalse,
      );
    });

    test('family and timeline cannot self-reference', () {
      expect(
        validContent(
          family: const [
            ProphetFamilyRelation(
              relatedPersonId: 'ibrahim',
              type: ProphetRelationType.parent,
              certainty: CertaintyLevel.explicitSource,
              sources: [quranSource],
            ),
          ],
        ).canEnterProductionDataset,
        isFalse,
      );
      expect(
        validContent(
          timeline: const [
            ProphetTimelineRelation(
              relatedProphetId: 'ibrahim',
              type: ProphetTimelineRelationType.sameEra,
              certainty: CertaintyLevel.stronglyAttested,
              sources: [hadithSource],
            ),
          ],
        ).canEnterProductionDataset,
        isFalse,
      );
    });

    test('biographical claims require real source class and metadata', () {
      const unknownSource = SourceReference(
        id: 'unknown',
        title: 'Unknown',
        sourceClass: ReligiousSourceClass.unknown,
        licenseId: 'reference-only',
      );
      final unsafeClaim = ProphetClaim(
        text: text('Popular story'),
        certainty: CertaintyLevel.traditional,
        sources: const [unknownSource],
      );
      expect(
        validContent(claims: [unsafeClaim]).canEnterProductionDataset,
        isFalse,
      );
    });

    test('rejects non-biography source classes from prophet evidence', () {
      const ebcedSource = SourceReference(
        id: 'ebced-example',
        title: 'Ebced tradition',
        sourceClass: ReligiousSourceClass.ebcedHavasTradition,
        licenseId: 'reference-only',
      );
      const meaningDuaSource = SourceReference(
        id: 'dua-editorial',
        title: 'Meaning-based dua',
        sourceClass: ReligiousSourceClass.meaningBasedDua,
        licenseId: 'reference-only',
      );

      final ebcedClaim = ProphetClaim(
        text: text('Biyografi iddiası'),
        certainty: CertaintyLevel.traditional,
        sources: const [ebcedSource],
      );
      final duaClaim = ProphetClaim(
        text: text('Biyografi iddiası'),
        certainty: CertaintyLevel.traditional,
        sources: const [meaningDuaSource],
      );

      expect(validContent(claims: [ebcedClaim]).canEnterProductionDataset, isFalse);
      expect(validContent(claims: [duaClaim]).canEnterProductionDataset, isFalse);
      expect(
        validContent(governedRecord: record(sources: const [ebcedSource]))
            .canEnterProductionDataset,
        isFalse,
      );
    });

    test('disputed and traditional layers remain representable as such', () {
      final disputedDate = ProphetDateEvidence(
        label: text('Tartışmalı dönem'),
        status: ProphetDateStatus.disputed,
        certainty: CertaintyLevel.disputed,
        sources: const [disputedSource],
      );
      final traditionalDate = ProphetDateEvidence(
        label: text('Geleneksel dönem'),
        status: ProphetDateStatus.traditional,
        certainty: CertaintyLevel.traditional,
        sources: const [traditionSource],
      );
      expect(disputedDate.isValid, isTrue);
      expect(traditionalDate.isValid, isTrue);
    });
  });
}
