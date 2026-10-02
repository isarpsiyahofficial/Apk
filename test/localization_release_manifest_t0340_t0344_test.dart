import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/localization/localization_release_manifest_t0340.dart';

LocalizationCoverageCellT0340 _cell(
  LocalizationSurfaceT0340 surface,
  LocalizationStateT0340 state,
  LocalizationLocaleT0340 locale,
) =>
    LocalizationCoverageCellT0340(
      surface: surface,
      state: state,
      locale: locale,
    );

void main() {
  test('required release matrix expands every surface/state across TR EN AR', () {
    final required = LocalizationReleaseManifestT0340.requiredCells;
    final keys = required.map((cell) => cell.key).toSet();

    expect(keys.length, required.length);
    for (final entry in LocalizationReleaseManifestT0340.requiredStates.entries) {
      for (final state in entry.value) {
        for (final locale in LocalizationLocaleT0340.values) {
          expect(keys, contains('${entry.key.name}:${state.name}:${locale.name}'));
        }
      }
    }
  });

  test('complete explicit unresolved partition is accepted without fake PASS', () {
    final unresolved = LocalizationReleaseManifestT0340.requiredCells
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Awaiting surface-specific widget/integration evidence.',
          ),
        )
        .toList();

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: const [],
        unresolved: unresolved,
      ),
      returnsNormally,
    );
  });

  test('verified proof can replace the exact unresolved cell only', () {
    final target = _cell(
      LocalizationSurfaceT0340.dua,
      LocalizationStateT0340.error,
      LocalizationLocaleT0340.ar,
    );
    final unresolved = LocalizationReleaseManifestT0340.requiredCells
        .where((cell) => cell.key != target.key)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Not yet proven.',
          ),
        );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(
            cell: target,
            proofId: 'localization_dua_surface_t0344_test.dart::error::ar',
          ),
        ],
        unresolved: unresolved,
      ),
      returnsNormally,
    );
  });

  test('cross-locale proof binding fails closed', () {
    final target = _cell(
      LocalizationSurfaceT0340.dua,
      LocalizationStateT0340.error,
      LocalizationLocaleT0340.ar,
    );
    final unresolved = LocalizationReleaseManifestT0340.requiredCells
        .where((cell) => cell.key != target.key)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Not yet proven.',
          ),
        );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(
            cell: target,
            proofId: 'localization_dua_surface_t0344_test.dart::error::en',
          ),
        ],
        unresolved: unresolved,
      ),
      throwsStateError,
    );
  });

  test('same proof ID cannot verify multiple localization cells', () {
    final targets = LocalizationReleaseManifestT0340.requiredCells
        .where((cell) => cell.locale == LocalizationLocaleT0340.tr)
        .take(2)
        .toList();
    final targetKeys = targets.map((cell) => cell.key).toSet();
    final unresolved = LocalizationReleaseManifestT0340.requiredCells
        .where((cell) => !targetKeys.contains(cell.key))
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Pending.',
          ),
        );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(
            cell: targets[0],
            proofId: 'shared-proof::tr',
          ),
          LocalizationVerifiedEvidenceT0340(
            cell: targets[1],
            proofId: 'shared-proof::tr',
          ),
        ],
        unresolved: unresolved,
      ),
      throwsStateError,
    );
  });

  test('silent missing cell fails closed', () {
    final unresolved = LocalizationReleaseManifestT0340.requiredCells
        .skip(1)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Pending.',
          ),
        );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: const [],
        unresolved: unresolved,
      ),
      throwsStateError,
    );
  });

  test('same cell cannot be both verified and unresolved', () {
    final target = LocalizationReleaseManifestT0340.requiredCells.first;
    final remaining = LocalizationReleaseManifestT0340.requiredCells
        .skip(1)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Pending.',
          ),
        );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(
            cell: target,
            proofId: 'proof::${target.locale.name}',
          ),
        ],
        unresolved: [
          LocalizationUnresolvedEvidenceT0340(
            cell: target,
            reason: 'Contradictory status.',
          ),
          ...remaining,
        ],
      ),
      throwsStateError,
    );
  });

  test('duplicate verified or unresolved cells fail closed', () {
    final target = LocalizationReleaseManifestT0340.requiredCells.first;
    final rest = LocalizationReleaseManifestT0340.requiredCells
        .skip(1)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Pending.',
          ),
        )
        .toList();

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(
            cell: target,
            proofId: 'a::${target.locale.name}',
          ),
          LocalizationVerifiedEvidenceT0340(
            cell: target,
            proofId: 'b::${target.locale.name}',
          ),
        ],
        unresolved: rest,
      ),
      throwsStateError,
    );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: const [],
        unresolved: [
          LocalizationUnresolvedEvidenceT0340(cell: target, reason: 'a'),
          LocalizationUnresolvedEvidenceT0340(cell: target, reason: 'b'),
          ...rest,
        ],
      ),
      throwsStateError,
    );
  });

  test('blank proof and blank unresolved reason fail closed', () {
    final target = LocalizationReleaseManifestT0340.requiredCells.first;
    final rest = LocalizationReleaseManifestT0340.requiredCells
        .skip(1)
        .map(
          (cell) => LocalizationUnresolvedEvidenceT0340(
            cell: cell,
            reason: 'Pending.',
          ),
        )
        .toList();

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: [
          LocalizationVerifiedEvidenceT0340(cell: target, proofId: '   '),
        ],
        unresolved: rest,
      ),
      throwsStateError,
    );

    expect(
      () => LocalizationReleaseManifestT0340.validate(
        verified: const [],
        unresolved: [
          LocalizationUnresolvedEvidenceT0340(cell: target, reason: '   '),
          ...rest,
        ],
      ),
      throwsStateError,
    );
  });
}