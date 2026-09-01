import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

enum ShareContentLocaleT0243 { tr, en, ar }

class RuntimeReligiousShareContentT0243 {
  const RuntimeReligiousShareContentT0243._({
    required this.contentId,
    required this.type,
    required this.text,
    required this.sourceLabel,
    required this.sourceClass,
  });

  factory RuntimeReligiousShareContentT0243.fromCanonicalQuranAyah(
    QuranAyah ayah,
  ) {
    if (ayah.arabic.trim().isEmpty) {
      throw StateError('T0243 cannot render an empty canonical Quran ayah.');
    }
    return RuntimeReligiousShareContentT0243._(
      contentId: 'quran:${ayah.key}',
      type: ContentType.quranVerse,
      text: ayah.arabic,
      sourceLabel: 'Quran ${ayah.sura}:${ayah.ayah}',
      sourceClass: ReligiousSourceClass.quran,
    );
  }

  factory RuntimeReligiousShareContentT0243.fromPublishedRecord({
    required ReligiousContentRecord record,
    required ShareContentLocaleT0243 locale,
  }) {
    if (!record.canEnterProductionDataset) {
      throw StateError(
        'T0243 only renders religious text from production-approved records.',
      );
    }
    if (record.type != ContentType.dua &&
        record.type != ContentType.quranVerse &&
        record.type != ContentType.translation &&
        record.type != ContentType.dhikr &&
        record.type != ContentType.divineName) {
      throw StateError('T0243 record type is not eligible for religious sharing.');
    }

    final text = switch (locale) {
      ShareContentLocaleT0243.tr => record.text.tr,
      ShareContentLocaleT0243.en => record.text.en,
      ShareContentLocaleT0243.ar => record.text.ar,
    };
    final primarySource = record.sources.first;
    final sourceLabel = primarySource.locator?.trim().isNotEmpty == true
        ? '${primarySource.title} · ${primarySource.locator}'
        : primarySource.title;

    return RuntimeReligiousShareContentT0243._(
      contentId: record.id,
      type: record.type,
      text: text,
      sourceLabel: sourceLabel,
      sourceClass: record.sourceStatus,
    );
  }

  final String contentId;
  final ContentType type;
  final String text;
  final String sourceLabel;
  final ReligiousSourceClass sourceClass;
}
