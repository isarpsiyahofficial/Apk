# T0223 — Local vector historical map policy

## Scope

T0223 maps are explanatory historical context only. A map must not turn an approximate, regional, broad or disputed historical geography into an exact modern border, coordinate or territorial claim.

## Bundling and rights gate

- Final history maps are bundled under `assets/history/maps/`; remote map URLs are rejected by the runtime contract.
- The initial SVGs in this repository are original schematic compositions created specifically for the project. They contain no traced third-party map geometry, raster image, remote reference, template, Canva element or AI-generated artwork.
- Their manifest license marker is `PROJECT-ORIGINAL-T0223`; redistribution is limited to the project/app distribution context unless the project owner publishes a separate public license.
- Any later third-party vector must replace that marker with its real license/provenance evidence before it can pass the catalog gate.

## Canonical inventory and byte integrity

The current governed V1 catalog contains exactly these two project-original schematic vectors:

1. `history-map:hijaz-seerah-schematic` → `assets/history/maps/hijaz-seerah-schematic.svg`
   - geography IDs: `city:mecca`, `city:medina`
   - SHA-256: `25ad004a83de447792267a3622ec97c086e3989942999abf5e9231e61d2dfad5`
2. `history-map:abyssinia-context-schematic` → `assets/history/maps/abyssinia-context-schematic.svg`
   - geography ID: `region:abyssinia`
   - SHA-256: `e50ef88db916c8ea3b5d9ad74df4e5b6267166d4478276e6e50ef39b240a287e`

`T0223CanonicalMapGate` fail-closes if a canonical ID is removed, an extra unreviewed map is inserted, an ID is pointed at another asset path, a governed geography mapping changes, a canonical map stops being explicitly `schematic`, the project-original license marker drifts, or its T0220-derived source provenance changes. CI additionally hashes the exact SVG bytes, so a vector cannot be silently redrawn while retaining the same catalog metadata and provenance claim.

A deliberate future map revision must therefore update the SVG, its provenance review, the governed mapping where applicable, this policy evidence, and the pinned test hash together.

## Accuracy gate

Every asset must be classified as `approximateRegion` or `schematic`. There is intentionally no `exact` representation value in T0223. The UI-facing precision notice must exist in Turkish, English and Arabic.

The first two maps are deliberately schematic:

1. `hijaz-seerah-schematic.svg` — a relative Mecca/Medina context diagram. It does not claim exact route, scale, coastline or political boundaries.
2. `abyssinia-context-schematic.svg` — a relative Red Sea/Abyssinia migration context diagram. It does not claim an exact route, landing point, Aksumite boundary or modern border.

Historical source IDs are not invented for the drawings. The catalog derives them from the already source-governed T0220 events whose stable geography IDs the map targets. If no source-backed event exists for a target geography, catalog construction fails closed.

## Vector safety

The repository test reads each SVG and rejects external URL references, scripts and embedded raster `<image>` nodes. This keeps the history map path offline-first and prevents a supposedly local map from silently becoming a network dependency.
