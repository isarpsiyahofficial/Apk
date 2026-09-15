import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/share/domain/quran_source_lock_t0244.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/presentation/quran_share_card_t0244.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CanonicalQuranDataset dataset;

  setUpAll(() async {
    dataset = await CanonicalQuranAssetLoader().load();
  });

  RuntimeReligiousShareContentT0243 canonical() {
    return RuntimeReligiousShareContentT0243.fromCanonicalQuranDataset(
      dataset: dataset,
      sura: 2,
      ayah: 255,
    );
  }

  test('T0244 derives locked source from canonical sura and ayah identity', () {
    final lock = QuranShareSourceLockT0244.fromRuntimeContent(canonical());

    expect(lock.sura, 2);
    expect(lock.ayah, 255);
    expect(lock.lockedSourceLabel, 'Quran 2:255');
  });

  for (final format in ShareCanvasFormatT0242.values) {
    testWidgets('Quran share card always renders locked source in $format', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 270,
            child: QuranShareCardT0244(
              format: format,
              background: const SizedBox.expand(),
              content: canonical(),
            ),
          ),
        ),
      );

      expect(find.text('Quran 2:255'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('t0244-locked-quran-source')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
