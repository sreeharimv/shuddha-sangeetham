/// Curated SearchAlias seed data.
///
/// Each entry is a map with keys: entity_type, canonical_name, aliases.
/// The [SeedLoader] resolves canonical_name → entity_id at runtime before
/// inserting into the search_aliases table.
///
/// Sources: karnatik.com transliteration variations observed in practice,
/// plus common misspellings used by concert-going audiences.
const List<_AliasSeed> kSearchAliasSeed = [
  // ---- Composers -------------------------------------------------------
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Tyagaraja',
    aliases: [
      'Thyagaraja',
      'Tyagarajan',
      'Tyagayya',
      'Thyagayya',
      'Thiagaraja',
      'Tyāgarāja',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Muttuswami Dikshitar',
    aliases: [
      'Dikshitar',
      'Dikshithar',
      'Diksitar',
      'Muthuswami Dikshitar',
      'Mutthuswami Dikshitar',
      'Muttuswamy Dikshitar',
      'Dikshita',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Syama Sastri',
    aliases: [
      'Shyama Sastri',
      'Syama Shastri',
      'Shyama Shastri',
      'Syamasastri',
      'Shyamasastri',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Swati Tirunal',
    aliases: [
      'Swathi Thirunal',
      'Swati Thirunal',
      'Swathi Tirunal',
      'Maharaja Swati Tirunal',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Purandaradasa',
    aliases: [
      'Purandara Dasa',
      'Purandaradasa',
      'Purandar Das',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Oottukkadu Venkata Kavi',
    aliases: [
      'Oottukadu',
      'Oottukkadu',
      'Venkata Kavi',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Papanasam Sivan',
    aliases: [
      'Papanasam',
      'Papanasam Sivam',
    ],
  ),
  _AliasSeed(
    entityType: 'composer',
    canonicalName: 'Mysore Vasudevachar',
    aliases: [
      'Vasudevachar',
      'Vasudeva Iyengar',
      'Mysore Vasudevachar',
    ],
  ),

  // ---- Ragas -----------------------------------------------------------
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Bhairavi',
    aliases: [
      'Bhairawi',
      'Bairavi',
      'Bhyravi',
      'Bhairavee',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Kalyani',
    aliases: [
      'Kalyanee',
      'Kalyanii',
      'Kalyaani',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Shankarabharanam',
    aliases: [
      'Sankarabharanam',
      'Shankarabharnam',
      'Shankarabharana',
      'Sankarabharnam',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Todi',
    aliases: [
      'Thodi',
      'Toodi',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Kambhoji',
    aliases: [
      'Kamboji',
      'Kambhojee',
      'Kamboji',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Varali',
    aliases: [
      'Varali',
      'Varalee',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Arabhi',
    aliases: [
      'Arabi',
      'Arabee',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Saveri',
    aliases: [
      'Saaveri',
      'Saaveri',
      'Saaweree',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Bilahari',
    aliases: [
      'Bilaharee',
      'Vilahari',
      'Vilaharee',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Mohanam',
    aliases: [
      'Mohana',
      'Mohannam',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Begada',
    aliases: [
      'Vegada',
      'Begade',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Kharaharapriya',
    aliases: [
      'Kharaharapriya',
      'Karaharapriya',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Harikambhoji',
    aliases: [
      'Harikamboji',
      'Hari Kambhoji',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Natabhairavi',
    aliases: [
      'Nata Bhairavi',
      'Natabhairawi',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Charukeshi',
    aliases: [
      'Charukesi',
      'Charukeesi',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Kedaragowla',
    aliases: [
      'Kedara Gowla',
      'Kedharagowla',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Anandabhairavi',
    aliases: [
      'Ananda Bhairavi',
      'Anandabhairawi',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Vasantha',
    aliases: [
      'Vasanta',
      'Vasantham',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Pantuvarali',
    aliases: [
      'Panta Varali',
      'Pantuvarali',
      'Kamavardhini',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Suddha Dhanyasi',
    aliases: [
      'Shuddha Dhanyasi',
      'Dhanyasi',
      'Suddha Dhanyas',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Madhyamavati',
    aliases: [
      'Madhyamawati',
      'Madhyama Vati',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Ritigowla',
    aliases: [
      'Riti Gowla',
      'Ritigaula',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Atana',
    aliases: [
      'Adana',
      'Ataana',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Sriranjani',
    aliases: [
      'Sri Ranjani',
      'Shri Ranjani',
      'Sree Ranjani',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Abheri',
    aliases: [
      'Abheri',
      'Abheree',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Nattai',
    aliases: [
      'Nattai',
      'Nata',
      'Naatai',
    ],
  ),
  _AliasSeed(
    entityType: 'raga',
    canonicalName: 'Gowrimanohari',
    aliases: [
      'Gowri Manohari',
      'Gauri Manohari',
      'Gaurimanohari',
    ],
  ),

  // ---- Talas -----------------------------------------------------------
  _AliasSeed(
    entityType: 'tala',
    canonicalName: 'Adi',
    aliases: [
      'Aadi',
      'Adhi',
      'Aditalam',
      'Adi Talam',
    ],
  ),
  _AliasSeed(
    entityType: 'tala',
    canonicalName: 'Rupakam',
    aliases: [
      'Roopaka',
      'Rupaka',
      'Roopakam',
    ],
  ),
  _AliasSeed(
    entityType: 'tala',
    canonicalName: 'Misra Chapu',
    aliases: [
      'Misrachapu',
      'Misra Chaappu',
      'Misra Chappu',
    ],
  ),
  _AliasSeed(
    entityType: 'tala',
    canonicalName: 'Khanda Chapu',
    aliases: [
      'Khandachapu',
      'Khanda Chappu',
    ],
  ),
  _AliasSeed(
    entityType: 'tala',
    canonicalName: 'Tisra Triputa',
    aliases: [
      'Tisra Triputa',
      'Tisra',
    ],
  ),
];

class _AliasSeed {
  const _AliasSeed({
    required this.entityType,
    required this.canonicalName,
    required this.aliases,
  });

  final String entityType;
  final String canonicalName;
  final List<String> aliases;
}
