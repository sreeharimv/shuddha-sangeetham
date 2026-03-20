import 'package:drift/drift.dart';

/// Artist — first-class entity for concert performers.
///
/// Solves the spelling-variant problem the same way Raga and Composer do.
/// e.g. "T.M. Krishna" with variants ["TM Krishna", "TMK", "T M Krishna"].
///
/// SearchAlias also covers Artist — "TMK" → artist_id for T.M. Krishna.
class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Canonical display name, e.g. "T.M. Krishna"
  TextColumn get name => text()();

  /// JSON array — e.g. '["TM Krishna","TMK","T M Krishna"]'
  TextColumn get nameVariants => text().withDefault(const Constant('[]'))();

  /// vocal | violin | mridangam | flute | veena | other
  TextColumn get instrument => text().nullable()();

  TextColumn get biography => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
