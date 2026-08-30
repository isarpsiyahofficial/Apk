import 'package:flutter/material.dart';

import '../data/canonical_prophets.dart';
import '../data/revelation_journey_timeline.dart';

class RevelationJourneyPage extends StatefulWidget {
  const RevelationJourneyPage({super.key});

  @override
  State<RevelationJourneyPage> createState() => _RevelationJourneyPageState();
}

class _RevelationJourneyPageState extends State<RevelationJourneyPage> {
  RevelationJourneyPeriod? _selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final copy = _JourneyCopy.forLocale(Localizations.localeOf(context));
    final allSegments = buildRevelationJourneyTimeline();
    final segments = _selectedPeriod == null
        ? allSegments
        : revelationJourneyForPeriod(_selectedPeriod!);

    return Scaffold(
      appBar: AppBar(title: Text(copy.title)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 700 ? 32.0 : 16.0;
            return ListView(
              padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 32),
              children: [
                Text(copy.intro, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        key: const ValueKey('journey-filter-all'),
                        label: Text(copy.allPeriods),
                        selected: _selectedPeriod == null,
                        onSelected: (_) => setState(() => _selectedPeriod = null),
                      ),
                      const SizedBox(width: 8),
                      for (final period in RevelationJourneyPeriod.values) ...[
                        ChoiceChip(
                          key: ValueKey('journey-filter-${period.name}'),
                          label: Text(copy.periodLabel(period)),
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
                  _TimelineSegmentCard(segment: segment, copy: copy),
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
  const _TimelineSegmentCard({required this.segment, required this.copy});

  final RevelationJourneySegment segment;
  final _JourneyCopy copy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final identities = segment.prophetIds.map(_identityForId).toList();

    return Semantics(
      container: true,
      label: segment.isParallel ? copy.parallelSemantics : copy.sequentialSemantics,
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
                      copy.periodLabel(segment.period),
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  if (segment.isParallel)
                    Chip(
                      key: ValueKey('parallel-${segment.order}'),
                      avatar: const Icon(Icons.view_week_outlined, size: 18),
                      label: Text(copy.parallel),
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
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(copy.approximateNotice, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProphetNamePill extends StatelessWidget {
  const _ProphetNamePill({required this.identity, super.key});

  final CanonicalProphetIdentity identity;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final name = switch (languageCode) {
      'ar' => identity.name.ar,
      'en' => identity.name.en,
      _ => identity.name.tr,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(name),
      ),
    );
  }
}

CanonicalProphetIdentity _identityForId(String id) =>
    canonicalQuranNamedProphets.firstWhere((entry) => entry.canonicalId == id);

class _JourneyCopy {
  const _JourneyCopy({
    required this.title,
    required this.intro,
    required this.allPeriods,
    required this.parallel,
    required this.approximateNotice,
    required this.parallelSemantics,
    required this.sequentialSemantics,
    required this.periods,
  });

  factory _JourneyCopy.forLocale(Locale locale) {
    if (locale.languageCode == 'ar') {
      return const _JourneyCopy(
        title: 'رحلة الوحي',
        intro: 'خط زمني تعليمي تقريبي. تُعرض الفترات المتزامنة بالتوازي، ولا تُختلق تواريخ دقيقة عندما لا يثبتها مصدر موثوق.',
        allPeriods: 'كل الفترات',
        parallel: 'متوازٍ',
        approximateNotice: 'الفترة تقريبية؛ التاريخ الدقيق غير مثبت هنا.',
        parallelSemantics: 'أنبياء معروضون في فترة متوازية',
        sequentialSemantics: 'مرحلة في التسلسل التقريبي',
        periods: {
          RevelationJourneyPeriod.firstProphets: 'الأنبياء الأوائل',
          RevelationJourneyPeriod.abrahamic: 'الفترة الإبراهيمية',
          RevelationJourneyPeriod.israelite: 'أنبياء بني إسرائيل',
          RevelationJourneyPeriod.isa: 'فترة عيسى',
          RevelationJourneyPeriod.muhammad: 'فترة محمد',
        },
      );
    }
    if (locale.languageCode == 'en') {
      return const _JourneyCopy(
        title: 'Revelation Journey',
        intro: 'An approximate educational timeline. Broad contemporaneous periods are shown in parallel, and exact dates are never invented when reliable sources do not establish them.',
        allPeriods: 'All periods',
        parallel: 'Parallel',
        approximateNotice: 'Approximate period; no exact date is asserted here.',
        parallelSemantics: 'Prophets shown in a parallel period',
        sequentialSemantics: 'Stage in the approximate chronology',
        periods: {
          RevelationJourneyPeriod.firstProphets: 'First prophets',
          RevelationJourneyPeriod.abrahamic: 'Abrahamic period',
          RevelationJourneyPeriod.israelite: 'Israelite prophets',
          RevelationJourneyPeriod.isa: 'Jesus period',
          RevelationJourneyPeriod.muhammad: 'Muhammad period',
        },
      );
    }
    return const _JourneyCopy(
      title: 'Vahiy Yolculuğu',
      intro: 'Yaklaşık ve eğitsel bir zaman çizelgesidir. Geniş anlamda aynı dönemde değerlendirilen peygamberler paralel gösterilir; güvenilir kaynak kesin tarih vermiyorsa tarih uydurulmaz.',
      allPeriods: 'Tüm dönemler',
      parallel: 'Paralel',
      approximateNotice: 'Dönem yaklaşık gösterilir; burada kesin tarih iddia edilmez.',
      parallelSemantics: 'Paralel dönemde gösterilen peygamberler',
      sequentialSemantics: 'Yaklaşık kronolojide bir aşama',
      periods: {
        RevelationJourneyPeriod.firstProphets: 'İlk peygamberler',
        RevelationJourneyPeriod.abrahamic: 'İbrahimî dönem',
        RevelationJourneyPeriod.israelite: 'İsrailoğulları peygamberleri',
        RevelationJourneyPeriod.isa: 'Hz. İsa dönemi',
        RevelationJourneyPeriod.muhammad: 'Hz. Muhammed dönemi',
      },
    );
  }

  final String title;
  final String intro;
  final String allPeriods;
  final String parallel;
  final String approximateNotice;
  final String parallelSemantics;
  final String sequentialSemantics;
  final Map<RevelationJourneyPeriod, String> periods;

  String periodLabel(RevelationJourneyPeriod period) => periods[period]!;
}
