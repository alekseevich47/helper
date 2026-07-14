import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/local/hive_provider.dart';
import '../widgets/call_recording_setup_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          const CallRecordingSetupSection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.theme,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioGroup<String>(
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                notifier.update(settings.copyWith(themeMode: value));
              }
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l10n.systemTheme),
                  value: 'system',
                ),
                RadioListTile<String>(
                  title: Text(l10n.lightTheme),
                  value: 'light',
                ),
                RadioListTile<String>(
                  title: Text(l10n.darkTheme),
                  value: 'dark',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioGroup<String>(
            groupValue: settings.language,
            onChanged: (value) {
              if (value != null) {
                notifier.update(settings.copyWith(language: value));
              }
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Русский'),
                  value: 'ru',
                ),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: Text(l10n.autoTranscribe),
            subtitle: Text(l10n.comingSoon),
            value: settings.autoTranscribe,
            onChanged: null,
          ),
          SwitchListTile(
            title: Text(l10n.notifyBeforeTranscribe),
            subtitle: Text(l10n.comingSoon),
            value: settings.notifyBeforeTranscribe,
            onChanged: null,
          ),
          ListTile(
            title: const Text('Whisper'),
            subtitle: Text(l10n.comingSoon),
            trailing: Text(settings.whisperModel),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
