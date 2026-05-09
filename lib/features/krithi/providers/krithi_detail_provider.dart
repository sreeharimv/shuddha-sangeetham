import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/krithi_detail_repository.dart';

final krithiDetailRepositoryProvider = Provider<KrithiDetailRepository>((ref) {
  return KrithiDetailRepository(ref.watch(databaseProvider));
});

/// Loads the full detail for a single krithi by id.
final krithiDetailProvider =
    FutureProvider.family<KrithiDetail?, int>((ref, id) async {
  return ref.watch(krithiDetailRepositoryProvider).fetchById(id);
});

/// Tracks bookmark state with optimistic toggle, scoped per krithiId.
///
/// Uses a family provider; each krithiId gets its own notifier instance.
final bookmarkNotifierProvider =
    NotifierProvider.family<BookmarkNotifier, AsyncValue<bool>, int>(
  (krithiId) => BookmarkNotifier(krithiId),
);

class BookmarkNotifier extends Notifier<AsyncValue<bool>> {
  BookmarkNotifier(this._krithiId);

  final int _krithiId;

  @override
  AsyncValue<bool> build() {
    _load();
    return const AsyncValue.loading();
  }

  KrithiDetailRepository get _repo =>
      ref.read(krithiDetailRepositoryProvider);

  Future<void> _load() async {
    state = AsyncValue.data(await _repo.isBookmarked(_krithiId));
  }

  Future<void> toggle() async {
    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => false,
    };
    state = AsyncValue.data(!current);
    try {
      if (current) {
        await _repo.removeBookmark(_krithiId);
      } else {
        await _repo.addBookmark(_krithiId);
      }
    } catch (_) {
      state = AsyncValue.data(current);
    }
  }
}
