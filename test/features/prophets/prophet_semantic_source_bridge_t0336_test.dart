import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  test('Quran-reviewed geography reaches T0336 with exact ownership', () {
    const expected = <String, String>{
      'salih': 'tanzil-uthmani-v1.1-salih-q7-73-74-q89-9-thamud-settlement-geography',
      'lut': 'tanzil-uthmani-v1.1-lut-q21-74-q15-76-town-road-geography',
      'hud': 'tanzil-uthmani-v1.1-hud-q11-50-q46-21-ahqaf-geography',
      'harun': 'tanzil-uthmani-v1.1-harun-q23-45-46-q43-51-egypt-geography',
      'nuh': 'tanzil-uthmani-v1.1-nuh-q11-44-al-judi-geography',
      'ibrahim': 'tanzil-uthmani-v1.1-ibrahim-q2-127-kaaba-geography',
      'ismail': 'tanzil-uthmani-v1.1-ismail-q2-127-kaaba-geography',
      'yusuf': 'tanzil-uthmani-v1.1-yusuf-q12-21-egypt-geography',
      'shuayb': 'tanzil-uthmani-v1.1-shuayb-q11-84-madyan-geography',
      'musa': 'tanzil-uthmani-v1.1-musa-q28-22-23-madyan-geography',
      'muhammad': 'tanzil-uthmani-v1.1-muhammad-q17-1-isra-geography',
    };

    expect(
      canonicalProphetGeographyEvidenceT0336.map((item) => item.biographyProphetId).toSet(),
      expected.keys.toSet(),
      reason: 'No unreviewed geography owner may silently enter verified T0336 coverage',
    );

    for (final entry in expected.entries) {
      final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
        (item) => item.identity.canonicalId == entry.key,
      );
      final field = draft.sections[ProphetBiographySectionKey.geography]!;
      expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(field.sources, hasLength(1));
      expect(field.sources.single.id, entry.value);
      expect(field.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(prophetBiographyT0194DraftHasTraceableProvenance(draft), isTrue);

      final claim = canonicalProphetGeographyEvidenceT0336.singleWhere(
        (item) =>
            item.biographyProphetId == entry.key &&
            item.sourceIds.contains(entry.value),
      );
      expect(claim.subjectProphetId, entry.key);
      expect(claim.dimension, ProphetSemanticDimension.geography);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.contextReference, isFalse);
      expect(claim.sourceClasses, {ReligiousSourceClass.quran});
    }
  });

  test('geography evidence cannot migrate between prophet biographies', () {
    const qa = ProphetSemanticOwnershipQa();
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: const [
        ProphetSemanticClaim(
          biographyProphetId: 'muhammad',
          subjectProphetId: 'yusuf',
          dimension: ProphetSemanticDimension.geography,
          claimKey: 'geography:muhammad:egypt',
          sourceIds: ['tanzil-uthmani-v1.1-yusuf-q12-21-egypt-geography'],
          sourceClasses: {ReligiousSourceClass.quran},
        ),
      ],
    );

    expect(result.isValid, isFalse);
  });

  test('cross-reference geography cannot be reassigned to another owner', () {
    const qa = ProphetSemanticOwnershipQa();
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: const [
        ProphetSemanticClaim(
          biographyProphetId: 'salih',
          subjectProphetId: 'hud',
          dimension: ProphetSemanticDimension.geography,
          claimKey: 'geography:salih:ahqaf',
          sourceIds: ['tanzil-uthmani-v1.1-hud-q11-50-q46-21-ahqaf-geography'],
          sourceClasses: {ReligiousSourceClass.quran},
        ),
        ProphetSemanticClaim(
          biographyProphetId: 'yusuf',
          subjectProphetId: 'lut',
          dimension: ProphetSemanticDimension.geography,
          claimKey: 'geography:yusuf:lut-town-road',
          sourceIds: ['tanzil-uthmani-v1.1-lut-q21-74-q15-76-town-road-geography'],
          sourceClasses: {ReligiousSourceClass.quran},
        ),
      ],
    );

    expect(result.isValid, isFalse);
  });

  test('T0336 hadith evidence remains pinned to admitted T0194 reports and owner', () {
    final claims = canonicalProphetHadithEvidenceT0336;
    final sourceIds = claims.expand((claim) => claim.sourceIds).toSet();

    expect(
      sourceIds,
      {
        'sahih-muslim-1162e-muhammad-birth',
        'sahih-bukhari-4449-muhammad-death',
      },
    );
    expect(claims, hasLength(2));
    for (final claim in claims) {
      expect(claim.biographyProphetId, 'muhammad');
      expect(claim.subjectProphetId, 'muhammad');
      expect(claim.dimension, ProphetSemanticDimension.hadith);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.contextReference, isFalse);
      expect(claim.sourceClasses, {ReligiousSourceClass.sahihHasanHadith});
    }
  });
}
