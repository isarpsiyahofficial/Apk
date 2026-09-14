# T0338 — Production Publication-State Release Gate

## Scope

SPEC 571–589 requires every religious record to carry stable identity, source status, review status, version and review metadata, and requires unapproved content to stay out of the final dataset. `approved` and `published` are intentionally distinct states.

## Release rule

A record can enter a production religious dataset only when all of the following are true:

1. Its ID is non-empty and belongs to the exact expected production inventory.
2. Expected IDs remain unique after trim/normalization; aliases such as `canonical` and ` canonical ` cannot silently collapse into one release key.
3. The record ID occurs exactly once in the release input.
4. `reviewStatus == ContentReviewStatus.published`.
5. The shared `ReligiousContentRecord.canEnterProductionDataset` contract also passes, including non-unknown record-level source classification, complete TR/EN/AR text, at least one source and a positive version.
6. Published records carry explicit non-blank reviewer attribution; review metadata cannot be anonymous at the final publication boundary.
7. Every source ID in the record is non-empty and unique.
8. Every source has a non-empty title and license ID.
9. No source may use `ReligiousSourceClass.unknown`.
10. Every source has an inspectable locator or URL; a bibliography label without a usable reference cannot satisfy production provenance.
11. Every expected canonical ID is present; missing records fail closed rather than silently producing a partial dataset.

The states `draft`, `research`, `religiousReview`, `languageReview`, `approved` and `withdrawn` are all non-production states. In particular, `approved` does not automatically mean `published`.

## Failure paths locked by tests

`test/production_publication_gate_t0338_test.dart` verifies:

- every non-published review state is rejected;
- `approved` cannot masquerade as `published`;
- a `published` label cannot bypass missing localization or unknown record-level source governance;
- null, empty or whitespace-only reviewer attribution fails;
- duplicate record IDs fail instead of shadowing another review state;
- unexpected IDs fail;
- missing canonical IDs fail;
- blank/empty release inventories fail;
- expected IDs that collide after whitespace normalization fail;
- duplicate source IDs fail;
- blank source license metadata fails;
- unknown per-source classification fails;
- a source without locator and URL fails as uninspectable provenance;
- successful output is immutable.

## Relationship to feature-specific review gates

Feature-specific gates such as the dua native-language + religious-review evidence gate, religious-day T0335 source closure, prophet semantic ownership and history T0337 source-independence audit remain stricter prerequisites where applicable. T0338 is the final shared publication-state boundary; it does not weaken source, provenance, semantic, native-language or religious-review requirements.

## Finality

Passing T0338 does not make the application final. The remaining TEST_MATRIX language, religious-content, monetization, Canva/share, privacy and release gates still apply independently.
