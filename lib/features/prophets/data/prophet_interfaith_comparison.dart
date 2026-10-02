import '../../../core/content/content_governance.dart';

enum ProphetComparisonTradition {
  islamic,
  jewish,
  christian,
  academic,
}

class ProphetComparisonReference {
  const ProphetComparisonReference({
    required this.stableId,
    required this.tradition,
    required this.title,
    required this.locator,
    required this.licenseId,
    required this.sourceUrl,
  });

  final String stableId;
  final ProphetComparisonTradition tradition;
  final String title;
  final String locator;
  final String licenseId;
  final String sourceUrl;

  bool get isValid {
    final uri = Uri.tryParse(sourceUrl.trim());
    return stableId.trim().isNotEmpty &&
        title.trim().isNotEmpty &&
        locator.trim().isNotEmpty &&
        licenseId.trim().isNotEmpty &&
        uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty;
  }
}

class ProphetInterfaithComparison {
  const ProphetInterfaithComparison({
    required this.canonicalProphetId,
    required this.topicId,
    required this.islamicPerspective,
    required this.comparisonPerspective,
    required this.comparisonTradition,
    required this.islamicSources,
    required this.comparisonSources,
    required this.separationNotice,
  });

  final String canonicalProphetId;
  final String topicId;
  final LocalizedReligiousText islamicPerspective;
  final LocalizedReligiousText comparisonPerspective;
  final ProphetComparisonTradition comparisonTradition;
  final List<ProphetComparisonReference> islamicSources;
  final List<ProphetComparisonReference> comparisonSources;
  final LocalizedReligiousText separationNotice;

  bool get isValid {
    if (canonicalProphetId.trim().isEmpty ||
        topicId.trim().isEmpty ||
        !islamicPerspective.isComplete ||
        !comparisonPerspective.isComplete ||
        !separationNotice.isComplete ||
        comparisonTradition == ProphetComparisonTradition.islamic ||
        islamicSources.isEmpty ||
        comparisonSources.isEmpty) {
      return false;
    }

    if (islamicSources.any(
          (source) =>
              !source.isValid ||
              source.tradition != ProphetComparisonTradition.islamic,
        ) ||
        comparisonSources.any(
          (source) =>
              !source.isValid || source.tradition != comparisonTradition,
        )) {
      return false;
    }

    final allIds = <String>[
      ...islamicSources.map((source) => source.stableId),
      ...comparisonSources.map((source) => source.stableId),
    ];
    if (allIds.toSet().length != allIds.length) return false;

    return true;
  }
}

const _isaIslamicSource = ProphetComparisonReference(
  stableId: 'quran-4-157-158-isa-crucifixion',
  tradition: ProphetComparisonTradition.islamic,
  title: 'Tanzil Project — Quran Uthmani v1.1',
  locator: 'Quran 4:157-158',
  licenseId: 'CC-BY-3.0',
  sourceUrl: 'https://tanzil.net/docs/Text_License',
);

const _isaChristianSource = ProphetComparisonReference(
  stableId: 'world-english-bible-2020-isa-crucifixion',
  tradition: ProphetComparisonTradition.christian,
  title: 'World English Bible — 2020 stable text edition',
  locator: 'Matthew 27:35; Mark 15:24; Luke 23:33; John 19:18',
  licenseId: 'PUBLIC-DOMAIN',
  sourceUrl: 'https://ebible.org/engwebp/',
);

bool _matchesExactReference(
  ProphetComparisonReference actual,
  ProphetComparisonReference expected,
) =>
    actual.stableId == expected.stableId &&
    actual.tradition == expected.tradition &&
    actual.title == expected.title &&
    actual.locator == expected.locator &&
    actual.licenseId == expected.licenseId &&
    actual.sourceUrl == expected.sourceUrl;

/// Fail-closed T0195 production provenance gate.
///
/// Structural validity alone is intentionally insufficient for religious
/// comparison content. Production references must match the reviewed source
/// identity, tradition, locator, license status and canonical HTTPS URL exactly.
bool prophetInterfaithComparisonHasApprovedProvenance(
  ProphetInterfaithComparison entry,
) {
  if (!entry.isValid) return false;

  if (entry.canonicalProphetId == 'isa' &&
      entry.topicId == 'crucifixion-account' &&
      entry.comparisonTradition == ProphetComparisonTradition.christian) {
    return entry.islamicSources.length == 1 &&
        entry.comparisonSources.length == 1 &&
        _matchesExactReference(entry.islamicSources.single, _isaIslamicSource) &&
        _matchesExactReference(
          entry.comparisonSources.single,
          _isaChristianSource,
        );
  }

  return false;
}

/// T0195 keeps comparison material opt-in and physically separate from the
/// canonical Islamic biography fields. It must never be used to overwrite the
/// Islamic biography, certainty, chronology, or source classification.
const prophetInterfaithComparisons = <ProphetInterfaithComparison>[
  ProphetInterfaithComparison(
    canonicalProphetId: 'isa',
    topicId: 'crucifixion-account',
    islamicPerspective: LocalizedReligiousText(
      tr: 'Kur’an 4:157-158, Îsâ’nın öldürülüp çarmıha gerildiği iddiasını reddeder ve Allah’ın onu kendine yükselttiğini bildirir. Bu alan Kur’an’ın açık ifadesiyle sınırlıdır; sonraki ayrıntıları kesinleştirmez.',
      en: 'Quran 4:157-158 rejects the claim that Jesus was killed and crucified and states that God raised him to Himself. This field stays within the Quran’s explicit wording and does not turn later details into certainty.',
      ar: 'تنفي الآيتان 157-158 من سورة النساء دعوى قتل عيسى وصلبه، وتذكران أن الله رفعه إليه. يلتزم هذا الحقل بالنص القرآني الصريح ولا يحوّل التفاصيل اللاحقة إلى حقائق قطعية.',
    ),
    comparisonPerspective: LocalizedReligiousText(
      tr: 'Hristiyan kanonik İncil anlatıları Îsâ’nın çarmıha gerildiğini anlatır. Bu bilgi burada yalnız Hristiyan metin geleneğinin kendi anlatımı olarak gösterilir; İslami biyografi alanıyla birleştirilmez.',
      en: 'The Christian canonical Gospel accounts narrate the crucifixion of Jesus. It is shown here only as the Christian textual tradition’s own account and is not merged into the Islamic biography field.',
      ar: 'تروي الأناجيل المسيحية القانونية صلب عيسى. ويُعرض ذلك هنا بوصفه رواية التقليد النصي المسيحي نفسه فقط، من دون دمجه في حقل السيرة الإسلامية.',
    ),
    comparisonTradition: ProphetComparisonTradition.christian,
    islamicSources: <ProphetComparisonReference>[_isaIslamicSource],
    comparisonSources: <ProphetComparisonReference>[_isaChristianSource],
    separationNotice: LocalizedReligiousText(
      tr: 'Karşılaştırma alanı bilgilendirme içindir; İslami anlatı ve diğer dinlerin kendi anlatıları ayrı kaynak katmanlarında tutulur.',
      en: 'This comparison is informational; the Islamic account and other traditions’ own accounts remain in separate source layers.',
      ar: 'هذه المقارنة للتعريف فقط؛ وتبقى الرواية الإسلامية وروايات التقاليد الأخرى في طبقات مصادر منفصلة.',
    ),
  ),
];

bool get prophetInterfaithComparisonsAreValid =>
    prophetInterfaithComparisons.isNotEmpty &&
    prophetInterfaithComparisons.every(
      prophetInterfaithComparisonHasApprovedProvenance,
    );
