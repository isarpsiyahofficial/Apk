import 'package:flutter/material.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_reader_page.dart';
import 'package:islami_hayat/features/quran/presentation/quran_search_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class QuranHubPage extends StatefulWidget {
  const QuranHubPage({
    super.key,
    required this.progressRepository,
    this.searchRepository,
  });

  final QuranReadingProgressRepository progressRepository;
  final QuranSearchDataSource? searchRepository;

  @override
  State<QuranHubPage> createState() => _QuranHubPageState();
}

final class _QuranHubPageState extends State<QuranHubPage> {
  int _mode = 0;
  int _readerGeneration = 0;

  Future<void> _openVerse(QuranSearchResult result) async {
    final l10n = AppLocalizations.of(context);
    try {
      final current = await widget.progressRepository.load();
      await widget.progressRepository.save(
        current.copyWith(surah: result.surah, ayah: result.ayah),
      );
      if (!mounted) return;
      setState(() {
        _mode = 0;
        _readerGeneration += 1;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranSearchOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment<int>(
                  value: 0,
                  icon: const Icon(Icons.menu_book_outlined),
                  label: Text(l10n.quranReadTab),
                ),
                ButtonSegment<int>(
                  value: 1,
                  icon: const Icon(Icons.search),
                  label: Text(l10n.quranSearchTab),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (value) {
                setState(() => _mode = value.first);
              },
              showSelectedIcon: false,
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _mode,
            children: [
              QuranReaderPage(
                key: ValueKey('quran-reader-$_readerGeneration'),
                progressRepository: widget.progressRepository,
              ),
              QuranSearchPage(
                repository: widget.searchRepository,
                onOpenVerse: _openVerse,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
