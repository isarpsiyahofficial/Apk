# T0223 — Local vector historical map policy

## Scope

T0223 maps are explanatory historical context only. A map must not turn an approximate, regional, broad or disputed historical geography into an exact modern border, coordinate or territorial claim.

## Bundling and rights gate

- Final history maps are bundled under `assets/history/maps/`; remote map URLs are rejected by the runtime contract.
- The initial SVGs in this repository are original schematic compositions created specifically for the project. They contain no traced third-party map geometry, raster image, remote reference, template, Canva element or AI-generated artwork.
- Their manifest license marker is `PROJECT-ORIGINAL-T0223`; redistribution is limited to the project/app distribution context unless the project owner publishes a separate public license.
- Any later third-party vector must replace that marker with its real license/provenance evidence before it can pass the catalog gate.

## Accuracy gate

Every asset must be classified as `approximateRegion` or `schematic`. There is intentionally no `exact` representation value in T0223. The UI-facing precision notice must exist in Turkish, English and Arabic.

The first two maps are deliberately schematic:

1. `hijaz-seerah-schematic.svg` — a relative Mecca/Medina context diagram. It does not claim exact route, scale, coastline or political boundaries.
2. `abyssinia-context-schematic.svg` — a relative Red Sea/Abyssinia migration context diagram. It does not claim an exact route, landing point, Aksumite boundary or modern border.

Historical source IDs are not invented for the drawings. The catalog derives them from the already source-governed T0220 events whose stable geography IDs the map targets. If no source-backed event exists for a target geography, catalog construction fails closed.

## Vector safety

The repository test reads each SVG and rejects external URL references, scripts and embedded raster `<image>` nodes. This keeps the history map path offline-first and prevents a supposedly local map from silently becoming a network dependency.
