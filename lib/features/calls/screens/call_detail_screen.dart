import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/local/hive_provider.dart';
import '../../../data/local/models/call_event.dart';
import '../../../data/local/models/call_record.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class CallDetailScreen extends ConsumerStatefulWidget {
  const CallDetailScreen({super.key, required this.callId});

  final String callId;

  @override
  ConsumerState<CallDetailScreen> createState() => _CallDetailScreenState();
}

class _CallDetailScreenState extends ConsumerState<CallDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  String? _loadedPath;
  bool _playerReady = false;
  bool _playerError = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _ensurePlayerLoaded(String path) {
    if (path == _loadedPath) return;
    _loadedPath = path;
    _playerReady = false;
    _playerError = false;

    final Future<Duration?> load = path.startsWith('content://') ||
            path.startsWith('file://') ||
            path.startsWith('http')
        ? _player.setAudioSource(AudioSource.uri(Uri.parse(path)))
        : _player.setFilePath(path);

    load.then((_) {
      if (mounted) setState(() => _playerReady = true);
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _playerReady = false;
          _playerError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final callsBox = ref.watch(callsBoxProvider);
    final eventsBox = ref.watch(eventsBoxProvider);
    final call = callsBox.get(widget.callId);

    if (call == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.unknown)),
        body: EmptyStateWidget(
          message: l10n.unknown,
          icon: Icons.phone_missed_outlined,
        ),
      );
    }

    final title = call.contactName ?? call.phoneNumber ?? l10n.unknown;
    final audioPath = call.audioFilePath;

    if (audioPath != null) {
      _ensurePlayerLoaded(audioPath);
    }

    final events = eventsBox.values
        .where((event) => event.callId == call.id)
        .toList()
      ..sort((a, b) {
        final aDate = a.eventDateTime;
        final bDate = b.eventDateTime;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.summary),
              Tab(text: l10n.transcription),
              Tab(text: l10n.events),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AudioSection(
              call: call,
              locale: locale,
              l10n: l10n,
              player: _player,
              playerReady: _playerReady,
              playerError: _playerError,
              hasAudioPath: audioPath != null,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _TextTab(
                    text: call.summaryText,
                    emptyMessage: l10n.noSummary,
                    l10n: l10n,
                  ),
                  _TextTab(
                    text: call.transcriptionText,
                    emptyMessage: l10n.noTranscription,
                    l10n: l10n,
                  ),
                  _EventsTab(events: events, l10n: l10n, locale: locale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioSection extends StatelessWidget {
  const _AudioSection({
    required this.call,
    required this.locale,
    required this.l10n,
    required this.player,
    required this.playerReady,
    required this.playerError,
    required this.hasAudioPath,
  });

  final CallRecord call;
  final String locale;
  final AppLocalizations l10n;
  final AudioPlayer player;
  final bool playerReady;
  final bool playerError;
  final bool hasAudioPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle =
        '${formatDateTime(call.dateTime, locale: locale)}'
        ' · ${formatDuration(call.durationSeconds)}';

    if (!hasAudioPath || playerError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              l10n.audioNotFound,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              final processingState = snapshot.data?.processingState;

              return Row(
                children: [
                  IconButton.filled(
                    onPressed: playerReady && processingState != ProcessingState.loading
                        ? () {
                            if (playing) {
                              player.pause();
                            } else {
                              player.play();
                            }
                          }
                        : null,
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    tooltip: playing ? l10n.pause : l10n.play,
                  ),
                  Expanded(
                    child: StreamBuilder<Duration?>(
                      stream: player.durationStream,
                      builder: (context, durationSnapshot) {
                        final duration = durationSnapshot.data ?? Duration.zero;

                        return StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, positionSnapshot) {
                            final position = positionSnapshot.data ?? Duration.zero;
                            final maxMs = duration.inMilliseconds;
                            final value = maxMs > 0
                                ? position.inMilliseconds
                                    .clamp(0, maxMs)
                                    .toDouble()
                                : 0.0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Slider(
                                  value: value,
                                  max: maxMs > 0 ? maxMs.toDouble() : 1,
                                  onChanged: playerReady && maxMs > 0
                                      ? (ms) => player.seek(
                                            Duration(milliseconds: ms.round()),
                                          )
                                      : null,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDuration(position),
                                      style: theme.textTheme.labelSmall,
                                    ),
                                    Text(
                                      formatDuration(duration),
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TextTab extends StatelessWidget {
  const _TextTab({
    required this.text,
    required this.emptyMessage,
    required this.l10n,
  });

  final String? text;
  final String emptyMessage;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Tooltip(
              message: l10n.comingSoon,
              child: FilledButton.tonalIcon(
                onPressed: null,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ),
          ),
        ),
        Expanded(
          child: text != null && text!.isNotEmpty
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(text!),
                )
              : EmptyStateWidget(
                  message: emptyMessage,
                  icon: Icons.description_outlined,
                ),
        ),
      ],
    );
  }
}

class _EventsTab extends StatelessWidget {
  const _EventsTab({
    required this.events,
    required this.l10n,
    required this.locale,
  });

  final List<CallEvent> events;
  final AppLocalizations l10n;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Tooltip(
              message: l10n.comingSoon,
              child: FilledButton.tonalIcon(
                onPressed: null,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ),
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? EmptyStateWidget(
                  message: l10n.noEvents,
                  icon: Icons.event_outlined,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final subtitle = event.eventDateTime != null
                        ? formatDateTime(event.eventDateTime!, locale: locale)
                        : null;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(event.title),
                      subtitle: subtitle != null
                          ? Text(subtitle)
                          : event.description != null
                              ? Text(event.description!)
                              : null,
                      leading: Icon(_eventIcon(event.type)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  IconData _eventIcon(String type) {
    return switch (type) {
      'reminder' => Icons.notifications_outlined,
      'meeting' => Icons.groups_outlined,
      'birthday' => Icons.cake_outlined,
      'task' => Icons.task_alt_outlined,
      _ => Icons.event_note_outlined,
    };
  }
}
