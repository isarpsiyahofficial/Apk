import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  test(
    'T0336 contextual mentions cannot satisfy any of the eight semantic dimensions',
    () {
      for (final dimension in ProphetSemanticDimension.values) {
        final claim = ProphetSemanticClaim(
          biographyProphetId: 'muhammad',
          subjectProphetId: 'yusuf',
          dimension: dimension,
          claimKey: 'context:${dimension.name}:muhammad_mentions_yusuf',
          sourceIds: const ['tanzil-uthmani-v1.1'],
          sourceClasses: const {ReligiousSourceClass.quran},
          contextReference: true,
        );

        final manifest = buildProphetSemanticGapManifestT0336(
          claims: [claim],
        );

        expect(
          manifest.slotFor('muhammad', dimension).isVerified,
          isFalse,
          reason:
              '${dimension.name}: a contextual Yusuf mention inside Muhammad biography must not create coverage',
        );
        expect(
          manifest.slotFor('yusuf', dimension).isVerified,
          isFalse,
          reason:
              '${dimension.name}: being mentioned as the subject must not transfer coverage to Yusuf biography',
        );
      }
    },
  );

  test(
    'T0336 contextual references remain non-owning even with strong source classes',
    () {
      const strongSources = <ReligiousSourceClass>[
        ReligiousSourceClass.quran,
        ReligiousSourceClass.sahihHasanHadith,
        ReligiousSourceClass.earlyIslamicHistoryTafsir,
        ReligiousSourceClass.modernHistoryArchaeology,
      ];

      for (final sourceClass in strongSources) {
        final claim = ProphetSemanticClaim(
          biographyProphetId: 'yusuf',
          subjectProphetId: 'muhammad',
          dimension: ProphetSemanticDimension.event,
          claimKey: 'context:event:yusuf_mentions_muhammad:${sourceClass.name}',
          sourceIds: ['context-source:${sourceClass.name}'],
          sourceClasses: {sourceClass},
          contextReference: true,
        );

        final manifest = buildProphetSemanticGapManifestT0336(
          claims: [claim],
        );

        expect(
          manifest
              .slotFor('yusuf', ProphetSemanticDimension.event)
              .isVerified,
          isFalse,
          reason:
              '${sourceClass.name}: source strength must not override contextual-reference ownership',
        );
        expect(
          manifest
              .slotFor('muhammad', ProphetSemanticDimension.event)
              .isVerified,
          isFalse,
          reason:
              '${sourceClass.name}: mentioned subject must not inherit another biography claim',
        );
      }
    },
  );
}
