import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

void main() {
  group('T0198 verified prophet family graph', () {
    test('seed graph is valid and every source is explicit Quran evidence', () {
      expect(verifiedProphetFamilyGraphIsValid, isTrue);
      expect(verifiedProphetKinshipFacts, isNotEmpty);

      for (final fact in verifiedProphetKinshipFacts) {
        expect(fact.isValid, isTrue);
        expect(fact.certainty, CertaintyLevel.explicitSource);
        for (final source in fact.sources) {
          expect(source.sourceClass, ReligiousSourceClass.quran);
          expect(source.id, startsWith('tanzil-uthmani-v1.1-'));
          expect(source.licenseId, 'CC-BY-3.0');
          expect(source.locator, isNotEmpty);
        }
      }
    });

    test('Musa and Harun project as reciprocal sibling relations', () {
      final musa = verifiedFamilyRelationsFor('musa');
      final harun = verifiedFamilyRelationsFor('harun');

      expect(musa, hasLength(1));
      expect(musa.single.relatedPersonId, 'harun');
      expect(musa.single.type, ProphetRelationType.sibling);
      expect(harun, hasLength(1));
      expect(harun.single.relatedPersonId, 'musa');
      expect(harun.single.type, ProphetRelationType.sibling);
    });

    test('Zakariya and Yahya project as reciprocal parent-child relations', () {
      final zakariya = verifiedFamilyRelationsFor('zakariya');
      final yahya = verifiedFamilyRelationsFor('yahya');

      expect(zakariya, hasLength(1));
      expect(zakariya.single.relatedPersonId, 'yahya');
      expect(zakariya.single.type, ProphetRelationType.child);
      expect(yahya, hasLength(1));
      expect(yahya.single.relatedPersonId, 'zakariya');
      expect(yahya.single.type, ProphetRelationType.parent);
    });

    test('shared or traditional genealogy is never inferred automatically', () {
      expect(verifiedFamilyRelationsFor('ismail'), isEmpty);
      expect(verifiedFamilyRelationsFor('ishaq'), isEmpty);
      expect(verifiedFamilyRelationsFor('yakub'), isEmpty);
    });

    test('unknown prophet id fails closed instead of returning guessed data', () {
      expect(
        () => verifiedFamilyRelationsFor('noncanonical-person'),
        throwsArgumentError,
      );
    });

    test('later tradition cannot enter verified family graph', () {
      const invalid = VerifiedProphetKinshipFact(
        id: 'traditional-genealogy',
        firstProphetId: 'ibrahim',
        secondProphetId: 'ishaq',
        kind: VerifiedProphetKinshipKind.parentChild,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'late-source',
            title: 'Later narrative',
            sourceClass: ReligiousSourceClass.laterTradition,
            licenseId: 'reference-only',
            locator: 'chapter 1',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
      expect(() => invalid.asRelations(), throwsStateError);
    });

    test('disputed certainty and missing locator are rejected', () {
      const disputed = VerifiedProphetKinshipFact(
        id: 'disputed-link',
        firstProphetId: 'ibrahim',
        secondProphetId: 'ishaq',
        kind: VerifiedProphetKinshipKind.parentChild,
        certainty: CertaintyLevel.disputed,
        sources: [
          SourceReference(
            id: 'quran-link',
            title: 'Quran reference',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 14:39',
          ),
        ],
      );
      const missingLocator = VerifiedProphetKinshipFact(
        id: 'musa-harun-siblings-q20-30',
        firstProphetId: 'musa',
        secondProphetId: 'harun',
        kind: VerifiedProphetKinshipKind.siblings,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'tanzil-uthmani-v1.1-q20-30',
            title: 'Tanzil Project — Uthmani Quran Text v1.1',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
          ),
        ],
      );

      expect(disputed.isValid, isFalse);
      expect(missingLocator.isValid, isFalse);
    });

    test('self-relations and noncanonical relations are rejected', () {
      const selfRelation = VerifiedProphetKinshipFact(
        id: 'self-link',
        firstProphetId: 'musa',
        secondProphetId: 'musa',
        kind: VerifiedProphetKinshipKind.siblings,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'quran-20-30',
            title: 'Quran 20:30',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 20:30',
          ),
        ],
      );
      const noncanonical = VerifiedProphetKinshipFact(
        id: 'noncanonical-link',
        firstProphetId: 'musa',
        secondProphetId: 'unknown-person',
        kind: VerifiedProphetKinshipKind.siblings,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'quran-20-30',
            title: 'Quran 20:30',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 20:30',
          ),
        ],
      );

      expect(selfRelation.isValid, isFalse);
      expect(noncanonical.isValid, isFalse);
    });

    test('Quran class label alone cannot forge a reviewed family source', () {
      const forgedSource = VerifiedProphetKinshipFact(
        id: 'musa-harun-siblings-q20-30',
        firstProphetId: 'musa',
        secondProphetId: 'harun',
        kind: VerifiedProphetKinshipKind.siblings,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'forged-quran-source',
            title: 'Unreviewed Quran metadata',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 20:30',
          ),
        ],
      );

      expect(forgedSource.isValid, isFalse);
      expect(() => forgedSource.asRelations(), throwsStateError);
    });

    test('reviewed source cannot be rebound to a different genealogy claim', () {
      const rebound = VerifiedProphetKinshipFact(
        id: 'musa-harun-siblings-q20-30',
        firstProphetId: 'ibrahim',
        secondProphetId: 'ishaq',
        kind: VerifiedProphetKinshipKind.parentChild,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'tanzil-uthmani-v1.1-q20-30',
            title: 'Tanzil Project — Uthmani Quran Text v1.1',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 20:30',
          ),
        ],
      );

      expect(rebound.isValid, isFalse);
    });

    test('locator and licence tampering fail closed', () {
      const wrongLocator = VerifiedProphetKinshipFact(
        id: 'zakariya-yahya-parent-child-q19-7',
        firstProphetId: 'zakariya',
        secondProphetId: 'yahya',
        kind: VerifiedProphetKinshipKind.parentChild,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'tanzil-uthmani-v1.1-q19-7',
            title: 'Tanzil Project — Uthmani Quran Text v1.1',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: 'Quran 19:8',
          ),
        ],
      );
      const wrongLicense = VerifiedProphetKinshipFact(
        id: 'musa-harun-siblings-q20-30',
        firstProphetId: 'musa',
        secondProphetId: 'harun',
        kind: VerifiedProphetKinshipKind.siblings,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'tanzil-uthmani-v1.1-q20-30',
            title: 'Tanzil Project — Uthmani Quran Text v1.1',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Quran 20:30',
          ),
        ],
      );

      expect(wrongLocator.isValid, isFalse);
      expect(wrongLicense.isValid, isFalse);
    });

    test('whole-graph audit rejects duplicate reviewed relationship claims', () {
      final musaHarun = verifiedProphetKinshipFacts.firstWhere(
        (fact) => fact.id == 'musa-harun-siblings-q20-30',
      );

      expect(
        verifiedProphetFamilyGraphIsValidFor([musaHarun, musaHarun]),
        isFalse,
      );
      expect(verifiedProphetFamilyGraphIsValidFor(const []), isFalse);
    });
  });
}
