import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/local/hive_provider.dart';
import '../../../data/local/models/note.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final box = ref.watch(notesBoxProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabNotes)),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Note> notesBox, _) {
          final notes = notesBox.values.toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          if (notes.isEmpty) {
            return EmptyStateWidget(
              message: l10n.noNotes,
              icon: Icons.notes_outlined,
            );
          }

          return ListView.separated(
            itemCount: notes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final note = notes[index];
              final title = note.title.isNotEmpty ? note.title : l10n.newNote;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    title.characters.first.toUpperCase(),
                  ),
                ),
                title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  formatDateTime(note.updatedAt, locale: locale),
                ),
                onTap: () => context.push('/notes/${note.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notes/new'),
        tooltip: l10n.newNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
