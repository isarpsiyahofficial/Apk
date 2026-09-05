import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/domain/islamic_history_period_tree.dart';

void main() {
  group('IslamicHistoryPeriodTree T0210', () {
    test('canonical tree begins with the world before Islam', () {
      final tree = canonicalIslamicHistoryPeriodTree;

      expect(tree.periods, isNotEmpty);
      expect(tree.periods.first.id, IslamicHistoryPeriodTree.preIslamWorldId);
      expect(tree.periods.first.title.tr, 'İslam’dan Önce Dünya');
      expect(tree.periods.first.title.en, 'The World Before Islam');
      expect(tree.periods.first.title.ar, 'العالم قبل الإسلام');
      expect(tree.periods.first.certainty, HistoryDateCertainty.broadEra);
    });

    test('rejects a history tree that starts directly with 610 CE', () {
      const revelationStart = IslamicHistoryPeriod(
        id: 'revelation_610',
        title: LocalizedHistoryText(
          tr: 'Vahyin Başlangıcı',
          en: 'Beginning of Revelation',
          ar: 'بداية الوحي',
        ),
        certainty: HistoryDateCertainty.approximate,
      );

      expect(
        () => IslamicHistoryPeriodTree.validated(const [revelationStart]),
        throwsStateError,
      );
    });

    test('rejects duplicate IDs', () {
      expect(
        () => IslamicHistoryPeriodTree.validated(
          const [preIslamWorldPeriod, preIslamWorldPeriod],
        ),
        throwsStateError,
      );
    });

    test('rejects incomplete localization', () {
      const invalid = IslamicHistoryPeriod(
        id: IslamicHistoryPeriodTree.preIslamWorldId,
        title: LocalizedHistoryText(
          tr: 'İslam’dan Önce Dünya',
          en: 'The World Before Islam',
          ar: '',
        ),
        certainty: HistoryDateCertainty.broadEra,
      );

      expect(
        () => IslamicHistoryPeriodTree.validated(const [invalid]),
        throwsStateError,
      );
    });

    test('rejects missing and self-referencing parents', () {
      const missingParent = IslamicHistoryPeriod(
        id: 'late_antiquity',
        parentId: 'missing',
        title: LocalizedHistoryText(
          tr: 'Geç Antik Çağ',
          en: 'Late Antiquity',
          ar: 'العصور القديمة المتأخرة',
        ),
        certainty: HistoryDateCertainty.broadEra,
      );
      const selfParent = IslamicHistoryPeriod(
        id: IslamicHistoryPeriodTree.preIslamWorldId,
        parentId: IslamicHistoryPeriodTree.preIslamWorldId,
        title: LocalizedHistoryText(
          tr: 'İslam’dan Önce Dünya',
          en: 'The World Before Islam',
          ar: 'العالم قبل الإسلام',
        ),
        certainty: HistoryDateCertainty.broadEra,
      );

      expect(
        () => IslamicHistoryPeriodTree.validated(
          const [preIslamWorldPeriod, missingParent],
        ),
        throwsStateError,
      );
      expect(
        () => IslamicHistoryPeriodTree.validated(const [selfParent]),
        throwsStateError,
      );
    });
  });
}
