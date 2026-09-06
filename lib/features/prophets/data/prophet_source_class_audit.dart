import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_dataset.dart';

/// SPEC 864–869 / TODO T0196 permits only these source classes for
/// prophet-biography information. Other application-wide source classes (for
/// example meaning-based dua or ebced/havas) must never be promoted into a
/// prophet biography merely because they are valid elsewhere in the product.
const Set<ReligiousSourceClass> prophetBiographySourceClassAllowlist = {
  ReligiousSourceClass.quran,
  ReligiousSourceClass.sahihHasanHadith,
  ReligiousSourceClass.earlyIslamicHistoryTafsir,
  ReligiousSourceClass.israiliyat,
  ReligiousSourceClass.laterTradition,
  ReligiousSourceClass.modernHistoryArchaeology,
  ReligiousSourceClass.disputed,
};

class ProphetSourceClassAuditResult {
  const ProphetSourceClassAuditResult({
    required this.isValid,
    required this.errors,
  });

  final bool isValid;
  final List<String> errors;
}

/// Returns the effective SPEC 864 classification of one biography field.
///
/// A researched field can carry more than one explicit source class when the
/// text deliberately separates perspectives. A still-unresolved field is
/// classified as `unknown` without fabricating a SourceReference.
Set<ReligiousSourceClass> effectiveProphetBiographySourceClasses(
  ProphetBiographyField field,
) {
  if (field.status == ProphetBiographyFieldStatus.unknownPendingResearch) {
    return const {ReligiousSourceClass.unknown};
  }
  return Set<ReligiousSourceClass>.unmodifiable(
    field.sources.map((source) => source.sourceClass),
  );
}

ProphetSourceClassAuditResult auditProphetBiographySourceClasses(
  Iterable<CanonicalProphetBiographyDraft> drafts,
) {
  final errors = <String>[];

  for (final draft in drafts) {
    final prophetId = draft.identity.canonicalId;
    for (final entry in draft.sections.entries) {
      final field = entry.value;
      final fieldId = entry.key.name;

      if (field.status == ProphetBiographyFieldStatus.sourceBacked) {
        if (field.sources.isEmpty) {
          errors.add('$prophetId/$fieldId: source-backed field has no source');
          continue;
        }
        for (final source in field.sources) {
          if (source.id.trim().isEmpty ||
              source.title.trim().isEmpty ||
              source.licenseId.trim().isEmpty ||
              (source.locator?.trim().isEmpty ?? true)) {
            errors.add('$prophetId/$fieldId: incomplete source metadata');
          }
          if (!prophetBiographySourceClassAllowlist.contains(source.sourceClass)) {
            errors.add(
              '$prophetId/$fieldId: source class '
              '${source.sourceClass.stableId} is not permitted for prophet biographies',
            );
          }
        }

        final effectiveClasses = effectiveProphetBiographySourceClasses(field);
        if (effectiveClasses.isEmpty ||
            effectiveClasses.contains(ReligiousSourceClass.unknown)) {
          errors.add('$prophetId/$fieldId: source-backed field is not classified');
        }
      } else {
        if (field.sources.isNotEmpty) {
          errors.add('$prophetId/$fieldId: unknown field must not carry sources');
        }
        final effectiveClasses = effectiveProphetBiographySourceClasses(field);
        if (effectiveClasses.length != 1 ||
            !effectiveClasses.contains(ReligiousSourceClass.unknown)) {
          errors.add('$prophetId/$fieldId: unresolved field must classify as unknown');
        }
      }
    }
  }

  return ProphetSourceClassAuditResult(
    isValid: errors.isEmpty,
    errors: List<String>.unmodifiable(errors),
  );
}

final canonicalProphetSourceClassAudit =
    auditProphetBiographySourceClasses(canonicalProphetBiographyT0194Dataset);
