import 'package:drift/drift.dart';

/// Local bookmark — stored on-device only.
///
/// No user account required. Works fully offline (v1).
/// In v2, registered users can sync bookmarks to their account.
class Bookmarks extends Table {
  /// Bookmarks use krithiId as the natural primary key — one bookmark per krithi.
  IntColumn get krithiId => integer()
      .customConstraint('NOT NULL REFERENCES krithis(id)')();

  DateTimeColumn get bookmarkedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {krithiId};
}
