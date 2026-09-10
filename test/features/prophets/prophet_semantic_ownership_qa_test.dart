import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

ProphetSemanticClaim _claim({
  required String biography,
  required String subject,
  required ProphetSemanticDimension dimension,
  required String key,
  bool contextReference = false,
  List<String> sourceIds = const ['verified-source'],
}) =>
    ProphetSemanticClaim(
      biographyProphetId: biography,
      subjectProphetId: subject,
      dimension: dimension,
      claimKey: key,
      sourceIds: sourceIds,
      contextReference: contextReference,
    );

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('Yusuf event copied into Muhammad biography fails closed', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'muhammad',
          subject: 'yusuf',
          dimension: ProphetSemanticDimension.event,
          key: 'yusuf_well_and_egypt',
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('fact belongs to yusuf'));
  });

  test('Muhammad Hijra event copied into Yusuf biography fails closed', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'yusuf',
          subject: 'muhammad',
          dimension: ProphetSemanticDimension.event,
          key: 'muhammad_hijra_to_medina',
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('exclusive event belongs to muhammad'));
  });

  test('natural contextual mention of another prophet is not ownership error', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'muhammad',
          subject: 'ibrahim',
          dimension: ProphetSemanticDimension.familyLineage,
          key: 'familyLineage:contextual_lineage_reference',
          contextReference: true,
        ),
      ],
    );

    expect(result.isValid, isTrue);
  });

  test('full-release mode requires all semantic dimensions for all 25 prophets', () {
    final result = qa.audit(
      claims: [
        _claim(
          biography: 'muhammad',
          subject: 'muhammad',
          dimension: ProphetSemanticDimension.identity,
          key: 'identity:muhammad',
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('semantic cross-check coverage missing'));
    expect(result.errors.join('\n'), contains('yusuf'));
  });

  test('claim without source evidence fails closed', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: const [
        ProphetSemanticClaim(
          biographyProphetId: 'muhammad',
          subjectProphetId: 'muhammad',
          dimension: ProphetSemanticDimension.historicalDate,
          claimKey: 'historicalDate:hijra_year',
          sourceIds: [],
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('incomplete semantic evidence'));
  });

  test('known exclusive event cannot be relabelled as another dimension', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'muhammad',
          subject: 'muhammad',
          dimension: ProphetSemanticDimension.historicalDate,
          key: 'muhammad_hijra_to_medina',
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('must use the event dimension'));
  });

  test('dimension label cannot be spoofed with a differently namespaced key', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'muhammad',
          subject: 'muhammad',
          dimension: ProphetSemanticDimension.hadith,
          key: 'geography:medina',
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('must be namespaced as hadith:'));
  });

  test('duplicate semantic source IDs fail closed', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        _claim(
          biography: 'yusuf',
          subject: 'yusuf',
          dimension: ProphetSemanticDimension.quranVerse,
          key: 'quranVerse:yusuf_12_4',
          sourceIds: const ['quran-12-4', 'quran-12-4'],
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('duplicate semantic source evidence'));
  });

  test('duplicate claim evidence cannot count twice toward release coverage', () {
    final duplicate = _claim(
      biography: 'musa',
      subject: 'musa',
      dimension: ProphetSemanticDimension.geography,
      key: 'geography:exodus_context',
    );
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [duplicate, duplicate],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.join('\n'), contains('duplicate semantic claim evidence'));
  });
}