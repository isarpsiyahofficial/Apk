import '../domain/history_chunked_page_source_t0225.dart';
import '../domain/history_event_contract.dart';
import '../domain/history_paged_index_t0225.dart';
import '../domain/t0214_canonical_history_gate.dart';
import '../domain/t0215_canonical_history_gate.dart';
import '../domain/t0216_canonical_history_gate.dart';
import '../domain/t0217_canonical_history_gate.dart';
import '../domain/t0218_canonical_history_gate.dart';
import 'early_modern_events_t0220.dart';
import 'high_medieval_events_t0220.dart';
import 'history_t0220_inventory.dart';
import 'medieval_caliphates_events_t0220.dart';
import 'modern_global_events_t0220.dart';
import 'muhammad_period_events_t0220.dart';
import 'rashidun_first_fitna_events_t0220.dart';
import 'regional_events_t0220.dart';

List<HistoryEventRecord> _t0214Chunk() {
  T0214CanonicalHistoryGate.validateCanonicalDataset();
  return medievalHistoryT0214EventDatasetT0220.events;
}

List<HistoryEventRecord> _t0215Chunk() {
  T0215CanonicalHistoryGate.validateCanonicalDataset();
  return highMedievalHistoryT0215EventDatasetT0220.events;
}

List<HistoryEventRecord> _t0216Chunk() {
  T0216CanonicalHistoryGate.validateCanonicalDataset();
  return earlyModernEventsT0220.events;
}

List<HistoryEventRecord> _t0217Chunk() {
  T0217CanonicalHistoryGate.validateCanonicalDataset();
  return regionalEventsT0220.events;
}

List<HistoryEventRecord> _t0218Chunk() {
  T0218CanonicalHistoryGate.validateCanonicalDataset();
  return modernGlobalEventsT0220.events;
}

/// Production T0225 page source.
///
/// The counts are canonical-contract metadata and are checked again when a
/// chunk is first materialised. Conservative minimum years are lower bounds,
/// not user-facing historical claims; they only let the page source prove that
/// an unloaded chunk cannot precede the requested chronological boundary.
final historyChunkedPageSourceT0225 = HistoryChunkedPageSourceT0225(
  chunks: <HistoryLazyChunkT0225>[
    HistoryLazyChunkT0225(
      id: 't0217-regional',
      itemCount: 5,
      minimumStartYearCe: 600,
      loader: _t0217Chunk,
    ),
    HistoryLazyChunkT0225(
      id: 't0213-early-caliphate',
      itemCount: 5,
      minimumStartYearCe: 632,
      loader: () => earlyCaliphateT0220Dataset.events,
    ),
    HistoryLazyChunkT0225(
      id: 't0214-medieval-caliphates',
      itemCount: 6,
      minimumStartYearCe: 661,
      loader: _t0214Chunk,
    ),
    HistoryLazyChunkT0225(
      id: 't0215-high-medieval',
      itemCount: 5,
      minimumStartYearCe: 1000,
      loader: _t0215Chunk,
    ),
    HistoryLazyChunkT0225(
      id: 't0216-early-modern',
      itemCount: 3,
      minimumStartYearCe: 1200,
      loader: _t0216Chunk,
    ),
    HistoryLazyChunkT0225(
      id: 't0218-modern-global',
      itemCount: 4,
      minimumStartYearCe: 1500,
      loader: _t0218Chunk,
    ),
    HistoryLazyChunkT0225(
      id: 't0212-muhammad-relative-chronology',
      itemCount: 19,
      unknownDatesOnly: true,
      loader: () => muhammadPeriodEventsT0220.events,
    ),
  ],
);

/// Canonical device-local T0225 access point.
///
/// Page reads are backed by lazy chronological chunks. The complete T0220
/// inventory is retained only as the on-demand stable-ID/person/geography index
/// source; a normal first-page read does not invoke it.
final historyPagedIndexT0225 = HistoryPagedIndexT0225(
  totalCount: historyChunkedPageSourceT0225.totalCount,
  pageLoader: historyChunkedPageSourceT0225.loadPage,
  loader: () => historyT0220Inventory.events,
);
