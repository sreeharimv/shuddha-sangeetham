import 'package:drift/drift.dart';

/// Concert — one record per unique real-world performance.
///
/// Replaces the old PerformanceLog design. The [attendeeCount] field is
/// incremented when duplicate entries (same artist + date + krithi) are merged.
/// The [status] field is schema-ready for v2 moderation — no migration needed.
class Concerts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get krithiId => integer()
      .customConstraint('NOT NULL REFERENCES krithis(id)')();

  /// Raga performed — may differ from the krithi default (manodharma raga).
  IntColumn get ragaId => integer()
      .customConstraint('REFERENCES ragas(id)')
      .nullable()();

  TextColumn get venue => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get sabhaName => text().nullable()();
  DateTimeColumn get performanceDate => dateTime()();

  /// Incremented when duplicate entries are merged (v2 logic).
  IntColumn get attendeeCount =>
      integer().withDefault(const Constant(1))();

  /// active | flagged | removed
  TextColumn get status =>
      text().withDefault(const Constant('active'))();

  IntColumn get createdByUserId => integer()
      .customConstraint('REFERENCES users(id)')
      .nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Junction table — one concert can have multiple artists.
class ConcertArtists extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get concertId => integer()
      .customConstraint('NOT NULL REFERENCES concerts(id)')();

  IntColumn get artistId => integer()
      .customConstraint('NOT NULL REFERENCES artists(id)')();

  /// main | accompanist (optional role label)
  TextColumn get role => text().nullable()();
}

/// One record per user who logged / confirmed attendance at this concert.
class ConcertAttendees extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get concertId => integer()
      .customConstraint('NOT NULL REFERENCES concerts(id)')();

  IntColumn get userId => integer()
      .customConstraint('NOT NULL REFERENCES users(id)')();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {concertId, userId},
      ];
}
