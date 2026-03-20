import 'package:drift/drift.dart';

/// SearchAlias — the backbone of offline fuzzy search.
///
/// Maps every known spelling variant / abbreviation / misspelling to the
/// canonical entity. Seeded at build time from a curated + auto-generated list.
///
/// Examples:
///   alias="Thyagaraja"  entity_type="composer" entity_id=<Tyagaraja id>
///   alias="Bhairawi"    entity_type="raga"     entity_id=<Bhairavi id>
///   alias="TMK"         entity_type="artist"   entity_id=<T.M. Krishna id>
class SearchAliases extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// krithi | raga | composer | tala | artist
  TextColumn get entityType => text()();

  /// ID in the corresponding entity table.
  IntColumn get entityId => integer()();

  /// The alternate spelling / abbreviation / misspelling.
  TextColumn get alias => text()();

  @override
  List<Index> get indexes => [
        Index('idx_search_aliases_alias', 'alias'),
        Index('idx_search_aliases_entity', 'entity_type, entity_id'),
      ];
}
