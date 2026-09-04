import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';

void main() {
  group('ReligiousDateDisplayPolicy', () {
    test('country variation notice is complete in TR EN AR', () {
      expect(ReligiousDateDisplayPolicy.countryVariationNotice.isComplete, isTrue);
      expect(
        ReligiousDateDisplayPolicy.countryVariationNotice.tr,
        contains('ülkeye'),
      );
      expect(
        ReligiousDateDisplayPolicy.countryVariationNotice.en,
        contains('vary by country'),
      );
      expect(
        ReligiousDateDisplayPolicy.countryVariationNotice.ar,
        contains('بين البلدان'),
      );
    });

    test('exact local date is fail-closed until authority confirms it', () {
      final source = religiousDateAuthorities.first;
      final provisional = ReligiousDateObservation(
        contentId: 'religious-day:eid-al-fitr',
        hijriYear: 1448,
        hijriMonth: 10,
        hijriDay: 1,
        gregorianDate: DateTime.utc(2027, 3, 9),
        source: source,
        status: ReligiousDateVerificationStatus.provisional,
        verifiedAt: DateTime.utc(2027, 3, 8),
      );

      expect(ReligiousDateDisplayPolicy.canShowExactDate(provisional), isFalse);
    });

    test('confirmed exact date requires verification after source retrieval', () {
      final source = religiousDateAuthorities.first;
      final stale = ReligiousDateObservation(
        contentId: 'religious-day:ashura',
        hijriYear: 1448,
        hijriMonth: 1,
        hijriDay: 10,
        gregorianDate: DateTime.utc(2026, 6, 26),
        source: source,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2026, 9, 3),
        sourcePublicationLocator: 'official-calendar:1448-01-10',
        sourcePublicationUrl: Uri.parse(
          'https://namazvakitleri.diyanet.gov.tr/',
        ),
      );
      final verified = ReligiousDateObservation(
        contentId: stale.contentId,
        hijriYear: stale.hijriYear,
        hijriMonth: stale.hijriMonth,
        hijriDay: stale.hijriDay,
        gregorianDate: stale.gregorianDate,
        source: source,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2026, 9, 4, 1),
        sourcePublicationLocator: 'official-calendar:1448-01-10',
        sourcePublicationUrl: Uri.parse(
          'https://namazvakitleri.diyanet.gov.tr/',
        ),
      );

      expect(ReligiousDateDisplayPolicy.canShowExactDate(stale), isFalse);
      expect(ReligiousDateDisplayPolicy.canShowExactDate(verified), isTrue);
    });

    test('confirmed status without pinned publication evidence stays blocked', () {
      final source = religiousDateAuthorities.first;
      final missingEvidence = ReligiousDateObservation(
        contentId: 'religious-day:eid-al-fitr',
        hijriYear: 1448,
        hijriMonth: 10,
        hijriDay: 1,
        gregorianDate: DateTime.utc(2027, 3, 10),
        source: source,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2027, 3, 9),
      );
      final missingLocator = ReligiousDateObservation(
        contentId: missingEvidence.contentId,
        hijriYear: missingEvidence.hijriYear,
        hijriMonth: missingEvidence.hijriMonth,
        hijriDay: missingEvidence.hijriDay,
        gregorianDate: missingEvidence.gregorianDate,
        source: source,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2027, 3, 9),
        sourcePublicationUrl: Uri.parse(
          'https://namazvakitleri.diyanet.gov.tr/',
        ),
      );

      expect(missingEvidence.hasPinnedPublicationEvidence, isFalse);
      expect(ReligiousDateDisplayPolicy.canShowExactDate(missingEvidence), isFalse);
      expect(ReligiousDateDisplayPolicy.canShowExactDate(missingLocator), isFalse);
    });

    test('same Hijri observance may legitimately differ by country', () {
      final trSource = religiousDateAuthorities.singleWhere(
        (source) => source.countryCode == 'TR',
      );
      final saSource = religiousDateAuthorities.singleWhere(
        (source) => source.countryCode == 'SA',
      );
      final tr = ReligiousDateObservation(
        contentId: 'religious-day:eid-al-fitr',
        hijriYear: 1448,
        hijriMonth: 10,
        hijriDay: 1,
        gregorianDate: DateTime.utc(2027, 3, 10),
        source: trSource,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2027, 3, 9),
        sourcePublicationLocator: 'tr-official:1448-10-01',
        sourcePublicationUrl: Uri.parse(
          'https://namazvakitleri.diyanet.gov.tr/',
        ),
      );
      final sa = ReligiousDateObservation(
        contentId: tr.contentId,
        hijriYear: tr.hijriYear,
        hijriMonth: tr.hijriMonth,
        hijriDay: tr.hijriDay,
        gregorianDate: DateTime.utc(2027, 3, 9),
        source: saSource,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2027, 3, 9),
        sourcePublicationLocator: 'sa-announcement:1448-10-01',
        sourcePublicationUrl: Uri.parse('https://www.spa.gov.sa/'),
      );

      expect(ReligiousDateDisplayPolicy.sameHijriObservance(tr, sa), isTrue);
      expect(
        ReligiousDateDisplayPolicy.hasCountryDateDifference(tr, sa),
        isTrue,
      );
    });

    test('publication evidence rejects a non-HTTPS exact-date URL', () {
      final source = religiousDateAuthorities.first;
      expect(
        () => ReligiousDateObservation(
          contentId: 'religious-day:ashura',
          hijriYear: 1448,
          hijriMonth: 1,
          hijriDay: 10,
          gregorianDate: DateTime.utc(2026, 6, 26),
          source: source,
          status: ReligiousDateVerificationStatus.confirmed,
          verifiedAt: DateTime.utc(2026, 9, 4),
          sourcePublicationLocator: 'official-calendar:1448-01-10',
          sourcePublicationUrl: Uri.parse('http://example.org/date'),
        ),
        throwsArgumentError,
      );
    });

    test('source metadata rejects non-HTTPS or incomplete authority records', () {
      expect(
        () => ReligiousDateSourceMetadata(
          id: 'bad',
          title: 'Bad source',
          jurisdiction: 'Nowhere',
          countryCode: 'XX',
          kind: ReligiousDateSourceKind.nationalReligiousAuthority,
          url: Uri.parse('http://example.com'),
          retrievedAt: DateTime.utc(2026, 9, 4),
        ),
        throwsArgumentError,
      );
    });
  });
}
