import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/phone_brand.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/local/hive_provider.dart';
import '../../data/local/models/app_settings.dart';
import '../../data/local/models/call_record.dart';

const _notificationChannelId = 'new_call';
const _notificationChannelName = 'Новый звонок';
const _scanWindow = Duration(minutes: 5);
const _postCallDelay = Duration(seconds: 3);
const _audioExtensions = {
  '.mp3',
  '.m4a',
  '.wav',
  '.amr',
  '.aac',
  '.3gp',
  '.ogg',
  '.opus',
};
const _mediaStoreChannel = MethodChannel('com.urban.callmemo/mediastore');

/// Детекция окончания звонка → поиск файла автозаписи → запись в Hive.
class CallDetectionService {
  CallDetectionService._();
  static final CallDetectionService instance = CallDetectionService._();
  factory CallDetectionService() => instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<PhoneState>? _phoneSub;
  String _brand = '';
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    await _initNotifications();
    await _requestPermissions();

    final android = await DeviceInfoPlugin().androidInfo;
    _brand = android.brand.toLowerCase();
    debugPrint('CallDetectionService: brand=$_brand');

    _phoneSub = PhoneState.stream.listen((state) {
      debugPrint('CallDetectionService: phone state=${state.status}');
      if (state.status == PhoneStateStatus.CALL_ENDED) {
        unawaited(
          _onCallEnded(
            phoneNumber: state.number,
            duration: state.duration,
          ),
        );
      }
    });
  }

  /// Ручной скан (FAB), если stream недоступен.
  Future<CallRecord?> scanForNewRecording({String? phoneNumber}) =>
      _scanForNewRecording(phoneNumber: phoneNumber);

  Future<void> dispose() async {
    await _phoneSub?.cancel();
    _phoneSub = null;
    _initialized = false;
  }

  Future<void> _onCallEnded({
    String? phoneNumber,
    Duration? duration,
  }) async {
    await Future<void>.delayed(_postCallDelay);
    await _scanForNewRecording(
      phoneNumber: phoneNumber,
      durationSeconds: duration?.inSeconds ?? 0,
    );
  }

  Future<CallRecord?> _scanForNewRecording({
    String? phoneNumber,
    int durationSeconds = 0,
  }) async {
    if (!Hive.isBoxOpen('calls')) return null;

    final found = await _findNewestRecording();
    if (found == null) {
      debugPrint('CallDetectionService: no recording found');
      return null;
    }

    final path = found.path;
    final box = Hive.box<CallRecord>('calls');
    final alreadyExists = box.values.any((c) => c.audioFilePath == path);
    if (alreadyExists) {
      debugPrint('CallDetectionService: already in Hive: $path');
      return null;
    }

    final id = const Uuid().v4();
    final record = CallRecord(
      id: id,
      phoneNumber: phoneNumber,
      dateTime: found.modified,
      durationSeconds:
          durationSeconds > 0 ? durationSeconds : found.durationSeconds,
      audioFilePath: path,
      status: 'new',
    );
    await box.put(id, record);
    await _showNewCallNotification();
    debugPrint('CallDetectionService: saved $id → $path');
    return record;
  }

  Future<_FoundAudio?> _findNewestRecording() async {
    final fromFs = await _findNewestOnFilesystem();
    if (fromFs != null) return fromFs;
    return _findNewestViaMediaStore();
  }

  Future<_FoundAudio?> _findNewestOnFilesystem() async {
    final roots = await _storageRoots();
    final candidates = <File>[];

    for (final root in roots) {
      for (final rel in _pathsForBrand(_brand)) {
        final dir = Directory('$root${Platform.pathSeparator}$rel');
        candidates.addAll(await _listRecentAudio(dir));
      }
    }

    if (candidates.isEmpty) {
      for (final root in roots) {
        for (final rel in BrandPaths.fallbackScan) {
          final dir = Directory('$root${Platform.pathSeparator}$rel');
          candidates.addAll(await _listRecentAudio(dir));
        }
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort(
      (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );
    final file = candidates.first;
    return _FoundAudio(
      path: file.path,
      modified: await file.lastModified(),
    );
  }

  Future<_FoundAudio?> _findNewestViaMediaStore() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    try {
      final raw = await _mediaStoreChannel.invokeMethod<List<dynamic>>(
        'recentAudio',
        {'windowSeconds': _scanWindow.inSeconds},
      );
      if (raw == null || raw.isEmpty) return null;

      final items = raw
          .cast<Map<dynamic, dynamic>>()
          .map(_MediaStoreItem.fromMap)
          .where((e) => e.playablePath != null)
          .toList()
        ..sort((a, b) => b.modifiedMs.compareTo(a.modifiedMs));

      if (items.isEmpty) return null;
      final best = items.first;
      return _FoundAudio(
        path: best.playablePath!,
        modified: DateTime.fromMillisecondsSinceEpoch(best.modifiedMs),
        durationSeconds: best.durationSeconds,
      );
    } on PlatformException catch (e) {
      debugPrint('CallDetectionService: MediaStore error $e');
      return null;
    }
  }

  Future<List<File>> _listRecentAudio(Directory dir) async {
    if (!await dir.exists()) return const [];

    final cutoff = DateTime.now().subtract(_scanWindow);
    final result = <File>[];

    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        final lower = entity.path.toLowerCase();
        final hasExt = _audioExtensions.any(lower.endsWith);
        if (!hasExt) continue;
        final modified = await entity.lastModified();
        if (modified.isBefore(cutoff)) continue;
        result.add(entity);
      }
    } on FileSystemException {
      return const [];
    }

    return result;
  }

  Future<List<String>> _storageRoots() async {
    final roots = <String>{'/storage/emulated/0'};

    try {
      final ext = await getExternalStorageDirectory();
      if (ext != null) {
        var current = ext;
        for (var i = 0; i < 4; i++) {
          current = current.parent;
          if (current.path.endsWith('0') ||
              current.path.contains('emulated')) {
            roots.add(current.path);
            break;
          }
        }
      }
    } catch (_) {}

    return roots.toList();
  }

  List<String> _pathsForBrand(String brand) {
    return switch (PhoneBrand.detect(brand)) {
      PhoneBrandFamily.samsung => [BrandPaths.samsung],
      PhoneBrandFamily.xiaomi => [BrandPaths.xiaomi],
      PhoneBrandFamily.oppo || PhoneBrandFamily.vivo => [BrandPaths.oppo],
      PhoneBrandFamily.tecno => BrandPaths.tecno,
      _ => BrandPaths.fallbackScan,
    };
  }

  Future<void> _requestPermissions() async {
    final statuses = await [
      Permission.phone,
      Permission.audio,
      Permission.notification,
      Permission.storage,
    ].request();

    for (final entry in statuses.entries) {
      if (entry.value.isDenied || entry.value.isPermanentlyDenied) {
        debugPrint(
          'CallDetectionService: permission ${entry.key} → ${entry.value}',
        );
      }
    }
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: androidInit),
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _notificationChannelId,
        _notificationChannelName,
        description: 'Уведомления о новых записях звонков',
        importance: Importance.defaultImportance,
      ),
    );
  }

  Future<void> _showNewCallNotification() async {
    final language = _settingsLanguage();
    final l10n = lookupAppLocalizations(Locale(language));

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      l10n.appTitle,
      l10n.newCallRecorded,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notificationChannelId,
          _notificationChannelName,
          channelDescription: 'Уведомления о новых записях звонков',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }

  String _settingsLanguage() {
    try {
      final box = Hive.box<AppSettings>('settings');
      return box.get(settingsBoxKey)?.language ?? 'ru';
    } catch (_) {
      return 'ru';
    }
  }
}

class _FoundAudio {
  const _FoundAudio({
    required this.path,
    required this.modified,
    this.durationSeconds = 0,
  });

  final String path;
  final DateTime modified;
  final int durationSeconds;
}

class _MediaStoreItem {
  const _MediaStoreItem({
    required this.playablePath,
    required this.modifiedMs,
    required this.durationSeconds,
  });

  final String? playablePath;
  final int modifiedMs;
  final int durationSeconds;

  factory _MediaStoreItem.fromMap(Map<dynamic, dynamic> map) {
    final filePath = map['path'] as String?;
    final uri = map['uri'] as String?;
    final modifiedMs = (map['modifiedMs'] as num?)?.toInt() ?? 0;
    final durationMs = (map['durationMs'] as num?)?.toInt() ?? 0;
    final playable = (filePath != null && filePath.isNotEmpty)
        ? filePath
        : uri;

    return _MediaStoreItem(
      playablePath: playable,
      modifiedMs: modifiedMs,
      durationSeconds: durationMs > 0 ? (durationMs / 1000).round() : 0,
    );
  }
}
