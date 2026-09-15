import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';

class QuranShareSourceLockT0244 {
  const QuranShareSourceLockT0244._({
    required this.sura,
    required this.ayah,
  });

  factory QuranShareSourceLockT0244.fromRuntimeContent(
    RuntimeReligiousShareContentT0243 content,
  ) {
    if (content.type != ContentType.quranVerse ||
        content.sourceClass != ReligiousSourceClass.quran) {
      throw StateError('T0244 source lock only accepts canonical Quran content.');
    }

    final match = RegExp(r'^quran:(\d+):(\d+)$').firstMatch(content.contentId);
    if (match == null) {
      throw StateError('T0244 Quran content id must contain canonical sura:ayah.');
    }
    final sura = int.parse(match.group(1)!);
    final ayah = int.parse(match.group(2)!);
    if (sura < 1 || sura > 114 || ayah < 1) {
      throw StateError('T0244 Quran source coordinates are invalid.');
    }

    final expectedSourceLabel = 'Quran $sura:$ayah';
    if (content.sourceLabel != expectedSourceLabel) {
      throw StateError('T0244 Quran source label does not match canonical id.');
    }

    return QuranShareSourceLockT0244._(sura: sura, ayah: ayah);
  }

  final int sura;
  final int ayah;

  String get lockedSourceLabel => 'Quran $sura:$ayah';
}
