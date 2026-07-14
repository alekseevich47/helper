import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'adapters/hive_registrar.g.dart';
import 'models/app_settings.dart';
import 'models/call_event.dart';
import 'models/call_record.dart';
import 'models/note.dart';

const settingsBoxKey = 'app';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapters();
  }
}

Future<void> initHive() async {
  registerHiveAdapters();

  await Hive.openBox<CallRecord>('calls');
  await Hive.openBox<CallEvent>('events');
  await Hive.openBox<Note>('notes');
  final settingsBox = await Hive.openBox<AppSettings>('settings');

  if (!settingsBox.containsKey(settingsBoxKey)) {
    await settingsBox.put(settingsBoxKey, AppSettings.defaults());
  }
}

final callsBoxProvider = Provider<Box<CallRecord>>((ref) {
  return Hive.box<CallRecord>('calls');
});

final eventsBoxProvider = Provider<Box<CallEvent>>((ref) {
  return Hive.box<CallEvent>('events');
});

final notesBoxProvider = Provider<Box<Note>>((ref) {
  return Hive.box<Note>('notes');
});

final settingsBoxProvider = Provider<Box<AppSettings>>((ref) {
  return Hive.box<AppSettings>('settings');
});

class SettingsNotifier extends Notifier<AppSettings> {
  Box<AppSettings> get _box => ref.read(settingsBoxProvider);

  @override
  AppSettings build() {
    return _box.get(settingsBoxKey) ?? AppSettings.defaults();
  }

  Future<void> update(AppSettings settings) async {
    await _box.put(settingsBoxKey, settings);
    state = settings;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
