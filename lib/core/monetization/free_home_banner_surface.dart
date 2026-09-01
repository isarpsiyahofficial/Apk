import 'package:flutter/material.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

/// A deliberately narrow presentation boundary for the FREE home banner.
///
/// The shell places this surface outside the scrollable Today content, after
/// the complete religious/editorial flow. That keeps an ad from splitting a
/// Quran verse, dua, dhikr, history or other sacred-text block. Concrete ad SDK
/// widgets are injected as [adContent]; this widget never initializes or loads
/// an SDK on its own.
///
/// PRO is fail-closed. If no filled ad widget exists, this surface collapses to
/// zero size so ad no-fill can never block religious content access.
final class FreeHomeBannerSurface extends StatelessWidget {
  const FreeHomeBannerSurface({
    super.key,
    required this.entitlement,
    required this.adContent,
  });

  final EntitlementState entitlement;
  final Widget? adContent;

  bool get canPresent {
    return adContent != null &&
        AdPlacementPolicy.canRequest(
          surface: AppAdSurface.todayHome,
          format: AdFormat.banner,
          isPro: entitlement.isPro,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (!canPresent) return const SizedBox.shrink();

    return DecoratedBox(
      key: const ValueKey('free-home-banner-surface'),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 10),
        child: Align(
          alignment: AlignmentDirectional.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: adContent!,
          ),
        ),
      ),
    );
  }
}
