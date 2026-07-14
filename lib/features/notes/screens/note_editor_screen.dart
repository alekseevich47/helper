import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/local/hive_provider.dart';
import '../../../data/local/models/note.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isNew = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _isNew = widget.noteId == 'new';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _loadNote() {
    if (_initialized || _isNew) {
      _initialized = true;
      return;
    }

    final note = ref.read(notesBoxProvider).get(widget.noteId);
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    }
    _initialized = true;
  }

  Future<void> _save() async {
    final box = ref.read(notesBoxProvider);
    final now = DateTime.now();

    if (_isNew) {
      final id = const Uuid().v4();
      await box.put(
        id,
        Note(
          id: id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      final existing = box.get(widget.noteId);
      if (existing == null) return;

      await box.put(
        widget.noteId,
        Note(
          id: existing.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          createdAt: existing.createdAt,
          updatedAt: now,
          linkedCallId: existing.linkedCallId,
        ),
      );
    }

    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    await ref.read(notesBoxProvider).delete(widget.noteId);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _loadNote();

    final existingNote =
        _isNew ? null : ref.watch(notesBoxProvider).get(widget.noteId);

    if (!_isNew && existingNote == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editNote)),
        body: Center(child: Text(l10n.unknown)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.newNote : l10n.editNote),
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: _delete,
            ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: l10n.save,
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.newNote,
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
