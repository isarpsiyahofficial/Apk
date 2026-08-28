import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_preferences_repository.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_page.dart';

class DhikrGuidePreferencesView extends StatefulWidget {
  const DhikrGuidePreferencesView({
    super.key,
    this.entries = const [],
    this.repository,
  });

  final List<DhikrGuideEntry> entries;
  final DhikrGuidePreferencesRepository? repository;

  @override
  State<DhikrGuidePreferencesView> createState() =>
      _DhikrGuidePreferencesViewState();
}

class _DhikrGuidePreferencesViewState
    extends State<DhikrGuidePreferencesView> {
  late final DhikrGuidePreferencesRepository _repository;
  DhikrGuidePreferences _preferences = const DhikrGuidePreferences();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ??
        DhikrGuidePreferencesRepository(SecurePrivateUserStore());
    _load();
  }

  Future<void> _load() async {
    final value = await _repository.load();
    if (!mounted) return;
    setState(() {
      _preferences = value;
      _loading = false;
    });
  }

  Future<void> _setPreferences(DhikrGuidePreferences value) async {
    setState(() => _preferences = value);
    await _repository.save(value);
  }

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  bool _isTraditional(DhikrGuideEntry entry) {
    if (entry.countProvenance == DhikrCountProvenance.traditional) return true;
    return entry.sources.any(
      (source) =>
          source.sourceClass == ReligiousSourceClass.classicalTraditional ||
          source.sourceClass == ReligiousSourceClass.laterTradition,
    );
  }

  bool _isEbced(DhikrGuideEntry entry) =>
      entry.countProvenance == DhikrCountProvenance.ebcedHavasHistorical;

  int _rank(DhikrGuideEntry entry) {
    if (_isEbced(entry)) return 2;
    if (_isTraditional(entry)) return 1;
    return 0;
  }

  List<DhikrGuideEntry> get _visibleEntries {
    final visible = widget.entries.where((entry) {
      if (!entry.canEnterProductionDataset) return false;
      if (_isEbced(entry) && !_preferences.showEbcedHavasHistorical) {
        return false;
      }
      if (_isTraditional(entry) && !_preferences.showTraditionalPractices) {
        return false;
      }
      return true;
    }).toList(growable: false);
    visible.sort((a, b) => _rank(a).compareTo(_rank(b)));
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Card(
            child: ExpansionTile(
              key: const ValueKey('dhikr-content-preferences'),
              leading: const Icon(Icons.tune_outlined),
              title: Text(
                _text(
                  context,
                  'İçerik tercihleri',
                  'Content preferences',
                  'تفضيلات المحتوى',
                ),
              ),
              subtitle: Text(
                _text(
                  context,
                  'Güçlü kaynaklar varsayılan olarak öne çıkarılır.',
                  'Strong-source content is prioritized by default.',
                  'تظهر المحتويات ذات المصادر الأقوى أولًا افتراضيًا.',
                ),
                style: theme.textTheme.bodySmall,
              ),
              children: [
                SwitchListTile.adaptive(
                  key: const ValueKey('show-traditional-practices'),
                  value: _preferences.showTraditionalPractices,
                  onChanged: (value) => _setPreferences(
                    _preferences.copyWith(showTraditionalPractices: value),
                  ),
                  title: Text(
                    _text(
                      context,
                      'Geleneksel uygulamaları da göster',
                      'Show traditional practices',
                      'إظهار الممارسات التقليدية',
                    ),
                  ),
                  subtitle: Text(
                    _text(
                      context,
                      'Tasavvufî veya sonraki gelenek kayıtları güçlü kaynaklarla aynı statüde değildir.',
                      'Tasawwuf or later-tradition entries do not have the same status as strong-source content.',
                      'المحتوى الصوفي أو المتأخر تقليدي وليس في مرتبة المصادر الأقوى.',
                    ),
                  ),
                ),
                SwitchListTile.adaptive(
                  key: const ValueKey('show-ebced-havas-historical'),
                  value: _preferences.showEbcedHavasHistorical,
                  onChanged: (value) => _setPreferences(
                    _preferences.copyWith(showEbcedHavasHistorical: value),
                  ),
                  title: Text(
                    _text(
                      context,
                      'Ebced/havas tarihsel bilgisini göster',
                      'Show historical abjad/havas information',
                      'إظهار المعلومات التاريخية للأبجد/الخواص',
                    ),
                  ),
                  subtitle: Text(
                    _text(
                      context,
                      'Bilgilendiricidir; sünnetle sabit bir zikir sayısı olarak sunulmaz.',
                      'Informational only; never presented as a Sunnah-prescribed dhikr count.',
                      'للمعلومة التاريخية فقط، ولا يُعرض كعدد ذكر ثابت بالسنة.',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: DhikrGuidePage(entries: _visibleEntries),
        ),
      ],
    );
  }
}
