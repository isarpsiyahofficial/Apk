import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/noncanonical_prophet_candidates.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

void main() {
  group('non-canonical prophet candidates', () {
    test('keeps the five disputed/traditional identities outside canonical 25', () {
      expect(nonCanonicalProphetCandidates, hasLength(5));
      expect(nonCanonicalProphetCandidatesAreValid, isTrue);

      final canonicalIds = canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
      final candidateIds = nonCanonicalProphetCandidates.map((entry) => entry.canonicalId).toSet();
      expect(canonicalIds.intersection(candidateIds), isEmpty);
      expect(candidateIds, equals(disputedOrNonCanonicalProphetCandidates));
    });

    test('Luqman Uzayr and Dhul-Qarnayn remain Quran-named but disputed', () {
      for (final id in ['luqman', 'uzayr', 'dhul_qarnayn']) {
        final entry = nonCanonicalProphetCandidates.singleWhere((value) => value.canonicalId == id);
        expect(entry.identityBasis, ProphetCandidateIdentityBasis.quranNamed);
        expect(entry.status, ProphetCandidateStatus.prophethoodDisputed);
        expect(entry.quranReference, isNotNull);
        expect(entry.sources.any((source) => source.sourceClass == ReligiousSourceClass.quran), isTrue);
      }
    });

    test('Khidr is not represented as explicitly Quran-named', () {
      final khidr = nonCanonicalProphetCandidates.singleWhere((value) => value.canonicalId == 'khidr');
      expect(khidr.identityBasis, ProphetCandidateIdentityBasis.quranUnnamedTraditionalIdentification);
      expect(khidr.status, ProphetCandidateStatus.prophethoodDisputed);
      expect(khidr.quranReference?.stableId, '18:65');
      expect(khidr.summary.en, contains('does not explicitly name'));
    });

    test('Shith remains later tradition and has no fabricated Quran locator', () {
      final shith = nonCanonicalProphetCandidates.singleWhere((value) => value.canonicalId == 'shith');
      expect(shith.identityBasis, ProphetCandidateIdentityBasis.laterTradition);
      expect(shith.status, ProphetCandidateStatus.traditionalProphetClaim);
      expect(shith.quranReference, isNull);
      expect(shith.sources.any((source) => source.sourceClass == ReligiousSourceClass.quran), isFalse);
      expect(
        shith.sources.any((source) => source.sourceClass == ReligiousSourceClass.laterTradition),
        isTrue,
      );
    });

    test('all summaries are complete TR EN AR and source metadata is preserved', () {
      for (final entry in nonCanonicalProphetCandidates) {
        expect(entry.summary.isComplete, isTrue, reason: entry.canonicalId);
        expect(entry.name.isComplete, isTrue, reason: entry.canonicalId);
        expect(entry.sources, isNotEmpty, reason: entry.canonicalId);
        for (final source in entry.sources) {
          expect(source.id, isNotEmpty, reason: entry.canonicalId);
          expect(source.title, isNotEmpty, reason: entry.canonicalId);
          expect(source.licenseId, isNotEmpty, reason: entry.canonicalId);
        }
      }
    });

    test('invalid promotion into canonical identity fails the candidate gate', () {
      final unsafe = NonCanonicalProphetCandidate(
        canonicalId: 'ibrahim',
        name: const LocalizedReligiousText(tr: 'İbrâhim', en: 'Abraham', ar: 'إبراهيم'),
        arabicName: 'إبراهيم',
        identityBasis: ProphetCandidateIdentityBasis.quranNamed,
        status: ProphetCandidateStatus.prophethoodDisputed,
        quranReference: const ProphetVerseReference(surah: 2, ayah: 124),
        summary: const LocalizedReligiousText(tr: 'Test', en: 'Test', ar: 'اختبار'),
        sources: const [
          SourceReference(
            id: 'quran-canonical-2:124',
            title: 'Canonical Quran',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
            locator: '2:124',
          ),
        ],
      );
      expect(unsafe.isValid, isFalse);
    });

    test('later-tradition identity cannot be given a Quran source or locator', () {
      final unsafe = NonCanonicalProphetCandidate(
        canonicalId: 'shith-test',
        name: const LocalizedReligiousText(tr: 'Şît', en: 'Seth', ar: 'شيث'),
        arabicName: 'شيث',
        identityBasis: ProphetCandidateIdentityBasis.laterTradition,
        status: ProphetCandidateStatus.traditionalProphetClaim,
        quranReference: const ProphetVerseReference(surah: 2, ayah: 1),
        summary: const LocalizedReligiousText(tr: 'Test', en: 'Test', ar: 'اختبار'),
        sources: const [
          SourceReference(
            id: 'unsafe-quran',
            title: 'Unsafe Quran attribution',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
          ),
        ],
      );
      expect(unsafe.isValid, isFalse);
    });
  });
}
