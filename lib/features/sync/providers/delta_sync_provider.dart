import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/database_provider.dart';
import '../services/delta_sync_service.dart';

enum SyncStatus { idle, syncing, done, error }

class SyncState {
  const SyncState({
    this.status = SyncStatus.idle,
    this.newCount = 0,
    this.error,
  });

  final SyncStatus status;

  /// Number of records merged in the last successful sync.
  final int newCount;

  /// Non-null when [status] is [SyncStatus.error].
  final String? error;

  bool get isSyncing => status == SyncStatus.syncing;
}

class DeltaSyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState();

  /// Runs a sync cycle. Swallows network-offline errors silently (no snackbar
  /// for those); re-throws everything else so the UI can report it.
  Future<void> sync({bool silent = false}) async {
    if (state.isSyncing) return;
    state = const SyncState(status: SyncStatus.syncing);

    final db = ref.read(databaseProvider);
    final service = DeltaSyncService(db);
    try {
      final result = await service.sync();
      state = SyncState(status: SyncStatus.done, newCount: result.newCount);
    } on SocketException {
      // Device is offline — treat as a no-op so we never interrupt the user.
      state = const SyncState(status: SyncStatus.idle);
    } on Exception catch (e) {
      if (silent) {
        state = const SyncState(status: SyncStatus.idle);
      } else {
        state = SyncState(status: SyncStatus.error, error: e.toString());
      }
    } finally {
      service.dispose();
    }
  }
}

final deltaSyncProvider =
    NotifierProvider<DeltaSyncNotifier, SyncState>(DeltaSyncNotifier.new);
