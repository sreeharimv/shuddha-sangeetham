import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers/text_size_provider.dart';
import 'core/providers/theme_provider.dart';
import 'data/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openAppDatabase();

  final container = ProviderContainer(
    overrides: [databaseProvider.overrideWithValue(database)],
  );

  // Load persisted preferences before the first frame.
  await Future.wait([
    container.read(themeModeProvider.notifier).loadFromPrefs(),
    container.read(textSizeProvider.notifier).loadFromPrefs(),
  ]);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ShuddhaApp(),
    ),
  );
}
