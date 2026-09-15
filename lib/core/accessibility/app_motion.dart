import 'package:flutter/material.dart';

/// Central accessibility motion policy.
///
/// Device reduced-motion preference is exposed by Flutter through
/// [MediaQueryData.disableAnimations]. Product transitions must use this
/// policy instead of inventing a second preference or ignoring the platform
/// accessibility setting.
abstract final class AppMotion {
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  static Duration effectiveDuration(
    BuildContext context, {
    required Duration normal,
  }) => reduceMotion(context) ? Duration.zero : normal;
}

/// Material route transition that keeps the normal product transition when
/// motion is allowed, but renders the destination directly when the platform
/// asks for reduced motion.
///
/// Returning [child] removes scale/fade/spatial movement without changing the
/// navigation result, focus order, semantics tree or back-stack behavior.
final class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  static const PageTransitionsBuilder _normal = ZoomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduceMotion(context)) return child;
    return _normal.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
