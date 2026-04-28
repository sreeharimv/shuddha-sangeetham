/// Represents one row returned from a search query.
///
/// [lyricsSnippet] is populated only for lyrics search — a short excerpt
/// around the matching phrase, used for the result card preview.
class KrithiSearchResult {
  const KrithiSearchResult({
    required this.id,
    required this.name,
    required this.ragaName,
    required this.composerName,
    required this.talaName,
    required this.language,
    required this.compositionType,
    this.lyricsSnippet,
  });

  final int id;
  final String name;
  final String ragaName;
  final String composerName;
  final String talaName;
  final String language;
  final String compositionType;

  /// Non-null only in lyrics search mode.
  final String? lyricsSnippet;

  KrithiSearchResult copyWith({String? lyricsSnippet}) {
    return KrithiSearchResult(
      id: id,
      name: name,
      ragaName: ragaName,
      composerName: composerName,
      talaName: talaName,
      language: language,
      compositionType: compositionType,
      lyricsSnippet: lyricsSnippet ?? this.lyricsSnippet,
    );
  }
}
