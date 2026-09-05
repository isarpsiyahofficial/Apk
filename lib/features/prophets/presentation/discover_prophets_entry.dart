import 'package:flutter/material.dart';

import 'revelation_journey_page.dart';

class DiscoverProphetsEntry extends StatelessWidget {
  const DiscoverProphetsEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final copy = switch (language) {
      'ar' => const (
          title: 'رحلة الوحي',
          subtitle: 'استكشف التسلسل التقريبي للأنبياء والفترات المتوازية دون اختلاق تواريخ دقيقة.',
        ),
      'en' => const (
          title: 'Revelation Journey',
          subtitle: 'Explore the approximate prophetic chronology and parallel periods without invented exact dates.',
        ),
      _ => const (
          title: 'Vahiy Yolculuğu',
          subtitle: 'Peygamberlerin yaklaşık kronolojisini ve paralel dönemleri kesin tarih uydurmadan keşfet.',
        ),
    };

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        key: const ValueKey('discover-revelation-journey'),
        leading: const Icon(Icons.timeline_outlined),
        title: Text(copy.title),
        subtitle: Text(copy.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const RevelationJourneyPage(),
          ),
        ),
      ),
    );
  }
}
