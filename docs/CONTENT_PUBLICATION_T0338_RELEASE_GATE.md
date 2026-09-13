# T0338 — Production Publication-State Release Gate

## Scope

SPEC 571–589 requires every religious record to carry stable identity, source status, review status, version and review metadata, and requires unapproved content to stay out of the final dataset. `approved` and `published` are intentionally distinct states.

## Release rule

A record can enter a production religious dataset only when all of the following are true:

1. Its ID is non-empty and belongs to the exact expected production inventory.
2. The ID occurs exactly once in the release input.
3. `reviewStatus == ContentReviewStatus.published`.
4. The shared `ReligiousContentRecord.canEnterProductionDataset` contract also passes, including non-unknown source classification, complete TR/EN/AR text, at least one source and a positive version.
5. Every expected canonical ID is present; missing records fail closed rather than silently producing a partial dataset.

The states `draft`, `research`, `religiousReview`, `languageReview`, `approved` and `withdrawn` are all non-production states. In particular, `approved` does not automatically mean `published`.

## Failure paths locked by tests

`test/production_publication_gate_t0338_test.dart` verifies:

- every non-published review state is rejected;
- `approved` cannot masquerade as `published`;
- a `published` label cannot bypass missing localization or unknown-source governance;
- duplicate IDs fail instead of shadowing another review state;
- unexpected IDs fail;
- missing canonical IDs fail;
- blank/empty release inventories fail;
- successful output is immutable.

## Relationship to feature-specific review gates

Feature-specific gates such as the dua native-language + religious-review evidence gate remain stricter prerequisites where applicable. T0338 is the final shared publication-state boundary; it does not weaken source, provenance, semantic, native-language or religious-review requirements.

## Finality

Passing T0338 does not make the application final. The remaining TEST_MATRIX language, religious-content, monetization, Canva/share, privacy and release gates still apply independently.
