import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/trusted_content_error_view.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class QuranMemorizationPage extends StatefulWidget {
  QuranMemorizationPage({
    super.key,
    QuranReaderDataSource? repository,
    QuranReadingProgressRepository? progressRepository,
  }) : repository = repository ?? QuranReaderRepository(),
       progressRepository = progressRepository ??
           QuranReadingProgressRepository(SecurePrivateUserStore());

  final QuranReaderDataSource repository;
  final QuranReadingProgressRepository progressRepository;

  @override
  State<QuranMemorizationPage> createState() => _QuranMemorizationPageState();
}

final class _QuranMemorizationPageState extends State<QuranMemorizationPage> {
  Future<_MemorizationTarget>? _targetFuture;
  String? _languageCode;
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_targetFuture == null || _languageCode != languageCode) {
      _languageCode = languageCode;
      _revealed = false;
      _targetFuture = _loadTarget(languageCode);
    }
  }

  Future<_MemorizationTarget> _loadTarget(String languageCode) async {
    final progress = await widget.progressRepository.load();
    final chapter = await widget.repository.loadChapter(
      languageCode: languageCode,
      surah: progress.surah,
      startAyah: progress.ayah,
    );
    if (chapter.verses.isEmpty) {
      throw StateError('Verified Quran target verse is missing.');
    }
    return _MemorizationTarget(
      surah: progress.surah,
      ayah: progress.ayah,
      verse: chapter.verses.first,
    );
  }

  void _setRevealed(bool value) {
    if (_revealed == value) return;
    setState(() => _revealed = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final future = _targetFuture;
    if (future == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<_MemorizationTarget>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const TrustedContentErrorView();
        }

        final target = snapshot.requireData;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.quranMemorizeTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.quranMemorizeSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.continueQuranPosition(target.surah, target.ayah),
                    key: const ValueKey('quran-memorize-position'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: const ValueKey('quran-memorize-card'),
                      onTap: () => _setRevealed(!_revealed),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _revealed
                              ? _RevealedVerse(
                                  key: const ValueKey('quran-memorize-revealed'),
                                  verse: target.verse,
                                )
                              : _HiddenVerse(
                                  key: const ValueKey('quran-memorize-hidden'),
                                  label: l10n.quranMemorizeHidden,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.tonalIcon(
                    key: const ValueKey('quran-memorize-toggle'),
                    onPressed: () => _setRevealed(!_revealed),
                    icon: Icon(
                      _revealed
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    label: Text(
                      _revealed
                          ? l10n.quranMemorizeHideAgain
                          : l10n.quranMemorizeReveal,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.mic_off_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.quranMemorizeNoMicrophone,
                          key: const ValueKey('quran-memorize-no-microphone'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _MemorizationTarget {
  const _MemorizationTarget({
    required this.surah,
    required this.ayah,
    required this.verse,
  });

  final int surah;
  final int ayah;
  final QuranReaderVerse verse;
}

final class _HiddenVerse extends StatelessWidget {
  const _HiddenVerse({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Column(
        children: [
          Icon(
            Icons.visibility_off_outlined,
            size: 42,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

final class _RevealedVerse extends StatelessWidget {
  const _RevealedVerse({super.key, required this.verse});

  final QuranReaderVerse verse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            verse.arabic,
            key: const ValueKey('quran-memorize-arabic'),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              height: 1.9,
            ),
          ),
        ),
        if (verse.translation case final translation?) ...[
          const SizedBox(height: 16),
          Text(
            translation,
            key: const ValueKey('quran-memorize-translation'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
        ],
      ],
    );
  }
}
