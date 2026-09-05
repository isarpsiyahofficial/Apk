import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/dua/data/dua_user_state_repository.dart';
import 'package:islami_hayat/features/dua/presentation/dua_source_disclosure_view.dart';

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
    final labels = _DuaLabels.forLocale(locale);

    return Scaffold(
      appBar: AppBar(title: Text(labels.title)),
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
                  child: Text(labels.privateStateError),
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
                    labelText: labels.search,
                    hintText: labels.searchHint,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<DuaCategory?>(
                  key: const ValueKey('dua-category-filter'),
                  initialValue: _category,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: labels.category),
                  items: [
                    DropdownMenuItem<DuaCategory?>(
                      value: null,
                      child: Text(labels.allCategories),
                    ),
                    for (final category in DuaCategory.values)
                      DropdownMenuItem<DuaCategory?>(
                        value: category,
                        child: Text(labels.categoryLabel(category)),
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
                      label: labels.all,
                      icon: Icons.menu_book_outlined,
                    ),
                    _viewChip(
                      value: _DuaView.favorites,
                      label: labels.favorites,
                      icon: Icons.favorite_outline,
                    ),
                    _viewChip(
                      value: _DuaView.history,
                      label: labels.history,
                      icon: Icons.history,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Center(child: Text(labels.empty)),
                  )
                else
                  for (final dua in visible)
                    _DuaListTile(
                      dua: dua,
                      locale: locale,
                      favorite: userState.favoriteIds.contains(dua.id),
                      favoriteLabel: labels.favorite,
                      unfavoriteLabel: labels.unfavorite,
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

final class _DuaLabels {
  const _DuaLabels({
    required this.title,
    required this.search,
    required this.searchHint,
    required this.category,
    required this.allCategories,
    required this.all,
    required this.favorites,
    required this.history,
    required this.empty,
    required this.favorite,
    required this.unfavorite,
    required this.privateStateError,
    required this.categoryNames,
  });

  final String title;
  final String search;
  final String searchHint;
  final String category;
  final String allCategories;
  final String all;
  final String favorites;
  final String history;
  final String empty;
  final String favorite;
  final String unfavorite;
  final String privateStateError;
  final Map<DuaCategory, String> categoryNames;

  String categoryLabel(DuaCategory category) => categoryNames[category]!;

  static _DuaLabels forLocale(String locale) => switch (locale) {
        'ar' => _ar,
        'en' => _en,
        _ => _tr,
      };

  static final _tr = _DuaLabels(
    title: 'Dualar',
    search: 'Dualarda ara',
    searchHint: 'Dua metninde ara',
    category: 'Kategori',
    allCategories: 'Tüm kategoriler',
    all: 'Tümü',
    favorites: 'Favoriler',
    history: 'Geçmiş',
    empty: 'Bu filtrelerde doğrulanmış dua bulunmuyor.',
    favorite: 'Favorilere ekle',
    unfavorite: 'Favorilerden çıkar',
    privateStateError:
        'Kişisel dua verileri okunamadı. Dini içerik değiştirilmedi.',
    categoryNames: _trCategories,
  );

  static final _en = _DuaLabels(
    title: 'Duas',
    search: 'Search duas',
    searchHint: 'Search within dua text',
    category: 'Category',
    allCategories: 'All categories',
    all: 'All',
    favorites: 'Favorites',
    history: 'History',
    empty: 'No verified dua matches these filters.',
    favorite: 'Add to favorites',
    unfavorite: 'Remove from favorites',
    privateStateError:
        'Private dua data could not be read. Religious content was not changed.',
    categoryNames: _enCategories,
  );

  static final _ar = _DuaLabels(
    title: 'الأدعية',
    search: 'البحث في الأدعية',
    searchHint: 'ابحث داخل نص الدعاء',
    category: 'الفئة',
    allCategories: 'جميع الفئات',
    all: 'الكل',
    favorites: 'المفضلة',
    history: 'السجل',
    empty: 'لا يوجد دعاء موثَّق يطابق هذه المرشحات.',
    favorite: 'إضافة إلى المفضلة',
    unfavorite: 'إزالة من المفضلة',
    privateStateError:
        'تعذّرت قراءة بيانات الأدعية الخاصة. لم يتغير المحتوى الديني.',
    categoryNames: _arCategories,
  );
}

const _trCategories = <DuaCategory, String>{
  DuaCategory.morning: 'Sabah',
  DuaCategory.evening: 'Akşam',
  DuaCategory.night: 'Gece',
  DuaCategory.distress: 'Sıkıntı',
  DuaCategory.peace: 'Huzur',
  DuaCategory.repentance: 'Tövbe',
  DuaCategory.seekingForgiveness: 'İstiğfar',
  DuaCategory.gratitude: 'Şükür',
  DuaCategory.patience: 'Sabır',
  DuaCategory.provision: 'Rızık',
  DuaCategory.debt: 'Borç',
  DuaCategory.blessing: 'Bereket',
  DuaCategory.family: 'Aile',
  DuaCategory.spouse: 'Eş',
  DuaCategory.parents: 'Anne-baba',
  DuaCategory.children: 'Çocuklar',
  DuaCategory.spiritualSupportDuringIllness: 'Hastalıkta manevi destek',
  DuaCategory.fear: 'Korku',
  DuaCategory.travel: 'Yolculuk',
  DuaCategory.protection: 'Korunma',
  DuaCategory.ramadan: 'Ramazan',
  DuaCategory.friday: 'Cuma',
  DuaCategory.eid: 'Bayram',
  DuaCategory.religiousNights: 'Dini geceler',
};

const _enCategories = <DuaCategory, String>{
  DuaCategory.morning: 'Morning',
  DuaCategory.evening: 'Evening',
  DuaCategory.night: 'Night',
  DuaCategory.distress: 'Distress',
  DuaCategory.peace: 'Peace',
  DuaCategory.repentance: 'Repentance',
  DuaCategory.seekingForgiveness: 'Seeking forgiveness',
  DuaCategory.gratitude: 'Gratitude',
  DuaCategory.patience: 'Patience',
  DuaCategory.provision: 'Provision',
  DuaCategory.debt: 'Debt',
  DuaCategory.blessing: 'Blessing',
  DuaCategory.family: 'Family',
  DuaCategory.spouse: 'Spouse',
  DuaCategory.parents: 'Parents',
  DuaCategory.children: 'Children',
  DuaCategory.spiritualSupportDuringIllness:
      'Spiritual support during illness',
  DuaCategory.fear: 'Fear',
  DuaCategory.travel: 'Travel',
  DuaCategory.protection: 'Protection',
  DuaCategory.ramadan: 'Ramadan',
  DuaCategory.friday: 'Friday',
  DuaCategory.eid: 'Eid',
  DuaCategory.religiousNights: 'Religious nights',
};

const _arCategories = <DuaCategory, String>{
  DuaCategory.morning: 'الصباح',
  DuaCategory.evening: 'المساء',
  DuaCategory.night: 'الليل',
  DuaCategory.distress: 'الكرب',
  DuaCategory.peace: 'الطمأنينة',
  DuaCategory.repentance: 'التوبة',
  DuaCategory.seekingForgiveness: 'الاستغفار',
  DuaCategory.gratitude: 'الشكر',
  DuaCategory.patience: 'الصبر',
  DuaCategory.provision: 'الرزق',
  DuaCategory.debt: 'الدَّين',
  DuaCategory.blessing: 'البركة',
  DuaCategory.family: 'الأسرة',
  DuaCategory.spouse: 'الزوجان',
  DuaCategory.parents: 'الوالدان',
  DuaCategory.children: 'الأبناء',
  DuaCategory.spiritualSupportDuringIllness: 'الدعم الروحي أثناء المرض',
  DuaCategory.fear: 'الخوف',
  DuaCategory.travel: 'السفر',
  DuaCategory.protection: 'الحفظ',
  DuaCategory.ramadan: 'رمضان',
  DuaCategory.friday: 'الجمعة',
  DuaCategory.eid: 'العيد',
  DuaCategory.religiousNights: 'الليالي الدينية',
};
