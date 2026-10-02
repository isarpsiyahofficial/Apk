enum PrivacyEgressChannelT0300 {
  firstPartyAnalytics,
  marketingAnalytics,
  remoteCrashReporting,
}

/// Release policy for optional telemetry integrations.
///
/// V1 has no first-party analytics backend and does not ship Firebase
/// Analytics or marketing SDKs. Android Vitals remains the default crash
/// observation surface. If a remote crash reporter is ever introduced, it
/// must pass the T0301 text-redaction boundary before any event can leave the
/// device.
final class TelemetryPolicyT0300 {
  const TelemetryPolicyT0300._();

  static bool isEnabled(PrivacyEgressChannelT0300 channel) => switch (channel) {
        PrivacyEgressChannelT0300.firstPartyAnalytics => false,
        PrivacyEgressChannelT0300.marketingAnalytics => false,
        PrivacyEgressChannelT0300.remoteCrashReporting => false,
      };

  static void requireDisabled(PrivacyEgressChannelT0300 channel) {
    if (isEnabled(channel)) {
      throw StateError('Telemetry channel must remain disabled in V1: $channel');
    }
  }

  static const Set<String> forbiddenFlutterPackages = <String>{
    'firebase_analytics',
    'appsflyer_sdk',
    'adjust_sdk',
    'facebook_app_events',
    'mixpanel_flutter',
    'amplitude_flutter',
  };
}
