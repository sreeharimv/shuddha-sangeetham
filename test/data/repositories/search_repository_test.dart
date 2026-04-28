import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shuddha_sangeetham/data/database/app_database.dart';
import 'package:shuddha_sangeetham/data/database/tables/composers.dart';
import 'package:shuddha_sangeetham/data/database/tables/krithis.dart';
import 'package:shuddha_sangeetham/data/database/tables/ragas.dart';
import 'package:shuddha_sangeetham/data/database/tables/search_aliases.dart';
import 'package:shuddha_sangeetham/data/database/tables/talas.dart';
import 'package:shuddha_sangeetham/data/repositories/search_repository.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

AppDatabase _makeInMemoryDb() {
  return AppDatabase(NativeDatabase.memory());
}

/// Inserts a minimal set of fixture data and returns ids.
Future<_Fixtures> _insertFixtures(AppDatabase db) async {
  final composerId = await db.into(db.composers).insert(
        ComposersCompanion.insert(name: 'Tyagaraja'),
      );
  final ragaId = await db.into(db.ragas).insert(
        RagasCompanion.insert(name: 'Abheri'),
      );
  final talaId = await db.into(db.talas).insert(
        TalasCompanion.insert(name: 'Adi'),
      );

  final krithiId = await db.into(db.krithis).insert(
        KrithisCompanion.insert(
          name: 'Nagumomu Ganaleni',
          composerId: composerId,
          ragaId: ragaId,
          talaId: talaId,
          language: 'telugu',
          compositionType: 'krithi',
          pallavi: 'nagumomu ganalEni nA bhAgyamE',
          anupallavi: Value('manasA nI pada yugamuna'),
          searchTokens: const Value('nagumomu ganaleni'),
        ),
      );

  // Second krithi for filter tests
  final composerId2 = await db.into(db.composers).insert(
        ComposersCompanion.insert(name: 'Muttuswami Dikshitar'),
      );
  final ragaId2 = await db.into(db.ragas).insert(
        RagasCompanion.insert(name: 'Kalyani'),
      );
  await db.into(db.krithis).insert(
        KrithisCompanion.insert(
          name: 'Sri Kamalambikayai',
          composerId: composerId2,
          ragaId: ragaId2,
          talaId: talaId,
          language: 'sanskrit',
          compositionType: 'krithi',
          pallavi: 'sri kamalambikayai namaste',
          searchTokens: const Value('sri kamalambikayai'),
        ),
      );

  return _Fixtures(
    composerId: composerId,
    composerId2: composerId2,
    ragaId: ragaId,
    ragaId2: ragaId2,
    talaId: talaId,
    krithiId: krithiId,
  );
}

class _Fixtures {
  _Fixtures({
    required this.composerId,
    required this.composerId2,
    required this.ragaId,
    required this.ragaId2,
    required this.talaId,
    required this.krithiId,
  });

  final int composerId;
  final int composerId2;
  final int ragaId;
  final int ragaId2;
  final int talaId;
  final int krithiId;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late AppDatabase db;
  late SearchRepository repo;
  late _Fixtures fix;

  setUp(() async {
    db = _makeInMemoryDb();
    repo = SearchRepository(db);
    fix = await _insertFixtures(db);
  });

  tearDown(() async {
    await db.close();
  });

  // ---- quickSearch --------------------------------------------------------

  group('quickSearch', () {
    test('returns empty list for empty query', () async {
      final results = await repo.quickSearch('');
      expect(results, isEmpty);
    });

    test('finds krithi by partial name match', () async {
      final results = await repo.quickSearch('nagumomu');
      expect(results, isNotEmpty);
      expect(results.first.name, equals('Nagumomu Ganaleni'));
    });

    test('finds krithi by FTS search_tokens', () async {
      final results = await repo.quickSearch('ganaleni');
      expect(results, isNotEmpty);
      expect(results.first.name, equals('Nagumomu Ganaleni'));
    });

    test('result card fields are populated', () async {
      final results = await repo.quickSearch('nagumomu');
      final r = results.first;
      expect(r.ragaName, equals('Abheri'));
      expect(r.composerName, equals('Tyagaraja'));
      expect(r.talaName, equals('Adi'));
      expect(r.language, equals('telugu'));
    });

    test('alias-resolved raga search returns matching krithi', () async {
      // Seed an alias manually for this test
      await db.into(db.searchAliases).insert(
            SearchAliasesCompanion.insert(
              entityType: 'raga',
              entityId: fix.ragaId,
              alias: 'abheree',
            ),
          );
      final results = await repo.quickSearch('abheree');
      expect(results, isNotEmpty);
      expect(results.any((r) => r.name == 'Nagumomu Ganaleni'), isTrue);
    });

    test('no results for unrelated query', () async {
      final results = await repo.quickSearch('xyznotexist');
      expect(results, isEmpty);
    });

    test('case-insensitive matching', () async {
      final results = await repo.quickSearch('NAGUMOMU');
      expect(results, isNotEmpty);
    });
  });

  // ---- lyricsSearch -------------------------------------------------------

  group('lyricsSearch', () {
    test('returns empty list for empty query', () async {
      final results = await repo.lyricsSearch('');
      expect(results, isEmpty);
    });

    test('finds krithi by pallavi phrase', () async {
      final results = await repo.lyricsSearch('bhagyame');
      expect(results, isNotEmpty);
      expect(results.first.name, equals('Nagumomu Ganaleni'));
    });

    test('finds krithi by anupallavi phrase', () async {
      final results = await repo.lyricsSearch('pada yugamuna');
      expect(results, isNotEmpty);
      expect(results.first.name, equals('Nagumomu Ganaleni'));
    });

    test('lyricsSnippet is non-null', () async {
      final results = await repo.lyricsSearch('bhagyame');
      expect(results.first.lyricsSnippet, isNotNull);
    });

    test('no results for text not in any krithi', () async {
      final results = await repo.lyricsSearch('zzznomatchtext');
      expect(results, isEmpty);
    });
  });

  // ---- filterSearch -------------------------------------------------------

  group('filterSearch', () {
    test('no filters returns all krithis', () async {
      final results = await repo.filterSearch();
      expect(results.length, equals(2));
    });

    test('filter by ragaId returns matching krithi only', () async {
      final results = await repo.filterSearch(ragaId: fix.ragaId);
      expect(results.length, equals(1));
      expect(results.first.name, equals('Nagumomu Ganaleni'));
    });

    test('filter by composerId returns matching krithi only', () async {
      final results = await repo.filterSearch(composerId: fix.composerId2);
      expect(results.length, equals(1));
      expect(results.first.name, equals('Sri Kamalambikayai'));
    });

    test('filter by language returns matching krithi', () async {
      final results = await repo.filterSearch(language: 'sanskrit');
      expect(results.length, equals(1));
      expect(results.first.language, equals('sanskrit'));
    });

    test('filter by compositionType returns matching krithis', () async {
      final results = await repo.filterSearch(compositionType: 'krithi');
      expect(results.length, equals(2));
    });

    test('combined raga + language filter narrows results correctly', () async {
      final results = await repo.filterSearch(
        ragaId: fix.ragaId2,
        language: 'sanskrit',
      );
      expect(results.length, equals(1));
      expect(results.first.ragaName, equals('Kalyani'));
    });

    test('filter with no matches returns empty list', () async {
      final results = await repo.filterSearch(language: 'tamil');
      expect(results, isEmpty);
    });
  });
}
