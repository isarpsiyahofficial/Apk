import 'package:flutter/material.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

enum StartupAccessState { checking, allowed, offlineBlocked }

final class StartupAccessCopy {
  const StartupAccessCopy({
    required this.checkingTitle,
    required this.checkingBody,
    required this.offlineTitle,
    required this.offlineBody,
    required this.retry,
  });

  final String checkingTitle;
  final String checkingBody;
  final String offlineTitle;
  final String offlineBody;
  final String retry;

  static StartupAccessCopy resolve(Locale locale) {
    return switch (locale.languageCode) {
      'en' => const StartupAccessCopy(
          checkingTitle: 'Checking internet connection',
          checkingBody: 'Free access requires a verified internet connection.',
          offlineTitle: 'Internet connection required',
          offlineBody:
              'Free mode needs internet access. Connect to the internet and try again.',
          retry: 'Try again',
        ),
      'ar' => const StartupAccessCopy(
          checkingTitle: 'جارٍ التحقق من الاتصال بالإنترنت',
          checkingBody: 'يتطلب الاستخدام المجاني اتصالًا موثوقًا بالإنترنت.',
          offlineTitle: 'يلزم الاتصال بالإنترنت',
          offlineBody:
              'يتطلب الوضع المجاني اتصالًا بالإنترنت. اتصل بالإنترنت ثم أعد المحاولة.',
          retry: 'إعادة المحاولة',
        ),
      _ => const StartupAccessCopy(
          checkingTitle: 'İnternet bağlantısı kontrol ediliyor',
          checkingBody:
              'Ücretsiz kullanım için doğrulanmış internet bağlantısı gerekir.',
          offlineTitle: 'İnternet bağlantısı gerekli',
          offlineBody:
              'Ücretsiz mod internet erişimi gerektirir. İnternete bağlanıp tekrar deneyin.',
          retry: 'Tekrar dene',
        ),
    };
  }
}

class StartupAccessGate extends StatefulWidget {
  const StartupAccessGate({
    required this.entitlement,
    required this.verifier,
    required this.child,
    super.key,
  });

  final EntitlementState entitlement;
  final InternetReachabilityVerifier verifier;
  final Widget child;

  @override
  State<StartupAccessGate> createState() => _StartupAccessGateState();
}

class _StartupAccessGateState extends State<StartupAccessGate> {
  StartupAccessState _state = StartupAccessState.checking;
  int _evaluationToken = 0;

  @override
  void initState() {
    super.initState();
    _evaluate();
  }

  @override
  void didUpdateWidget(covariant StartupAccessGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entitlement.tier != widget.entitlement.tier ||
        oldWidget.verifier != widget.verifier) {
      _evaluate();
    }
  }

  Future<void> _evaluate() async {
    final token = ++_evaluationToken;

    if (widget.entitlement.isPro) {
      if (mounted) {
        setState(() => _state = StartupAccessState.allowed);
      }
      return;
    }

    if (mounted) {
      setState(() => _state = StartupAccessState.checking);
    }

    final reachability = await widget.verifier.verify();
    if (!mounted || token != _evaluationToken) return;

    setState(() {
      _state = reachability == InternetReachability.reachable
          ? StartupAccessState.allowed
          : StartupAccessState.offlineBlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == StartupAccessState.allowed) {
      return widget.child;
    }

    final copy = StartupAccessCopy.resolve(Localizations.localeOf(context));
    final checking = _state == StartupAccessState.checking;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = (constraints.maxHeight - 64)
                .clamp(0.0, double.infinity)
                .toDouble();
            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (checking)
                          const SizedBox.square(
                            dimension: 36,
                            child: CircularProgressIndicator(),
                          )
                        else
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 44,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        const SizedBox(height: 24),
                        Text(
                          checking ? copy.checkingTitle : copy.offlineTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          checking ? copy.checkingBody : copy.offlineBody,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (!checking) ...[
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _evaluate,
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(copy.retry),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
