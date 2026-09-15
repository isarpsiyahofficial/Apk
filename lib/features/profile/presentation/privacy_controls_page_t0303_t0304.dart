import 'package:flutter/material.dart';
import 'package:islami_hayat/core/privacy/local_personal_data_reset_t0304.dart';
import 'package:islami_hayat/core/privacy/question_history_privacy_t0303.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class PrivacyControlsPageT0303T0304 extends StatefulWidget {
  const PrivacyControlsPageT0303T0304({super.key, this.store});

  final PrivateUserStore? store;

  @override
  State<PrivacyControlsPageT0303T0304> createState() =>
      _PrivacyControlsPageT0303T0304State();
}

class _PrivacyControlsPageT0303T0304State
    extends State<PrivacyControlsPageT0303T0304> {
  late final PrivateUserStore _store;
  late final QuestionHistoryPrivacyT0303 _history;
  late final LocalPersonalDataResetT0304 _reset;

  bool _loading = true;
  bool _historyEnabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? SecurePrivateUserStore();
    _history = QuestionHistoryPrivacyT0303(_store);
    _reset = LocalPersonalDataResetT0304(_store);
    _load();
  }

  Future<void> _load() async {
    final enabled = await _history.isEnabled();
    if (!mounted) return;
    setState(() {
      _historyEnabled = enabled;
      _loading = false;
    });
  }

  Future<void> _setHistoryEnabled(bool enabled) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _history.setEnabled(enabled);
      if (!mounted) return;
      setState(() => _historyEnabled = enabled);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clearHistory() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _history.clearHistory();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).privacyHistoryCleared)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmResetAll() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.privacyResetAllTitle),
            content: Text(l10n.privacyResetAllConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.quranReflectionNoteCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.privacyResetAllAction),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    try {
      await _reset.resetAll();
      if (!mounted) return;
      setState(() => _historyEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.privacyResetAllDone)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(l10n.privacySubtitle, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        value: _historyEnabled,
                        onChanged: _busy ? null : _setHistoryEnabled,
                        title: Text(l10n.privacyQuestionHistoryTitle),
                        subtitle: Text(l10n.privacyQuestionHistoryBody),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        enabled: !_busy,
                        leading: const Icon(Icons.delete_outline),
                        title: Text(l10n.privacyClearHistory),
                        subtitle: Text(l10n.privacyClearHistoryBody),
                        onTap: _busy ? null : _clearHistory,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    enabled: !_busy,
                    minVerticalPadding: 16,
                    leading: const Icon(Icons.restart_alt_outlined),
                    title: Text(l10n.privacyResetAllTitle),
                    subtitle: Text(l10n.privacyResetAllBody),
                    onTap: _busy ? null : _confirmResetAll,
                  ),
                ),
              ],
            ),
    );
  }
}
