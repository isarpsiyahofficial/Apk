import 'package:flutter/material.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';

class DivineNameGuidePage extends StatelessWidget {
  const DivineNameGuidePage({
    super.key,
    this.entries = const [],
  });

  final List<DivineNameEntry> entries;

  String _text(BuildContext context, String tr, String en, String ar) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  String _localized(BuildContext context, LocalizedReligiousText value) {
    return switch (Localizations.localeOf(context).languageCode) {
      'ar' => value.ar,
      'en' => value.en,
      _ => value.tr,
    };
  }

  String _transliteration(BuildContext context, DivineNameEntry entry) {
    return Localizations.localeOf(context).languageCode == 'en'
        ? entry.transliterationEn
        : entry.transliterationTr;
  }

  String _sourceClass(BuildContext context, ReligiousSourceClass sourceClass) {
    return switch (sourceClass) {
      ReligiousSourceClass.quran =>
        _text(context, 'Kur’an', 'Qur’an', 'القرآن'),
      ReligiousSourceClass.sahihHasanHadith => _text(
          context,
          'Sahih/hasen hadis',
          'Sahih/hasan hadith',
          'حديث صحيح/حسن',
        ),
      _ => _text(context, 'Kaynak', 'Source', 'المصدر'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final published = entries
        .where((entry) => entry.canEnterProductionDataset)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _text(context, 'Esmâü’l-Hüsnâ', 'Beautiful Names', 'أسماء الله الحسنى'),
        ),
      ),
      body: SafeArea(
        child: published.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      _text(
                        context,
                        'Kaynak ve üç dil incelemesi tamamlanmış Esmâ kayıtları hazır olduğunda burada görünecek.',
                        'Esmâ entries will appear here after source verification and three-language review are complete.',
                        'ستظهر أسماء الله الحسنى هنا بعد اكتمال توثيق المصادر ومراجعة اللغات الثلاث.',
                      ),
                      key: const ValueKey('divine-name-empty-state'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                itemCount: published.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final entry = published[index];
                  final primary = entry.sources.firstWhere(
                    (source) =>
                        source.sourceClass == ReligiousSourceClass.quran ||
                        source.sourceClass ==
                            ReligiousSourceClass.sahihHasanHadith,
                  );
                  final ebced = entry.publishedEbced;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  entry.arabic,
                                  key: ValueKey('divine-name-arabic-${entry.id}'),
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineMedium,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _transliteration(context, entry),
                                key: ValueKey(
                                  'divine-name-transliteration-${entry.id}',
                                ),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                _text(context, 'Anlamı', 'Meaning', 'المعنى'),
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _localized(context, entry.meaning),
                                key: ValueKey('divine-name-meaning-${entry.id}'),
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _text(
                                  context,
                                  'Neden zikredilir?',
                                  'Why is it recited?',
                                  'لماذا يُذكر؟',
                                ),
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _localized(context, entry.whyRecited),
                                key: ValueKey('divine-name-why-${entry.id}'),
                                style: theme.textTheme.bodyLarge,
                              ),
                              if (ebced != null) ...[
                                const SizedBox(height: 16),
                                DecoratedBox(
                                  key: ValueKey('divine-name-ebced-${entry.id}'),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: theme.colorScheme
                                                      .onSecondaryContainer,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                child: Text(
                                                  _text(
                                                    context,
                                                    'Ebced / tarihsel bilgi',
                                                    'Abjad / historical info',
                                                    'أبجد / معلومة تاريخية',
                                                  ),
                                                  key: ValueKey(
                                                    'divine-name-ebced-badge-${entry.id}',
                                                  ),
                                                  style:
                                                      theme.textTheme.labelMedium,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${_text(context, 'Ebced değeri', 'Abjad value', 'قيمة أبجد')}: ${ebced.value}',
                                              style: theme.textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _text(
                                            context,
                                            'Bu sayı matematiksel harf-sayı değeridir; sünnetle sabit zikir adedi değildir.',
                                            'This is a mathematical letter-number value; it is not a Sunnah-prescribed dhikr count.',
                                            'هذه قيمة حرفية عددية في حساب أبجد، وليست عددًا للذكر ثابتًا بالسنة.',
                                          ),
                                          key: ValueKey(
                                            'divine-name-ebced-disclaimer-${entry.id}',
                                          ),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${ebced.source.title} · ${ebced.source.locator}',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.menu_book_outlined, size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${_sourceClass(context, primary.sourceClass)} · ${primary.title}',
                                              key: ValueKey(
                                                'divine-name-source-${entry.id}',
                                              ),
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            if (primary.locator != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                primary.locator!,
                                                style: theme.textTheme.bodySmall,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
