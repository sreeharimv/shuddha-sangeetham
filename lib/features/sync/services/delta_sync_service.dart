import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/delta_sync_repository.dart';

class DeltaSyncResult {
  const DeltaSyncResult(this.newCount);
  final int newCount;
}

/// Contacts the backend, downloads any krithis updated since the last sync,
/// and merges them into local SQLite. Designed to run silently in background.
///
/// Throws on network or server errors so the caller can surface state.
/// Callers should treat [SocketException] / timeout as "offline" and swallow.
class DeltaSyncService {
  DeltaSyncService(AppDatabase db)
      : _repo = DeltaSyncRepository(db),
        _client = http.Client();

  final DeltaSyncRepository _repo;
  final http.Client _client;

  Future<DeltaSyncResult> sync() async {
    final since = await _repo.latestUpdatedAt();
    final sinceStr =
        since?.toUtc().toIso8601String() ?? '1970-01-01T00:00:00.000Z';

    final uri = Uri.parse('${AppConstants.syncBaseUrl}/api/sync')
        .replace(queryParameters: {'since': sinceStr});

    final response = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Sync API returned HTTP ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final rawList = body['krithis'];
    if (rawList == null) return const DeltaSyncResult(0);

    final krithis = (rawList as List<dynamic>).cast<Map<String, dynamic>>();
    await _repo.upsertKrithis(krithis);

    return DeltaSyncResult(krithis.length);
  }

  void dispose() => _client.close();
}
