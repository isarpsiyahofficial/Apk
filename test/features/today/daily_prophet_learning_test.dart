import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';

void main() {
  test('daily learning is deterministic and source-backed', () {
    final date = DateTime(2026, 8, 30);
    final first = dailyProphetLearningForDate(date);
    final second = dailyProphetLearningForDate(date);

    expect(first, isNotNull);
    expect(second, isNotNull);
    expect(second!.prophetId, first!.prophetId);
    expect(second.sectionKey, first.sectionKey);
    expect(first.sectionKey, isNot(ProphetBiographySectionKey.mainMessage));
    expect(first.field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(first.field.sources, isNotEmpty);
    expect(
      first.field.sources.every(
        (source) => source.locator?.trim().isNotEmpty ?? false,
      ),
      isTrue,
    );
    expect(
      canonicalProphetBiographyT0194Dataset.any(
        (biography) => biography.identity.canonicalId == first.prophetId,
      ),
      isTrue,
    );
  });

  test('a full year never promotes pending research into recommendations', () {
    for (var day = 0; day < 366; day++) {
      final suggestion = dailyProphetLearningForDate(
        DateTime.utc(2026, 1, 1).add(Duration(days: day)),
      );

      expect(suggestion, isNotNull, reason: 'day=$day');
      expect(
        suggestion!.field.status,
        ProphetBiographyFieldStatus.sourceBacked,
        reason: 'day=$day prophet=${suggestion.prophetId}',
      );
      expect(
        suggestion.field.sources.every(
          (source) => source.locator?.trim().isNotEmpty ?? false,
        ),
        isTrue,
        reason: 'day=$day prophet=${suggestion.prophetId}',
      );
    }
  });
}
