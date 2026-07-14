import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/local/hive_provider.dart';
import '../../../data/local/models/call_event.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final box = ref.watch(eventsBoxProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabCalendar)),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<CallEvent> eventsBox, _) {
          final allEvents = eventsBox.values
              .where((event) => event.eventDateTime != null)
              .toList();

          List<CallEvent> eventsForDay(DateTime day) {
            return allEvents
                .where((event) => isSameDay(event.eventDateTime, day))
                .toList()
              ..sort(
                (a, b) => a.eventDateTime!.compareTo(b.eventDateTime!),
              );
          }

          final selectedDayEvents = eventsForDay(_selectedDay);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TableCalendar<CallEvent>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                locale: locale,
                eventLoader: eventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: theme.colorScheme.onPrimary,
                  ),
                  markerDecoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  formatDate(_selectedDay, locale: locale),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: selectedDayEvents.isEmpty
                    ? EmptyStateWidget(
                        message: l10n.noEvents,
                        icon: Icons.event_outlined,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedDayEvents.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final event = selectedDayEvents[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(_eventIcon(event.type)),
                            title: Text(event.title),
                            subtitle: _eventSubtitle(event, locale),
                            trailing: event.isCompleted
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget? _eventSubtitle(CallEvent event, String locale) {
    final parts = <String>[];
    if (event.eventDateTime != null) {
      parts.add(formatDateTime(event.eventDateTime!, locale: locale));
    }
    if (event.description != null && event.description!.isNotEmpty) {
      parts.add(event.description!);
    }
    if (parts.isEmpty) return null;
    return Text(parts.join('\n'));
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
