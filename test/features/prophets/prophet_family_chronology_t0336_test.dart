import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

void main() {
  group('T0336 family-lineage and chronology cross-check', () {
    test('reviewed family graph stays chronology-consistent', () {
      expect(verifiedProphetFamilyGraphIsValid, isTrue);
      expect(verifiedProphetFamilyChronologyIsConsistent, isTrue);
    });

    test('Ibrahim projects only reviewed Ismail and Ishaq child relations', () {
      final relations = verifiedFamilyRelationsFor('ibrahim');
      final childIds = relations
          .where((relation) => relation.type == ProphetRelationType.child)
          .map((relation) => relation.relatedPersonId)
          .toSet();

      expect(childIds, {'ismail', 'ishaq'});
      expect(relations, hasLength(2));
    });

    test('Dawud and Sulayman project reciprocal parent-child relation', () {
      final dawud = verifiedFamilyRelationsFor('dawud');
      final sulayman = verifiedFamilyRelationsFor('sulayman');

      expect(dawud, hasLength(1));
      expect(dawud.single.relatedPersonId, 'sulayman');
      expect(dawud.single.type, ProphetRelationType.child);
      expect(sulayman, hasLength(1));
      expect(sulayman.single.relatedPersonId, 'dawud');
      expect(sulayman.single.type, ProphetRelationType.parent);
    });

    test('unreviewed Ishaq to Yakub relation is not inferred', () {
      final ishaq = verifiedFamilyRelationsFor('ishaq');
      final yakub = verifiedFamilyRelationsFor('yakub');

      expect(
        ishaq.where((relation) => relation.relatedPersonId == 'yakub'),
        isEmpty,
      );
      expect(
        yakub.where((relation) => relation.relatedPersonId == 'ishaq'),
        isEmpty,
      );
    });

    test('reviewed lineage locators stay pinned to exact Quran anchors', () {
      final byId = {
        for (final fact in verifiedProphetKinshipFacts) fact.id: fact,
      };

      expect(
        byId['ibrahim-ismail-parent-child-q14-39']!.sources.single.locator,
        'Quran 14:39',
      );
      expect(
        byId['ibrahim-ishaq-parent-child-q14-39']!.sources.single.locator,
        'Quran 14:39',
      );
      expect(
        byId['dawud-sulayman-parent-child-q38-30']!.sources.single.locator,
        'Quran 38:30',
      );
    });
  });
}
