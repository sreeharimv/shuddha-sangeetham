import 'package:drift/drift.dart';

/// Tala (rhythmic cycle) table.
class Talas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// JSON array of alternate spellings, e.g. '["Aadi","Aditalam"]'.
  TextColumn get nameVariants => text().withDefault(const Constant('[]'))();

  /// Anga breakdown, e.g. "laghu + drutam + drutam"
  TextColumn get structure => text().nullable()();

  /// Total aksharas (beats) in one cycle.
  IntColumn get aksharasCount => integer().nullable()();
}
