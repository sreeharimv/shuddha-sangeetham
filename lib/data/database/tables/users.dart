import 'package:drift/drift.dart';

/// App user — not used in v1 (guest-only). Schema ready for v2.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get displayName => text()();
  TextColumn get email => text().unique()();

  /// user | admin
  TextColumn get role => text().withDefault(const Constant('user'))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
