import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_content.dart';

enum ProphetCandidateIdentityBasis {
  quranNamed,
  quranUnnamedTraditionalIdentification,
  laterTradition,
}

enum ProphetCandidateStatus {
  prophethoodDisputed,
  traditionalProphetClaim,
}

class NonCanonicalProphetCandidate {
  const NonCanonicalProphetCandidate({
    required this.canonicalId,
    required this.name,
    required this.arabicName,
    required this.identityBasis,
    required this.status,
    required this.summary,
    required this.sources,
    this.quranReference,
  });

  final String canonicalId;
  final LocalizedReligiousText name;
  final String arabicName;
  final ProphetCandidateIdentityBasis identityBasis;
  final ProphetCandidateStatus status;
  final LocalizedReligiousText summary;
  final List<SourceReference> sources;
  final ProphetVerseReference? quranReference;

  bool get isValid {
    if (canonicalId.trim().isEmpty ||
        !name.isComplete ||
        arabicName.trim().isEmpty ||
        !summary.isComplete ||
        sources.isEmpty ||
        sources.any((source) =>
            source.id.trim().isEmpty ||
            source.title.trim().isEmpty ||
            source.licenseId.trim().isEmpty)) {
      return false;
    }

    final canonicalIds =
        canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
    if (canonicalIds.contains(canonicalId)) return false;

    final reference = quranReference;
    switch (identityBasis) {
      case ProphetCandidateIdentityBasis.quranNamed:
        return reference?.isValid == true &&
            _hasPinnedQuranEvidence(reference!, sources) &&
            status == ProphetCandidateStatus.prophethoodDisputed;
      case ProphetCandidateIdentityBasis.quranUnnamedTraditionalIdentification:
        return reference?.isValid == true &&
            _hasPinnedQuranEvidence(reference!, sources) &&
            sources.any((source) =>
                source.sourceClass == ReligiousSourceClass.disputed ||
                source.sourceClass == ReligiousSourceClass.classicalTraditional ||
                source.sourceClass == ReligiousSourceClass.laterTradition) &&
            status == ProphetCandidateStatus.prophethoodDisputed;
      case ProphetCandidateIdentityBasis.laterTradition:
        return quranReference == null &&
            sources.every((source) => source.sourceClass != ReligiousSourceClass.quran) &&
            sources.any((source) =>
                source.sourceClass == ReligiousSourceClass.laterTradition ||
                source.sourceClass == ReligiousSourceClass.israiliyat ||
                source.sourceClass == ReligiousSourceClass.classicalTraditional) &&
            status == ProphetCandidateStatus.traditionalProphetClaim;
    }
  }
}

bool _hasPinnedQuranEvidence(
  ProphetVerseReference reference,
  List<SourceReference> sources,
) {
  final quranSources = sources
      .where((source) => source.sourceClass == ReligiousSourceClass.quran)
      .toList(growable: false);
  if (quranSources.isEmpty) return false;

  return quranSources.every(_hasValidQuranLocator) &&
      quranSources.any((source) => _quranSourceCoversReference(source, reference));
}

bool _hasValidQuranLocator(SourceReference source) {
  final range = _parseQuranLocator(source.locator);
  return range != null && range.isValid;
}

bool _quranSourceCoversReference(
  SourceReference source,
  ProphetVerseReference reference,
) {
  final range = _parseQuranLocator(source.locator);
  if (range == null || !range.isValid) return false;
  return range.contains(reference);
}

_QuranLocatorRange? _parseQuranLocator(String? rawLocator) {
  final locator = rawLocator?.trim();
  if (locator == null || locator.isEmpty) return null;

  final match = RegExp(r'^(\d{1,3}):(\d+)(?:-(?:(\d{1,3}):)?(\d+))?$')
      .firstMatch(locator);
  if (match == null) return null;

  final startSurah = int.tryParse(match.group(1)!);
  final startAyah = int.tryParse(match.group(2)!);
  final explicitEndSurah = match.group(3) == null
      ? null
      : int.tryParse(match.group(3)!);
  final explicitEndAyah =
      match.group(4) == null ? null : int.tryParse(match.group(4)!);
  if (startSurah == null || startAyah == null) return null;

  return _QuranLocatorRange(
    startSurah: startSurah,
    startAyah: startAyah,
    endSurah: explicitEndSurah ?? startSurah,
    endAyah: explicitEndAyah ?? startAyah,
  );
}

class _QuranLocatorRange {
  const _QuranLocatorRange({
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });

  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;

  bool get isValid {
    if (startSurah < 1 || startSurah > 114 || endSurah < 1 || endSurah > 114) {
      return false;
    }
    if (startAyah < 1 || endAyah < 1) return false;
    return _compare(startSurah, startAyah, endSurah, endAyah) <= 0;
  }

  bool contains(ProphetVerseReference reference) {
    if (!reference.isValid || !isValid) return false;
    return _compare(
              startSurah,
              startAyah,
              reference.surah,
              reference.ayah,
            ) <=
            0 &&
        _compare(
              reference.surah,
              reference.ayah,
              endSurah,
              endAyah,
            ) <=
            0;
  }

  static int _compare(int leftSurah, int leftAyah, int rightSurah, int rightAyah) {
    final surahComparison = leftSurah.compareTo(rightSurah);
    return surahComparison != 0 ? surahComparison : leftAyah.compareTo(rightAyah);
  }
}

SourceReference _quranSource(String locator) => SourceReference(
      id: 'quran-canonical-$locator',
      title: 'Canonical Quran',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'CC-BY-3.0',
      locator: locator,
    );

SourceReference _tdvSource({
  required String id,
  required String title,
  required String path,
  ReligiousSourceClass sourceClass = ReligiousSourceClass.disputed,
}) => SourceReference(
      id: id,
      title: title,
      sourceClass: sourceClass,
      licenseId: 'reference-only',
      url: Uri.parse('https://islamansiklopedisi.org.tr/$path'),
    );

final nonCanonicalProphetCandidates = <NonCanonicalProphetCandidate>[
  NonCanonicalProphetCandidate(
    canonicalId: 'luqman',
    name: const LocalizedReligiousText(tr: 'Lokman', en: 'Luqman', ar: 'لقمان'),
    arabicName: 'لقمان',
    identityBasis: ProphetCandidateIdentityBasis.quranNamed,
    status: ProphetCandidateStatus.prophethoodDisputed,
    quranReference: const ProphetVerseReference(surah: 31, ayah: 12),
    summary: const LocalizedReligiousText(
      tr: 'Kur’an’da adı geçer ve kendisine hikmet verildiği bildirilir; peygamberliği ihtilaflıdır ve canonical 25 peygamber listesine dahil edilmez.',
      en: 'He is named in the Quran and is described as having been granted wisdom; his prophethood is disputed and he is not included in the canonical list of 25 prophets.',
      ar: 'ورد اسمه في القرآن وذُكر أن الله آتاه الحكمة؛ ونبوته محل خلاف، لذلك لا يُدرج ضمن قائمة الأنبياء الخمسة والعشرين المعتمدة.',
    ),
    sources: [
      _quranSource('31:12'),
      _tdvSource(id: 'tdv-lokman', title: 'TDV İslâm Ansiklopedisi — Lokman', path: 'lokman'),
    ],
  ),
  NonCanonicalProphetCandidate(
    canonicalId: 'uzayr',
    name: const LocalizedReligiousText(tr: 'Üzeyir', en: 'Uzayr', ar: 'عزير'),
    arabicName: 'عزير',
    identityBasis: ProphetCandidateIdentityBasis.quranNamed,
    status: ProphetCandidateStatus.prophethoodDisputed,
    quranReference: const ProphetVerseReference(surah: 9, ayah: 30),
    summary: const LocalizedReligiousText(
      tr: 'Kur’an’da adı geçer; peygamber olup olmadığı İslami kaynaklarda ihtilaflıdır ve canonical 25 peygamber listesine dahil edilmez.',
      en: 'He is named in the Quran; Islamic sources differ over whether he was a prophet, so he is not included in the canonical list of 25 prophets.',
      ar: 'ورد اسمه في القرآن، واختلفت المصادر الإسلامية في نبوته؛ لذلك لا يُدرج ضمن قائمة الأنبياء الخمسة والعشرين المعتمدة.',
    ),
    sources: [
      _quranSource('9:30'),
      _tdvSource(id: 'tdv-uzeyir', title: 'TDV İslâm Ansiklopedisi — Üzeyir', path: 'uzeyir'),
    ],
  ),
  NonCanonicalProphetCandidate(
    canonicalId: 'dhul_qarnayn',
    name: const LocalizedReligiousText(tr: 'Zülkarneyn', en: 'Dhul-Qarnayn', ar: 'ذو القرنين'),
    arabicName: 'ذو القرنين',
    identityBasis: ProphetCandidateIdentityBasis.quranNamed,
    status: ProphetCandidateStatus.prophethoodDisputed,
    quranReference: const ProphetVerseReference(surah: 18, ayah: 83),
    summary: const LocalizedReligiousText(
      tr: 'Kur’an’da kıssası ve lakabı geçer; peygamberliği konusunda farklı görüşler vardır ve canonical 25 peygamber listesine dahil edilmez.',
      en: 'His Quranic account and title are explicit, but views differ over his prophethood; he is not included in the canonical list of 25 prophets.',
      ar: 'وردت قصته ولقبه في القرآن، لكن نبوته محل خلاف؛ لذلك لا يُدرج ضمن قائمة الأنبياء الخمسة والعشرين المعتمدة.',
    ),
    sources: [
      _quranSource('18:83-98'),
      _tdvSource(id: 'tdv-zulkarneyn', title: 'TDV İslâm Ansiklopedisi — Zülkarneyn', path: 'zulkarneyn'),
    ],
  ),
  NonCanonicalProphetCandidate(
    canonicalId: 'khidr',
    name: const LocalizedReligiousText(tr: 'Hızır', en: 'Khidr', ar: 'الخضر'),
    arabicName: 'الخضر',
    identityBasis: ProphetCandidateIdentityBasis.quranUnnamedTraditionalIdentification,
    status: ProphetCandidateStatus.prophethoodDisputed,
    quranReference: const ProphetVerseReference(surah: 18, ayah: 65),
    summary: const LocalizedReligiousText(
      tr: 'Kur’an, Mûsâ kıssasındaki kulu “Hızır” adıyla açıkça isimlendirmez; bu kimlik geleneksel olarak kurulmuştur ve peygamberliği de ihtilaflıdır.',
      en: 'The Quran does not explicitly name the servant in Moses’ account as “Khidr”; that identification is traditional, and his prophethood is also disputed.',
      ar: 'لا يذكر القرآن اسم «الخضر» صراحةً للعبد في قصة موسى؛ وإنما هو تعيين موروث، كما أن نبوته محل خلاف.',
    ),
    sources: [
      _quranSource('18:65-82'),
      _tdvSource(id: 'tdv-hizir', title: 'TDV İslâm Ansiklopedisi — Hızır', path: 'hizir'),
    ],
  ),
  NonCanonicalProphetCandidate(
    canonicalId: 'shith',
    name: const LocalizedReligiousText(tr: 'Şît', en: 'Seth', ar: 'شيث'),
    arabicName: 'شيث',
    identityBasis: ProphetCandidateIdentityBasis.laterTradition,
    status: ProphetCandidateStatus.traditionalProphetClaim,
    summary: const LocalizedReligiousText(
      tr: 'Kur’an’da adı geçmez. Şît’in peygamberliği daha sonraki İslami rivayetlerde aktarılır; bu bilgi canonical Kur’an peygamber listesine yükseltilmez.',
      en: 'He is not named in the Quran. Reports of Seth’s prophethood come from later Islamic tradition and are not promoted into the canonical Quran-named prophet list.',
      ar: 'لا يرد اسم شيث في القرآن. وتُنقل نبوته في روايات إسلامية لاحقة، ولا تُرفع هذه الروايات إلى مرتبة قائمة الأنبياء المذكورين صراحةً في القرآن.',
    ),
    sources: [
      _tdvSource(
        id: 'tdv-sit',
        title: 'TDV İslâm Ansiklopedisi — Şît',
        path: 'sit',
        sourceClass: ReligiousSourceClass.laterTradition,
      ),
    ],
  ),
];

bool get nonCanonicalProphetCandidatesAreValid {
  if (nonCanonicalProphetCandidates.length != 5 ||
      nonCanonicalProphetCandidates.any((entry) => !entry.isValid)) {
    return false;
  }

  final ids = nonCanonicalProphetCandidates.map((entry) => entry.canonicalId).toSet();
  return ids.length == nonCanonicalProphetCandidates.length &&
      ids.containsAll(disputedOrNonCanonicalProphetCandidates) &&
      disputedOrNonCanonicalProphetCandidates.containsAll(ids);
}
