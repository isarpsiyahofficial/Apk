# T0340–T0344 localization surface/state manifest

This release QA layer prevents a partially translated UI from being mistaken for a complete TR/EN/AR pass.

`LocalizationReleaseManifestT0340` expands every required product surface/state across all three release locales (`tr`, `en`, `ar`). Every resulting cell must be represented by exactly one of two states:

- **verified** — linked to a concrete widget/integration proof ID;
- **unresolved** — explicitly retained with a non-empty reason.

Missing cells, duplicate cells, a cell appearing in both sets, anonymous proof IDs, or reasonless unresolved entries fail closed.

The required surface families cover Today, Qur’an, Dua, Dhikr, Prophets, History, Religious Days, Topic Search, Premium, Ads, Billing, Offline Gate, Notifications, Widget and Share. Their required failure/state coverage includes the applicable loading, empty, error, permission, offline/recovery, rewarded success/cancel/no-fill, purchase success/cancel/pending/restore/revoke states.

This manifest deliberately does **not** mark T0340–T0344 or TEST_MATRIX L01–L10 PASS. Existing evidence such as the primary five-tab crawl, Dua loading/empty/error checks, notification permission/storage failures and FREE offline recovery can be promoted cell-by-cell only with an exact proof ID. Billing/rewarded/share/widget and other incomplete states remain explicit unresolved work until real behavior evidence exists.

## Release rule

A future full localization release gate must pass all of the following together:

1. ARB contract and placeholder/leakage audit;
2. this surface/state/locale manifest with no unresolved cells;
3. surface-specific functional/failure-path tests rather than render-only assertions;
4. AR RTL and responsive checks on relevant phone/tablet/emulator sizes;
5. exact release HEAD Flutter/Android CI success;
6. native TR/EN/AR editorial review where product copy requires human language judgement.

The manifest is a completeness guard, not a substitute for those tests.
