import 'package:flutter/material.dart';
import 'package:islami_hayat/core/responsive/app_breakpoints.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';
import 'package:islami_hayat/features/today/domain/daily_verse_prophet_story.dart';
import 'package:islami_hayat/features/today/presentation/daily_prophet_learning_card.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class TodayPage extends StatefulWidget {
  TodayPage({
    super.key,
    QuranReadingProgressRepository? quranProgressRepository,
    QuranVerseUserStateDataSource? verseUserStateRepository,
    DailyVerseDataSource? dailyVerseRepository,
    this.now,
    this.onContinueQuran,
    this.onOpenDailyVerse,
    this.onOpenProphetStory,
  }) : quranProgressRepository = quranProgressRepository ??
            QuranReadingProgressRepository(SecurePrivateUserStore()),
       verseUserStateRepository =
           verseUserStateRepository ?? QuranVerseUserStateRepository(),
       dailyVerseRepository = dailyVerseRepository ?? DailyVerseRepository();

  final QuranReadingProgressRepository quranProgressRepository;
  final QuranVerseUserStateDataSource verseUserStateRepository;
  final DailyVerseDataSource dailyVerseRepository;
  final DateTime Function()? now;
  final VoidCallback? onContinueQuran;
  final Future<void> Function(QuranAddress address)? onOpenDailyVerse;
  final ValueChanged<String>? onOpenProphetStory;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late Future<QuranReadingProgress?> _progressFuture;
  late DateTime _today;
  Future<DailyVerse>? _dailyVerseFuture;
  String? _dailyVerseLanguage;

  @override
  void initState() {
    super.initState();
    _progressFuture = widget.quranProgressRepository.loadSaved();
    _today = widget.now?.call() ?? DateTime.now();
  }

  @override
  void didUpdateWidget(covariant TodayPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
      oldWidget.quranProgressRepository,
      widget.quranProgressRepository,
    )) {
      _progressFuture = widget.quranProgressRepository.loadSaved();
    }
    if (!identical(oldWidget.dailyVerseRepository, widget.dailyVerseRepository) ||
        oldWidget.now != widget.now) {
      _today = widget.now?.call() ?? DateTime.now();
      _dailyVerseFuture = null;
      _dailyVerseLanguage = null;
    }
  }

  Future<DailyVerse> _dailyVerseFor(String languageCode) {
    if (_dailyVerseFuture == null || _dailyVerseLanguage != languageCode) {
      _dailyVerseLanguage = languageCode;
      _dailyVerseFuture = widget.dailyVerseRepository.forDate(
        date: _today,
        languageCode: languageCode,
      );
    }
    return _dailyVerseFuture!;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final padding = AppBreakpoints.horizontalPadding(width);
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final learningSuggestion = dailyProphetLearningForDate(_today);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            title: l10n.todayGreeting,
            subtitle: l10n.todaySubtitle,
          ),
          const SizedBox(height: 36),
          FutureBuilder<DailyVerse>(
            future: _dailyVerseFor(languageCode),
            builder: (context, snapshot) {
              final verse = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError ||
                  verse == null) {
                return _EditorialBlock(
                  eyebrow: l10n.dailyVerseTitle,
                  icon: Icons.menu_book_outlined,
                  body: l10n.contentPending,
                );
              }
              return _DailyVerseBlock(
                eyebrow: l10n.dailyVerseTitle,
                verse: verse,
                verseUserStateRepository: widget.verseUserStateRepository,
                onTap: widget.onOpenDailyVerse,
                prophetStoryIds: prophetStoryIdsForDailyVerse(verse.address),
                onOpenProphetStory: widget.onOpenProphetStory,
              );
            },
          ),
          const SizedBox(height: 22),
          _EditorialBlock(
            eyebrow: l10n.dailyDuaTitle,
            icon: Icons.volunteer_activism_outlined,
            body: l10n.contentPending,
          ),
          const SizedBox(height: 22),
          _EditorialBlock(
            eyebrow: l10n.historyTodayTitle,
            icon: Icons.history_edu_outlined,
            body: l10n.contentPending,
          ),
          if (learningSuggestion != null) ...[
            const SizedBox(height: 22),
            DailyProphetLearningCard(
              suggestion: learningSuggestion,
              title: l10n.dailyProphetLearningTitle,
              prophetName: _prophetDisplayName(
                learningSuggestion.prophetId,
                languageCode,
              ),
              sourceLabel: l10n.sourceLabel,
              openLabel: l10n.dailyProphetLearningOpen,
              onOpen: widget.onOpenProphetStory,
            ),
          ],
          const SizedBox(height: 34),
          _QuickActions(
            items: [
              _QuickActionData(Icons.search, l10n.quickTopicSearch),
              _QuickActionData(Icons.volunteer_activism_outlined, l10n.quickDuas),
              _QuickActionData(Icons.touch_app_outlined, l10n.quickDhikr),
              _QuickActionData(Icons.explore_outlined, l10n.quickExplore),
            ],
          ),
          const SizedBox(height: 28),
          FutureBuilder<QuranReadingProgress?>(
            future: _progressFuture,
            builder: (context, snapshot) {
              final progress = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done ||
                  snapshot.hasError ||
                  progress == null) {
                return const SizedBox.shrink();
              }
              return _ContinueQuranBlock(
                title: l10n.continueQuranTitle,
                position: l10n.continueQuranPosition(
                  progress.surah,
                  progress.ayah,
                ),
                onTap: widget.onContinueQuran,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 10),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _DailyVerseBlock extends StatefulWidget {
  const _DailyVerseBlock({
    required this.eyebrow,
    required this.verse,
    required this.verseUserStateRepository,
    required this.onTap,
    required this.prophetStoryIds,
    required this.onOpenProphetStory,
  });

  final String eyebrow;
  final DailyVerse verse;
  final QuranVerseUserStateDataSource verseUserStateRepository;
  final Future<void> Function(QuranAddress address)? onTap;
  final List<String> prophetStoryIds;
  final ValueChanged<String>? onOpenProphetStory;

  @override
  State<_DailyVerseBlock> createState() => _DailyVerseBlockState();
}

class _DailyVerseBlockState extends State<_DailyVerseBlock> {
  late Future<QuranVerseUserState> _stateFuture;
  bool _updatingFavorite = false;

  @override
  void initState() {
    super.initState();
    _stateFuture = widget.verseUserStateRepository.load();
  }

  @override
  void didUpdateWidget(covariant _DailyVerseBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
          oldWidget.verseUserStateRepository,
          widget.verseUserStateRepository,
        ) ||
        oldWidget.verse.address.key != widget.verse.address.key) {
      _stateFuture = widget.verseUserStateRepository.load();
    }
  }

  Future<void> _toggleFavorite() async {
    if (_updatingFavorite) return;
    setState(() => _updatingFavorite = true);
    try {
      final state = await widget.verseUserStateRepository.toggleFavorite(
        surah: widget.verse.address.surah,
        ayah: widget.verse.address.ayah,
      );
      if (!mounted) return;
      setState(() {
        _stateFuture = Future.value(state);
      });
    } finally {
      if (mounted) setState(() => _updatingFavorite = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return Semantics(
      button: widget.onTap != null,
      child: InkWell(
        key: const ValueKey('daily-verse-card'),
        onTap: widget.onTap == null
            ? null
            : () {
                widget.onTap!(widget.verse.address);
              },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.dividerColor),
              bottom: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eyebrow.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.verse.arabic,
                      key: const ValueKey('daily-verse-arabic'),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.titleLarge?.copyWith(height: 1.9),
                    ),
                    if (widget.verse.translation case final translation?) ...[
                      const SizedBox(height: 12),
                      Text(
                        translation,
                        key: const ValueKey('daily-verse-translation'),
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      widget.verse.sourceLabel,
                      key: const ValueKey('daily-verse-source'),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (widget.onOpenProphetStory != null &&
                        widget.prophetStoryIds.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final prophetId in widget.prophetStoryIds)
                            TextButton.icon(
                              key: ValueKey(
                                'daily-verse-prophet-story-$prophetId',
                              ),
                              onPressed: () =>
                                  widget.onOpenProphetStory!(prophetId),
                              icon: const Icon(Icons.auto_stories_outlined),
                              label: Text(
                                _prophetStoryActionLabel(
                                  languageCode,
                                  _prophetDisplayName(
                                    prophetId,
                                    languageCode,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FutureBuilder<QuranVerseUserState>(
                future: _stateFuture,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final favorite = state?.isFavorite(
                        surah: widget.verse.address.surah,
                        ayah: widget.verse.address.ayah,
                      ) ??
                      false;
                  return IconButton(
                    key: const ValueKey('daily-verse-favorite'),
                    tooltip: favorite
                        ? l10n.quranRemoveFavorite
                        : l10n.quranAddFavorite,
                    onPressed: snapshot.connectionState == ConnectionState.done &&
                            !_updatingFavorite
                        ? _toggleFavorite
                        : null,
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: favorite ? theme.colorScheme.primary : null,
                    ),
                  );
                },
              ),
              if (widget.onTap != null) ...[
                const SizedBox(width: 4),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _prophetDisplayName(String prophetId, String languageCode) {
  final biography = canonicalProphetBiographyT0194Dataset.firstWhere(
    (entry) => entry.identity.canonicalId == prophetId,
  );
  return switch (languageCode) {
    'ar' => biography.identity.name.ar,
    'en' => biography.identity.name.en,
    _ => biography.identity.name.tr,
  };
}

String _prophetStoryActionLabel(String languageCode, String prophetName) {
  return switch (languageCode) {
    'ar' => 'استكشف هذه القصة · $prophetName',
    'en' => 'Explore this story · $prophetName',
    _ => 'Bu kıssayı keşfet · $prophetName',
  };
}

class _EditorialBlock extends StatelessWidget {
  const _EditorialBlock({
    required this.eyebrow,
    required this.icon,
    required this.body,
  });

  final String eyebrow;
  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor),
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 22, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(body, style: theme.textTheme.titleLarge),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        ],
      ),
    );
  }
}

class _ContinueQuranBlock extends StatelessWidget {
  const _ContinueQuranBlock({
    required this.title,
    required this.position,
    required this.onTap,
  });

  final String title;
  final String position;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: onTap != null,
      child: InkWell(
        key: const ValueKey('continue-quran-card'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.bookmark_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(position, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.items});

  final List<_QuickActionData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 4 : 2;
        final gap = 12.0;
        final itemWidth =
            (constraints.maxWidth - ((columns - 1) * gap)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _QuickAction(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.item});

  final _QuickActionData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(item.icon, color: theme.colorScheme.primary, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: Text(item.label, style: theme.textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData(this.icon, this.label);

  final IconData icon;
  final String label;
}