abstract final class AppConstants {
  static const appName = 'Shuddha Sangeetham';
  static const packageId = 'com.shuddhasangeetham.app';
  static const dbFileName = 'shuddha_sangeetham.db';
  static const dbSchemaVersion = 1;

  /// Minimum characters before search is triggered.
  static const searchMinChars = 2;

  /// Debounce for quick search (name / raga / composer).
  static const searchDebounceMs = 200;

  /// Debounce for lyrics full-text search.
  static const lyricsSearchDebounceMs = 500;

  /// Number of krithis to load per page in the Browse screen.
  static const browsePageSize = 50;

  static const karnatikBaseUrl = 'https://www.karnatik.com';

  /// Backend base URL for delta sync. Override via --dart-define=SYNC_BASE_URL=...
  static const syncBaseUrl = String.fromEnvironment(
    'SYNC_BASE_URL',
    defaultValue: 'https://api.shuddhasangeetham.app',
  );
  static const karnatikAttribution =
      'Content sourced with reference to karnatik.com';

  // --- Language values (stored as text in DB) ---
  static const languages = [
    'Telugu',
    'Sanskrit',
    'Tamil',
    'Kannada',
    'Other',
  ];

  // --- Composition type values ---
  static const compositionTypes = [
    'Krithi',
    'Varnam',
    'Geetam',
    'Swarajati',
    'Other',
  ];

  // --- Artist instrument values ---
  static const instruments = [
    'Vocal',
    'Violin',
    'Mridangam',
    'Flute',
    'Veena',
    'Other',
  ];

  // --- Concert status values ---
  static const concertStatusActive = 'active';
  static const concertStatusFlagged = 'flagged';
  static const concertStatusRemoved = 'removed';

  // --- SearchAlias entity types ---
  static const aliasTypeKrithi = 'krithi';
  static const aliasTypeRaga = 'raga';
  static const aliasTypeComposer = 'composer';
  static const aliasTypeTala = 'tala';
  static const aliasTypeArtist = 'artist';
}
