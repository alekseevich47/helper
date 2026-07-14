import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app.dart';
import 'data/local/hive_provider.dart';
import 'domain/services/call_detection_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initHive();
  await CallDetectionService().init();
  runApp(const ProviderScope(child: CallMemoApp()));
}
