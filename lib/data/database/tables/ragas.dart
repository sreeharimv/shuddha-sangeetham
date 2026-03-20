import 'package:drift/drift.dart';

/// Raga table.
///
/// Supports both melakarta ragas (have [melakarataNumber]) and janya ragas
/// (have [parentMelakarataId] pointing to their parent melakarta raga).
class Ragas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// JSON array of alternate spellings, e.g. '["Bhairawi","Bairavi","Bhyravi"]'.
  TextColumn get nameVariants => text().withDefault(const Constant('[]'))();

  /// Ascending scale, e.g. "S R2 G3 M1 P D2 N3 S"
  TextColumn get arohana => text().nullable()();

  /// Descending scale, e.g. "S N3 D2 P M1 G3 R2 S"
  TextColumn get avarohana => text().nullable()();

  /// 1–72 for melakarta ragas; null for janya ragas.
  IntColumn get melakarataNumber => integer().nullable()();

  /// FK to this table — parent melakarta for janya ragas.
  IntColumn get parentMelakarataId => integer().nullable()();

  /// Short description of the raga's mood / feel / time of day.
  TextColumn get characteristics => text().nullable()();
}
