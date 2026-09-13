import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';

void main() {
  const expectedTerminology = <String, (String tr, String en, String ar)>{
    'adam': ('Âdem', 'Adam', 'آدم'),
    'idris': ('İdris', 'Idris', 'إدريس'),
    'nuh': ('Nûh', 'Noah', 'نوح'),
    'hud': ('Hûd', 'Hud', 'هود'),
    'salih': ('Sâlih', 'Salih', 'صالح'),
    'ibrahim': ('İbrâhim', 'Abraham', 'إبراهيم'),
    'lut': ('Lût', 'Lot', 'لوط'),
    'ismail': ('İsmâil', 'Ishmael', 'إسماعيل'),
    'ishaq': ('İshak', 'Isaac', 'إسحاق'),
    'yakub': ('Ya‘kūb', 'Jacob', 'يعقوب'),
    'yusuf': ('Yûsuf', 'Joseph', 'يوسف'),
    'ayyub': ('Eyyûb', 'Job', 'أيوب'),
    'shuayb': ('Şuayb', 'Shuayb', 'شعيب'),
    'musa': ('Mûsâ', 'Moses', 'موسى'),
    'harun': ('Hârûn', 'Aaron', 'هارون'),
    'dawud': ('Dâvûd', 'David', 'داود'),
    'sulayman': ('Süleyman', 'Solomon', 'سليمان'),
    'ilyas': ('İlyâs', 'Elijah', 'إلياس'),
    'alyasa': ('Elyesa‘', 'Elisha', 'اليسع'),
    'yunus': ('Yûnus', 'Jonah', 'يونس'),
    'zakariya': ('Zekeriyyâ', 'Zechariah', 'زكريا'),
    'yahya': ('Yahyâ', 'John', 'يحيى'),
    'isa': ('Îsâ', 'Jesus', 'عيسى'),
    'muhammad': ('Muhammed', 'Muhammad', 'محمد'),
    'dhul_kifl': ('Zülkifl', 'Dhul-Kifl', 'ذو الكفل'),
  };

  test('T0205 locks all 25 TR/EN/AR established prophet name forms', () {
    expect(canonicalQuranNamedProphets, hasLength(expectedTerminology.length));

    for (final prophet in canonicalQuranNamedProphets) {
      final expected = expectedTerminology[prophet.canonicalId];
      expect(
        expected,
        isNotNull,
        reason: 'Unexpected canonical prophet id: ${prophet.canonicalId}',
      );
      expect(prophet.name.tr, expected!.$1, reason: '${prophet.canonicalId} TR');
      expect(prophet.name.en, expected.$2, reason: '${prophet.canonicalId} EN');
      expect(prophet.name.ar, expected.$3, reason: '${prophet.canonicalId} AR');
      expect(
        prophet.arabicName,
        expected.$3,
        reason: '${prophet.canonicalId} Arabic identity must match AR display name',
      );
    }
  });

  test('T0205 canonical display names contain no bidi/control characters', () {
    final unsafeControls = RegExp(r'[\u0000-\u001F\u007F-\u009F\u200E\u200F\u202A-\u202E\u2066-\u2069]');

    for (final prophet in canonicalQuranNamedProphets) {
      for (final value in <String>[
        prophet.name.tr,
        prophet.name.en,
        prophet.name.ar,
        prophet.arabicName,
      ]) {
        expect(
          unsafeControls.hasMatch(value),
          isFalse,
          reason: '${prophet.canonicalId} contains hidden direction/control characters',
        );
        expect(value, value.trim(), reason: '${prophet.canonicalId} has edge whitespace');
      }
    }
  });

  test('T0205 names stay unique within each locale', () {
    final tr = canonicalQuranNamedProphets.map((e) => e.name.tr).toSet();
    final en = canonicalQuranNamedProphets.map((e) => e.name.en).toSet();
    final ar = canonicalQuranNamedProphets.map((e) => e.name.ar).toSet();

    expect(tr, hasLength(canonicalQuranNamedProphets.length));
    expect(en, hasLength(canonicalQuranNamedProphets.length));
    expect(ar, hasLength(canonicalQuranNamedProphets.length));
  });

  test('T0205 disputed/non-canonical candidates cannot enter the 25-name registry', () {
    final canonicalIds = canonicalQuranNamedProphets.map((e) => e.canonicalId).toSet();
    expect(canonicalIds.intersection(disputedOrNonCanonicalProphetCandidates), isEmpty);
    expect(canonicalQuranNamedProphetsIsValid, isTrue);
  });
}
