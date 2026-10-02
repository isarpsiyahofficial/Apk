/// T0336 source-audit records for canonical prophets whose hadith dimension
/// remains explicitly unresolved after the reviewed Sahih/TDV research pass.
///
/// These records are editorial release metadata only. They are deliberately
/// not [ProphetSemanticClaim] instances and therefore can never inflate hadith
/// coverage. A future verified claim must replace the relevant unresolved audit
/// only after exact primary-source locator, grading/source class and biography
/// ownership are independently reviewed.
enum ProphetHadithUnresolvedReasonT0336 {
  noDirectAdmittedReport,
  identityMismatch,
  disputedOrIndirectReport,
  israiliyyatOrUnsupportedNarrative,
}

final class ProphetHadithUnresolvedSourceAuditT0336 {
  const ProphetHadithUnresolvedSourceAuditT0336({
    required this.prophetId,
    required this.reason,
    required this.reviewAuthority,
    required this.reviewNote,
  });

  final String prophetId;
  final ProphetHadithUnresolvedReasonT0336 reason;
  final String reviewAuthority;
  final String reviewNote;

  bool get isFailClosed =>
      prophetId.trim().isNotEmpty &&
      reviewAuthority.trim().isNotEmpty &&
      reviewNote.trim().isNotEmpty;
}

const canonicalProphetHadithUnresolvedSourceAuditT0336 =
    <ProphetHadithUnresolvedSourceAuditT0336>[
  ProphetHadithUnresolvedSourceAuditT0336(
    prophetId: 'hud',
    reason: ProphetHadithUnresolvedReasonT0336.noDirectAdmittedReport,
    reviewAuthority: 'TDV İslâm Ansiklopedisi — HÛD',
    reviewNote:
        'Reviewed material establishes Hud primarily through Quranic and later historical/genealogical discussion; no exact biography-owned Sahih/Hasan hadith locator was admitted in the T0336 source pass.',
  ),
  ProphetHadithUnresolvedSourceAuditT0336(
    prophetId: 'shuayb',
    reason: ProphetHadithUnresolvedReasonT0336.disputedOrIndirectReport,
    reviewAuthority: 'TDV İslâm Ansiklopedisi — ŞUAYB',
    reviewNote:
        'The article records differing traditions and points secondarily to a report about Arab prophets, but T0336 has not established an exact primary Sahih/Hasan locator that directly supports Shuayb biography ownership.',
  ),
  ProphetHadithUnresolvedSourceAuditT0336(
    prophetId: 'dhul_kifl',
    reason: ProphetHadithUnresolvedReasonT0336.identityMismatch,
    reviewAuthority: 'TDV İslâm Ansiklopedisi — ZÜLKİFL',
    reviewNote:
        'TDV explicitly warns that the Ahmad/Tirmidhi report about a man called Kifl cannot be identified with the Quranic Dhul-Kifl; the report is described as gharib and must not be promoted to Dhul-Kifl ownership.',
  ),
  ProphetHadithUnresolvedSourceAuditT0336(
    prophetId: 'ilyas',
    reason:
        ProphetHadithUnresolvedReasonT0336.israiliyyatOrUnsupportedNarrative,
    reviewAuthority: 'TDV İslâm Ansiklopedisi — İLYÂS',
    reviewNote:
        'TDV distinguishes Quranic material from extensive later Israelite-derived narratives and flags claims of Ilyas remaining alive as unsupported/fabricated; no reviewed direct hadith owner claim is admitted here.',
  ),
  ProphetHadithUnresolvedSourceAuditT0336(
    prophetId: 'alyasa',
    reason: ProphetHadithUnresolvedReasonT0336.noDirectAdmittedReport,
    reviewAuthority: 'TDV İslâm Ansiklopedisi — ELYESA‘',
    reviewNote:
        'TDV states that beyond the two Quranic mentions and genealogy reported in Islamic sources, no further information is available; T0336 therefore keeps the hadith slot unresolved rather than inventing evidence.',
  ),
];
