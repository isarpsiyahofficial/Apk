import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/trusted_content_error_view.dart';
import 'package:islami_hayat/features/profile/presentation/sources_licenses_page.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class QuranReaderPage extends StatefulWidget {
  QuranReaderPage({
    super.key,
    QuranReaderRepository? repository,
  }) : repository = repository ?? QuranReaderRepository();

  final QuranReaderRepository repository;

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
  double _quranScale = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_languageCode == languageCode && _chapterFuture != null) return;
    _languageCode = languageCode;
    _loadSelectedChapter();
  }

  void _loadSelectedChapter() {
    final languageCode = _languageCode;
    if (languageCode == null) return;
    _chapterFuture = widget.repository.loadChapter(
      languageCode: languageCode,
      surah: _selectedSurah,
    );
  }

  void _selectSurah(int? surah) {
    if (surah == null || surah == _selectedSurah) return;
    setState(() {
      _selectedSurah = surah;
      _loadSelectedChapter();
    });
  }

  void _changeQuranScale(double delta) {
    final next = (_quranScale + delta).clamp(
      _minQuranScale,
      _maxQuranScale,
    );
    if (next == _quranScale) return;
    setState(() => _quranScale = next);
  }

  void _openSources() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const SourcesLicensesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final future = _chapterFuture;
    if (future == null) {
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
          key: PageStorageKey('quran-reader-${chapter.surah}'),
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
                    DropdownButtonFormField<int>(
                      key: const ValueKey('quran-surah-selector'),
                      initialValue: chapter.surah,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.menu_book_outlined),
                        border: OutlineInputBorder(),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${verse.surah}:${verse.ayah}',
                        style: Theme.of(context).textTheme.labelMedium,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.55),
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
