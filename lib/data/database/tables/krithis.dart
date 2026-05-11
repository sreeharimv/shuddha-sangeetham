import 'package:drift/drift.dart';

/// Krithi (composition) — the central entity of the app.
///
/// Foreign keys reference Composers, Ragas, and Talas by id.
/// Custom constraints are used instead of drift's .references() to avoid
/// circular import issues when all table files are imported into app_database.
class Krithis extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Transliterated English name, e.g. "Nagumomu Ganaleni"
  TextColumn get name => text()();

  /// Normalized + variant spellings joined as a single string for FTS indexing.
  /// Populated during the data pipeline (Session 2 / Session 3).
  TextColumn get searchTokens => text().nullable()();

  IntColumn get composerId => integer()
      .customConstraint('NOT NULL REFERENCES composers(id)')();

  IntColumn get ragaId => integer()
      .customConstraint('NOT NULL REFERENCES ragas(id)')();

  IntColumn get talaId => integer()
      .customConstraint('NOT NULL REFERENCES talas(id)')();

  /// telugu | sanskrit | tamil | kannada | other
  TextColumn get language => text()();

  /// krithi | varnam | geetam | swarajati | other
  TextColumn get compositionType => text()();

  /// Deity associated with the composition (nullable).
  TextColumn get deity => text().nullable()();

  /// Opening section of the lyrics (always present).
  TextColumn get pallavi => text()();

  /// Second section (may be absent in some compositions).
  TextColumn get anupallavi => text().nullable()();

  /// Verse(s) — full text; may contain multiple charanams separated by line
  /// breaks or markers. Nullable for compositions that only have a pallavi.
  TextColumn get charanam => text().nullable()();

  /// Source page, e.g. "https://www.karnatik.com/c1000.shtml"
  TextColumn get sourceUrl => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
