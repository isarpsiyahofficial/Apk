import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/trusted_content_error_view.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class QuranSearchPage extends StatefulWidget {
  QuranSearchPage({
    super.key,
    QuranSearchDataSource? repository,
    required this.onOpenVerse,
  }) : repository = repository ?? QuranSearchRepository();

  final QuranSearchDataSource repository;
  final ValueChanged<QuranSearchResult> onOpenVerse;

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

final class _QuranSearchPageState extends State<QuranSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<QuranSearchResult>>? _resultsFuture;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      _searched = true;
      _resultsFuture = widget.repository.search(
        languageCode: languageCode,
        query: query,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.quranSearchTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranSearchSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              TextField(
                key: const ValueKey('quran-search-field'),
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  labelText: l10n.quranSearchLabel,
                  hintText: l10n.quranSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    key: const ValueKey('quran-search-submit'),
                    tooltip: l10n.quranSearchAction,
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildResults(context)),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final future = _resultsFuture;
    if (future == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.quranSearchPrivacyNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return FutureBuilder<List<QuranSearchResult>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const TrustedContentErrorView();
        }
        final results = snapshot.data ?? const <QuranSearchResult>[];
        if (_searched && results.isEmpty) {
          return Center(child: Text(l10n.quranSearchNoResults));
        }

        return ListView.separated(
          key: const ValueKey('quran-search-results'),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final result = results[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: ValueKey('quran-search-result-${result.key}'),
                onTap: () => widget.onOpenVerse(result),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.continueQuranPosition(result.surah, result.ayah),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 10),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          result.arabic,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            height: 1.8,
                          ),
                        ),
                      ),
                      if (result.translation case final translation?) ...[
                        const SizedBox(height: 10),
                        Text(
                          translation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton.icon(
                          onPressed: () => widget.onOpenVerse(result),
                          icon: const Icon(Icons.menu_book_outlined),
                          label: Text(l10n.quranSearchOpenVerse),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
