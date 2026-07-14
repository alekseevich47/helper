import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/local/hive_provider.dart';
import '../../../data/local/models/call_record.dart';
import '../../../domain/services/call_detection_service.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/call_list_tile.dart';

class CallsListScreen extends ConsumerWidget {
  const CallsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final box = ref.watch(callsBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabCalls),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<CallRecord> callsBox, _) {
          final calls = callsBox.values.toList()
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          return RefreshIndicator(
            onRefresh: () async {
              // Box is live via listenable; brief await for indicator UX.
              await Future<void>.delayed(Duration.zero);
            },
            child: calls.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.6,
                        child: EmptyStateWidget(
                          message: l10n.noCalls,
                          icon: Icons.phone_outlined,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: calls.length,
                    itemBuilder: (context, index) {
                      return CallListTile(call: calls[index]);
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDebugDialog(context, ref),
        tooltip: l10n.addFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDebugDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.addFile),
          content: const Text('Выбор файла позже'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (!context.mounted) return;
                final messenger = ScaffoldMessenger.of(context);
                final record =
                    await CallDetectionService.instance.scanForNewRecording();
                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      record != null ? l10n.scanFound : l10n.scanNotFound,
                    ),
                  ),
                );
              },
              child: Text(l10n.scanRecordings),
            ),
            FilledButton(
              onPressed: () async {
                final box = ref.read(callsBoxProvider);
                final id = const Uuid().v4();
                await box.put(
                  id,
                  CallRecord(
                    id: id,
                    dateTime: DateTime.now(),
                    durationSeconds: 0,
                    status: 'new',
                  ),
                );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Добавить тестовый звонок'),
            ),
          ],
        );
      },
    );
  }
}
