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

    test('Ishaq to Yakub to Yusuf chain is reviewed and chronology-consistent', () {
      final ishaq = verifiedFamilyRelationsFor('ishaq');
      final yakub = verifiedFamilyRelationsFor('yakub');
      final yusuf = verifiedFamilyRelationsFor('yusuf');

      expect(
        ishaq.singleWhere((relation) => relation.relatedPersonId == 'yakub').type,
        ProphetRelationType.child,
      );
      expect(
        yakub.singleWhere((relation) => relation.relatedPersonId == 'ishaq').type,
        ProphetRelationType.parent,
      );
      expect(
        yakub.singleWhere((relation) => relation.relatedPersonId == 'yusuf').type,
        ProphetRelationType.child,
      );
      expect(yusuf.single.relatedPersonId, 'yakub');
      expect(yusuf.single.type, ProphetRelationType.parent);
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

    test('direct evidence never manufactures transitive ancestry', () {
      expect(
        verifiedFamilyRelationsFor('ibrahim')
            .where((relation) => relation.relatedPersonId == 'yakub'),
        isEmpty,
      );
      expect(
        verifiedFamilyRelationsFor('ishaq')
            .where((relation) => relation.relatedPersonId == 'yusuf'),
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
        byId['ishaq-yakub-parent-child-q21-72']!.sources.single.locator,
        'Quran 21:72',
      );
      expect(
        byId['yakub-yusuf-parent-child-q12-4-6']!.sources.single.locator,
        'Quran 12:4-6',
      );
      expect(
        byId['dawud-sulayman-parent-child-q38-30']!.sources.single.locator,
        'Quran 38:30',
      );
    });
  });
}
