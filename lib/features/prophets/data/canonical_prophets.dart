import '../../../core/content/content_governance.dart';
import 'prophet_content.dart';

/// Canonical identity-only registry for the 25 prophets whose names are
/// explicitly mentioned in the Quran in the mainstream Islamic enumeration.
///
/// This is deliberately not a biography or chronology dataset. T0194+ owns
/// broader references, family, geography, chronology and biographical claims.
class CanonicalProphetIdentity {
  const CanonicalProphetIdentity({
    required this.canonicalId,
    required this.name,
    required this.arabicName,
    required this.explicitNameReference,
  });

  final String canonicalId;
  final LocalizedReligiousText name;
  final String arabicName;

  /// A representative Quran reference in which the prophet's name itself is
  /// explicit. It is an identity anchor, not an exhaustive verse index.
  final ProphetVerseReference explicitNameReference;

  bool get isValid =>
      canonicalId.trim().isNotEmpty &&
      name.isComplete &&
      arabicName.trim().isNotEmpty &&
      explicitNameReference.isValid;
}

const canonicalQuranNamedProphets = <CanonicalProphetIdentity>[
  CanonicalProphetIdentity(
    canonicalId: 'adam',
    name: LocalizedReligiousText(tr: 'Âdem', en: 'Adam', ar: 'آدم'),
    arabicName: 'آدم',
    explicitNameReference: ProphetVerseReference(surah: 2, ayah: 31),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'idris',
    name: LocalizedReligiousText(tr: 'İdris', en: 'Idris', ar: 'إدريس'),
    arabicName: 'إدريس',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 56),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'nuh',
    name: LocalizedReligiousText(tr: 'Nûh', en: 'Noah', ar: 'نوح'),
    arabicName: 'نوح',
    explicitNameReference: ProphetVerseReference(surah: 71, ayah: 1),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'hud',
    name: LocalizedReligiousText(tr: 'Hûd', en: 'Hud', ar: 'هود'),
    arabicName: 'هود',
    explicitNameReference: ProphetVerseReference(surah: 11, ayah: 50),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'salih',
    name: LocalizedReligiousText(tr: 'Sâlih', en: 'Salih', ar: 'صالح'),
    arabicName: 'صالح',
    explicitNameReference: ProphetVerseReference(surah: 11, ayah: 61),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'ibrahim',
    name: LocalizedReligiousText(tr: 'İbrâhim', en: 'Abraham', ar: 'إبراهيم'),
    arabicName: 'إبراهيم',
    explicitNameReference: ProphetVerseReference(surah: 2, ayah: 124),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'lut',
    name: LocalizedReligiousText(tr: 'Lût', en: 'Lot', ar: 'لوط'),
    arabicName: 'لوط',
    explicitNameReference: ProphetVerseReference(surah: 7, ayah: 80),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'ismail',
    name: LocalizedReligiousText(tr: 'İsmâil', en: 'Ishmael', ar: 'إسماعيل'),
    arabicName: 'إسماعيل',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 54),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'ishaq',
    name: LocalizedReligiousText(tr: 'İshak', en: 'Isaac', ar: 'إسحاق'),
    arabicName: 'إسحاق',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 49),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'yakub',
    name: LocalizedReligiousText(tr: 'Ya‘kūb', en: 'Jacob', ar: 'يعقوب'),
    arabicName: 'يعقوب',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 49),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'yusuf',
    name: LocalizedReligiousText(tr: 'Yûsuf', en: 'Joseph', ar: 'يوسف'),
    arabicName: 'يوسف',
    explicitNameReference: ProphetVerseReference(surah: 12, ayah: 4),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'ayyub',
    name: LocalizedReligiousText(tr: 'Eyyûb', en: 'Job', ar: 'أيوب'),
    arabicName: 'أيوب',
    explicitNameReference: ProphetVerseReference(surah: 21, ayah: 83),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'shuayb',
    name: LocalizedReligiousText(tr: 'Şuayb', en: 'Shuayb', ar: 'شعيب'),
    arabicName: 'شعيب',
    explicitNameReference: ProphetVerseReference(surah: 7, ayah: 85),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'musa',
    name: LocalizedReligiousText(tr: 'Mûsâ', en: 'Moses', ar: 'موسى'),
    arabicName: 'موسى',
    explicitNameReference: ProphetVerseReference(surah: 20, ayah: 9),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'harun',
    name: LocalizedReligiousText(tr: 'Hârûn', en: 'Aaron', ar: 'هارون'),
    arabicName: 'هارون',
    explicitNameReference: ProphetVerseReference(surah: 20, ayah: 30),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'dawud',
    name: LocalizedReligiousText(tr: 'Dâvûd', en: 'David', ar: 'داود'),
    arabicName: 'داود',
    explicitNameReference: ProphetVerseReference(surah: 2, ayah: 251),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'sulayman',
    name: LocalizedReligiousText(tr: 'Süleyman', en: 'Solomon', ar: 'سليمان'),
    arabicName: 'سليمان',
    explicitNameReference: ProphetVerseReference(surah: 27, ayah: 15),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'ilyas',
    name: LocalizedReligiousText(tr: 'İlyâs', en: 'Elijah', ar: 'إلياس'),
    arabicName: 'إلياس',
    explicitNameReference: ProphetVerseReference(surah: 37, ayah: 123),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'alyasa',
    name: LocalizedReligiousText(tr: 'Elyesa‘', en: 'Elisha', ar: 'اليسع'),
    arabicName: 'اليسع',
    explicitNameReference: ProphetVerseReference(surah: 6, ayah: 86),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'yunus',
    name: LocalizedReligiousText(tr: 'Yûnus', en: 'Jonah', ar: 'يونس'),
    arabicName: 'يونس',
    explicitNameReference: ProphetVerseReference(surah: 4, ayah: 163),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'zakariya',
    name: LocalizedReligiousText(tr: 'Zekeriyyâ', en: 'Zechariah', ar: 'زكريا'),
    arabicName: 'زكريا',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 2),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'yahya',
    name: LocalizedReligiousText(tr: 'Yahyâ', en: 'John', ar: 'يحيى'),
    arabicName: 'يحيى',
    explicitNameReference: ProphetVerseReference(surah: 19, ayah: 7),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'isa',
    name: LocalizedReligiousText(tr: 'Îsâ', en: 'Jesus', ar: 'عيسى'),
    arabicName: 'عيسى',
    explicitNameReference: ProphetVerseReference(surah: 3, ayah: 45),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'muhammad',
    name: LocalizedReligiousText(tr: 'Muhammed', en: 'Muhammad', ar: 'محمد'),
    arabicName: 'محمد',
    explicitNameReference: ProphetVerseReference(surah: 3, ayah: 144),
  ),
  CanonicalProphetIdentity(
    canonicalId: 'dhul_kifl',
    name: LocalizedReligiousText(tr: 'Zülkifl', en: 'Dhul-Kifl', ar: 'ذو الكفل'),
    arabicName: 'ذو الكفل',
    explicitNameReference: ProphetVerseReference(surah: 21, ayah: 85),
  ),
];

const disputedOrNonCanonicalProphetCandidates = <String>{
  'luqman',
  'uzayr',
  'dhul_qarnayn',
  'khidr',
  'shith',
};

bool get canonicalQuranNamedProphetsIsValid {
  if (canonicalQuranNamedProphets.length != 25 ||
      canonicalQuranNamedProphets.any((entry) => !entry.isValid)) {
    return false;
  }

  final ids = canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
  final arabicNames = canonicalQuranNamedProphets.map((entry) => entry.arabicName).toSet();
  if (ids.length != canonicalQuranNamedProphets.length ||
      arabicNames.length != canonicalQuranNamedProphets.length) {
    return false;
  }

  return ids.intersection(disputedOrNonCanonicalProphetCandidates).isEmpty;
}
