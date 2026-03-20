// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ComposersTable extends Composers
    with TableInfo<$ComposersTable, Composer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComposersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameVariantsMeta =
      const VerificationMeta('nameVariants');
  @override
  late final GeneratedColumn<String> nameVariants = GeneratedColumn<String>(
      'name_variants', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _eraMeta = const VerificationMeta('era');
  @override
  late final GeneratedColumn<String> era = GeneratedColumn<String>(
      'era', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _biographyMeta =
      const VerificationMeta('biography');
  @override
  late final GeneratedColumn<String> biography = GeneratedColumn<String>(
      'biography', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageOfCompositionsMeta =
      const VerificationMeta('languageOfCompositions');
  @override
  late final GeneratedColumn<String> languageOfCompositions =
      GeneratedColumn<String>('language_of_compositions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameVariants, era, biography, languageOfCompositions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'composers';
  @override
  VerificationContext validateIntegrity(Insertable<Composer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_variants')) {
      context.handle(
          _nameVariantsMeta,
          nameVariants.isAcceptableOrUnknown(
              data['name_variants']!, _nameVariantsMeta));
    }
    if (data.containsKey('era')) {
      context.handle(
          _eraMeta, era.isAcceptableOrUnknown(data['era']!, _eraMeta));
    }
    if (data.containsKey('biography')) {
      context.handle(_biographyMeta,
          biography.isAcceptableOrUnknown(data['biography']!, _biographyMeta));
    }
    if (data.containsKey('language_of_compositions')) {
      context.handle(
          _languageOfCompositionsMeta,
          languageOfCompositions.isAcceptableOrUnknown(
              data['language_of_compositions']!, _languageOfCompositionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Composer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Composer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_variants'])!,
      era: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}era']),
      biography: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}biography']),
      languageOfCompositions: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}language_of_compositions']),
    );
  }

  @override
  $ComposersTable createAlias(String alias) {
    return $ComposersTable(attachedDatabase, alias);
  }
}

class Composer extends DataClass implements Insertable<Composer> {
  final int id;
  final String name;

  /// JSON array of alternate spellings / abbreviations.
  final String nameVariants;

  /// e.g. "18th century" or "1767–1847"
  final String? era;
  final String? biography;

  /// Primary language of compositions (Telugu, Sanskrit, Tamil …)
  final String? languageOfCompositions;
  const Composer(
      {required this.id,
      required this.name,
      required this.nameVariants,
      this.era,
      this.biography,
      this.languageOfCompositions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_variants'] = Variable<String>(nameVariants);
    if (!nullToAbsent || era != null) {
      map['era'] = Variable<String>(era);
    }
    if (!nullToAbsent || biography != null) {
      map['biography'] = Variable<String>(biography);
    }
    if (!nullToAbsent || languageOfCompositions != null) {
      map['language_of_compositions'] =
          Variable<String>(languageOfCompositions);
    }
    return map;
  }

  ComposersCompanion toCompanion(bool nullToAbsent) {
    return ComposersCompanion(
      id: Value(id),
      name: Value(name),
      nameVariants: Value(nameVariants),
      era: era == null && nullToAbsent ? const Value.absent() : Value(era),
      biography: biography == null && nullToAbsent
          ? const Value.absent()
          : Value(biography),
      languageOfCompositions: languageOfCompositions == null && nullToAbsent
          ? const Value.absent()
          : Value(languageOfCompositions),
    );
  }

  factory Composer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Composer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameVariants: serializer.fromJson<String>(json['nameVariants']),
      era: serializer.fromJson<String?>(json['era']),
      biography: serializer.fromJson<String?>(json['biography']),
      languageOfCompositions:
          serializer.fromJson<String?>(json['languageOfCompositions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameVariants': serializer.toJson<String>(nameVariants),
      'era': serializer.toJson<String?>(era),
      'biography': serializer.toJson<String?>(biography),
      'languageOfCompositions':
          serializer.toJson<String?>(languageOfCompositions),
    };
  }

  Composer copyWith(
          {int? id,
          String? name,
          String? nameVariants,
          Value<String?> era = const Value.absent(),
          Value<String?> biography = const Value.absent(),
          Value<String?> languageOfCompositions = const Value.absent()}) =>
      Composer(
        id: id ?? this.id,
        name: name ?? this.name,
        nameVariants: nameVariants ?? this.nameVariants,
        era: era.present ? era.value : this.era,
        biography: biography.present ? biography.value : this.biography,
        languageOfCompositions: languageOfCompositions.present
            ? languageOfCompositions.value
            : this.languageOfCompositions,
      );
  Composer copyWithCompanion(ComposersCompanion data) {
    return Composer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameVariants: data.nameVariants.present
          ? data.nameVariants.value
          : this.nameVariants,
      era: data.era.present ? data.era.value : this.era,
      biography: data.biography.present ? data.biography.value : this.biography,
      languageOfCompositions: data.languageOfCompositions.present
          ? data.languageOfCompositions.value
          : this.languageOfCompositions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Composer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('era: $era, ')
          ..write('biography: $biography, ')
          ..write('languageOfCompositions: $languageOfCompositions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, nameVariants, era, biography, languageOfCompositions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Composer &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameVariants == this.nameVariants &&
          other.era == this.era &&
          other.biography == this.biography &&
          other.languageOfCompositions == this.languageOfCompositions);
}

class ComposersCompanion extends UpdateCompanion<Composer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameVariants;
  final Value<String?> era;
  final Value<String?> biography;
  final Value<String?> languageOfCompositions;
  const ComposersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameVariants = const Value.absent(),
    this.era = const Value.absent(),
    this.biography = const Value.absent(),
    this.languageOfCompositions = const Value.absent(),
  });
  ComposersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameVariants = const Value.absent(),
    this.era = const Value.absent(),
    this.biography = const Value.absent(),
    this.languageOfCompositions = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Composer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameVariants,
    Expression<String>? era,
    Expression<String>? biography,
    Expression<String>? languageOfCompositions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameVariants != null) 'name_variants': nameVariants,
      if (era != null) 'era': era,
      if (biography != null) 'biography': biography,
      if (languageOfCompositions != null)
        'language_of_compositions': languageOfCompositions,
    });
  }

  ComposersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nameVariants,
      Value<String?>? era,
      Value<String?>? biography,
      Value<String?>? languageOfCompositions}) {
    return ComposersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVariants: nameVariants ?? this.nameVariants,
      era: era ?? this.era,
      biography: biography ?? this.biography,
      languageOfCompositions:
          languageOfCompositions ?? this.languageOfCompositions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameVariants.present) {
      map['name_variants'] = Variable<String>(nameVariants.value);
    }
    if (era.present) {
      map['era'] = Variable<String>(era.value);
    }
    if (biography.present) {
      map['biography'] = Variable<String>(biography.value);
    }
    if (languageOfCompositions.present) {
      map['language_of_compositions'] =
          Variable<String>(languageOfCompositions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComposersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('era: $era, ')
          ..write('biography: $biography, ')
          ..write('languageOfCompositions: $languageOfCompositions')
          ..write(')'))
        .toString();
  }
}

class $RagasTable extends Ragas with TableInfo<$RagasTable, Raga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RagasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameVariantsMeta =
      const VerificationMeta('nameVariants');
  @override
  late final GeneratedColumn<String> nameVariants = GeneratedColumn<String>(
      'name_variants', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _arohanaMeta =
      const VerificationMeta('arohana');
  @override
  late final GeneratedColumn<String> arohana = GeneratedColumn<String>(
      'arohana', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avarohanaMeta =
      const VerificationMeta('avarohana');
  @override
  late final GeneratedColumn<String> avarohana = GeneratedColumn<String>(
      'avarohana', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _melakarataNumberMeta =
      const VerificationMeta('melakarataNumber');
  @override
  late final GeneratedColumn<int> melakarataNumber = GeneratedColumn<int>(
      'melakarata_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _parentMelakarataIdMeta =
      const VerificationMeta('parentMelakarataId');
  @override
  late final GeneratedColumn<int> parentMelakarataId = GeneratedColumn<int>(
      'parent_melakarata_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _characteristicsMeta =
      const VerificationMeta('characteristics');
  @override
  late final GeneratedColumn<String> characteristics = GeneratedColumn<String>(
      'characteristics', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nameVariants,
        arohana,
        avarohana,
        melakarataNumber,
        parentMelakarataId,
        characteristics
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ragas';
  @override
  VerificationContext validateIntegrity(Insertable<Raga> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_variants')) {
      context.handle(
          _nameVariantsMeta,
          nameVariants.isAcceptableOrUnknown(
              data['name_variants']!, _nameVariantsMeta));
    }
    if (data.containsKey('arohana')) {
      context.handle(_arohanaMeta,
          arohana.isAcceptableOrUnknown(data['arohana']!, _arohanaMeta));
    }
    if (data.containsKey('avarohana')) {
      context.handle(_avarohanaMeta,
          avarohana.isAcceptableOrUnknown(data['avarohana']!, _avarohanaMeta));
    }
    if (data.containsKey('melakarata_number')) {
      context.handle(
          _melakarataNumberMeta,
          melakarataNumber.isAcceptableOrUnknown(
              data['melakarata_number']!, _melakarataNumberMeta));
    }
    if (data.containsKey('parent_melakarata_id')) {
      context.handle(
          _parentMelakarataIdMeta,
          parentMelakarataId.isAcceptableOrUnknown(
              data['parent_melakarata_id']!, _parentMelakarataIdMeta));
    }
    if (data.containsKey('characteristics')) {
      context.handle(
          _characteristicsMeta,
          characteristics.isAcceptableOrUnknown(
              data['characteristics']!, _characteristicsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Raga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Raga(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_variants'])!,
      arohana: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arohana']),
      avarohana: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avarohana']),
      melakarataNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}melakarata_number']),
      parentMelakarataId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}parent_melakarata_id']),
      characteristics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}characteristics']),
    );
  }

  @override
  $RagasTable createAlias(String alias) {
    return $RagasTable(attachedDatabase, alias);
  }
}

class Raga extends DataClass implements Insertable<Raga> {
  final int id;
  final String name;

  /// JSON array of alternate spellings, e.g. '["Bhairawi","Bairavi","Bhyravi"]'.
  final String nameVariants;

  /// Ascending scale, e.g. "S R2 G3 M1 P D2 N3 S"
  final String? arohana;

  /// Descending scale, e.g. "S N3 D2 P M1 G3 R2 S"
  final String? avarohana;

  /// 1–72 for melakarta ragas; null for janya ragas.
  final int? melakarataNumber;

  /// FK to this table — parent melakarta for janya ragas.
  final int? parentMelakarataId;

  /// Short description of the raga's mood / feel / time of day.
  final String? characteristics;
  const Raga(
      {required this.id,
      required this.name,
      required this.nameVariants,
      this.arohana,
      this.avarohana,
      this.melakarataNumber,
      this.parentMelakarataId,
      this.characteristics});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_variants'] = Variable<String>(nameVariants);
    if (!nullToAbsent || arohana != null) {
      map['arohana'] = Variable<String>(arohana);
    }
    if (!nullToAbsent || avarohana != null) {
      map['avarohana'] = Variable<String>(avarohana);
    }
    if (!nullToAbsent || melakarataNumber != null) {
      map['melakarata_number'] = Variable<int>(melakarataNumber);
    }
    if (!nullToAbsent || parentMelakarataId != null) {
      map['parent_melakarata_id'] = Variable<int>(parentMelakarataId);
    }
    if (!nullToAbsent || characteristics != null) {
      map['characteristics'] = Variable<String>(characteristics);
    }
    return map;
  }

  RagasCompanion toCompanion(bool nullToAbsent) {
    return RagasCompanion(
      id: Value(id),
      name: Value(name),
      nameVariants: Value(nameVariants),
      arohana: arohana == null && nullToAbsent
          ? const Value.absent()
          : Value(arohana),
      avarohana: avarohana == null && nullToAbsent
          ? const Value.absent()
          : Value(avarohana),
      melakarataNumber: melakarataNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(melakarataNumber),
      parentMelakarataId: parentMelakarataId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentMelakarataId),
      characteristics: characteristics == null && nullToAbsent
          ? const Value.absent()
          : Value(characteristics),
    );
  }

  factory Raga.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Raga(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameVariants: serializer.fromJson<String>(json['nameVariants']),
      arohana: serializer.fromJson<String?>(json['arohana']),
      avarohana: serializer.fromJson<String?>(json['avarohana']),
      melakarataNumber: serializer.fromJson<int?>(json['melakarataNumber']),
      parentMelakarataId: serializer.fromJson<int?>(json['parentMelakarataId']),
      characteristics: serializer.fromJson<String?>(json['characteristics']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameVariants': serializer.toJson<String>(nameVariants),
      'arohana': serializer.toJson<String?>(arohana),
      'avarohana': serializer.toJson<String?>(avarohana),
      'melakarataNumber': serializer.toJson<int?>(melakarataNumber),
      'parentMelakarataId': serializer.toJson<int?>(parentMelakarataId),
      'characteristics': serializer.toJson<String?>(characteristics),
    };
  }

  Raga copyWith(
          {int? id,
          String? name,
          String? nameVariants,
          Value<String?> arohana = const Value.absent(),
          Value<String?> avarohana = const Value.absent(),
          Value<int?> melakarataNumber = const Value.absent(),
          Value<int?> parentMelakarataId = const Value.absent(),
          Value<String?> characteristics = const Value.absent()}) =>
      Raga(
        id: id ?? this.id,
        name: name ?? this.name,
        nameVariants: nameVariants ?? this.nameVariants,
        arohana: arohana.present ? arohana.value : this.arohana,
        avarohana: avarohana.present ? avarohana.value : this.avarohana,
        melakarataNumber: melakarataNumber.present
            ? melakarataNumber.value
            : this.melakarataNumber,
        parentMelakarataId: parentMelakarataId.present
            ? parentMelakarataId.value
            : this.parentMelakarataId,
        characteristics: characteristics.present
            ? characteristics.value
            : this.characteristics,
      );
  Raga copyWithCompanion(RagasCompanion data) {
    return Raga(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameVariants: data.nameVariants.present
          ? data.nameVariants.value
          : this.nameVariants,
      arohana: data.arohana.present ? data.arohana.value : this.arohana,
      avarohana: data.avarohana.present ? data.avarohana.value : this.avarohana,
      melakarataNumber: data.melakarataNumber.present
          ? data.melakarataNumber.value
          : this.melakarataNumber,
      parentMelakarataId: data.parentMelakarataId.present
          ? data.parentMelakarataId.value
          : this.parentMelakarataId,
      characteristics: data.characteristics.present
          ? data.characteristics.value
          : this.characteristics,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Raga(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('arohana: $arohana, ')
          ..write('avarohana: $avarohana, ')
          ..write('melakarataNumber: $melakarataNumber, ')
          ..write('parentMelakarataId: $parentMelakarataId, ')
          ..write('characteristics: $characteristics')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameVariants, arohana, avarohana,
      melakarataNumber, parentMelakarataId, characteristics);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Raga &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameVariants == this.nameVariants &&
          other.arohana == this.arohana &&
          other.avarohana == this.avarohana &&
          other.melakarataNumber == this.melakarataNumber &&
          other.parentMelakarataId == this.parentMelakarataId &&
          other.characteristics == this.characteristics);
}

class RagasCompanion extends UpdateCompanion<Raga> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameVariants;
  final Value<String?> arohana;
  final Value<String?> avarohana;
  final Value<int?> melakarataNumber;
  final Value<int?> parentMelakarataId;
  final Value<String?> characteristics;
  const RagasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameVariants = const Value.absent(),
    this.arohana = const Value.absent(),
    this.avarohana = const Value.absent(),
    this.melakarataNumber = const Value.absent(),
    this.parentMelakarataId = const Value.absent(),
    this.characteristics = const Value.absent(),
  });
  RagasCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameVariants = const Value.absent(),
    this.arohana = const Value.absent(),
    this.avarohana = const Value.absent(),
    this.melakarataNumber = const Value.absent(),
    this.parentMelakarataId = const Value.absent(),
    this.characteristics = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Raga> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameVariants,
    Expression<String>? arohana,
    Expression<String>? avarohana,
    Expression<int>? melakarataNumber,
    Expression<int>? parentMelakarataId,
    Expression<String>? characteristics,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameVariants != null) 'name_variants': nameVariants,
      if (arohana != null) 'arohana': arohana,
      if (avarohana != null) 'avarohana': avarohana,
      if (melakarataNumber != null) 'melakarata_number': melakarataNumber,
      if (parentMelakarataId != null)
        'parent_melakarata_id': parentMelakarataId,
      if (characteristics != null) 'characteristics': characteristics,
    });
  }

  RagasCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nameVariants,
      Value<String?>? arohana,
      Value<String?>? avarohana,
      Value<int?>? melakarataNumber,
      Value<int?>? parentMelakarataId,
      Value<String?>? characteristics}) {
    return RagasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVariants: nameVariants ?? this.nameVariants,
      arohana: arohana ?? this.arohana,
      avarohana: avarohana ?? this.avarohana,
      melakarataNumber: melakarataNumber ?? this.melakarataNumber,
      parentMelakarataId: parentMelakarataId ?? this.parentMelakarataId,
      characteristics: characteristics ?? this.characteristics,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameVariants.present) {
      map['name_variants'] = Variable<String>(nameVariants.value);
    }
    if (arohana.present) {
      map['arohana'] = Variable<String>(arohana.value);
    }
    if (avarohana.present) {
      map['avarohana'] = Variable<String>(avarohana.value);
    }
    if (melakarataNumber.present) {
      map['melakarata_number'] = Variable<int>(melakarataNumber.value);
    }
    if (parentMelakarataId.present) {
      map['parent_melakarata_id'] = Variable<int>(parentMelakarataId.value);
    }
    if (characteristics.present) {
      map['characteristics'] = Variable<String>(characteristics.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RagasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('arohana: $arohana, ')
          ..write('avarohana: $avarohana, ')
          ..write('melakarataNumber: $melakarataNumber, ')
          ..write('parentMelakarataId: $parentMelakarataId, ')
          ..write('characteristics: $characteristics')
          ..write(')'))
        .toString();
  }
}

class $TalasTable extends Talas with TableInfo<$TalasTable, Tala> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameVariantsMeta =
      const VerificationMeta('nameVariants');
  @override
  late final GeneratedColumn<String> nameVariants = GeneratedColumn<String>(
      'name_variants', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _structureMeta =
      const VerificationMeta('structure');
  @override
  late final GeneratedColumn<String> structure = GeneratedColumn<String>(
      'structure', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aksharasCountMeta =
      const VerificationMeta('aksharasCount');
  @override
  late final GeneratedColumn<int> aksharasCount = GeneratedColumn<int>(
      'aksharas_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameVariants, structure, aksharasCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talas';
  @override
  VerificationContext validateIntegrity(Insertable<Tala> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_variants')) {
      context.handle(
          _nameVariantsMeta,
          nameVariants.isAcceptableOrUnknown(
              data['name_variants']!, _nameVariantsMeta));
    }
    if (data.containsKey('structure')) {
      context.handle(_structureMeta,
          structure.isAcceptableOrUnknown(data['structure']!, _structureMeta));
    }
    if (data.containsKey('aksharas_count')) {
      context.handle(
          _aksharasCountMeta,
          aksharasCount.isAcceptableOrUnknown(
              data['aksharas_count']!, _aksharasCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tala map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tala(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_variants'])!,
      structure: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}structure']),
      aksharasCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aksharas_count']),
    );
  }

  @override
  $TalasTable createAlias(String alias) {
    return $TalasTable(attachedDatabase, alias);
  }
}

class Tala extends DataClass implements Insertable<Tala> {
  final int id;
  final String name;

  /// JSON array of alternate spellings, e.g. '["Aadi","Aditalam"]'.
  final String nameVariants;

  /// Anga breakdown, e.g. "laghu + drutam + drutam"
  final String? structure;

  /// Total aksharas (beats) in one cycle.
  final int? aksharasCount;
  const Tala(
      {required this.id,
      required this.name,
      required this.nameVariants,
      this.structure,
      this.aksharasCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_variants'] = Variable<String>(nameVariants);
    if (!nullToAbsent || structure != null) {
      map['structure'] = Variable<String>(structure);
    }
    if (!nullToAbsent || aksharasCount != null) {
      map['aksharas_count'] = Variable<int>(aksharasCount);
    }
    return map;
  }

  TalasCompanion toCompanion(bool nullToAbsent) {
    return TalasCompanion(
      id: Value(id),
      name: Value(name),
      nameVariants: Value(nameVariants),
      structure: structure == null && nullToAbsent
          ? const Value.absent()
          : Value(structure),
      aksharasCount: aksharasCount == null && nullToAbsent
          ? const Value.absent()
          : Value(aksharasCount),
    );
  }

  factory Tala.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tala(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameVariants: serializer.fromJson<String>(json['nameVariants']),
      structure: serializer.fromJson<String?>(json['structure']),
      aksharasCount: serializer.fromJson<int?>(json['aksharasCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameVariants': serializer.toJson<String>(nameVariants),
      'structure': serializer.toJson<String?>(structure),
      'aksharasCount': serializer.toJson<int?>(aksharasCount),
    };
  }

  Tala copyWith(
          {int? id,
          String? name,
          String? nameVariants,
          Value<String?> structure = const Value.absent(),
          Value<int?> aksharasCount = const Value.absent()}) =>
      Tala(
        id: id ?? this.id,
        name: name ?? this.name,
        nameVariants: nameVariants ?? this.nameVariants,
        structure: structure.present ? structure.value : this.structure,
        aksharasCount:
            aksharasCount.present ? aksharasCount.value : this.aksharasCount,
      );
  Tala copyWithCompanion(TalasCompanion data) {
    return Tala(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameVariants: data.nameVariants.present
          ? data.nameVariants.value
          : this.nameVariants,
      structure: data.structure.present ? data.structure.value : this.structure,
      aksharasCount: data.aksharasCount.present
          ? data.aksharasCount.value
          : this.aksharasCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tala(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('structure: $structure, ')
          ..write('aksharasCount: $aksharasCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameVariants, structure, aksharasCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tala &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameVariants == this.nameVariants &&
          other.structure == this.structure &&
          other.aksharasCount == this.aksharasCount);
}

class TalasCompanion extends UpdateCompanion<Tala> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameVariants;
  final Value<String?> structure;
  final Value<int?> aksharasCount;
  const TalasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameVariants = const Value.absent(),
    this.structure = const Value.absent(),
    this.aksharasCount = const Value.absent(),
  });
  TalasCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameVariants = const Value.absent(),
    this.structure = const Value.absent(),
    this.aksharasCount = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tala> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameVariants,
    Expression<String>? structure,
    Expression<int>? aksharasCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameVariants != null) 'name_variants': nameVariants,
      if (structure != null) 'structure': structure,
      if (aksharasCount != null) 'aksharas_count': aksharasCount,
    });
  }

  TalasCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nameVariants,
      Value<String?>? structure,
      Value<int?>? aksharasCount}) {
    return TalasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVariants: nameVariants ?? this.nameVariants,
      structure: structure ?? this.structure,
      aksharasCount: aksharasCount ?? this.aksharasCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameVariants.present) {
      map['name_variants'] = Variable<String>(nameVariants.value);
    }
    if (structure.present) {
      map['structure'] = Variable<String>(structure.value);
    }
    if (aksharasCount.present) {
      map['aksharas_count'] = Variable<int>(aksharasCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('structure: $structure, ')
          ..write('aksharasCount: $aksharasCount')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameVariantsMeta =
      const VerificationMeta('nameVariants');
  @override
  late final GeneratedColumn<String> nameVariants = GeneratedColumn<String>(
      'name_variants', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _instrumentMeta =
      const VerificationMeta('instrument');
  @override
  late final GeneratedColumn<String> instrument = GeneratedColumn<String>(
      'instrument', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _biographyMeta =
      const VerificationMeta('biography');
  @override
  late final GeneratedColumn<String> biography = GeneratedColumn<String>(
      'biography', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameVariants, instrument, biography, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(Insertable<Artist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_variants')) {
      context.handle(
          _nameVariantsMeta,
          nameVariants.isAcceptableOrUnknown(
              data['name_variants']!, _nameVariantsMeta));
    }
    if (data.containsKey('instrument')) {
      context.handle(
          _instrumentMeta,
          instrument.isAcceptableOrUnknown(
              data['instrument']!, _instrumentMeta));
    }
    if (data.containsKey('biography')) {
      context.handle(_biographyMeta,
          biography.isAcceptableOrUnknown(data['biography']!, _biographyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_variants'])!,
      instrument: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instrument']),
      biography: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}biography']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;

  /// Canonical display name, e.g. "T.M. Krishna"
  final String name;

  /// JSON array — e.g. '["TM Krishna","TMK","T M Krishna"]'
  final String nameVariants;

  /// vocal | violin | mridangam | flute | veena | other
  final String? instrument;
  final String? biography;
  final DateTime createdAt;
  const Artist(
      {required this.id,
      required this.name,
      required this.nameVariants,
      this.instrument,
      this.biography,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_variants'] = Variable<String>(nameVariants);
    if (!nullToAbsent || instrument != null) {
      map['instrument'] = Variable<String>(instrument);
    }
    if (!nullToAbsent || biography != null) {
      map['biography'] = Variable<String>(biography);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      name: Value(name),
      nameVariants: Value(nameVariants),
      instrument: instrument == null && nullToAbsent
          ? const Value.absent()
          : Value(instrument),
      biography: biography == null && nullToAbsent
          ? const Value.absent()
          : Value(biography),
      createdAt: Value(createdAt),
    );
  }

  factory Artist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameVariants: serializer.fromJson<String>(json['nameVariants']),
      instrument: serializer.fromJson<String?>(json['instrument']),
      biography: serializer.fromJson<String?>(json['biography']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameVariants': serializer.toJson<String>(nameVariants),
      'instrument': serializer.toJson<String?>(instrument),
      'biography': serializer.toJson<String?>(biography),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Artist copyWith(
          {int? id,
          String? name,
          String? nameVariants,
          Value<String?> instrument = const Value.absent(),
          Value<String?> biography = const Value.absent(),
          DateTime? createdAt}) =>
      Artist(
        id: id ?? this.id,
        name: name ?? this.name,
        nameVariants: nameVariants ?? this.nameVariants,
        instrument: instrument.present ? instrument.value : this.instrument,
        biography: biography.present ? biography.value : this.biography,
        createdAt: createdAt ?? this.createdAt,
      );
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameVariants: data.nameVariants.present
          ? data.nameVariants.value
          : this.nameVariants,
      instrument:
          data.instrument.present ? data.instrument.value : this.instrument,
      biography: data.biography.present ? data.biography.value : this.biography,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('instrument: $instrument, ')
          ..write('biography: $biography, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameVariants, instrument, biography, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameVariants == this.nameVariants &&
          other.instrument == this.instrument &&
          other.biography == this.biography &&
          other.createdAt == this.createdAt);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameVariants;
  final Value<String?> instrument;
  final Value<String?> biography;
  final Value<DateTime> createdAt;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameVariants = const Value.absent(),
    this.instrument = const Value.absent(),
    this.biography = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameVariants = const Value.absent(),
    this.instrument = const Value.absent(),
    this.biography = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameVariants,
    Expression<String>? instrument,
    Expression<String>? biography,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameVariants != null) 'name_variants': nameVariants,
      if (instrument != null) 'instrument': instrument,
      if (biography != null) 'biography': biography,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ArtistsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nameVariants,
      Value<String?>? instrument,
      Value<String?>? biography,
      Value<DateTime>? createdAt}) {
    return ArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameVariants: nameVariants ?? this.nameVariants,
      instrument: instrument ?? this.instrument,
      biography: biography ?? this.biography,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameVariants.present) {
      map['name_variants'] = Variable<String>(nameVariants.value);
    }
    if (instrument.present) {
      map['instrument'] = Variable<String>(instrument.value);
    }
    if (biography.present) {
      map['biography'] = Variable<String>(biography.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameVariants: $nameVariants, ')
          ..write('instrument: $instrument, ')
          ..write('biography: $biography, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KrithisTable extends Krithis with TableInfo<$KrithisTable, Krithi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KrithisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _searchTokensMeta =
      const VerificationMeta('searchTokens');
  @override
  late final GeneratedColumn<String> searchTokens = GeneratedColumn<String>(
      'search_tokens', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _composerIdMeta =
      const VerificationMeta('composerId');
  @override
  late final GeneratedColumn<int> composerId = GeneratedColumn<int>(
      'composer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES composers(id)');
  static const VerificationMeta _ragaIdMeta = const VerificationMeta('ragaId');
  @override
  late final GeneratedColumn<int> ragaId = GeneratedColumn<int>(
      'raga_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES ragas(id)');
  static const VerificationMeta _talaIdMeta = const VerificationMeta('talaId');
  @override
  late final GeneratedColumn<int> talaId = GeneratedColumn<int>(
      'tala_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES talas(id)');
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _compositionTypeMeta =
      const VerificationMeta('compositionType');
  @override
  late final GeneratedColumn<String> compositionType = GeneratedColumn<String>(
      'composition_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pallaviMeta =
      const VerificationMeta('pallavi');
  @override
  late final GeneratedColumn<String> pallavi = GeneratedColumn<String>(
      'pallavi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _anupallaviMeta =
      const VerificationMeta('anupallavi');
  @override
  late final GeneratedColumn<String> anupallavi = GeneratedColumn<String>(
      'anupallavi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _charanamMeta =
      const VerificationMeta('charanam');
  @override
  late final GeneratedColumn<String> charanam = GeneratedColumn<String>(
      'charanam', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        searchTokens,
        composerId,
        ragaId,
        talaId,
        language,
        compositionType,
        pallavi,
        anupallavi,
        charanam,
        sourceUrl,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'krithis';
  @override
  VerificationContext validateIntegrity(Insertable<Krithi> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('search_tokens')) {
      context.handle(
          _searchTokensMeta,
          searchTokens.isAcceptableOrUnknown(
              data['search_tokens']!, _searchTokensMeta));
    }
    if (data.containsKey('composer_id')) {
      context.handle(
          _composerIdMeta,
          composerId.isAcceptableOrUnknown(
              data['composer_id']!, _composerIdMeta));
    } else if (isInserting) {
      context.missing(_composerIdMeta);
    }
    if (data.containsKey('raga_id')) {
      context.handle(_ragaIdMeta,
          ragaId.isAcceptableOrUnknown(data['raga_id']!, _ragaIdMeta));
    } else if (isInserting) {
      context.missing(_ragaIdMeta);
    }
    if (data.containsKey('tala_id')) {
      context.handle(_talaIdMeta,
          talaId.isAcceptableOrUnknown(data['tala_id']!, _talaIdMeta));
    } else if (isInserting) {
      context.missing(_talaIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('composition_type')) {
      context.handle(
          _compositionTypeMeta,
          compositionType.isAcceptableOrUnknown(
              data['composition_type']!, _compositionTypeMeta));
    } else if (isInserting) {
      context.missing(_compositionTypeMeta);
    }
    if (data.containsKey('pallavi')) {
      context.handle(_pallaviMeta,
          pallavi.isAcceptableOrUnknown(data['pallavi']!, _pallaviMeta));
    } else if (isInserting) {
      context.missing(_pallaviMeta);
    }
    if (data.containsKey('anupallavi')) {
      context.handle(
          _anupallaviMeta,
          anupallavi.isAcceptableOrUnknown(
              data['anupallavi']!, _anupallaviMeta));
    }
    if (data.containsKey('charanam')) {
      context.handle(_charanamMeta,
          charanam.isAcceptableOrUnknown(data['charanam']!, _charanamMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Krithi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Krithi(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      searchTokens: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_tokens']),
      composerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}composer_id'])!,
      ragaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}raga_id'])!,
      talaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tala_id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      compositionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}composition_type'])!,
      pallavi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pallavi'])!,
      anupallavi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}anupallavi']),
      charanam: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}charanam']),
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $KrithisTable createAlias(String alias) {
    return $KrithisTable(attachedDatabase, alias);
  }
}

class Krithi extends DataClass implements Insertable<Krithi> {
  final int id;

  /// Transliterated English name, e.g. "Nagumomu Ganaleni"
  final String name;

  /// Normalized + variant spellings joined as a single string for FTS indexing.
  /// Populated during the data pipeline (Session 2 / Session 3).
  final String? searchTokens;
  final int composerId;
  final int ragaId;
  final int talaId;

  /// telugu | sanskrit | tamil | kannada | other
  final String language;

  /// krithi | varnam | geetam | swarajati | other
  final String compositionType;

  /// Opening section of the lyrics (always present).
  final String pallavi;

  /// Second section (may be absent in some compositions).
  final String? anupallavi;

  /// Verse(s) — full text; may contain multiple charanams separated by line
  /// breaks or markers. Nullable for compositions that only have a pallavi.
  final String? charanam;

  /// Source page, e.g. "https://www.karnatik.com/c1000.shtml"
  final String? sourceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Krithi(
      {required this.id,
      required this.name,
      this.searchTokens,
      required this.composerId,
      required this.ragaId,
      required this.talaId,
      required this.language,
      required this.compositionType,
      required this.pallavi,
      this.anupallavi,
      this.charanam,
      this.sourceUrl,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || searchTokens != null) {
      map['search_tokens'] = Variable<String>(searchTokens);
    }
    map['composer_id'] = Variable<int>(composerId);
    map['raga_id'] = Variable<int>(ragaId);
    map['tala_id'] = Variable<int>(talaId);
    map['language'] = Variable<String>(language);
    map['composition_type'] = Variable<String>(compositionType);
    map['pallavi'] = Variable<String>(pallavi);
    if (!nullToAbsent || anupallavi != null) {
      map['anupallavi'] = Variable<String>(anupallavi);
    }
    if (!nullToAbsent || charanam != null) {
      map['charanam'] = Variable<String>(charanam);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KrithisCompanion toCompanion(bool nullToAbsent) {
    return KrithisCompanion(
      id: Value(id),
      name: Value(name),
      searchTokens: searchTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(searchTokens),
      composerId: Value(composerId),
      ragaId: Value(ragaId),
      talaId: Value(talaId),
      language: Value(language),
      compositionType: Value(compositionType),
      pallavi: Value(pallavi),
      anupallavi: anupallavi == null && nullToAbsent
          ? const Value.absent()
          : Value(anupallavi),
      charanam: charanam == null && nullToAbsent
          ? const Value.absent()
          : Value(charanam),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Krithi.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Krithi(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      searchTokens: serializer.fromJson<String?>(json['searchTokens']),
      composerId: serializer.fromJson<int>(json['composerId']),
      ragaId: serializer.fromJson<int>(json['ragaId']),
      talaId: serializer.fromJson<int>(json['talaId']),
      language: serializer.fromJson<String>(json['language']),
      compositionType: serializer.fromJson<String>(json['compositionType']),
      pallavi: serializer.fromJson<String>(json['pallavi']),
      anupallavi: serializer.fromJson<String?>(json['anupallavi']),
      charanam: serializer.fromJson<String?>(json['charanam']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'searchTokens': serializer.toJson<String?>(searchTokens),
      'composerId': serializer.toJson<int>(composerId),
      'ragaId': serializer.toJson<int>(ragaId),
      'talaId': serializer.toJson<int>(talaId),
      'language': serializer.toJson<String>(language),
      'compositionType': serializer.toJson<String>(compositionType),
      'pallavi': serializer.toJson<String>(pallavi),
      'anupallavi': serializer.toJson<String?>(anupallavi),
      'charanam': serializer.toJson<String?>(charanam),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Krithi copyWith(
          {int? id,
          String? name,
          Value<String?> searchTokens = const Value.absent(),
          int? composerId,
          int? ragaId,
          int? talaId,
          String? language,
          String? compositionType,
          String? pallavi,
          Value<String?> anupallavi = const Value.absent(),
          Value<String?> charanam = const Value.absent(),
          Value<String?> sourceUrl = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Krithi(
        id: id ?? this.id,
        name: name ?? this.name,
        searchTokens:
            searchTokens.present ? searchTokens.value : this.searchTokens,
        composerId: composerId ?? this.composerId,
        ragaId: ragaId ?? this.ragaId,
        talaId: talaId ?? this.talaId,
        language: language ?? this.language,
        compositionType: compositionType ?? this.compositionType,
        pallavi: pallavi ?? this.pallavi,
        anupallavi: anupallavi.present ? anupallavi.value : this.anupallavi,
        charanam: charanam.present ? charanam.value : this.charanam,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Krithi copyWithCompanion(KrithisCompanion data) {
    return Krithi(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      searchTokens: data.searchTokens.present
          ? data.searchTokens.value
          : this.searchTokens,
      composerId:
          data.composerId.present ? data.composerId.value : this.composerId,
      ragaId: data.ragaId.present ? data.ragaId.value : this.ragaId,
      talaId: data.talaId.present ? data.talaId.value : this.talaId,
      language: data.language.present ? data.language.value : this.language,
      compositionType: data.compositionType.present
          ? data.compositionType.value
          : this.compositionType,
      pallavi: data.pallavi.present ? data.pallavi.value : this.pallavi,
      anupallavi:
          data.anupallavi.present ? data.anupallavi.value : this.anupallavi,
      charanam: data.charanam.present ? data.charanam.value : this.charanam,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Krithi(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchTokens: $searchTokens, ')
          ..write('composerId: $composerId, ')
          ..write('ragaId: $ragaId, ')
          ..write('talaId: $talaId, ')
          ..write('language: $language, ')
          ..write('compositionType: $compositionType, ')
          ..write('pallavi: $pallavi, ')
          ..write('anupallavi: $anupallavi, ')
          ..write('charanam: $charanam, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      searchTokens,
      composerId,
      ragaId,
      talaId,
      language,
      compositionType,
      pallavi,
      anupallavi,
      charanam,
      sourceUrl,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Krithi &&
          other.id == this.id &&
          other.name == this.name &&
          other.searchTokens == this.searchTokens &&
          other.composerId == this.composerId &&
          other.ragaId == this.ragaId &&
          other.talaId == this.talaId &&
          other.language == this.language &&
          other.compositionType == this.compositionType &&
          other.pallavi == this.pallavi &&
          other.anupallavi == this.anupallavi &&
          other.charanam == this.charanam &&
          other.sourceUrl == this.sourceUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KrithisCompanion extends UpdateCompanion<Krithi> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> searchTokens;
  final Value<int> composerId;
  final Value<int> ragaId;
  final Value<int> talaId;
  final Value<String> language;
  final Value<String> compositionType;
  final Value<String> pallavi;
  final Value<String?> anupallavi;
  final Value<String?> charanam;
  final Value<String?> sourceUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KrithisCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.searchTokens = const Value.absent(),
    this.composerId = const Value.absent(),
    this.ragaId = const Value.absent(),
    this.talaId = const Value.absent(),
    this.language = const Value.absent(),
    this.compositionType = const Value.absent(),
    this.pallavi = const Value.absent(),
    this.anupallavi = const Value.absent(),
    this.charanam = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KrithisCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.searchTokens = const Value.absent(),
    required int composerId,
    required int ragaId,
    required int talaId,
    required String language,
    required String compositionType,
    required String pallavi,
    this.anupallavi = const Value.absent(),
    this.charanam = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        composerId = Value(composerId),
        ragaId = Value(ragaId),
        talaId = Value(talaId),
        language = Value(language),
        compositionType = Value(compositionType),
        pallavi = Value(pallavi);
  static Insertable<Krithi> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? searchTokens,
    Expression<int>? composerId,
    Expression<int>? ragaId,
    Expression<int>? talaId,
    Expression<String>? language,
    Expression<String>? compositionType,
    Expression<String>? pallavi,
    Expression<String>? anupallavi,
    Expression<String>? charanam,
    Expression<String>? sourceUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (searchTokens != null) 'search_tokens': searchTokens,
      if (composerId != null) 'composer_id': composerId,
      if (ragaId != null) 'raga_id': ragaId,
      if (talaId != null) 'tala_id': talaId,
      if (language != null) 'language': language,
      if (compositionType != null) 'composition_type': compositionType,
      if (pallavi != null) 'pallavi': pallavi,
      if (anupallavi != null) 'anupallavi': anupallavi,
      if (charanam != null) 'charanam': charanam,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KrithisCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? searchTokens,
      Value<int>? composerId,
      Value<int>? ragaId,
      Value<int>? talaId,
      Value<String>? language,
      Value<String>? compositionType,
      Value<String>? pallavi,
      Value<String?>? anupallavi,
      Value<String?>? charanam,
      Value<String?>? sourceUrl,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return KrithisCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      searchTokens: searchTokens ?? this.searchTokens,
      composerId: composerId ?? this.composerId,
      ragaId: ragaId ?? this.ragaId,
      talaId: talaId ?? this.talaId,
      language: language ?? this.language,
      compositionType: compositionType ?? this.compositionType,
      pallavi: pallavi ?? this.pallavi,
      anupallavi: anupallavi ?? this.anupallavi,
      charanam: charanam ?? this.charanam,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (searchTokens.present) {
      map['search_tokens'] = Variable<String>(searchTokens.value);
    }
    if (composerId.present) {
      map['composer_id'] = Variable<int>(composerId.value);
    }
    if (ragaId.present) {
      map['raga_id'] = Variable<int>(ragaId.value);
    }
    if (talaId.present) {
      map['tala_id'] = Variable<int>(talaId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (compositionType.present) {
      map['composition_type'] = Variable<String>(compositionType.value);
    }
    if (pallavi.present) {
      map['pallavi'] = Variable<String>(pallavi.value);
    }
    if (anupallavi.present) {
      map['anupallavi'] = Variable<String>(anupallavi.value);
    }
    if (charanam.present) {
      map['charanam'] = Variable<String>(charanam.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KrithisCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchTokens: $searchTokens, ')
          ..write('composerId: $composerId, ')
          ..write('ragaId: $ragaId, ')
          ..write('talaId: $talaId, ')
          ..write('language: $language, ')
          ..write('compositionType: $compositionType, ')
          ..write('pallavi: $pallavi, ')
          ..write('anupallavi: $anupallavi, ')
          ..write('charanam: $charanam, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SearchAliasesTable extends SearchAliases
    with TableInfo<$SearchAliasesTable, SearchAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, entityType, entityId, alias];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_aliases';
  @override
  VerificationContext validateIntegrity(Insertable<SearchAliase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchAliase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchAliase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
    );
  }

  @override
  $SearchAliasesTable createAlias(String alias) {
    return $SearchAliasesTable(attachedDatabase, alias);
  }
}

class SearchAliase extends DataClass implements Insertable<SearchAliase> {
  final int id;

  /// krithi | raga | composer | tala | artist
  final String entityType;

  /// ID in the corresponding entity table.
  final int entityId;

  /// The alternate spelling / abbreviation / misspelling.
  final String alias;
  const SearchAliase(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.alias});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['alias'] = Variable<String>(alias);
    return map;
  }

  SearchAliasesCompanion toCompanion(bool nullToAbsent) {
    return SearchAliasesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      alias: Value(alias),
    );
  }

  factory SearchAliase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchAliase(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      alias: serializer.fromJson<String>(json['alias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'alias': serializer.toJson<String>(alias),
    };
  }

  SearchAliase copyWith(
          {int? id, String? entityType, int? entityId, String? alias}) =>
      SearchAliase(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        alias: alias ?? this.alias,
      );
  SearchAliase copyWithCompanion(SearchAliasesCompanion data) {
    return SearchAliase(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      alias: data.alias.present ? data.alias.value : this.alias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchAliase(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchAliase &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.alias == this.alias);
}

class SearchAliasesCompanion extends UpdateCompanion<SearchAliase> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> alias;
  const SearchAliasesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.alias = const Value.absent(),
  });
  SearchAliasesCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityId,
    required String alias,
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        alias = Value(alias);
  static Insertable<SearchAliase> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? alias,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (alias != null) 'alias': alias,
    });
  }

  SearchAliasesCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<int>? entityId,
      Value<String>? alias}) {
    return SearchAliasesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      alias: alias ?? this.alias,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchAliasesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('user'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, displayName, email, role, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String displayName;
  final String email;

  /// user | admin
  final String role;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.displayName,
      required this.email,
      required this.role,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      displayName: Value(displayName),
      email: Value(email),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? displayName,
          String? email,
          String? role,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, email, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> email;
  final Value<String> role;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String displayName,
    required String email,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : displayName = Value(displayName),
        email = Value(email);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? displayName,
      Value<String>? email,
      Value<String>? role,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ConcertsTable extends Concerts with TableInfo<$ConcertsTable, Concert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConcertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _krithiIdMeta =
      const VerificationMeta('krithiId');
  @override
  late final GeneratedColumn<int> krithiId = GeneratedColumn<int>(
      'krithi_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES krithis(id)');
  static const VerificationMeta _ragaIdMeta = const VerificationMeta('ragaId');
  @override
  late final GeneratedColumn<int> ragaId = GeneratedColumn<int>(
      'raga_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES ragas(id)');
  static const VerificationMeta _venueMeta = const VerificationMeta('venue');
  @override
  late final GeneratedColumn<String> venue = GeneratedColumn<String>(
      'venue', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sabhaNameMeta =
      const VerificationMeta('sabhaName');
  @override
  late final GeneratedColumn<String> sabhaName = GeneratedColumn<String>(
      'sabha_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _performanceDateMeta =
      const VerificationMeta('performanceDate');
  @override
  late final GeneratedColumn<DateTime> performanceDate =
      GeneratedColumn<DateTime>('performance_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _attendeeCountMeta =
      const VerificationMeta('attendeeCount');
  @override
  late final GeneratedColumn<int> attendeeCount = GeneratedColumn<int>(
      'attendee_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdByUserIdMeta =
      const VerificationMeta('createdByUserId');
  @override
  late final GeneratedColumn<int> createdByUserId = GeneratedColumn<int>(
      'created_by_user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES users(id)');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        krithiId,
        ragaId,
        venue,
        city,
        sabhaName,
        performanceDate,
        attendeeCount,
        status,
        createdByUserId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concerts';
  @override
  VerificationContext validateIntegrity(Insertable<Concert> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('krithi_id')) {
      context.handle(_krithiIdMeta,
          krithiId.isAcceptableOrUnknown(data['krithi_id']!, _krithiIdMeta));
    } else if (isInserting) {
      context.missing(_krithiIdMeta);
    }
    if (data.containsKey('raga_id')) {
      context.handle(_ragaIdMeta,
          ragaId.isAcceptableOrUnknown(data['raga_id']!, _ragaIdMeta));
    }
    if (data.containsKey('venue')) {
      context.handle(
          _venueMeta, venue.isAcceptableOrUnknown(data['venue']!, _venueMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('sabha_name')) {
      context.handle(_sabhaNameMeta,
          sabhaName.isAcceptableOrUnknown(data['sabha_name']!, _sabhaNameMeta));
    }
    if (data.containsKey('performance_date')) {
      context.handle(
          _performanceDateMeta,
          performanceDate.isAcceptableOrUnknown(
              data['performance_date']!, _performanceDateMeta));
    } else if (isInserting) {
      context.missing(_performanceDateMeta);
    }
    if (data.containsKey('attendee_count')) {
      context.handle(
          _attendeeCountMeta,
          attendeeCount.isAcceptableOrUnknown(
              data['attendee_count']!, _attendeeCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
          _createdByUserIdMeta,
          createdByUserId.isAcceptableOrUnknown(
              data['created_by_user_id']!, _createdByUserIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Concert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Concert(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      krithiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}krithi_id'])!,
      ragaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}raga_id']),
      venue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}venue']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      sabhaName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sabha_name']),
      performanceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}performance_date'])!,
      attendeeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attendee_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdByUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by_user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ConcertsTable createAlias(String alias) {
    return $ConcertsTable(attachedDatabase, alias);
  }
}

class Concert extends DataClass implements Insertable<Concert> {
  final int id;
  final int krithiId;

  /// Raga performed — may differ from the krithi default (manodharma raga).
  final int? ragaId;
  final String? venue;
  final String? city;
  final String? sabhaName;
  final DateTime performanceDate;

  /// Incremented when duplicate entries are merged (v2 logic).
  final int attendeeCount;

  /// active | flagged | removed
  final String status;
  final int? createdByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Concert(
      {required this.id,
      required this.krithiId,
      this.ragaId,
      this.venue,
      this.city,
      this.sabhaName,
      required this.performanceDate,
      required this.attendeeCount,
      required this.status,
      this.createdByUserId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['krithi_id'] = Variable<int>(krithiId);
    if (!nullToAbsent || ragaId != null) {
      map['raga_id'] = Variable<int>(ragaId);
    }
    if (!nullToAbsent || venue != null) {
      map['venue'] = Variable<String>(venue);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || sabhaName != null) {
      map['sabha_name'] = Variable<String>(sabhaName);
    }
    map['performance_date'] = Variable<DateTime>(performanceDate);
    map['attendee_count'] = Variable<int>(attendeeCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<int>(createdByUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConcertsCompanion toCompanion(bool nullToAbsent) {
    return ConcertsCompanion(
      id: Value(id),
      krithiId: Value(krithiId),
      ragaId:
          ragaId == null && nullToAbsent ? const Value.absent() : Value(ragaId),
      venue:
          venue == null && nullToAbsent ? const Value.absent() : Value(venue),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      sabhaName: sabhaName == null && nullToAbsent
          ? const Value.absent()
          : Value(sabhaName),
      performanceDate: Value(performanceDate),
      attendeeCount: Value(attendeeCount),
      status: Value(status),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Concert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Concert(
      id: serializer.fromJson<int>(json['id']),
      krithiId: serializer.fromJson<int>(json['krithiId']),
      ragaId: serializer.fromJson<int?>(json['ragaId']),
      venue: serializer.fromJson<String?>(json['venue']),
      city: serializer.fromJson<String?>(json['city']),
      sabhaName: serializer.fromJson<String?>(json['sabhaName']),
      performanceDate: serializer.fromJson<DateTime>(json['performanceDate']),
      attendeeCount: serializer.fromJson<int>(json['attendeeCount']),
      status: serializer.fromJson<String>(json['status']),
      createdByUserId: serializer.fromJson<int?>(json['createdByUserId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'krithiId': serializer.toJson<int>(krithiId),
      'ragaId': serializer.toJson<int?>(ragaId),
      'venue': serializer.toJson<String?>(venue),
      'city': serializer.toJson<String?>(city),
      'sabhaName': serializer.toJson<String?>(sabhaName),
      'performanceDate': serializer.toJson<DateTime>(performanceDate),
      'attendeeCount': serializer.toJson<int>(attendeeCount),
      'status': serializer.toJson<String>(status),
      'createdByUserId': serializer.toJson<int?>(createdByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Concert copyWith(
          {int? id,
          int? krithiId,
          Value<int?> ragaId = const Value.absent(),
          Value<String?> venue = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> sabhaName = const Value.absent(),
          DateTime? performanceDate,
          int? attendeeCount,
          String? status,
          Value<int?> createdByUserId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Concert(
        id: id ?? this.id,
        krithiId: krithiId ?? this.krithiId,
        ragaId: ragaId.present ? ragaId.value : this.ragaId,
        venue: venue.present ? venue.value : this.venue,
        city: city.present ? city.value : this.city,
        sabhaName: sabhaName.present ? sabhaName.value : this.sabhaName,
        performanceDate: performanceDate ?? this.performanceDate,
        attendeeCount: attendeeCount ?? this.attendeeCount,
        status: status ?? this.status,
        createdByUserId: createdByUserId.present
            ? createdByUserId.value
            : this.createdByUserId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Concert copyWithCompanion(ConcertsCompanion data) {
    return Concert(
      id: data.id.present ? data.id.value : this.id,
      krithiId: data.krithiId.present ? data.krithiId.value : this.krithiId,
      ragaId: data.ragaId.present ? data.ragaId.value : this.ragaId,
      venue: data.venue.present ? data.venue.value : this.venue,
      city: data.city.present ? data.city.value : this.city,
      sabhaName: data.sabhaName.present ? data.sabhaName.value : this.sabhaName,
      performanceDate: data.performanceDate.present
          ? data.performanceDate.value
          : this.performanceDate,
      attendeeCount: data.attendeeCount.present
          ? data.attendeeCount.value
          : this.attendeeCount,
      status: data.status.present ? data.status.value : this.status,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Concert(')
          ..write('id: $id, ')
          ..write('krithiId: $krithiId, ')
          ..write('ragaId: $ragaId, ')
          ..write('venue: $venue, ')
          ..write('city: $city, ')
          ..write('sabhaName: $sabhaName, ')
          ..write('performanceDate: $performanceDate, ')
          ..write('attendeeCount: $attendeeCount, ')
          ..write('status: $status, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      krithiId,
      ragaId,
      venue,
      city,
      sabhaName,
      performanceDate,
      attendeeCount,
      status,
      createdByUserId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Concert &&
          other.id == this.id &&
          other.krithiId == this.krithiId &&
          other.ragaId == this.ragaId &&
          other.venue == this.venue &&
          other.city == this.city &&
          other.sabhaName == this.sabhaName &&
          other.performanceDate == this.performanceDate &&
          other.attendeeCount == this.attendeeCount &&
          other.status == this.status &&
          other.createdByUserId == this.createdByUserId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConcertsCompanion extends UpdateCompanion<Concert> {
  final Value<int> id;
  final Value<int> krithiId;
  final Value<int?> ragaId;
  final Value<String?> venue;
  final Value<String?> city;
  final Value<String?> sabhaName;
  final Value<DateTime> performanceDate;
  final Value<int> attendeeCount;
  final Value<String> status;
  final Value<int?> createdByUserId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ConcertsCompanion({
    this.id = const Value.absent(),
    this.krithiId = const Value.absent(),
    this.ragaId = const Value.absent(),
    this.venue = const Value.absent(),
    this.city = const Value.absent(),
    this.sabhaName = const Value.absent(),
    this.performanceDate = const Value.absent(),
    this.attendeeCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ConcertsCompanion.insert({
    this.id = const Value.absent(),
    required int krithiId,
    this.ragaId = const Value.absent(),
    this.venue = const Value.absent(),
    this.city = const Value.absent(),
    this.sabhaName = const Value.absent(),
    required DateTime performanceDate,
    this.attendeeCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : krithiId = Value(krithiId),
        performanceDate = Value(performanceDate);
  static Insertable<Concert> custom({
    Expression<int>? id,
    Expression<int>? krithiId,
    Expression<int>? ragaId,
    Expression<String>? venue,
    Expression<String>? city,
    Expression<String>? sabhaName,
    Expression<DateTime>? performanceDate,
    Expression<int>? attendeeCount,
    Expression<String>? status,
    Expression<int>? createdByUserId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (krithiId != null) 'krithi_id': krithiId,
      if (ragaId != null) 'raga_id': ragaId,
      if (venue != null) 'venue': venue,
      if (city != null) 'city': city,
      if (sabhaName != null) 'sabha_name': sabhaName,
      if (performanceDate != null) 'performance_date': performanceDate,
      if (attendeeCount != null) 'attendee_count': attendeeCount,
      if (status != null) 'status': status,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ConcertsCompanion copyWith(
      {Value<int>? id,
      Value<int>? krithiId,
      Value<int?>? ragaId,
      Value<String?>? venue,
      Value<String?>? city,
      Value<String?>? sabhaName,
      Value<DateTime>? performanceDate,
      Value<int>? attendeeCount,
      Value<String>? status,
      Value<int?>? createdByUserId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ConcertsCompanion(
      id: id ?? this.id,
      krithiId: krithiId ?? this.krithiId,
      ragaId: ragaId ?? this.ragaId,
      venue: venue ?? this.venue,
      city: city ?? this.city,
      sabhaName: sabhaName ?? this.sabhaName,
      performanceDate: performanceDate ?? this.performanceDate,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      status: status ?? this.status,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (krithiId.present) {
      map['krithi_id'] = Variable<int>(krithiId.value);
    }
    if (ragaId.present) {
      map['raga_id'] = Variable<int>(ragaId.value);
    }
    if (venue.present) {
      map['venue'] = Variable<String>(venue.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (sabhaName.present) {
      map['sabha_name'] = Variable<String>(sabhaName.value);
    }
    if (performanceDate.present) {
      map['performance_date'] = Variable<DateTime>(performanceDate.value);
    }
    if (attendeeCount.present) {
      map['attendee_count'] = Variable<int>(attendeeCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<int>(createdByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConcertsCompanion(')
          ..write('id: $id, ')
          ..write('krithiId: $krithiId, ')
          ..write('ragaId: $ragaId, ')
          ..write('venue: $venue, ')
          ..write('city: $city, ')
          ..write('sabhaName: $sabhaName, ')
          ..write('performanceDate: $performanceDate, ')
          ..write('attendeeCount: $attendeeCount, ')
          ..write('status: $status, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ConcertArtistsTable extends ConcertArtists
    with TableInfo<$ConcertArtistsTable, ConcertArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConcertArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _concertIdMeta =
      const VerificationMeta('concertId');
  @override
  late final GeneratedColumn<int> concertId = GeneratedColumn<int>(
      'concert_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES concerts(id)');
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES artists(id)');
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, concertId, artistId, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concert_artists';
  @override
  VerificationContext validateIntegrity(Insertable<ConcertArtist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concert_id')) {
      context.handle(_concertIdMeta,
          concertId.isAcceptableOrUnknown(data['concert_id']!, _concertIdMeta));
    } else if (isInserting) {
      context.missing(_concertIdMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConcertArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConcertArtist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      concertId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}concert_id'])!,
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role']),
    );
  }

  @override
  $ConcertArtistsTable createAlias(String alias) {
    return $ConcertArtistsTable(attachedDatabase, alias);
  }
}

class ConcertArtist extends DataClass implements Insertable<ConcertArtist> {
  final int id;
  final int concertId;
  final int artistId;

  /// main | accompanist (optional role label)
  final String? role;
  const ConcertArtist(
      {required this.id,
      required this.concertId,
      required this.artistId,
      this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concert_id'] = Variable<int>(concertId);
    map['artist_id'] = Variable<int>(artistId);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    return map;
  }

  ConcertArtistsCompanion toCompanion(bool nullToAbsent) {
    return ConcertArtistsCompanion(
      id: Value(id),
      concertId: Value(concertId),
      artistId: Value(artistId),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
    );
  }

  factory ConcertArtist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConcertArtist(
      id: serializer.fromJson<int>(json['id']),
      concertId: serializer.fromJson<int>(json['concertId']),
      artistId: serializer.fromJson<int>(json['artistId']),
      role: serializer.fromJson<String?>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concertId': serializer.toJson<int>(concertId),
      'artistId': serializer.toJson<int>(artistId),
      'role': serializer.toJson<String?>(role),
    };
  }

  ConcertArtist copyWith(
          {int? id,
          int? concertId,
          int? artistId,
          Value<String?> role = const Value.absent()}) =>
      ConcertArtist(
        id: id ?? this.id,
        concertId: concertId ?? this.concertId,
        artistId: artistId ?? this.artistId,
        role: role.present ? role.value : this.role,
      );
  ConcertArtist copyWithCompanion(ConcertArtistsCompanion data) {
    return ConcertArtist(
      id: data.id.present ? data.id.value : this.id,
      concertId: data.concertId.present ? data.concertId.value : this.concertId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConcertArtist(')
          ..write('id: $id, ')
          ..write('concertId: $concertId, ')
          ..write('artistId: $artistId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concertId, artistId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConcertArtist &&
          other.id == this.id &&
          other.concertId == this.concertId &&
          other.artistId == this.artistId &&
          other.role == this.role);
}

class ConcertArtistsCompanion extends UpdateCompanion<ConcertArtist> {
  final Value<int> id;
  final Value<int> concertId;
  final Value<int> artistId;
  final Value<String?> role;
  const ConcertArtistsCompanion({
    this.id = const Value.absent(),
    this.concertId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.role = const Value.absent(),
  });
  ConcertArtistsCompanion.insert({
    this.id = const Value.absent(),
    required int concertId,
    required int artistId,
    this.role = const Value.absent(),
  })  : concertId = Value(concertId),
        artistId = Value(artistId);
  static Insertable<ConcertArtist> custom({
    Expression<int>? id,
    Expression<int>? concertId,
    Expression<int>? artistId,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concertId != null) 'concert_id': concertId,
      if (artistId != null) 'artist_id': artistId,
      if (role != null) 'role': role,
    });
  }

  ConcertArtistsCompanion copyWith(
      {Value<int>? id,
      Value<int>? concertId,
      Value<int>? artistId,
      Value<String?>? role}) {
    return ConcertArtistsCompanion(
      id: id ?? this.id,
      concertId: concertId ?? this.concertId,
      artistId: artistId ?? this.artistId,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concertId.present) {
      map['concert_id'] = Variable<int>(concertId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConcertArtistsCompanion(')
          ..write('id: $id, ')
          ..write('concertId: $concertId, ')
          ..write('artistId: $artistId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $ConcertAttendeesTable extends ConcertAttendees
    with TableInfo<$ConcertAttendeesTable, ConcertAttendee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConcertAttendeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _concertIdMeta =
      const VerificationMeta('concertId');
  @override
  late final GeneratedColumn<int> concertId = GeneratedColumn<int>(
      'concert_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES concerts(id)');
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES users(id)');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, concertId, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concert_attendees';
  @override
  VerificationContext validateIntegrity(Insertable<ConcertAttendee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concert_id')) {
      context.handle(_concertIdMeta,
          concertId.isAcceptableOrUnknown(data['concert_id']!, _concertIdMeta));
    } else if (isInserting) {
      context.missing(_concertIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {concertId, userId},
      ];
  @override
  ConcertAttendee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConcertAttendee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      concertId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}concert_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ConcertAttendeesTable createAlias(String alias) {
    return $ConcertAttendeesTable(attachedDatabase, alias);
  }
}

class ConcertAttendee extends DataClass implements Insertable<ConcertAttendee> {
  final int id;
  final int concertId;
  final int userId;
  final DateTime createdAt;
  const ConcertAttendee(
      {required this.id,
      required this.concertId,
      required this.userId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concert_id'] = Variable<int>(concertId);
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ConcertAttendeesCompanion toCompanion(bool nullToAbsent) {
    return ConcertAttendeesCompanion(
      id: Value(id),
      concertId: Value(concertId),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory ConcertAttendee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConcertAttendee(
      id: serializer.fromJson<int>(json['id']),
      concertId: serializer.fromJson<int>(json['concertId']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concertId': serializer.toJson<int>(concertId),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ConcertAttendee copyWith(
          {int? id, int? concertId, int? userId, DateTime? createdAt}) =>
      ConcertAttendee(
        id: id ?? this.id,
        concertId: concertId ?? this.concertId,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
      );
  ConcertAttendee copyWithCompanion(ConcertAttendeesCompanion data) {
    return ConcertAttendee(
      id: data.id.present ? data.id.value : this.id,
      concertId: data.concertId.present ? data.concertId.value : this.concertId,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConcertAttendee(')
          ..write('id: $id, ')
          ..write('concertId: $concertId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concertId, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConcertAttendee &&
          other.id == this.id &&
          other.concertId == this.concertId &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class ConcertAttendeesCompanion extends UpdateCompanion<ConcertAttendee> {
  final Value<int> id;
  final Value<int> concertId;
  final Value<int> userId;
  final Value<DateTime> createdAt;
  const ConcertAttendeesCompanion({
    this.id = const Value.absent(),
    this.concertId = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ConcertAttendeesCompanion.insert({
    this.id = const Value.absent(),
    required int concertId,
    required int userId,
    this.createdAt = const Value.absent(),
  })  : concertId = Value(concertId),
        userId = Value(userId);
  static Insertable<ConcertAttendee> custom({
    Expression<int>? id,
    Expression<int>? concertId,
    Expression<int>? userId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concertId != null) 'concert_id': concertId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ConcertAttendeesCompanion copyWith(
      {Value<int>? id,
      Value<int>? concertId,
      Value<int>? userId,
      Value<DateTime>? createdAt}) {
    return ConcertAttendeesCompanion(
      id: id ?? this.id,
      concertId: concertId ?? this.concertId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concertId.present) {
      map['concert_id'] = Variable<int>(concertId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConcertAttendeesCompanion(')
          ..write('id: $id, ')
          ..write('concertId: $concertId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _krithiIdMeta =
      const VerificationMeta('krithiId');
  @override
  late final GeneratedColumn<int> krithiId = GeneratedColumn<int>(
      'krithi_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL REFERENCES krithis(id)');
  static const VerificationMeta _bookmarkedAtMeta =
      const VerificationMeta('bookmarkedAt');
  @override
  late final GeneratedColumn<DateTime> bookmarkedAt = GeneratedColumn<DateTime>(
      'bookmarked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [krithiId, bookmarkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<Bookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('krithi_id')) {
      context.handle(_krithiIdMeta,
          krithiId.isAcceptableOrUnknown(data['krithi_id']!, _krithiIdMeta));
    }
    if (data.containsKey('bookmarked_at')) {
      context.handle(
          _bookmarkedAtMeta,
          bookmarkedAt.isAcceptableOrUnknown(
              data['bookmarked_at']!, _bookmarkedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {krithiId};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      krithiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}krithi_id'])!,
      bookmarkedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}bookmarked_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  /// Bookmarks use krithiId as the natural primary key — one bookmark per krithi.
  final int krithiId;
  final DateTime bookmarkedAt;
  const Bookmark({required this.krithiId, required this.bookmarkedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['krithi_id'] = Variable<int>(krithiId);
    map['bookmarked_at'] = Variable<DateTime>(bookmarkedAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      krithiId: Value(krithiId),
      bookmarkedAt: Value(bookmarkedAt),
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      krithiId: serializer.fromJson<int>(json['krithiId']),
      bookmarkedAt: serializer.fromJson<DateTime>(json['bookmarkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'krithiId': serializer.toJson<int>(krithiId),
      'bookmarkedAt': serializer.toJson<DateTime>(bookmarkedAt),
    };
  }

  Bookmark copyWith({int? krithiId, DateTime? bookmarkedAt}) => Bookmark(
        krithiId: krithiId ?? this.krithiId,
        bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
      );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      krithiId: data.krithiId.present ? data.krithiId.value : this.krithiId,
      bookmarkedAt: data.bookmarkedAt.present
          ? data.bookmarkedAt.value
          : this.bookmarkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('krithiId: $krithiId, ')
          ..write('bookmarkedAt: $bookmarkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(krithiId, bookmarkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.krithiId == this.krithiId &&
          other.bookmarkedAt == this.bookmarkedAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> krithiId;
  final Value<DateTime> bookmarkedAt;
  const BookmarksCompanion({
    this.krithiId = const Value.absent(),
    this.bookmarkedAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.krithiId = const Value.absent(),
    this.bookmarkedAt = const Value.absent(),
  });
  static Insertable<Bookmark> custom({
    Expression<int>? krithiId,
    Expression<DateTime>? bookmarkedAt,
  }) {
    return RawValuesInsertable({
      if (krithiId != null) 'krithi_id': krithiId,
      if (bookmarkedAt != null) 'bookmarked_at': bookmarkedAt,
    });
  }

  BookmarksCompanion copyWith(
      {Value<int>? krithiId, Value<DateTime>? bookmarkedAt}) {
    return BookmarksCompanion(
      krithiId: krithiId ?? this.krithiId,
      bookmarkedAt: bookmarkedAt ?? this.bookmarkedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (krithiId.present) {
      map['krithi_id'] = Variable<int>(krithiId.value);
    }
    if (bookmarkedAt.present) {
      map['bookmarked_at'] = Variable<DateTime>(bookmarkedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('krithiId: $krithiId, ')
          ..write('bookmarkedAt: $bookmarkedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ComposersTable composers = $ComposersTable(this);
  late final $RagasTable ragas = $RagasTable(this);
  late final $TalasTable talas = $TalasTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $KrithisTable krithis = $KrithisTable(this);
  late final $SearchAliasesTable searchAliases = $SearchAliasesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ConcertsTable concerts = $ConcertsTable(this);
  late final $ConcertArtistsTable concertArtists = $ConcertArtistsTable(this);
  late final $ConcertAttendeesTable concertAttendees =
      $ConcertAttendeesTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        composers,
        ragas,
        talas,
        artists,
        krithis,
        searchAliases,
        users,
        concerts,
        concertArtists,
        concertAttendees,
        bookmarks
      ];
}

typedef $$ComposersTableCreateCompanionBuilder = ComposersCompanion Function({
  Value<int> id,
  required String name,
  Value<String> nameVariants,
  Value<String?> era,
  Value<String?> biography,
  Value<String?> languageOfCompositions,
});
typedef $$ComposersTableUpdateCompanionBuilder = ComposersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nameVariants,
  Value<String?> era,
  Value<String?> biography,
  Value<String?> languageOfCompositions,
});

class $$ComposersTableFilterComposer
    extends Composer<_$AppDatabase, $ComposersTable> {
  $$ComposersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get era => $composableBuilder(
      column: $table.era, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get biography => $composableBuilder(
      column: $table.biography, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageOfCompositions => $composableBuilder(
      column: $table.languageOfCompositions,
      builder: (column) => ColumnFilters(column));
}

class $$ComposersTableOrderingComposer
    extends Composer<_$AppDatabase, $ComposersTable> {
  $$ComposersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get era => $composableBuilder(
      column: $table.era, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get biography => $composableBuilder(
      column: $table.biography, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageOfCompositions => $composableBuilder(
      column: $table.languageOfCompositions,
      builder: (column) => ColumnOrderings(column));
}

class $$ComposersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComposersTable> {
  $$ComposersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => column);

  GeneratedColumn<String> get era =>
      $composableBuilder(column: $table.era, builder: (column) => column);

  GeneratedColumn<String> get biography =>
      $composableBuilder(column: $table.biography, builder: (column) => column);

  GeneratedColumn<String> get languageOfCompositions => $composableBuilder(
      column: $table.languageOfCompositions, builder: (column) => column);
}

class $$ComposersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ComposersTable,
    Composer,
    $$ComposersTableFilterComposer,
    $$ComposersTableOrderingComposer,
    $$ComposersTableAnnotationComposer,
    $$ComposersTableCreateCompanionBuilder,
    $$ComposersTableUpdateCompanionBuilder,
    (Composer, BaseReferences<_$AppDatabase, $ComposersTable, Composer>),
    Composer,
    PrefetchHooks Function()> {
  $$ComposersTableTableManager(_$AppDatabase db, $ComposersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComposersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComposersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComposersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameVariants = const Value.absent(),
            Value<String?> era = const Value.absent(),
            Value<String?> biography = const Value.absent(),
            Value<String?> languageOfCompositions = const Value.absent(),
          }) =>
              ComposersCompanion(
            id: id,
            name: name,
            nameVariants: nameVariants,
            era: era,
            biography: biography,
            languageOfCompositions: languageOfCompositions,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> nameVariants = const Value.absent(),
            Value<String?> era = const Value.absent(),
            Value<String?> biography = const Value.absent(),
            Value<String?> languageOfCompositions = const Value.absent(),
          }) =>
              ComposersCompanion.insert(
            id: id,
            name: name,
            nameVariants: nameVariants,
            era: era,
            biography: biography,
            languageOfCompositions: languageOfCompositions,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ComposersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ComposersTable,
    Composer,
    $$ComposersTableFilterComposer,
    $$ComposersTableOrderingComposer,
    $$ComposersTableAnnotationComposer,
    $$ComposersTableCreateCompanionBuilder,
    $$ComposersTableUpdateCompanionBuilder,
    (Composer, BaseReferences<_$AppDatabase, $ComposersTable, Composer>),
    Composer,
    PrefetchHooks Function()>;
typedef $$RagasTableCreateCompanionBuilder = RagasCompanion Function({
  Value<int> id,
  required String name,
  Value<String> nameVariants,
  Value<String?> arohana,
  Value<String?> avarohana,
  Value<int?> melakarataNumber,
  Value<int?> parentMelakarataId,
  Value<String?> characteristics,
});
typedef $$RagasTableUpdateCompanionBuilder = RagasCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nameVariants,
  Value<String?> arohana,
  Value<String?> avarohana,
  Value<int?> melakarataNumber,
  Value<int?> parentMelakarataId,
  Value<String?> characteristics,
});

class $$RagasTableFilterComposer extends Composer<_$AppDatabase, $RagasTable> {
  $$RagasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arohana => $composableBuilder(
      column: $table.arohana, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avarohana => $composableBuilder(
      column: $table.avarohana, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get melakarataNumber => $composableBuilder(
      column: $table.melakarataNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentMelakarataId => $composableBuilder(
      column: $table.parentMelakarataId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characteristics => $composableBuilder(
      column: $table.characteristics,
      builder: (column) => ColumnFilters(column));
}

class $$RagasTableOrderingComposer
    extends Composer<_$AppDatabase, $RagasTable> {
  $$RagasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arohana => $composableBuilder(
      column: $table.arohana, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avarohana => $composableBuilder(
      column: $table.avarohana, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get melakarataNumber => $composableBuilder(
      column: $table.melakarataNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentMelakarataId => $composableBuilder(
      column: $table.parentMelakarataId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characteristics => $composableBuilder(
      column: $table.characteristics,
      builder: (column) => ColumnOrderings(column));
}

class $$RagasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RagasTable> {
  $$RagasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => column);

  GeneratedColumn<String> get arohana =>
      $composableBuilder(column: $table.arohana, builder: (column) => column);

  GeneratedColumn<String> get avarohana =>
      $composableBuilder(column: $table.avarohana, builder: (column) => column);

  GeneratedColumn<int> get melakarataNumber => $composableBuilder(
      column: $table.melakarataNumber, builder: (column) => column);

  GeneratedColumn<int> get parentMelakarataId => $composableBuilder(
      column: $table.parentMelakarataId, builder: (column) => column);

  GeneratedColumn<String> get characteristics => $composableBuilder(
      column: $table.characteristics, builder: (column) => column);
}

class $$RagasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RagasTable,
    Raga,
    $$RagasTableFilterComposer,
    $$RagasTableOrderingComposer,
    $$RagasTableAnnotationComposer,
    $$RagasTableCreateCompanionBuilder,
    $$RagasTableUpdateCompanionBuilder,
    (Raga, BaseReferences<_$AppDatabase, $RagasTable, Raga>),
    Raga,
    PrefetchHooks Function()> {
  $$RagasTableTableManager(_$AppDatabase db, $RagasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RagasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RagasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RagasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameVariants = const Value.absent(),
            Value<String?> arohana = const Value.absent(),
            Value<String?> avarohana = const Value.absent(),
            Value<int?> melakarataNumber = const Value.absent(),
            Value<int?> parentMelakarataId = const Value.absent(),
            Value<String?> characteristics = const Value.absent(),
          }) =>
              RagasCompanion(
            id: id,
            name: name,
            nameVariants: nameVariants,
            arohana: arohana,
            avarohana: avarohana,
            melakarataNumber: melakarataNumber,
            parentMelakarataId: parentMelakarataId,
            characteristics: characteristics,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> nameVariants = const Value.absent(),
            Value<String?> arohana = const Value.absent(),
            Value<String?> avarohana = const Value.absent(),
            Value<int?> melakarataNumber = const Value.absent(),
            Value<int?> parentMelakarataId = const Value.absent(),
            Value<String?> characteristics = const Value.absent(),
          }) =>
              RagasCompanion.insert(
            id: id,
            name: name,
            nameVariants: nameVariants,
            arohana: arohana,
            avarohana: avarohana,
            melakarataNumber: melakarataNumber,
            parentMelakarataId: parentMelakarataId,
            characteristics: characteristics,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RagasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RagasTable,
    Raga,
    $$RagasTableFilterComposer,
    $$RagasTableOrderingComposer,
    $$RagasTableAnnotationComposer,
    $$RagasTableCreateCompanionBuilder,
    $$RagasTableUpdateCompanionBuilder,
    (Raga, BaseReferences<_$AppDatabase, $RagasTable, Raga>),
    Raga,
    PrefetchHooks Function()>;
typedef $$TalasTableCreateCompanionBuilder = TalasCompanion Function({
  Value<int> id,
  required String name,
  Value<String> nameVariants,
  Value<String?> structure,
  Value<int?> aksharasCount,
});
typedef $$TalasTableUpdateCompanionBuilder = TalasCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nameVariants,
  Value<String?> structure,
  Value<int?> aksharasCount,
});

class $$TalasTableFilterComposer extends Composer<_$AppDatabase, $TalasTable> {
  $$TalasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get structure => $composableBuilder(
      column: $table.structure, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aksharasCount => $composableBuilder(
      column: $table.aksharasCount, builder: (column) => ColumnFilters(column));
}

class $$TalasTableOrderingComposer
    extends Composer<_$AppDatabase, $TalasTable> {
  $$TalasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get structure => $composableBuilder(
      column: $table.structure, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aksharasCount => $composableBuilder(
      column: $table.aksharasCount,
      builder: (column) => ColumnOrderings(column));
}

class $$TalasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TalasTable> {
  $$TalasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => column);

  GeneratedColumn<String> get structure =>
      $composableBuilder(column: $table.structure, builder: (column) => column);

  GeneratedColumn<int> get aksharasCount => $composableBuilder(
      column: $table.aksharasCount, builder: (column) => column);
}

class $$TalasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TalasTable,
    Tala,
    $$TalasTableFilterComposer,
    $$TalasTableOrderingComposer,
    $$TalasTableAnnotationComposer,
    $$TalasTableCreateCompanionBuilder,
    $$TalasTableUpdateCompanionBuilder,
    (Tala, BaseReferences<_$AppDatabase, $TalasTable, Tala>),
    Tala,
    PrefetchHooks Function()> {
  $$TalasTableTableManager(_$AppDatabase db, $TalasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TalasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TalasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TalasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameVariants = const Value.absent(),
            Value<String?> structure = const Value.absent(),
            Value<int?> aksharasCount = const Value.absent(),
          }) =>
              TalasCompanion(
            id: id,
            name: name,
            nameVariants: nameVariants,
            structure: structure,
            aksharasCount: aksharasCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> nameVariants = const Value.absent(),
            Value<String?> structure = const Value.absent(),
            Value<int?> aksharasCount = const Value.absent(),
          }) =>
              TalasCompanion.insert(
            id: id,
            name: name,
            nameVariants: nameVariants,
            structure: structure,
            aksharasCount: aksharasCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TalasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TalasTable,
    Tala,
    $$TalasTableFilterComposer,
    $$TalasTableOrderingComposer,
    $$TalasTableAnnotationComposer,
    $$TalasTableCreateCompanionBuilder,
    $$TalasTableUpdateCompanionBuilder,
    (Tala, BaseReferences<_$AppDatabase, $TalasTable, Tala>),
    Tala,
    PrefetchHooks Function()>;
typedef $$ArtistsTableCreateCompanionBuilder = ArtistsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> nameVariants,
  Value<String?> instrument,
  Value<String?> biography,
  Value<DateTime> createdAt,
});
typedef $$ArtistsTableUpdateCompanionBuilder = ArtistsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nameVariants,
  Value<String?> instrument,
  Value<String?> biography,
  Value<DateTime> createdAt,
});

class $$ArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instrument => $composableBuilder(
      column: $table.instrument, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get biography => $composableBuilder(
      column: $table.biography, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instrument => $composableBuilder(
      column: $table.instrument, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get biography => $composableBuilder(
      column: $table.biography, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameVariants => $composableBuilder(
      column: $table.nameVariants, builder: (column) => column);

  GeneratedColumn<String> get instrument => $composableBuilder(
      column: $table.instrument, builder: (column) => column);

  GeneratedColumn<String> get biography =>
      $composableBuilder(column: $table.biography, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ArtistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ArtistsTable,
    Artist,
    $$ArtistsTableFilterComposer,
    $$ArtistsTableOrderingComposer,
    $$ArtistsTableAnnotationComposer,
    $$ArtistsTableCreateCompanionBuilder,
    $$ArtistsTableUpdateCompanionBuilder,
    (Artist, BaseReferences<_$AppDatabase, $ArtistsTable, Artist>),
    Artist,
    PrefetchHooks Function()> {
  $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameVariants = const Value.absent(),
            Value<String?> instrument = const Value.absent(),
            Value<String?> biography = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ArtistsCompanion(
            id: id,
            name: name,
            nameVariants: nameVariants,
            instrument: instrument,
            biography: biography,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> nameVariants = const Value.absent(),
            Value<String?> instrument = const Value.absent(),
            Value<String?> biography = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ArtistsCompanion.insert(
            id: id,
            name: name,
            nameVariants: nameVariants,
            instrument: instrument,
            biography: biography,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ArtistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ArtistsTable,
    Artist,
    $$ArtistsTableFilterComposer,
    $$ArtistsTableOrderingComposer,
    $$ArtistsTableAnnotationComposer,
    $$ArtistsTableCreateCompanionBuilder,
    $$ArtistsTableUpdateCompanionBuilder,
    (Artist, BaseReferences<_$AppDatabase, $ArtistsTable, Artist>),
    Artist,
    PrefetchHooks Function()>;
typedef $$KrithisTableCreateCompanionBuilder = KrithisCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> searchTokens,
  required int composerId,
  required int ragaId,
  required int talaId,
  required String language,
  required String compositionType,
  required String pallavi,
  Value<String?> anupallavi,
  Value<String?> charanam,
  Value<String?> sourceUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$KrithisTableUpdateCompanionBuilder = KrithisCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> searchTokens,
  Value<int> composerId,
  Value<int> ragaId,
  Value<int> talaId,
  Value<String> language,
  Value<String> compositionType,
  Value<String> pallavi,
  Value<String?> anupallavi,
  Value<String?> charanam,
  Value<String?> sourceUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$KrithisTableFilterComposer
    extends Composer<_$AppDatabase, $KrithisTable> {
  $$KrithisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchTokens => $composableBuilder(
      column: $table.searchTokens, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get composerId => $composableBuilder(
      column: $table.composerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ragaId => $composableBuilder(
      column: $table.ragaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get talaId => $composableBuilder(
      column: $table.talaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get compositionType => $composableBuilder(
      column: $table.compositionType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pallavi => $composableBuilder(
      column: $table.pallavi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get anupallavi => $composableBuilder(
      column: $table.anupallavi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get charanam => $composableBuilder(
      column: $table.charanam, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$KrithisTableOrderingComposer
    extends Composer<_$AppDatabase, $KrithisTable> {
  $$KrithisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchTokens => $composableBuilder(
      column: $table.searchTokens,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get composerId => $composableBuilder(
      column: $table.composerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ragaId => $composableBuilder(
      column: $table.ragaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get talaId => $composableBuilder(
      column: $table.talaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get compositionType => $composableBuilder(
      column: $table.compositionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pallavi => $composableBuilder(
      column: $table.pallavi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get anupallavi => $composableBuilder(
      column: $table.anupallavi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get charanam => $composableBuilder(
      column: $table.charanam, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$KrithisTableAnnotationComposer
    extends Composer<_$AppDatabase, $KrithisTable> {
  $$KrithisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get searchTokens => $composableBuilder(
      column: $table.searchTokens, builder: (column) => column);

  GeneratedColumn<int> get composerId => $composableBuilder(
      column: $table.composerId, builder: (column) => column);

  GeneratedColumn<int> get ragaId =>
      $composableBuilder(column: $table.ragaId, builder: (column) => column);

  GeneratedColumn<int> get talaId =>
      $composableBuilder(column: $table.talaId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get compositionType => $composableBuilder(
      column: $table.compositionType, builder: (column) => column);

  GeneratedColumn<String> get pallavi =>
      $composableBuilder(column: $table.pallavi, builder: (column) => column);

  GeneratedColumn<String> get anupallavi => $composableBuilder(
      column: $table.anupallavi, builder: (column) => column);

  GeneratedColumn<String> get charanam =>
      $composableBuilder(column: $table.charanam, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KrithisTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KrithisTable,
    Krithi,
    $$KrithisTableFilterComposer,
    $$KrithisTableOrderingComposer,
    $$KrithisTableAnnotationComposer,
    $$KrithisTableCreateCompanionBuilder,
    $$KrithisTableUpdateCompanionBuilder,
    (Krithi, BaseReferences<_$AppDatabase, $KrithisTable, Krithi>),
    Krithi,
    PrefetchHooks Function()> {
  $$KrithisTableTableManager(_$AppDatabase db, $KrithisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KrithisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KrithisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KrithisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> searchTokens = const Value.absent(),
            Value<int> composerId = const Value.absent(),
            Value<int> ragaId = const Value.absent(),
            Value<int> talaId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> compositionType = const Value.absent(),
            Value<String> pallavi = const Value.absent(),
            Value<String?> anupallavi = const Value.absent(),
            Value<String?> charanam = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              KrithisCompanion(
            id: id,
            name: name,
            searchTokens: searchTokens,
            composerId: composerId,
            ragaId: ragaId,
            talaId: talaId,
            language: language,
            compositionType: compositionType,
            pallavi: pallavi,
            anupallavi: anupallavi,
            charanam: charanam,
            sourceUrl: sourceUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> searchTokens = const Value.absent(),
            required int composerId,
            required int ragaId,
            required int talaId,
            required String language,
            required String compositionType,
            required String pallavi,
            Value<String?> anupallavi = const Value.absent(),
            Value<String?> charanam = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              KrithisCompanion.insert(
            id: id,
            name: name,
            searchTokens: searchTokens,
            composerId: composerId,
            ragaId: ragaId,
            talaId: talaId,
            language: language,
            compositionType: compositionType,
            pallavi: pallavi,
            anupallavi: anupallavi,
            charanam: charanam,
            sourceUrl: sourceUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KrithisTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KrithisTable,
    Krithi,
    $$KrithisTableFilterComposer,
    $$KrithisTableOrderingComposer,
    $$KrithisTableAnnotationComposer,
    $$KrithisTableCreateCompanionBuilder,
    $$KrithisTableUpdateCompanionBuilder,
    (Krithi, BaseReferences<_$AppDatabase, $KrithisTable, Krithi>),
    Krithi,
    PrefetchHooks Function()>;
typedef $$SearchAliasesTableCreateCompanionBuilder = SearchAliasesCompanion
    Function({
  Value<int> id,
  required String entityType,
  required int entityId,
  required String alias,
});
typedef $$SearchAliasesTableUpdateCompanionBuilder = SearchAliasesCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<int> entityId,
  Value<String> alias,
});

class $$SearchAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $SearchAliasesTable> {
  $$SearchAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));
}

class $$SearchAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchAliasesTable> {
  $$SearchAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));
}

class $$SearchAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchAliasesTable> {
  $$SearchAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);
}

class $$SearchAliasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchAliasesTable,
    SearchAliase,
    $$SearchAliasesTableFilterComposer,
    $$SearchAliasesTableOrderingComposer,
    $$SearchAliasesTableAnnotationComposer,
    $$SearchAliasesTableCreateCompanionBuilder,
    $$SearchAliasesTableUpdateCompanionBuilder,
    (
      SearchAliase,
      BaseReferences<_$AppDatabase, $SearchAliasesTable, SearchAliase>
    ),
    SearchAliase,
    PrefetchHooks Function()> {
  $$SearchAliasesTableTableManager(_$AppDatabase db, $SearchAliasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int> entityId = const Value.absent(),
            Value<String> alias = const Value.absent(),
          }) =>
              SearchAliasesCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            alias: alias,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required int entityId,
            required String alias,
          }) =>
              SearchAliasesCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            alias: alias,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchAliasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchAliasesTable,
    SearchAliase,
    $$SearchAliasesTableFilterComposer,
    $$SearchAliasesTableOrderingComposer,
    $$SearchAliasesTableAnnotationComposer,
    $$SearchAliasesTableCreateCompanionBuilder,
    $$SearchAliasesTableUpdateCompanionBuilder,
    (
      SearchAliase,
      BaseReferences<_$AppDatabase, $SearchAliasesTable, SearchAliase>
    ),
    SearchAliase,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String displayName,
  required String email,
  Value<String> role,
  Value<DateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<String> email,
  Value<String> role,
  Value<DateTime> createdAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            displayName: displayName,
            email: email,
            role: role,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String displayName,
            required String email,
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            displayName: displayName,
            email: email,
            role: role,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$ConcertsTableCreateCompanionBuilder = ConcertsCompanion Function({
  Value<int> id,
  required int krithiId,
  Value<int?> ragaId,
  Value<String?> venue,
  Value<String?> city,
  Value<String?> sabhaName,
  required DateTime performanceDate,
  Value<int> attendeeCount,
  Value<String> status,
  Value<int?> createdByUserId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ConcertsTableUpdateCompanionBuilder = ConcertsCompanion Function({
  Value<int> id,
  Value<int> krithiId,
  Value<int?> ragaId,
  Value<String?> venue,
  Value<String?> city,
  Value<String?> sabhaName,
  Value<DateTime> performanceDate,
  Value<int> attendeeCount,
  Value<String> status,
  Value<int?> createdByUserId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ConcertsTableReferences
    extends BaseReferences<_$AppDatabase, $ConcertsTable, Concert> {
  $$ConcertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConcertArtistsTable, List<ConcertArtist>>
      _concertArtistsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.concertArtists,
              aliasName: $_aliasNameGenerator(
                  db.concerts.id, db.concertArtists.concertId));

  $$ConcertArtistsTableProcessedTableManager get concertArtistsRefs {
    final manager = $$ConcertArtistsTableTableManager($_db, $_db.concertArtists)
        .filter((f) => f.concertId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_concertArtistsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ConcertAttendeesTable, List<ConcertAttendee>>
      _concertAttendeesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.concertAttendees,
              aliasName: $_aliasNameGenerator(
                  db.concerts.id, db.concertAttendees.concertId));

  $$ConcertAttendeesTableProcessedTableManager get concertAttendeesRefs {
    final manager =
        $$ConcertAttendeesTableTableManager($_db, $_db.concertAttendees)
            .filter((f) => f.concertId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_concertAttendeesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ConcertsTableFilterComposer
    extends Composer<_$AppDatabase, $ConcertsTable> {
  $$ConcertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get krithiId => $composableBuilder(
      column: $table.krithiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ragaId => $composableBuilder(
      column: $table.ragaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get venue => $composableBuilder(
      column: $table.venue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sabhaName => $composableBuilder(
      column: $table.sabhaName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performanceDate => $composableBuilder(
      column: $table.performanceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attendeeCount => $composableBuilder(
      column: $table.attendeeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> concertArtistsRefs(
      Expression<bool> Function($$ConcertArtistsTableFilterComposer f) f) {
    final $$ConcertArtistsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.concertArtists,
        getReferencedColumn: (t) => t.concertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertArtistsTableFilterComposer(
              $db: $db,
              $table: $db.concertArtists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> concertAttendeesRefs(
      Expression<bool> Function($$ConcertAttendeesTableFilterComposer f) f) {
    final $$ConcertAttendeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.concertAttendees,
        getReferencedColumn: (t) => t.concertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertAttendeesTableFilterComposer(
              $db: $db,
              $table: $db.concertAttendees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConcertsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConcertsTable> {
  $$ConcertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get krithiId => $composableBuilder(
      column: $table.krithiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ragaId => $composableBuilder(
      column: $table.ragaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get venue => $composableBuilder(
      column: $table.venue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sabhaName => $composableBuilder(
      column: $table.sabhaName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performanceDate => $composableBuilder(
      column: $table.performanceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attendeeCount => $composableBuilder(
      column: $table.attendeeCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConcertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConcertsTable> {
  $$ConcertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get krithiId =>
      $composableBuilder(column: $table.krithiId, builder: (column) => column);

  GeneratedColumn<int> get ragaId =>
      $composableBuilder(column: $table.ragaId, builder: (column) => column);

  GeneratedColumn<String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get sabhaName =>
      $composableBuilder(column: $table.sabhaName, builder: (column) => column);

  GeneratedColumn<DateTime> get performanceDate => $composableBuilder(
      column: $table.performanceDate, builder: (column) => column);

  GeneratedColumn<int> get attendeeCount => $composableBuilder(
      column: $table.attendeeCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdByUserId => $composableBuilder(
      column: $table.createdByUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> concertArtistsRefs<T extends Object>(
      Expression<T> Function($$ConcertArtistsTableAnnotationComposer a) f) {
    final $$ConcertArtistsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.concertArtists,
        getReferencedColumn: (t) => t.concertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertArtistsTableAnnotationComposer(
              $db: $db,
              $table: $db.concertArtists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> concertAttendeesRefs<T extends Object>(
      Expression<T> Function($$ConcertAttendeesTableAnnotationComposer a) f) {
    final $$ConcertAttendeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.concertAttendees,
        getReferencedColumn: (t) => t.concertId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertAttendeesTableAnnotationComposer(
              $db: $db,
              $table: $db.concertAttendees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConcertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConcertsTable,
    Concert,
    $$ConcertsTableFilterComposer,
    $$ConcertsTableOrderingComposer,
    $$ConcertsTableAnnotationComposer,
    $$ConcertsTableCreateCompanionBuilder,
    $$ConcertsTableUpdateCompanionBuilder,
    (Concert, $$ConcertsTableReferences),
    Concert,
    PrefetchHooks Function(
        {bool concertArtistsRefs, bool concertAttendeesRefs})> {
  $$ConcertsTableTableManager(_$AppDatabase db, $ConcertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConcertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConcertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConcertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> krithiId = const Value.absent(),
            Value<int?> ragaId = const Value.absent(),
            Value<String?> venue = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> sabhaName = const Value.absent(),
            Value<DateTime> performanceDate = const Value.absent(),
            Value<int> attendeeCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> createdByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConcertsCompanion(
            id: id,
            krithiId: krithiId,
            ragaId: ragaId,
            venue: venue,
            city: city,
            sabhaName: sabhaName,
            performanceDate: performanceDate,
            attendeeCount: attendeeCount,
            status: status,
            createdByUserId: createdByUserId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int krithiId,
            Value<int?> ragaId = const Value.absent(),
            Value<String?> venue = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> sabhaName = const Value.absent(),
            required DateTime performanceDate,
            Value<int> attendeeCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> createdByUserId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConcertsCompanion.insert(
            id: id,
            krithiId: krithiId,
            ragaId: ragaId,
            venue: venue,
            city: city,
            sabhaName: sabhaName,
            performanceDate: performanceDate,
            attendeeCount: attendeeCount,
            status: status,
            createdByUserId: createdByUserId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ConcertsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {concertArtistsRefs = false, concertAttendeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (concertArtistsRefs) db.concertArtists,
                if (concertAttendeesRefs) db.concertAttendees
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (concertArtistsRefs)
                    await $_getPrefetchedData<Concert, $ConcertsTable,
                            ConcertArtist>(
                        currentTable: table,
                        referencedTable: $$ConcertsTableReferences
                            ._concertArtistsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ConcertsTableReferences(db, table, p0)
                                .concertArtistsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.concertId == item.id),
                        typedResults: items),
                  if (concertAttendeesRefs)
                    await $_getPrefetchedData<Concert, $ConcertsTable,
                            ConcertAttendee>(
                        currentTable: table,
                        referencedTable: $$ConcertsTableReferences
                            ._concertAttendeesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ConcertsTableReferences(db, table, p0)
                                .concertAttendeesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.concertId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ConcertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConcertsTable,
    Concert,
    $$ConcertsTableFilterComposer,
    $$ConcertsTableOrderingComposer,
    $$ConcertsTableAnnotationComposer,
    $$ConcertsTableCreateCompanionBuilder,
    $$ConcertsTableUpdateCompanionBuilder,
    (Concert, $$ConcertsTableReferences),
    Concert,
    PrefetchHooks Function(
        {bool concertArtistsRefs, bool concertAttendeesRefs})>;
typedef $$ConcertArtistsTableCreateCompanionBuilder = ConcertArtistsCompanion
    Function({
  Value<int> id,
  required int concertId,
  required int artistId,
  Value<String?> role,
});
typedef $$ConcertArtistsTableUpdateCompanionBuilder = ConcertArtistsCompanion
    Function({
  Value<int> id,
  Value<int> concertId,
  Value<int> artistId,
  Value<String?> role,
});

final class $$ConcertArtistsTableReferences
    extends BaseReferences<_$AppDatabase, $ConcertArtistsTable, ConcertArtist> {
  $$ConcertArtistsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ConcertsTable _concertIdTable(_$AppDatabase db) =>
      db.concerts.createAlias(
          $_aliasNameGenerator(db.concertArtists.concertId, db.concerts.id));

  $$ConcertsTableProcessedTableManager get concertId {
    final $_column = $_itemColumn<int>('concert_id')!;

    final manager = $$ConcertsTableTableManager($_db, $_db.concerts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_concertIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ConcertArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ConcertArtistsTable> {
  $$ConcertArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  $$ConcertsTableFilterComposer get concertId {
    final $$ConcertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableFilterComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConcertArtistsTable> {
  $$ConcertArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  $$ConcertsTableOrderingComposer get concertId {
    final $$ConcertsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableOrderingComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConcertArtistsTable> {
  $$ConcertArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  $$ConcertsTableAnnotationComposer get concertId {
    final $$ConcertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableAnnotationComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertArtistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConcertArtistsTable,
    ConcertArtist,
    $$ConcertArtistsTableFilterComposer,
    $$ConcertArtistsTableOrderingComposer,
    $$ConcertArtistsTableAnnotationComposer,
    $$ConcertArtistsTableCreateCompanionBuilder,
    $$ConcertArtistsTableUpdateCompanionBuilder,
    (ConcertArtist, $$ConcertArtistsTableReferences),
    ConcertArtist,
    PrefetchHooks Function({bool concertId})> {
  $$ConcertArtistsTableTableManager(
      _$AppDatabase db, $ConcertArtistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConcertArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConcertArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConcertArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> concertId = const Value.absent(),
            Value<int> artistId = const Value.absent(),
            Value<String?> role = const Value.absent(),
          }) =>
              ConcertArtistsCompanion(
            id: id,
            concertId: concertId,
            artistId: artistId,
            role: role,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int concertId,
            required int artistId,
            Value<String?> role = const Value.absent(),
          }) =>
              ConcertArtistsCompanion.insert(
            id: id,
            concertId: concertId,
            artistId: artistId,
            role: role,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConcertArtistsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({concertId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (concertId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.concertId,
                    referencedTable:
                        $$ConcertArtistsTableReferences._concertIdTable(db),
                    referencedColumn:
                        $$ConcertArtistsTableReferences._concertIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ConcertArtistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConcertArtistsTable,
    ConcertArtist,
    $$ConcertArtistsTableFilterComposer,
    $$ConcertArtistsTableOrderingComposer,
    $$ConcertArtistsTableAnnotationComposer,
    $$ConcertArtistsTableCreateCompanionBuilder,
    $$ConcertArtistsTableUpdateCompanionBuilder,
    (ConcertArtist, $$ConcertArtistsTableReferences),
    ConcertArtist,
    PrefetchHooks Function({bool concertId})>;
typedef $$ConcertAttendeesTableCreateCompanionBuilder
    = ConcertAttendeesCompanion Function({
  Value<int> id,
  required int concertId,
  required int userId,
  Value<DateTime> createdAt,
});
typedef $$ConcertAttendeesTableUpdateCompanionBuilder
    = ConcertAttendeesCompanion Function({
  Value<int> id,
  Value<int> concertId,
  Value<int> userId,
  Value<DateTime> createdAt,
});

final class $$ConcertAttendeesTableReferences extends BaseReferences<
    _$AppDatabase, $ConcertAttendeesTable, ConcertAttendee> {
  $$ConcertAttendeesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ConcertsTable _concertIdTable(_$AppDatabase db) =>
      db.concerts.createAlias(
          $_aliasNameGenerator(db.concertAttendees.concertId, db.concerts.id));

  $$ConcertsTableProcessedTableManager get concertId {
    final $_column = $_itemColumn<int>('concert_id')!;

    final manager = $$ConcertsTableTableManager($_db, $_db.concerts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_concertIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ConcertAttendeesTableFilterComposer
    extends Composer<_$AppDatabase, $ConcertAttendeesTable> {
  $$ConcertAttendeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ConcertsTableFilterComposer get concertId {
    final $$ConcertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableFilterComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertAttendeesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConcertAttendeesTable> {
  $$ConcertAttendeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ConcertsTableOrderingComposer get concertId {
    final $$ConcertsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableOrderingComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertAttendeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConcertAttendeesTable> {
  $$ConcertAttendeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ConcertsTableAnnotationComposer get concertId {
    final $$ConcertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concertId,
        referencedTable: $db.concerts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConcertsTableAnnotationComposer(
              $db: $db,
              $table: $db.concerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConcertAttendeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConcertAttendeesTable,
    ConcertAttendee,
    $$ConcertAttendeesTableFilterComposer,
    $$ConcertAttendeesTableOrderingComposer,
    $$ConcertAttendeesTableAnnotationComposer,
    $$ConcertAttendeesTableCreateCompanionBuilder,
    $$ConcertAttendeesTableUpdateCompanionBuilder,
    (ConcertAttendee, $$ConcertAttendeesTableReferences),
    ConcertAttendee,
    PrefetchHooks Function({bool concertId})> {
  $$ConcertAttendeesTableTableManager(
      _$AppDatabase db, $ConcertAttendeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConcertAttendeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConcertAttendeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConcertAttendeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> concertId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ConcertAttendeesCompanion(
            id: id,
            concertId: concertId,
            userId: userId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int concertId,
            required int userId,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ConcertAttendeesCompanion.insert(
            id: id,
            concertId: concertId,
            userId: userId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConcertAttendeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({concertId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (concertId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.concertId,
                    referencedTable:
                        $$ConcertAttendeesTableReferences._concertIdTable(db),
                    referencedColumn: $$ConcertAttendeesTableReferences
                        ._concertIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ConcertAttendeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConcertAttendeesTable,
    ConcertAttendee,
    $$ConcertAttendeesTableFilterComposer,
    $$ConcertAttendeesTableOrderingComposer,
    $$ConcertAttendeesTableAnnotationComposer,
    $$ConcertAttendeesTableCreateCompanionBuilder,
    $$ConcertAttendeesTableUpdateCompanionBuilder,
    (ConcertAttendee, $$ConcertAttendeesTableReferences),
    ConcertAttendee,
    PrefetchHooks Function({bool concertId})>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  Value<int> krithiId,
  Value<DateTime> bookmarkedAt,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<int> krithiId,
  Value<DateTime> bookmarkedAt,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get krithiId => $composableBuilder(
      column: $table.krithiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get bookmarkedAt => $composableBuilder(
      column: $table.bookmarkedAt, builder: (column) => ColumnFilters(column));
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get krithiId => $composableBuilder(
      column: $table.krithiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get bookmarkedAt => $composableBuilder(
      column: $table.bookmarkedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get krithiId =>
      $composableBuilder(column: $table.krithiId, builder: (column) => column);

  GeneratedColumn<DateTime> get bookmarkedAt => $composableBuilder(
      column: $table.bookmarkedAt, builder: (column) => column);
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> krithiId = const Value.absent(),
            Value<DateTime> bookmarkedAt = const Value.absent(),
          }) =>
              BookmarksCompanion(
            krithiId: krithiId,
            bookmarkedAt: bookmarkedAt,
          ),
          createCompanionCallback: ({
            Value<int> krithiId = const Value.absent(),
            Value<DateTime> bookmarkedAt = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            krithiId: krithiId,
            bookmarkedAt: bookmarkedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ComposersTableTableManager get composers =>
      $$ComposersTableTableManager(_db, _db.composers);
  $$RagasTableTableManager get ragas =>
      $$RagasTableTableManager(_db, _db.ragas);
  $$TalasTableTableManager get talas =>
      $$TalasTableTableManager(_db, _db.talas);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$KrithisTableTableManager get krithis =>
      $$KrithisTableTableManager(_db, _db.krithis);
  $$SearchAliasesTableTableManager get searchAliases =>
      $$SearchAliasesTableTableManager(_db, _db.searchAliases);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ConcertsTableTableManager get concerts =>
      $$ConcertsTableTableManager(_db, _db.concerts);
  $$ConcertArtistsTableTableManager get concertArtists =>
      $$ConcertArtistsTableTableManager(_db, _db.concertArtists);
  $$ConcertAttendeesTableTableManager get concertAttendees =>
      $$ConcertAttendeesTableTableManager(_db, _db.concertAttendees);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
