import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

/// Opens the on-device SQLite database via drift.
///
/// Called once in main() before the app starts. The resulting [AppDatabase]
/// instance is injected into the Riverpod provider tree via an override so
/// that all feature repositories can access it through [databaseProvider].
Future<AppDatabase> openAppDatabase() async {
  return AppDatabase(
    driftDatabase(name: 'shuddha_sangeetham'),
  );
}

/// Riverpod provider for the app database.
///
/// Always overridden in main() — the default throw ensures that a missing
/// override is caught immediately at startup rather than silently failing.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider must be overridden in main() via ProviderScope.overrides.',
  ),
);
