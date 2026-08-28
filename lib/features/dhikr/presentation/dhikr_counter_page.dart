import 'package:flutter/material.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_counter_repository.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_feedback.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class DhikrCounterPage extends StatefulWidget {
  const DhikrCounterPage({
    super.key,
    this.repository,
    this.feedbackPlayer = const SystemDhikrFeedbackPlayer(),
  });

  final DhikrCounterRepository? repository;
  final DhikrFeedbackPlayer feedbackPlayer;

  @override
  State<DhikrCounterPage> createState() => _DhikrCounterPageState();
}

class _DhikrCounterPageState extends State<DhikrCounterPage> {
  late final DhikrCounterRepository _repository;
  late Future<DhikrCounterState> _stateFuture;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ??
        DhikrCounterRepository(SecurePrivateUserStore());
    _stateFuture = _repository.load();
  }

  String _text(BuildContext context, String tr, String en, String ar) {
    final language = Localizations.localeOf(context).languageCode;
    return switch (language) {
      'ar' => ar,
      'en' => en,
      _ => tr,
    };
  }

  Future<void> _increment(DhikrCounterState state) async {
    if (_busy) return;
    _busy = true;
    try {
      final next = await _repository.increment(state);
      await _playEnabledFeedback(next);
      if (!mounted) return;
      setState(() {
        _stateFuture = Future.value(next);
      });
    } finally {
      _busy = false;
    }
  }

  Future<void> _playEnabledFeedback(DhikrCounterState state) async {
    if (state.vibrationEnabled) {
      try {
        await widget.feedbackPlayer.vibrate();
      } on Exception {
        // Feedback failure must never block or undo a saved dhikr count.
      }
    }
    if (state.soundEnabled) {
      try {
        await widget.feedbackPlayer.playSound();
      } on Exception {
        // Feedback failure must never block or undo a saved dhikr count.
      }
    }
  }

  Future<void> _setFeedback(
    DhikrCounterState state, {
    bool? vibrationEnabled,
    bool? soundEnabled,
  }) async {
    if (_busy) return;
    _busy = true;
    try {
      final next = await _repository.setFeedbackPreferences(
        state,
        vibrationEnabled: vibrationEnabled,
        soundEnabled: soundEnabled,
      );
      if (!mounted) return;
      setState(() {
        _stateFuture = Future.value(next);
      });
    } finally {
      _busy = false;
    }
  }

  Future<void> _reset() async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _text(
            context,
            'Sayacı sıfırla?',
            'Reset counter?',
            'إعادة ضبط العداد؟',
          ),
        ),
        content: Text(
          _text(
            context,
            'Bu işlem yalnız kişisel sayaç değerini sıfırlar.',
            'This only resets your personal counter value.',
            'يؤدي هذا فقط إلى تصفير قيمة عدادك الشخصي.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_text(context, 'Vazgeç', 'Cancel', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_text(context, 'Sıfırla', 'Reset', 'تصفير')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    _busy = true;
    try {
      final next = await _repository.reset();
      if (!mounted) return;
      setState(() {
        _stateFuture = Future.value(next);
      });
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder<DhikrCounterState>(
      future: _stateFuture,
      builder: (context, snapshot) {
        final state = snapshot.data ?? const DhikrCounterState(count: 0);
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text(l10n.dhikrTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(l10n.dhikrSubtitle, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text(
              _text(
                context,
                'Kişisel Sayaç',
                'Personal Counter',
                'العداد الشخصي',
              ),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              _text(
                context,
                'Bu sayaç bir sünnet sayısı iddiası değildir. Yalnız kendi takibin için kullanılır.',
                'This counter does not claim a Sunnah-prescribed number. It is only for your personal tracking.',
                'هذا العداد لا يدّعي عددًا مسنونًا، وإنما هو لمتابعتك الشخصية فقط.',
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Semantics(
              button: true,
              label: _text(
                context,
                'Zikri bir artır',
                'Increase dhikr count by one',
                'زيادة عداد الذكر واحدًا',
              ),
              value: '${state.count}',
              child: Material(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(28),
                child: InkWell(
                  key: const ValueKey('dhikr-counter-tap-area'),
                  onTap: snapshot.hasData ? () => _increment(state) : null,
                  borderRadius: BorderRadius.circular(28),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 240),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${state.count}',
                              key: const ValueKey('dhikr-counter-value'),
                              style: theme.textTheme.displayLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _text(
                                context,
                                'Dokun ve artır',
                                'Tap to count',
                                'المس لزيادة العدد',
                              ),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _text(context, 'Geri bildirim', 'Feedback', 'التنبيه عند العد'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _text(
                context,
                'Titreşim ve ses isteğe bağlıdır ve yalnız bu cihazda saklanır.',
                'Vibration and sound are optional and stored only on this device.',
                'الاهتزاز والصوت اختياريان وتُحفظ تفضيلاتهما على هذا الجهاز فقط.',
              ),
              style: theme.textTheme.bodySmall,
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('dhikr-vibration-toggle'),
              contentPadding: EdgeInsets.zero,
              value: state.vibrationEnabled,
              onChanged: snapshot.hasData
                  ? (value) => _setFeedback(
                        state,
                        vibrationEnabled: value,
                      )
                  : null,
              title: Text(_text(context, 'Titreşim', 'Vibration', 'الاهتزاز')),
            ),
            SwitchListTile.adaptive(
              key: const ValueKey('dhikr-sound-toggle'),
              contentPadding: EdgeInsets.zero,
              value: state.soundEnabled,
              onChanged: snapshot.hasData
                  ? (value) => _setFeedback(state, soundEnabled: value)
                  : null,
              title: Text(_text(context, 'Ses', 'Sound', 'الصوت')),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: snapshot.hasData ? _reset : null,
                icon: const Icon(Icons.restart_alt),
                label: Text(
                  _text(
                    context,
                    'Sayacı sıfırla',
                    'Reset counter',
                    'تصفير العداد',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
