import 'dart:io';

import 'package:call_memo/app.dart';
import 'package:call_memo/data/local/hive_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('callmemo_test_');
    Hive.init(tempDir.path);
    await initHive();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('CallMemoApp shows bottom navigation', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CallMemoApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Звонки'), findsWidgets);
  });
}
