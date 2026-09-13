import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/dua/data/dua_user_state_repository.dart';
import 'package:islami_hayat/features/dua/presentation/dua_source_disclosure_view.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

/// Device-local dua library surface for SPEC T0126.
///
/// Religious text is supplied only by [DuaLibraryRepository], which rejects
/// records that have not passed production review. Search/filter/favorite and
/// history never mutate trusted dua records.
final class DuaLibraryPage extends StatefulWidget {
  const DuaLibraryPage({
    required this.library,
    required this.userStateRepository,
    super.key,
  });

  final DuaLibraryRepository library;
  final DuaUserStateRepository userStateRepository;

  @override
  State<DuaLibraryPage> createState() => _DuaLibraryPageState();
}

enum _DuaView { all, favorites, history }

class _DuaLibraryPageState extends State<DuaLibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  DuaCategory? _category;
  _DuaView _view = _DuaView.all;
  late Future<DuaUserState> _stateFuture;

  @override
  void initState() {
    super.initState();
    _stateFuture = widget.userStateRepository.load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite(String id) async {
    final next = await widget.userStateRepository.toggleFavorite(id);
    if (!mounted) return;
    setState(() {
      _stateFuture = Future.value(next);
    });
  }

  Future<void> _open(DuaContent dua) async {
    final next = await widget.userStateRepository.recordOpened(dua.id);
    if (!mounted) return;
    setState(() {
      _stateFuture = Future.value(next);
    });
    await showDialog<void>(
      context: context,
      builder: (context) => _DuaDetailDialog(dua: dua),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.duaLibraryTitle)),
      body: SafeArea(
        child: FutureBuilder<DuaUserState>(
          future: _stateFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.duaLibraryPrivateStateError),
                ),
              );
            }

            final userState = snapshot.data ?? DuaUserState.empty();
            final searched = widget.library.search(
              query: _searchController.text,
              languageCode: locale,
              category: _category,
            );
            final visible = switch (_view) {
              _DuaView.all => searched,
              _DuaView.favorites => searched
                  .where((item) => userState.favoriteIds.contains(item.id))
                  .toList(growable: false),
              _DuaView.history => _historyOrdered(searched, userState.historyIds),
            };

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                TextField(
                  key: const ValueKey('dua-search-field'),
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: l10n.duaLibrarySearch,
                    hintText: l10n.duaLibrarySearchHint,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<DuaCategory?>(
                  key: const ValueKey('dua-category-filter'),
                  initialValue: _category,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.duaLibraryCategory),
                  items: [
                    DropdownMenuItem<DuaCategory?>(
                      value: null,
                      child: Text(l10n.duaLibraryAllCategories),
                    ),
                    for (final category in DuaCategory.values)
                      DropdownMenuItem<DuaCategory?>(
                        value: category,
                        child: Text(_categoryLabel(l10n, category)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 12),
                Wrap(
                  key: const ValueKey('dua-view-filter'),
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _viewChip(
                      value: _DuaView.all,
                      label: l10n.duaLibraryAll,
                      icon: Icons.menu_book_outlined,
                    ),
                    _viewChip(
                      value: _DuaView.favorites,
                      label: l10n.duaLibraryFavorites,
                      icon: Icons.favorite_outline,
                    ),
                    _viewChip(
                      value: _DuaView.history,
                      label: l10n.duaLibraryHistory,
                      icon: Icons.history,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Center(child: Text(l10n.duaLibraryEmpty)),
                  )
                else
                  for (final dua in visible)
                    _DuaListTile(
                      dua: dua,
                      locale: locale,
                      favorite: userState.favoriteIds.contains(dua.id),
                      favoriteLabel: l10n.duaLibraryFavorite,
                      unfavoriteLabel: l10n.duaLibraryUnfavorite,
                      onFavorite: () => _toggleFavorite(dua.id),
                      onTap: () => _open(dua),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _viewChip({
    required _DuaView value,
    required String label,
    required IconData icon,
  }) {
    return ChoiceChip(
      selected: _view == value,
      onSelected: (_) => setState(() => _view = value),
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  static List<DuaContent> _historyOrdered(
    List<DuaContent> candidates,
    List<String> historyIds,
  ) {
    final byId = {for (final item in candidates) item.id: item};
    final result = <DuaContent>[];
    for (final id in historyIds) {
      final item = byId[id];
      if (item != null) result.add(item);
    }
    return List<DuaContent>.unmodifiable(result);
  }
}

final class _DuaListTile extends StatelessWidget {
  const _DuaListTile({
    required this.dua,
    required this.locale,
    required this.favorite,
    required this.favoriteLabel,
    required this.unfavoriteLabel,
    required this.onFavorite,
    required this.onTap,
  });

  final DuaContent dua;
  final String locale;
  final bool favorite;
  final String favoriteLabel;
  final String unfavoriteLabel;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        key: ValueKey('dua-${dua.id}'),
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        title: Text(
          _localized(dua.text, locale),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textDirection: locale == 'ar' ? TextDirection.rtl : null,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DuaSourceDisclosureView(dua: dua),
        ),
        trailing: IconButton(
          tooltip: favorite ? unfavoriteLabel : favoriteLabel,
          onPressed: onFavorite,
          icon: Icon(favorite ? Icons.favorite : Icons.favorite_outline),
        ),
        onTap: onTap,
      ),
    );
  }
}

final class _DuaDetailDialog extends StatelessWidget {
  const _DuaDetailDialog({required this.dua});

  final DuaContent dua;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectableText(
                _localized(dua.text, locale),
                textDirection: locale == 'ar' ? TextDirection.rtl : null,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              DuaSourceDisclosureView(dua: dua),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}

String _localized(LocalizedReligiousText text, String locale) => switch (locale) {
      'ar' => text.ar,
      'en' => text.en,
      _ => text.tr,
    };

String _categoryLabel(AppLocalizations l10n, DuaCategory category) =>
    switch (category) {
      DuaCategory.morning => l10n.duaCategoryMorning,
      DuaCategory.evening => l10n.duaCategoryEvening,
      DuaCategory.night => l10n.duaCategoryNight,
      DuaCategory.distress => l10n.duaCategoryDistress,
      DuaCategory.peace => l10n.duaCategoryPeace,
      DuaCategory.repentance => l10n.duaCategoryRepentance,
      DuaCategory.seekingForgiveness => l10n.duaCategorySeekingForgiveness,
      DuaCategory.gratitude => l10n.duaCategoryGratitude,
      DuaCategory.patience => l10n.duaCategoryPatience,
      DuaCategory.provision => l10n.duaCategoryProvision,
      DuaCategory.debt => l10n.duaCategoryDebt,
      DuaCategory.blessing => l10n.duaCategoryBlessing,
      DuaCategory.family => l10n.duaCategoryFamily,
      DuaCategory.spouse => l10n.duaCategorySpouse,
      DuaCategory.parents => l10n.duaCategoryParents,
      DuaCategory.children => l10n.duaCategoryChildren,
      DuaCategory.spiritualSupportDuringIllness =>
        l10n.duaCategorySpiritualSupportDuringIllness,
      DuaCategory.fear => l10n.duaCategoryFear,
      DuaCategory.travel => l10n.duaCategoryTravel,
      DuaCategory.protection => l10n.duaCategoryProtection,
      DuaCategory.ramadan => l10n.duaCategoryRamadan,
      DuaCategory.friday => l10n.duaCategoryFriday,
      DuaCategory.eid => l10n.duaCategoryEid,
      DuaCategory.religiousNights => l10n.duaCategoryReligiousNights,
    };
