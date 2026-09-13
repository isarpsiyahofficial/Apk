enum SensitiveDataKindT0302 {
  userQuestion,
  privateNote,
  dhikrHistory,
  religiousInterest,
  nonSensitiveMachineMetadata,
}

enum EgressChannelT0302 {
  network,
  advertising,
  analytics,
  debugLog,
}

final class EgressPayloadT0302 {
  const EgressPayloadT0302({
    required this.kind,
    required this.value,
  });

  final SensitiveDataKindT0302 kind;
  final String value;
}

abstract interface class EgressSinkT0302 {
  Future<void> send(EgressChannelT0302 channel, String value);
}

/// Central fail-closed boundary for personal/religious-interest data leaving
/// the device. Sensitive payloads are rejected before a sink is invoked.
final class SensitiveDataEgressGuardT0302 {
  const SensitiveDataEgressGuardT0302();

  static const Set<SensitiveDataKindT0302> _blockedKinds = {
    SensitiveDataKindT0302.userQuestion,
    SensitiveDataKindT0302.privateNote,
    SensitiveDataKindT0302.dhikrHistory,
    SensitiveDataKindT0302.religiousInterest,
  };

  Future<void> dispatch({
    required EgressPayloadT0302 payload,
    required EgressChannelT0302 channel,
    required EgressSinkT0302 sink,
  }) async {
    if (_blockedKinds.contains(payload.kind)) {
      throw StateError(
        'Sensitive payload ${payload.kind.name} cannot leave the device via ${channel.name}',
      );
    }
    if (payload.value.isEmpty || payload.value.length > 80) {
      throw ArgumentError.value(
        payload.value,
        'payload.value',
        'machine metadata must be non-empty and bounded',
      );
    }

    await sink.send(channel, payload.value);
  }
}
