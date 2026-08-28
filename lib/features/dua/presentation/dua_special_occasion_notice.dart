import 'package:flutter/material.dart';
import 'package:islami_hayat/features/dua/data/dua_special_occasion_state.dart';

/// Disclosure shown for religious occasions when the reviewed local library
/// has no sahih/hasan dua specifically classified for that occasion.
///
/// The wording is intentionally scoped to this verified library. It must never
/// be read as a claim that no authentic dua exists anywhere in the tradition.
final class DuaSpecialOccasionNotice extends StatelessWidget {
  const DuaSpecialOccasionNotice({
    required this.state,
    super.key,
  });

  final DuaSpecialOccasionState state;

  @override
  Widget build(BuildContext context) {
    if (!state.shouldShowNoAuthenticatedSpecialDuaNotice) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context).languageCode;
    final copy = switch (locale) {
      'ar' => const (
          title: 'لا يوجد دعاء خاص ثابت في المكتبة الموثَّقة',
          body:
              'لا تتضمن مكتبتنا المراجَعة حاليًا دعاءً خاصًا بهذه المناسبة مصنّفًا ضمن السنة الصحيحة أو الحسنة. وقد تظهر أدعية أخرى موثَّقة، لكنها لا تُقدَّم على أنها دعاء سنة خاص بهذه المناسبة.',
        ),
      'en' => const (
          title: 'No authenticated special dua in the verified library',
          body:
              'Our reviewed library currently contains no dua classified as an authentic/hasan Sunnah dua specifically for this occasion. Other verified duas may still be shown, but they are not presented as a special Sunnah dua for this occasion.',
        ),
      _ => const (
          title: 'Doğrulanmış kütüphanede özel sahih dua yok',
          body:
              'İncelenmiş kütüphanemizde şu anda bu güne veya geceye özel, sahih/hasen sünnet duası olarak sınıflandırılmış bir dua bulunmuyor. Diğer doğrulanmış dualar gösterilebilir; ancak bunlar bu güne özel sünnet duası gibi sunulmaz.',
        ),
    };

    return Semantics(
      key: const ValueKey('dua-special-occasion-honesty-notice'),
      container: true,
      liveRegion: true,
      label: '${copy.title}. ${copy.body}',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 10, top: 2),
                      child: Icon(Icons.info_outline, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        copy.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(copy.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
