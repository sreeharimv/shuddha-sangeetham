import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/search_repository.dart';
import 'database_provider.dart';

/// Provides the [SearchRepository] scoped to the app database.
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SearchRepository(db);
});
