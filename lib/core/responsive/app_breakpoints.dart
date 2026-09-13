abstract final class AppBreakpoints {
  static const double compactMax = 599;
  static const double mediumMax = 839;
  static const double expandedMax = 1199;
  static const double contentMaxWidth = 1200;

  static bool isCompact(double width) => width <= compactMax;

  static bool isMedium(double width) =>
      width > compactMax && width <= mediumMax;

  static bool useNavigationRail(double width) => width > mediumMax;

  static double horizontalPadding(double width) {
    if (width <= compactMax) return 20;
    if (width <= mediumMax) return 28;
    if (width <= expandedMax) return 40;
    return 56;
  }
}
