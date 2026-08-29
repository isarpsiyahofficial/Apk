import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_dataset.dart';

class ProphetSourceClassAuditResult {
  const ProphetSourceClassAuditResult({
    required this.isValid,
    required this.errors,
  });

  final bool isValid;
  final List<String> errors;
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

      switch (field.status) {
        case ProphetBiographyFieldStatus.sourceBacked:
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
            if (source.sourceClass == ReligiousSourceClass.unknown) {
              errors.add('$prophetId/$fieldId: unknown source class');
            }
          }
        case ProphetBiographyFieldStatus.unknownPendingResearch:
          if (field.sources.isNotEmpty) {
            errors.add('$prophetId/$fieldId: unknown field must not carry sources');
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
