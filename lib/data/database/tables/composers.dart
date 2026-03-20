import 'package:drift/drift.dart';

/// Composer table.
///
/// [nameVariants] stores a JSON array of alternate spellings,
/// e.g. '["Thyagaraja","Tyagarajan","Tyagayya"]'.
class Composers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// JSON array of alternate spellings / abbreviations.
  TextColumn get nameVariants => text().withDefault(const Constant('[]'))();

  /// e.g. "18th century" or "1767–1847"
  TextColumn get era => text().nullable()();

  TextColumn get biography => text().nullable()();

  /// Primary language of compositions (Telugu, Sanskrit, Tamil …)
  TextColumn get languageOfCompositions => text().nullable()();
}
