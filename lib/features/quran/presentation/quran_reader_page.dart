import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/trusted_content_error_view.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/profile/presentation/sources_licenses_page.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reflection_note_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_structure_metadata.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class QuranReaderPage extends StatefulWidget {
  QuranReaderPage({
    super.key,
    QuranReaderDataSource? repository,
    QuranReadingProgressRepository? progressRepository,
    QuranVerseUserStateDataSource? verseUserStateRepository,
    QuranReflectionNoteDataSource? reflectionNoteRepository,
  }) : repository = repository ?? QuranReaderRepository(),
       progressRepository =
           progressRepository ??
           QuranReadingProgressRepository(SecurePrivateUserStore()),
       verseUserStateRepository =
           verseUserStateRepository ?? QuranVerseUserStateRepository(),
       reflectionNoteRepository =
           reflectionNoteRepository ?? QuranReflectionNoteRepository();

  final QuranReaderDataSource repository;
  final QuranReadingProgressRepository progressRepository;
  final QuranVerseUserStateDataSource verseUserStateRepository;
  final QuranReflectionNoteDataSource reflectionNoteRepository;

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

final class _QuranReaderPageState extends State<QuranReaderPage> {
  static const double _minQuranScale = 0.8;
  static const double _maxQuranScale = 1.6;
  static const double _quranScaleStep = 0.1;

  Future<QuranReaderChapter>? _chapterFuture;
  String? _languageCode;
  int _selectedSurah = 1;
  int _savedAyah = 1;
  double _quranScale = 1;
  bool _restoreStarted = false;
  bool _progressReady = false;
  bool _collectionMutationInFlight = false;
  QuranVerseUserState _verseUserState = const QuranVerseUserState.empty();
  Map<String, String> _reflectionNotes = const <String, String>{};

  int get _selectedJuz => quranJuzForPosition(
    surah: _selectedSurah,
    ayah: _savedAyah,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    final languageChanged = _languageCode != languageCode;
    _languageCode = languageCode;

    if (!_restoreStarted) {
      _restoreStarted = true;
      unawaited(_restorePrivateState());
      return;
    }

    if (_progressReady && languageChanged) {
      setState(_loadSelectedChapter);
    }
  }

  Future<void> _restorePrivateState() async {
    QuranReadingProgress progress;
    QuranVerseUserState verseUserState;
    Map<String, String> reflectionNotes;
    try {
      progress = await widget.progressRepository.load();
    } on QuranReadingProgressFormatException {
      try {
        await widget.progressRepository.reset();
      } catch (_) {
        // Private progress cleanup failure must not block trusted Quran content.
      }
      progress = QuranReadingProgress.initial();
    } catch (_) {
      progress = QuranReadingProgress.initial();
    }

    try {
      verseUserState = await widget.verseUserStateRepository.load();
    } catch (_) {
      verseUserState = const QuranVerseUserState.empty();
    }

    try {
      reflectionNotes = await widget.reflectionNoteRepository.loadNotes();
    } catch (_) {
      // Personal notes are convenience state. Storage failure must not block or
      // alter the separately verified Quran text.
      reflectionNotes = const <String, String>{};
    }

    if (!mounted) return;
    setState(() {
      _selectedSurah = progress.surah;
      _savedAyah = progress.ayah;
      _quranScale = progress.quranScale;
      _verseUserState = verseUserState;
      _reflectionNotes = reflectionNotes;
      _progressReady = true;
      _loadSelectedChapter();
    });
  }

  void _loadSelectedChapter() {
    final languageCode = _languageCode;
    if (languageCode == null) return;
    _chapterFuture = widget.repository.loadChapter(
      languageCode: languageCode,
      surah: _selectedSurah,
      startAyah: _savedAyah,
    );
  }

  void _selectSurah(int? surah) {
    if (surah == null || surah == _selectedSurah) return;
    setState(() {
      _selectedSurah = surah;
      _savedAyah = 1;
      _loadSelectedChapter();
    });
    unawaited(_persistProgressSafely());
  }

  void _selectJuz(int? juz) {
    if (juz == null) return;
    final start = quranJuzStart(juz);
    if (start.surah == _selectedSurah && start.ayah == _savedAyah) return;
    setState(() {
      _selectedSurah = start.surah;
      _savedAyah = start.ayah;
      _loadSelectedChapter();
    });
    unawaited(_persistProgressSafely());
  }

  void _changeQuranScale(double delta) {
    final next = (_quranScale + delta)
        .clamp(_minQuranScale, _maxQuranScale)
        .toDouble();
    if (next == _quranScale) return;
    setState(() => _quranScale = next);
    unawaited(_persistProgressSafely());
  }

  Future<void> _saveReadingPosition(int ayah) async {
    final previous = _savedAyah;
    setState(() => _savedAyah = ayah);
    try {
      await _persistProgress();
    } catch (_) {
      if (mounted) setState(() => _savedAyah = previous);
    }
  }

  Future<void> _toggleFavorite(int surah, int ayah) async {
    if (_collectionMutationInFlight) return;
    setState(() => _collectionMutationInFlight = true);
    try {
      final state = await widget.verseUserStateRepository.toggleFavorite(
        surah: surah,
        ayah: ayah,
      );
      if (mounted) setState(() => _verseUserState = state);
    } catch (_) {
      // Private collection state failure must not affect Quran reading.
    } finally {
      if (mounted) setState(() => _collectionMutationInFlight = false);
    }
  }

  Future<void> _toggleBookmark(int surah, int ayah) async {
    if (_collectionMutationInFlight) return;
    setState(() => _collectionMutationInFlight = true);
    try {
      final state = await widget.verseUserStateRepository.toggleBookmark(
        surah: surah,
        ayah: ayah,
      );
      if (mounted) setState(() => _verseUserState = state);
    } catch (_) {
      // Private collection state failure must not affect Quran reading.
    } finally {
      if (mounted) setState(() => _collectionMutationInFlight = false);
    }
  }

  Future<void> _openReflectionNote(int surah, int ayah) async {
    final l10n = AppLocalizations.of(context);
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final existing = _reflectionNotes[id] ?? '';
    final controller = TextEditingController(text: existing);
    final result = await showDialog<_ReflectionNoteAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          existing.isEmpty
              ? l10n.quranReflectionNote
              : l10n.quranEditReflectionNote,
        ),
        content: TextField(
          key: const ValueKey('quran-reflection-note-field'),
          controller: controller,
          autofocus: true,
          minLines: 4,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: l10n.quranReflectionNoteHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          if (existing.isNotEmpty)
            TextButton(
              key: const ValueKey('quran-reflection-note-delete'),
              onPressed: () => Navigator.of(dialogContext).pop(
                const _ReflectionNoteAction.delete(),
              ),
              child: Text(l10n.quranReflectionNoteDelete),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.quranReflectionNoteCancel),
          ),
          FilledButton(
            key: const ValueKey('quran-reflection-note-save'),
            onPressed: () => Navigator.of(dialogContext).pop(
              _ReflectionNoteAction.save(controller.text),
            ),
            child: Text(l10n.quranReflectionNoteSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;

    try {
      if (result.delete) {
        await widget.reflectionNoteRepository.deleteNote(
          surah: surah,
          ayah: ayah,
        );
        if (!mounted) return;
        setState(() {
          _reflectionNotes = Map<String, String>.unmodifiable(
            Map<String, String>.of(_reflectionNotes)..remove(id),
          );
        });
      } else {
        await widget.reflectionNoteRepository.saveNote(
          surah: surah,
          ayah: ayah,
          text: result.text ?? '',
        );
        if (!mounted) return;
        final next = Map<String, String>.of(_reflectionNotes);
        if ((result.text ?? '').trim().isEmpty) {
          next.remove(id);
        } else {
          next[id] = result.text!;
        }
        setState(() => _reflectionNotes = Map<String, String>.unmodifiable(next));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranReflectionNoteSaveFailed)),
      );
    }
  }

  Future<void> _persistProgressSafely() async {
    try {
      await _persistProgress();
    } catch (_) {
      // Font/chapter preference persistence is non-critical convenience state.
    }
  }

  Future<void> _persistProgress() {
    return widget.progressRepository.save(
      QuranReadingProgress(
        surah: _selectedSurah,
        ayah: _savedAyah,
        quranScale: _quranScale,
      ),
    );
  }

  void _openSources() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SourcesLicensesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final future = _chapterFuture;
    if (!_progressReady || future == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<QuranReaderChapter>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const TrustedContentErrorView();
        }

        final chapter = snapshot.requireData;
        final arabicStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          height: 1.9,
          fontSize:
              (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24) *
              _quranScale,
        );

        return CustomScrollView(
          key: PageStorageKey(
            'quran-reader-${chapter.surah}-$_savedAyah',
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.quranTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.quranSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 640;
                        final selectors = <Widget>[
                          KeyedSubtree(
                            key: const ValueKey('quran-surah-selector'),
                            child: DropdownButtonFormField<int>(
                              key: ValueKey('quran-surah-value-${chapter.surah}'),
                              initialValue: chapter.surah,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: l10n.quranSurahLabel,
                                prefixIcon: const Icon(Icons.menu_book_outlined),
                                border: const OutlineInputBorder(),
                              ),
                              items: widget.repository.chapterSummaries
                                  .map(
                                    (summary) => DropdownMenuItem<int>(
                                      value: summary.surah,
                                      child: Text(
                                        '${summary.surah} · ${summary.ayahCount}',
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                              onChanged: _selectSurah,
                            ),
                          ),
                          KeyedSubtree(
                            key: const ValueKey('quran-juz-selector'),
                            child: DropdownButtonFormField<int>(
                              key: ValueKey('quran-juz-value-$_selectedJuz'),
                              initialValue: _selectedJuz,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: l10n.quranJuzLabel,
                                prefixIcon: const Icon(
                                  Icons.auto_stories_outlined,
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              items: canonicalQuranJuzStarts
                                  .map(
                                    (start) => DropdownMenuItem<int>(
                                      value: start.juz,
                                      child: Text(
                                        '${l10n.quranJuzLabel} ${start.juz} · '
                                        '${l10n.continueQuranPosition(start.surah, start.ayah)}',
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                              onChanged: _selectJuz,
                            ),
                          ),
                        ];

                        if (!wide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              selectors.first,
                              const SizedBox(height: 12),
                              selectors.last,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: selectors.first),
                            const SizedBox(width: 12),
                            Expanded(child: selectors.last),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton.outlined(
                          key: const ValueKey('quran-font-smaller'),
                          tooltip: l10n.quranFontSmaller,
                          onPressed: _quranScale <= _minQuranScale
                              ? null
                              : () => _changeQuranScale(-_quranScaleStep),
                          icon: const Icon(Icons.text_decrease_outlined),
                        ),
                        IconButton.outlined(
                          key: const ValueKey('quran-font-larger'),
                          tooltip: l10n.quranFontLarger,
                          onPressed: _quranScale >= _maxQuranScale
                              ? null
                              : () => _changeQuranScale(_quranScaleStep),
                          icon: const Icon(Icons.text_increase_outlined),
                        ),
                        TextButton.icon(
                          key: const ValueKey('quran-open-sources'),
                          onPressed: _openSources,
                          icon: const Icon(Icons.verified_outlined),
                          label: Text(l10n.sourcesLicensesTitle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${l10n.quranSavedPosition}: '
                      '${l10n.continueQuranPosition(_selectedSurah, _savedAyah)}',
                      key: const ValueKey('quran-saved-position'),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.verified_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.quranSourceName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    if (chapter.mealSource case final source?) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${l10n.mealSourceLabel}: '
                        '${source.publisher} · V${source.version}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: chapter.verses.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final verse = chapter.verses[index];
                final verseId = quranVerseUserDataId(
                  surah: verse.surah,
                  ayah: verse.ayah,
                );
                final isSaved = verse.ayah == _savedAyah;
                final isFavorite = _verseUserState.isFavorite(
                  surah: verse.surah,
                  ayah: verse.ayah,
                );
                final isBookmarked = _verseUserState.isBookmarked(
                  surah: verse.surah,
                  ayah: verse.ayah,
                );
                final hasNote = _reflectionNotes.containsKey(verseId);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${verse.surah}:${verse.ayah}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          IconButton(
                            key: ValueKey(
                              'quran-favorite-${verse.surah}-${verse.ayah}',
                            ),
                            tooltip: isFavorite
                                ? l10n.quranRemoveFavorite
                                : l10n.quranAddFavorite,
                            onPressed: _collectionMutationInFlight
                                ? null
                                : () => _toggleFavorite(
                                    verse.surah,
                                    verse.ayah,
                                  ),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                            ),
                          ),
                          IconButton(
                            key: ValueKey(
                              'quran-bookmark-${verse.surah}-${verse.ayah}',
                            ),
                            tooltip: isBookmarked
                                ? l10n.quranRemoveBookmark
                                : l10n.quranAddBookmark,
                            onPressed: _collectionMutationInFlight
                                ? null
                                : () => _toggleBookmark(
                                    verse.surah,
                                    verse.ayah,
                                  ),
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                            ),
                          ),
                          IconButton(
                            key: ValueKey(
                              'quran-note-${verse.surah}-${verse.ayah}',
                            ),
                            tooltip: hasNote
                                ? l10n.quranEditReflectionNote
                                : l10n.quranReflectionNote,
                            onPressed: () => _openReflectionNote(
                              verse.surah,
                              verse.ayah,
                            ),
                            icon: Icon(
                              hasNote
                                  ? Icons.sticky_note_2_rounded
                                  : Icons.note_add_outlined,
                            ),
                          ),
                          IconButton(
                            key: ValueKey(
                              'quran-save-position-${verse.surah}-${verse.ayah}',
                            ),
                            tooltip: isSaved
                                ? l10n.quranSavedPosition
                                : l10n.quranSavePosition,
                            onPressed: isSaved
                                ? null
                                : () => _saveReadingPosition(verse.ayah),
                            icon: Icon(
                              isSaved
                                  ? Icons.play_circle_fill_rounded
                                  : Icons.play_circle_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SelectableText(
                          verse.arabic,
                          textAlign: TextAlign.right,
                          style: arabicStyle,
                        ),
                      ),
                      if (verse.translation case final translation?) ...[
                        const SizedBox(height: 14),
                        SelectableText(
                          translation,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.55),
                        ),
                      ],
                      if (verse.footnotes case final footnotes?
                          when footnotes.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          footnotes,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

final class _ReflectionNoteAction {
  const _ReflectionNoteAction.save(this.text) : delete = false;
  const _ReflectionNoteAction.delete() : text = null, delete = true;

  final String? text;
  final bool delete;
}
