import 'package:flutter/material.dart';

import '../../../core/constants/phone_brand.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/services/call_recording_setup_service.dart';

/// Блок настройки системной автозаписи звонков (по бренду устройства).
class CallRecordingSetupSection extends StatefulWidget {
  const CallRecordingSetupSection({super.key});

  @override
  State<CallRecordingSetupSection> createState() =>
      _CallRecordingSetupSectionState();
}

class _CallRecordingSetupSectionState extends State<CallRecordingSetupSection> {
  final _service = CallRecordingSetupService.instance;
  CallRecordingDeviceInfo? _info;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await _service.detectDevice();
    if (!mounted) return;
    setState(() {
      _info = info;
      _loading = false;
    });
  }

  Future<void> _openSettings() async {
    setState(() => _busy = true);
    final result = await _service.openAutoRecordSettings();
    if (!mounted) return;
    setState(() => _busy = false);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.opened
              ? l10n.callRecordingOpened
              : l10n.callRecordingOpenFailed,
        ),
      ),
    );
  }

  Future<void> _openPhone() async {
    setState(() => _busy = true);
    final result = await _service.openPhoneApp();
    if (!mounted) return;
    setState(() => _busy = false);
    final l10n = AppLocalizations.of(context)!;
    if (!result.opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.callRecordingOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading || _info == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final family = _info!.family;
    final display = PhoneBrand.displayName(family);
    final mayLack = PhoneBrand.mayLackStockAutoRecord(family);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.callRecordingSetup,
            style: theme.textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.phone_in_talk_outlined),
          title: Text(l10n.detectedBrand),
          subtitle: Text('$display (${_info!.rawBrand})'),
        ),
        if (mayLack)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.callRecordingMayBeUnavailable,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            _service.stepsFor(l10n, family),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: FilledButton.icon(
            onPressed: _busy ? null : _openSettings,
            icon: const Icon(Icons.settings_voice_outlined),
            label: Text(l10n.openCallRecordingSettings),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: OutlinedButton.icon(
            onPressed: _busy ? null : _openPhone,
            icon: const Icon(Icons.dialpad_outlined),
            label: Text(l10n.openPhoneApp),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
