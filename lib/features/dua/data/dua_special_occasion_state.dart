import 'dua_content.dart';
import 'dua_library_repository.dart';

/// Honest availability state for occasion-specific authenticated duas.
///
/// This type never claims that no authentic dua exists anywhere in the
/// tradition. It only reports what is present in the production-reviewed,
/// bundled library for the selected occasion. That distinction prevents an
/// empty dataset from being turned into a religious assertion.
enum DuaSpecialOccasionStatus {
  authenticatedSpecialDuaAvailable,
  noAuthenticatedSpecialDuaInVerifiedLibrary,
}

final class DuaSpecialOccasionState {
  const DuaSpecialOccasionState({
    required this.category,
    required this.status,
    required this.authenticatedSpecialDuas,
    required this.otherVerifiedDuas,
  });

  final DuaCategory category;
  final DuaSpecialOccasionStatus status;
  final List<DuaContent> authenticatedSpecialDuas;
  final List<DuaContent> otherVerifiedDuas;

  bool get hasAuthenticatedSpecialDua =>
      status == DuaSpecialOccasionStatus.authenticatedSpecialDuaAvailable;

  bool get shouldShowNoAuthenticatedSpecialDuaNotice =>
      status ==
      DuaSpecialOccasionStatus.noAuthenticatedSpecialDuaInVerifiedLibrary;
}

abstract final class DuaSpecialOccasionEvaluator {
  static const Set<DuaCategory> supportedOccasionCategories = {
    DuaCategory.ramadan,
    DuaCategory.friday,
    DuaCategory.eid,
    DuaCategory.religiousNights,
  };

  static DuaSpecialOccasionState evaluate({
    required DuaLibraryRepository library,
    required DuaCategory category,
  }) {
    if (!supportedOccasionCategories.contains(category)) {
      throw ArgumentError.value(
        category,
        'category',
        'Only religious occasion categories can use the special-dua state.',
      );
    }

    final records = library.byCategory(category);
    final authenticated = records
        .where(
          (dua) => dua.sourceStatus == DuaSourceStatus.sahihHasanSunnah,
        )
        .toList(growable: false);
    final other = records
        .where(
          (dua) => dua.sourceStatus != DuaSourceStatus.sahihHasanSunnah,
        )
        .toList(growable: false);

    return DuaSpecialOccasionState(
      category: category,
      status: authenticated.isEmpty
          ? DuaSpecialOccasionStatus.noAuthenticatedSpecialDuaInVerifiedLibrary
          : DuaSpecialOccasionStatus.authenticatedSpecialDuaAvailable,
      authenticatedSpecialDuas: List<DuaContent>.unmodifiable(authenticated),
      otherVerifiedDuas: List<DuaContent>.unmodifiable(other),
    );
  }
}
