import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_exact_date_claim_audit_t0207.dart';

void main() {
  const audit = ProphetExactDateClaimAuditT0207();

  test('canonical T0194 biography prose has no unstructured exact calendar year', () {
    expect(audit.audit(canonicalProphetBiographyT0194Dataset), isEmpty);
  });

  test('rejects Latin calendar-year claims embedded directly in biography prose', () {
    final adam = canonicalProphetBiographyDrafts.first;
    final sections = Map<ProphetBiographySectionKey, ProphetBiographyField>.from(
      adam.sections,
    );
    sections[ProphetBiographySectionKey.period] = const ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Âdem kesin olarak MÖ 4000 yılında yaşamıştır.',
        en: 'Adam lived in exactly 4000 BCE.',
        ar: 'آدم عاش في زمن غير محدد.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: [prophetUniversalMessageSource],
    );
    final injected = CanonicalProphetBiographyDraft(
      identity: adam.identity,
      quranReferences: adam.quranReferences,
      sections: sections,
    );

    final errors = audit.audit([injected]);
    expect(errors, hasLength(1));
    expect(errors.single, contains('unstructured exact calendar-year claim'));
  });

  test('rejects Arabic exact calendar-year claims embedded in biography prose', () {
    final adam = canonicalProphetBiographyDrafts.first;
    final sections = Map<ProphetBiographySectionKey, ProphetBiographyField>.from(
      adam.sections,
    );
    sections[ProphetBiographySectionKey.period] = const ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Dönem kesinleştirilmemiştir.',
        en: 'The period is not established exactly.',
        ar: 'عاش آدم سنة ٤٠٠٠ ق.م.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: [prophetUniversalMessageSource],
    );
    final injected = CanonicalProphetBiographyDraft(
      identity: adam.identity,
      quranReferences: adam.quranReferences,
      sections: sections,
    );

    expect(audit.audit([injected]), isNotEmpty);
  });

  test('does not confuse sourced durations with calendar-year claims', () {
    final nuh = canonicalProphetBiographyDrafts.singleWhere(
      (draft) => draft.identity.canonicalId == 'nuh',
    );
    final sections = Map<ProphetBiographySectionKey, ProphetBiographyField>.from(
      nuh.sections,
    );
    sections[ProphetBiographySectionKey.keyEvents] = const ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Kur’an, Nûh’un kavmi içinde bin yıldan elli yıl eksik kaldığını bildirir.',
        en: 'The Quran states that Noah remained among his people for a thousand years minus fifty.',
        ar: 'يذكر القرآن أنه لبث في قومه ألف سنة إلا خمسين عامًا.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: [prophetUniversalMessageSource],
    );
    final injected = CanonicalProphetBiographyDraft(
      identity: nuh.identity,
      quranReferences: nuh.quranReferences,
      sections: sections,
    );

    expect(audit.audit([injected]), isEmpty);
  });
}
