import 'package:flutter/material.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

import 'revelation_journey_page.dart';

class DiscoverProphetsEntry extends StatelessWidget {
  const DiscoverProphetsEntry({
    this.quranTargetOpener,
    super.key,
  });

  final ProphetQuranTargetOpener? quranTargetOpener;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        key: const ValueKey('discover-revelation-journey'),
        leading: const Icon(Icons.timeline_outlined),
        title: Text(l10n.revelationJourneyTitle),
        subtitle: Text(l10n.revelationJourneySubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RevelationJourneyPage(
              quranTargetOpener: quranTargetOpener,
            ),
          ),
        ),
      ),
    );
  }
}
