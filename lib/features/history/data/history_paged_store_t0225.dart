import '../domain/history_paged_index_t0225.dart';
import 'history_t0220_inventory.dart';

/// Canonical device-local T0225 access point.
///
/// Constructing this object does not materialize the event inventory. The
/// T0220 event list is requested only on the first page/index access and then
/// retained behind stable-ID indexes for the process lifetime.
final historyPagedIndexT0225 = HistoryPagedIndexT0225(
  loader: () => historyT0220Inventory.events,
);
