import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';
import 'package:islami_hayat/features/share/presentation/runtime_religious_share_card_t0243.dart';
import 'package:islami_hayat/features/share/presentation/share_text_customization_controls_t0246.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

ReligiousContentRecord _record() => ReligiousContentRecord(
  id: 'dua:t0246',
  type: ContentType.dua,
  sourceStatus: ReligiousSourceClass.sahihHasanHadith,
  version: 1,
  reviewStatus: ContentReviewStatus.published,
  certainty: CertaintyLevel.explicitSource,
  text: const LocalizedReligiousText(
    tr: 'Doğrulanmış dini metin',
    en: 'Verified religious text',
    ar: 'نص ديني موثق',
  ),
  sources: const [
    SourceReference(
      id: 'source:t0246',
      title: 'Reviewed source',
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'reviewed-reference',
    ),
  ],
  lastReviewedAt: DateTime.utc(2026, 9, 1),
);

void main() {
  test('T0246 font-size choices stay inside the safe bounded range', () {
    for (final preset in ShareFontSizePresetT0246.values) {
      final preferences = ShareTextPreferencesT0246(fontSizePreset: preset);
      expect(preset.scale, inInclusiveRange(0.90, 1.12));
      expect(preferences.fontSizeFor(20), closeTo(20 * preset.scale, 1e-9));
      expect(preferences.fontSizeFor(20), greaterThanOrEqualTo(18));
      expect(preferences.fontSizeFor(20), lessThanOrEqualTo(22.4 + 1e-9));
    }
  });

  test('T0246 rejects invalid base font sizes', () {
    const preferences = ShareTextPreferencesT0246();
    expect(() => preferences.fontSizeFor(0), throwsArgumentError);
    expect(() => preferences.fontSizeFor(double.infinity), throwsArgumentError);
  });

  test('T0246 exposes only start, center and end alignment choices', () {
    expect(ShareTextAlignmentT0246.values, hasLength(3));
    expect(
      ShareTextAlignmentT0246.values.map((value) => value.textAlign),
      [TextAlign.start, TextAlign.center, TextAlign.end],
    );
  });

  testWidgets('T0246 controls can change only bounded presentation preferences', (
    tester,
  ) async {
    var preferences = const ShareTextPreferencesT0246();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return ShareTextCustomizationControlsT0246(
                preferences: preferences,
                onChanged: (next) => setState(() => preferences = next),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('t0246-font-large')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('t0246-align-start')));
    await tester.pump();

    expect(preferences.fontSizePreset, ShareFontSizePresetT0246.large);
    expect(preferences.alignment, ShareTextAlignmentT0246.start);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(EditableText), findsNothing);
  });

  testWidgets('T0246 share card renders governed text as non-editable Text', (
    tester,
  ) async {
    final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: _record(),
      locale: ShareContentLocaleT0243.ar,
    );
    const preferences = ShareTextPreferencesT0246(
      fontSizePreset: ShareFontSizePresetT0246.large,
      alignment: ShareTextAlignmentT0246.end,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: RuntimeReligiousShareCardT0243(
              format: ShareCanvasFormatT0242.instagramStory916,
              background: const SizedBox.expand(),
              content: content,
              textPreferences: preferences,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final text = tester.widget<Text>(
      find.byKey(const ValueKey('t0246-immutable-religious-text')),
    );
    expect(text.data, 'نص ديني موثق');
    expect(text.textAlign, TextAlign.end);
    expect(text.style?.fontSize, 24 * 1.12);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(EditableText), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
