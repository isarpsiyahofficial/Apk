import 'package:flutter/material.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

import '../../../core/storage/secure_private_user_store.dart';
import '../../quran/data/quran_reading_progress_repository.dart';
import '../../quran/presentation/quran_reader_page.dart';
import '../data/canonical_prophets.dart';
import '../data/prophet_biography_t0194_dataset.dart';
import '../data/prophet_deep_links.dart';
import '../data/revelation_journey_timeline.dart';

typedef ProphetQuranTargetOpener = Future<bool> Function(
  BuildContext context,
  ProphetDeepLink link,
);

class RevelationJourneyPage extends StatefulWidget {
  const RevelationJourneyPage({
    super.key,
    this.quranTargetOpener,
  });

  final ProphetQuranTargetOpener? quranTargetOpener;

  @override
  State<RevelationJourneyPage> createState() => _RevelationJourneyPageState();
}

class _RevelationJourneyPageState extends State<RevelationJourneyPage> {
  RevelationJourneyPeriod? _selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allSegments = buildRevelationJourneyTimeline();
    final segments = _selectedPeriod == null
        ? allSegments
        : revelationJourneyForPeriod(_selectedPeriod!);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.revelationJourneyTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 700 ? 32.0 : 16.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 32),
              children: [
                Text(
                  l10n.revelationJourneyIntro,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        key: const ValueKey('journey-filter-all'),
                        label: Text(l10n.revelationJourneyAllPeriods),
                        selected: _selectedPeriod == null,
                        onSelected: (_) => setState(() => _selectedPeriod = null),
                      ),
                      const SizedBox(width: 8),
                      for (final period in RevelationJourneyPeriod.values) ...[
                        ChoiceChip(
                          key: ValueKey('journey-filter-${period.name}'),
                          label: Text(_periodLabel(l10n, period)),
                          selected: _selectedPeriod == period,
                          onSelected: (_) => setState(() => _selectedPeriod = period),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                for (final segment in segments) ...[
                  _TimelineSegmentCard(
                    segment: segment,
                    quranTargetOpener:
                        widget.quranTargetOpener ?? _openQuranTarget,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimelineSegmentCard extends StatelessWidget {
  const _TimelineSegmentCard({
    required this.segment,
    required this.quranTargetOpener,
  });

  final RevelationJourneySegment segment;
  final ProphetQuranTargetOpener quranTargetOpener;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final identities = segment.prophetIds.map(_identityForId).toList();

    return Semantics(
      container: true,
      label: segment.isParallel
          ? l10n.revelationJourneyParallelSemantics
          : l10n.revelationJourneySequentialSemantics,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _periodLabel(l10n, segment.period),
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  if (segment.isParallel)
                    Chip(
                      key: ValueKey('parallel-${segment.order}'),
                      avatar: const Icon(Icons.view_week_outlined, size: 18),
                      label: Text(l10n.revelationJourneyParallel),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final identity in identities)
                    _ProphetNamePill(
                      key: ValueKey(
                        'journey-prophet-${identity.canonicalId}',
                      ),
                      identity: identity,
                      quranTargetOpener: quranTargetOpener,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.revelationJourneyApproximateNotice,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProphetNamePill extends StatelessWidget {
  const _ProphetNamePill({
    required this.identity,
    required this.quranTargetOpener,
    super.key,
  });

  final CanonicalProphetIdentity identity;
  final ProphetQuranTargetOpener quranTargetOpener;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final name = switch (languageCode) {
      'ar' => identity.name.ar,
      'en' => identity.name.en,
      _ => identity.name.tr,
    };

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProphetQuranReferences(
          context,
          identity: identity,
          displayName: name,
          quranTargetOpener: quranTargetOpener,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              const SizedBox(width: 6),
              const Icon(Icons.menu_book_outlined, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showProphetQuranReferences(
  BuildContext context, {
  required CanonicalProphetIdentity identity,
  required String displayName,
  required ProphetQuranTargetOpener quranTargetOpener,
}) async {
  final biography = canonicalProphetBiographyT0194Dataset.firstWhere(
    (entry) => entry.identity.canonicalId == identity.canonicalId,
  );
  final references = biography.quranReferences;
  if (references.isEmpty) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      return SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(sheetContext).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.revelationJourneyQuranReferences),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  itemCount: references.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (itemContext, index) {
                    final reference = references[index];
                    final link = ProphetDeepLink.quranVerse(
                      prophetId: identity.canonicalId,
                      verse: reference,
                    );
                    return ListTile(
                      key: ValueKey(
                        'journey-quran-${identity.canonicalId}-${reference.stableId}',
                      ),
                      leading: const Icon(Icons.menu_book_outlined),
                      title: Text('${reference.surah}:${reference.ayah}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final opened = await quranTargetOpener(context, link);
                        if (!opened || !sheetContext.mounted) return;
                        Navigator.of(sheetContext).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> _openQuranTarget(
  BuildContext context,
  ProphetDeepLink link,
) async {
  if (!link.isValid ||
      link.kind != ProphetDeepLinkKind.quranVerse ||
      link.surah == null ||
      link.ayah == null) {
    return false;
  }

  final progressRepository = QuranReadingProgressRepository(
    SecurePrivateUserStore(),
  );
  try {
    final current = await progressRepository.load();
    final target = current.copyWith(surah: link.surah, ayah: link.ayah);
    await progressRepository.save(target);
    if (!context.mounted) return false;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => QuranReaderPage(
          progressRepository: progressRepository,
        ),
      ),
    );
    return true;
  } catch (_) {
    if (context.mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.revelationJourneyQuranOpenFailed)),
      );
    }
    return false;
  }
}

CanonicalProphetIdentity _identityForId(String id) =>
    canonicalQuranNamedProphets.firstWhere((entry) => entry.canonicalId == id);

String _periodLabel(
  AppLocalizations l10n,
  RevelationJourneyPeriod period,
) =>
    switch (period) {
      RevelationJourneyPeriod.firstProphets =>
        l10n.revelationJourneyPeriodFirstProphets,
      RevelationJourneyPeriod.abrahamic =>
        l10n.revelationJourneyPeriodAbrahamic,
      RevelationJourneyPeriod.israelite =>
        l10n.revelationJourneyPeriodIsraelite,
      RevelationJourneyPeriod.isa => l10n.revelationJourneyPeriodIsa,
      RevelationJourneyPeriod.muhammad =>
        l10n.revelationJourneyPeriodMuhammad,
    };
