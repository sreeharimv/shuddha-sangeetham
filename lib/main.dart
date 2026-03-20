import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openAppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const ShuddhaApp(),
    ),
  );
}
