enum HistoryDateCertainty { exact, approximate, broadEra, unknown }

class LocalizedHistoryText {
  const LocalizedHistoryText({
    required this.tr,
    required this.en,
    required this.ar,
  });

  final String tr;
  final String en;
  final String ar;

  bool get isComplete =>
      tr.trim().isNotEmpty && en.trim().isNotEmpty && ar.trim().isNotEmpty;
}

class IslamicHistoryPeriod {
  const IslamicHistoryPeriod({
    required this.id,
    required this.title,
    required this.certainty,
    this.parentId,
  });

  final String id;
  final LocalizedHistoryText title;
  final HistoryDateCertainty certainty;
  final String? parentId;
}

class IslamicHistoryPeriodTree {
  IslamicHistoryPeriodTree._(this.periods);

  factory IslamicHistoryPeriodTree.validated(
    List<IslamicHistoryPeriod> periods,
  ) {
    if (periods.isEmpty) {
      throw StateError('History period tree must not be empty.');
    }

    final byId = <String, IslamicHistoryPeriod>{};
    for (final period in periods) {
      if (period.id.trim().isEmpty || !period.title.isComplete) {
        throw StateError('History periods require stable IDs and TR/EN/AR titles.');
      }
      if (byId.containsKey(period.id)) {
        throw StateError('Duplicate history period ID: ${period.id}');
      }
      byId[period.id] = period;
    }

    if (periods.first.id != preIslamWorldId) {
      throw StateError(
        'Islamic history must begin with the pre-Islam world context, not 610 CE.',
      );
    }

    final root = byId[preIslamWorldId];
    if (root == null || root.parentId != null) {
      throw StateError('The pre-Islam world period must be the single root.');
    }

    for (final period in periods) {
      final parentId = period.parentId;
      if (period.id == preIslamWorldId) {
        continue;
      }
      if (parentId == null) {
        throw StateError(
          'History period ${period.id} must be connected to the canonical root.',
        );
      }
      if (!byId.containsKey(parentId)) {
        throw StateError(
          'History period ${period.id} references missing parent $parentId.',
        );
      }
      if (parentId == period.id) {
        throw StateError('History period ${period.id} cannot parent itself.');
      }
    }

    for (final period in periods) {
      final visited = <String>{};
      var current = period;
      while (current.id != preIslamWorldId) {
        if (!visited.add(current.id)) {
          throw StateError(
            'History period tree contains a parent cycle at ${current.id}.',
          );
        }
        final parentId = current.parentId;
        if (parentId == null) {
          throw StateError(
            'History period ${period.id} is disconnected from the canonical root.',
          );
        }
        current = byId[parentId]!;
      }
    }

    return IslamicHistoryPeriodTree._(List.unmodifiable(periods));
  }

  static const String preIslamWorldId = 'pre_islam_world';

  final List<IslamicHistoryPeriod> periods;
}

const preIslamWorldPeriod = IslamicHistoryPeriod(
  id: IslamicHistoryPeriodTree.preIslamWorldId,
  title: LocalizedHistoryText(
    tr: 'İslam’dan Önce Dünya',
    en: 'The World Before Islam',
    ar: 'العالم قبل الإسلام',
  ),
  certainty: HistoryDateCertainty.broadEra,
);

final canonicalIslamicHistoryPeriodTree = IslamicHistoryPeriodTree.validated(
  const [preIslamWorldPeriod],
);
