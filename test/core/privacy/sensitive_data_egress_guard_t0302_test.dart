import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/privacy/sensitive_data_egress_guard_t0302.dart';

final class _RecordingSink implements EgressSinkT0302 {
  int calls = 0;
  final List<EgressChannelT0302> channels = [];
  final List<String> values = [];

  @override
  Future<void> send(EgressChannelT0302 channel, String value) async {
    calls += 1;
    channels.add(channel);
    values.add(value);
  }
}

void main() {
  const guard = SensitiveDataEgressGuardT0302();

  for (final kind in const [
    SensitiveDataKindT0302.userQuestion,
    SensitiveDataKindT0302.privateNote,
    SensitiveDataKindT0302.dhikrHistory,
    SensitiveDataKindT0302.religiousInterest,
  ]) {
    for (final channel in EgressChannelT0302.values) {
      test('T0302 blocks ${kind.name} before ${channel.name} sink invocation', () async {
        final sink = _RecordingSink();

        await expectLater(
          guard.dispatch(
            payload: EgressPayloadT0302(
              kind: kind,
              value: 'sensitive-user-content',
            ),
            channel: channel,
            sink: sink,
          ),
          throwsStateError,
        );

        expect(sink.calls, 0);
        expect(sink.values, isEmpty);
      });
    }
  }

  test('T0302 allows bounded non-sensitive machine metadata', () async {
    final sink = _RecordingSink();

    await guard.dispatch(
      payload: const EgressPayloadT0302(
        kind: SensitiveDataKindT0302.nonSensitiveMachineMetadata,
        value: 'build:verification',
      ),
      channel: EgressChannelT0302.debugLog,
      sink: sink,
    );

    expect(sink.calls, 1);
    expect(sink.channels, [EgressChannelT0302.debugLog]);
    expect(sink.values, ['build:verification']);
  });

  test('T0302 rejects oversized metadata before sink invocation', () async {
    final sink = _RecordingSink();

    await expectLater(
      guard.dispatch(
        payload: EgressPayloadT0302(
          kind: SensitiveDataKindT0302.nonSensitiveMachineMetadata,
          value: List.filled(81, 'x').join(),
        ),
        channel: EgressChannelT0302.network,
        sink: sink,
      ),
      throwsArgumentError,
    );

    expect(sink.calls, 0);
  });
}
