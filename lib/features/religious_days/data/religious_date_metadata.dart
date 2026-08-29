import '../../../core/content/content_governance.dart';

enum ReligiousDateSourceKind {
  nationalReligiousAuthority,
  officialMoonSightingAuthority,
}

enum ReligiousDateVerificationStatus {
  provisional,
  confirmed,
}

/// Metadata for the authority used to map a Hijri observance to a local
/// Gregorian date. The app keeps this separate from religious-content sources:
/// a calendar authority establishes the local date, not the religious merit of
/// the observance itself.
class ReligiousDateSourceMetadata {
  ReligiousDateSourceMetadata({
    required this.id,
    required this.title,
    required this.jurisdiction,
    required this.countryCode,
    required this.kind,
    required this.url,
    required this.retrievedAt,
  }) {
    if (id.trim().isEmpty ||
        title.trim().isEmpty ||
        jurisdiction.trim().isEmpty ||
        countryCode.trim().length != 2 ||
        !url.hasScheme ||
        url.scheme != 'https') {
      throw ArgumentError('Incomplete religious-date source metadata.');
    }
  }

  final String id;
  final String title;
  final String jurisdiction;
  final String countryCode;
  final ReligiousDateSourceKind kind;
  final Uri url;
  final DateTime retrievedAt;
}

class ReligiousDateObservation {
  ReligiousDateObservation({
    required this.contentId,
    required this.hijriYear,
    required this.hijriMonth,
    required this.hijriDay,
    required this.gregorianDate,
    required this.source,
    required this.status,
    required this.verifiedAt,
  }) {
    if (contentId.trim().isEmpty ||
        hijriYear < 1 ||
        hijriMonth < 1 ||
        hijriMonth > 12 ||
        hijriDay < 1 ||
        hijriDay > 30) {
      throw ArgumentError('Invalid religious-date observation.');
    }
  }

  final String contentId;
  final int hijriYear;
  final int hijriMonth;
  final int hijriDay;
  final DateTime gregorianDate;
  final ReligiousDateSourceMetadata source;
  final ReligiousDateVerificationStatus status;
  final DateTime verifiedAt;

  bool get canPresentAsExactLocalGregorianDate =>
      status == ReligiousDateVerificationStatus.confirmed &&
      !verifiedAt.isBefore(source.retrievedAt);
}

/// SPEC 317–319: Hijri observance dates may differ between countries because
/// local authorities can use different calendar/sighting decisions. Therefore
/// the app must never promote one country's Gregorian date to a universal date.
class ReligiousDateDisplayPolicy {
  const ReligiousDateDisplayPolicy._();

  static const countryVariationNotice = LocalizedReligiousText(
    tr: 'Hicrî tarihler ülkeye ve yetkili kurumun takvim/hilâl kararına göre farklılık gösterebilir. Kesin yerel tarih için gösterilen kaynağı kontrol edin.',
    en: 'Hijri dates can vary by country and by the calendar or crescent-sighting decision of the relevant authority. Check the shown source for the exact local date.',
    ar: 'قد تختلف التواريخ الهجرية بين البلدان بحسب التقويم المعتمد أو قرار تحري الهلال لدى الجهة المختصة. يُرجى مراجعة المصدر المعروض للتاريخ المحلي الدقيق.',
  );

  static bool canShowExactDate(ReligiousDateObservation observation) =>
      observation.canPresentAsExactLocalGregorianDate;

  static bool sameHijriObservance(
    ReligiousDateObservation a,
    ReligiousDateObservation b,
  ) =>
      a.contentId == b.contentId &&
      a.hijriYear == b.hijriYear &&
      a.hijriMonth == b.hijriMonth &&
      a.hijriDay == b.hijriDay;

  static bool hasCountryDateDifference(
    ReligiousDateObservation a,
    ReligiousDateObservation b,
  ) =>
      sameHijriObservance(a, b) &&
      a.source.countryCode != b.source.countryCode &&
      !_sameCivilDay(a.gregorianDate, b.gregorianDate);

  static bool _sameCivilDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Authority registry only. It does not hard-code future religious dates.
/// Exact date observations must be added from a dated official publication and
/// remain jurisdiction-scoped.
final religiousDateAuthorities = <ReligiousDateSourceMetadata>[
  ReligiousDateSourceMetadata(
    id: 'tr-diyanet-calendar',
    title: 'Diyanet İşleri Başkanlığı — Resmî Takvim / Hicrî Tarih',
    jurisdiction: 'Türkiye',
    countryCode: 'TR',
    kind: ReligiousDateSourceKind.nationalReligiousAuthority,
    url: Uri.parse('https://namazvakitleri.diyanet.gov.tr/'),
    retrievedAt: DateTime.utc(2026, 8, 29),
  ),
  ReligiousDateSourceMetadata(
    id: 'sa-supreme-court-crescent',
    title: 'Saudi Supreme Court crescent announcements via Saudi Press Agency',
    jurisdiction: 'Saudi Arabia',
    countryCode: 'SA',
    kind: ReligiousDateSourceKind.officialMoonSightingAuthority,
    url: Uri.parse('https://www.spa.gov.sa/'),
    retrievedAt: DateTime.utc(2026, 8, 29),
  ),
];
