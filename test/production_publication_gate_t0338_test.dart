import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/content/production_publication_gate_t0338.dart';

void main() {
  const gate = ProductionPublicationGateT0338();
  const source = SourceReference(
    id: 'source:verified',
    title: 'Verified source',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'license:verified',
    locator: '1:1',
  );

  ReligiousContentRecord record({
    required String id,
    ContentReviewStatus status = ContentReviewStatus.published,
    ReligiousSourceClass sourceStatus = ReligiousSourceClass.quran,
    List<SourceReference> sources = const [source],
    LocalizedReligiousText text = const LocalizedReligiousText(
      tr: 'Türkçe',
      en: 'English',
      ar: 'العربية',
    ),
  }) =>
      ReligiousContentRecord(
        id: id,
        type: ContentType.editorial,
        sourceStatus: sourceStatus,
        version: 1,
        reviewStatus: status,
        certainty: CertaintyLevel.explicitSource,
        text: text,
        sources: sources,
        lastReviewedAt: DateTime.utc(2026, 9, 11),
        reviewer: 'reviewer:t0338',
      );

  test('exact published inventory is accepted and immutable', () {
    final result = gate.requirePublishedRecords(
      records: [record(id: 'a'), record(id: 'b')],
      expectedIds: const {'a', 'b'},
    );

    expect(result.map((entry) => entry.id), ['a', 'b']);
    expect(() => result.add(record(id: 'c')), throwsUnsupportedError);
  });

  test('every non-published workflow state is rejected fail-closed', () {
    for (final status in ContentReviewStatus.values) {
      if (status == ContentReviewStatus.published) continue;

      expect(
        () => gate.requirePublishedRecords(
          records: [record(id: 'blocked', status: status)],
          expectedIds: const {'blocked'},
        ),
        throwsA(isA<StateError>()),
        reason: '${status.name} must never enter production',
      );
    }
  });

  test('approved is not treated as published', () {
    expect(
      () => gate.requirePublishedRecords(
        records: [
          record(id: 'approved-only', status: ContentReviewStatus.approved),
        ],
        expectedIds: const {'approved-only'},
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('approved'),
        ),
      ),
    );
  });

  test('published label cannot bypass shared governance requirements', () {
    expect(
      () => gate.requirePublishedRecords(
        records: [
          record(
            id: 'unknown-source',
            sourceStatus: ReligiousSourceClass.unknown,
          ),
        ],
        expectedIds: const {'unknown-source'},
      ),
      throwsA(isA<StateError>()),
    );

    expect(
      () => gate.requirePublishedRecords(
        records: [
          record(
            id: 'missing-arabic',
            text: const LocalizedReligiousText(
              tr: 'Türkçe',
              en: 'English',
              ar: '',
            ),
          ),
        ],
        expectedIds: const {'missing-arabic'},
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('duplicate records fail instead of shadowing publication state', () {
    expect(
      () => gate.requirePublishedRecords(
        records: [record(id: 'same'), record(id: 'same')],
        expectedIds: const {'same'},
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('unexpected and missing canonical records both fail closed', () {
    expect(
      () => gate.requirePublishedRecords(
        records: [record(id: 'expected'), record(id: 'unexpected')],
        expectedIds: const {'expected'},
      ),
      throwsA(isA<StateError>()),
    );

    expect(
      () => gate.requirePublishedRecords(
        records: [record(id: 'expected')],
        expectedIds: const {'expected', 'missing'},
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('missing'),
        ),
      ),
    );
  });

  test('blank or empty expected inventories are invalid release inputs', () {
    expect(
      () => gate.requirePublishedRecords(
        records: [record(id: 'a')],
        expectedIds: const {},
      ),
      throwsA(isA<StateError>()),
    );
    expect(
      () => gate.requirePublishedRecords(
        records: [record(id: 'a')],
        expectedIds: const {'   '},
      ),
      throwsA(isA<StateError>()),
    );
  });
}
