import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';

const _assetPath = 'assets/db/shuddha_sangeetham.db';
const _dbFileName = 'shuddha_sangeetham.db';

/// Opens the on-device SQLite database.
///
/// On first launch the pre-populated DB is copied from the app bundle into
/// the device's documents directory. Subsequent launches open the copy
/// directly — allowing drift to write bookmarks, sync updates, etc.
Future<AppDatabase> openAppDatabase() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(docsDir.path, _dbFileName));

  if (!dbFile.existsSync()) {
    // First launch — copy bundled DB from assets.
    final data = await rootBundle.load(_assetPath);
    final bytes = data.buffer.asUint8List();
    await dbFile.writeAsBytes(bytes, flush: true);
  }

  return AppDatabase(NativeDatabase(dbFile));
}

/// Riverpod provider for the app database.
///
/// Always overridden in main() — the default throw ensures a missing
/// override is caught immediately at startup rather than silently failing.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider must be overridden in main() via ProviderScope.overrides.',
  ),
);
