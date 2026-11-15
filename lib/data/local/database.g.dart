// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final String symbol;
  final DateTime addedAt;
  const Favorite({required this.symbol, required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(symbol: Value(symbol), addedAt: Value(addedAt));
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      symbol: serializer.fromJson<String>(json['symbol']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  Favorite copyWith({String? symbol, DateTime? addedAt}) =>
      Favorite(symbol: symbol ?? this.symbol, addedAt: addedAt ?? this.addedAt);
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('symbol: $symbol, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.symbol == this.symbol &&
          other.addedAt == this.addedAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<String> symbol;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const FavoritesCompanion({
    this.symbol = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesCompanion.insert({
    required String symbol,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       addedAt = Value(addedAt);
  static Insertable<Favorite> custom({
    Expression<String>? symbol,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesCompanion copyWith({
    Value<String>? symbol,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return FavoritesCompanion(
      symbol: symbol ?? this.symbol,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('symbol: $symbol, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SimulationsTable extends Simulations
    with TableInfo<$SimulationsTable, Simulation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SimulationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, title, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'simulations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Simulation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Simulation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Simulation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SimulationsTable createAlias(String alias) {
    return $SimulationsTable(attachedDatabase, alias);
  }
}

class Simulation extends DataClass implements Insertable<Simulation> {
  final int id;
  final String kind;
  final String title;
  final String payload;
  final DateTime createdAt;
  const Simulation({
    required this.id,
    required this.kind,
    required this.title,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SimulationsCompanion toCompanion(bool nullToAbsent) {
    return SimulationsCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory Simulation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Simulation(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Simulation copyWith({
    int? id,
    String? kind,
    String? title,
    String? payload,
    DateTime? createdAt,
  }) => Simulation(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  Simulation copyWithCompanion(SimulationsCompanion data) {
    return Simulation(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Simulation(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, title, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Simulation &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class SimulationsCompanion extends UpdateCompanion<Simulation> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const SimulationsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SimulationsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String title,
    required String payload,
    required DateTime createdAt,
  }) : kind = Value(kind),
       title = Value(title),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<Simulation> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SimulationsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return SimulationsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SimulationsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final String key;
  final String value;
  const Preference({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(key: Value(key), value: Value(value));
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Preference copyWith({String? key, String? value}) =>
      Preference(key: key ?? this.key, value: value ?? this.value);
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.key == this.key &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Preference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizStatsRowsTable extends QuizStatsRows
    with TableInfo<$QuizStatsRowsTable, QuizStatsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizStatsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _answeredMeta = const VerificationMeta(
    'answered',
  );
  @override
  late final GeneratedColumn<int> answered = GeneratedColumn<int>(
    'answered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPlayedMeta = const VerificationMeta(
    'lastPlayed',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
    'last_played',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    correct,
    answered,
    streak,
    bestStreak,
    lastPlayed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_stats_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizStatsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    if (data.containsKey('answered')) {
      context.handle(
        _answeredMeta,
        answered.isAcceptableOrUnknown(data['answered']!, _answeredMeta),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    }
    if (data.containsKey('last_played')) {
      context.handle(
        _lastPlayedMeta,
        lastPlayed.isAcceptableOrUnknown(data['last_played']!, _lastPlayedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizStatsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizStatsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      answered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      lastPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played'],
      ),
    );
  }

  @override
  $QuizStatsRowsTable createAlias(String alias) {
    return $QuizStatsRowsTable(attachedDatabase, alias);
  }
}

class QuizStatsRow extends DataClass implements Insertable<QuizStatsRow> {
  final int id;
  final int correct;
  final int answered;
  final int streak;
  final int bestStreak;
  final DateTime? lastPlayed;
  const QuizStatsRow({
    required this.id,
    required this.correct,
    required this.answered,
    required this.streak,
    required this.bestStreak,
    this.lastPlayed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['correct'] = Variable<int>(correct);
    map['answered'] = Variable<int>(answered);
    map['streak'] = Variable<int>(streak);
    map['best_streak'] = Variable<int>(bestStreak);
    if (!nullToAbsent || lastPlayed != null) {
      map['last_played'] = Variable<DateTime>(lastPlayed);
    }
    return map;
  }

  QuizStatsRowsCompanion toCompanion(bool nullToAbsent) {
    return QuizStatsRowsCompanion(
      id: Value(id),
      correct: Value(correct),
      answered: Value(answered),
      streak: Value(streak),
      bestStreak: Value(bestStreak),
      lastPlayed: lastPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayed),
    );
  }

  factory QuizStatsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizStatsRow(
      id: serializer.fromJson<int>(json['id']),
      correct: serializer.fromJson<int>(json['correct']),
      answered: serializer.fromJson<int>(json['answered']),
      streak: serializer.fromJson<int>(json['streak']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      lastPlayed: serializer.fromJson<DateTime?>(json['lastPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'correct': serializer.toJson<int>(correct),
      'answered': serializer.toJson<int>(answered),
      'streak': serializer.toJson<int>(streak),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'lastPlayed': serializer.toJson<DateTime?>(lastPlayed),
    };
  }

  QuizStatsRow copyWith({
    int? id,
    int? correct,
    int? answered,
    int? streak,
    int? bestStreak,
    Value<DateTime?> lastPlayed = const Value.absent(),
  }) => QuizStatsRow(
    id: id ?? this.id,
    correct: correct ?? this.correct,
    answered: answered ?? this.answered,
    streak: streak ?? this.streak,
    bestStreak: bestStreak ?? this.bestStreak,
    lastPlayed: lastPlayed.present ? lastPlayed.value : this.lastPlayed,
  );
  QuizStatsRow copyWithCompanion(QuizStatsRowsCompanion data) {
    return QuizStatsRow(
      id: data.id.present ? data.id.value : this.id,
      correct: data.correct.present ? data.correct.value : this.correct,
      answered: data.answered.present ? data.answered.value : this.answered,
      streak: data.streak.present ? data.streak.value : this.streak,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      lastPlayed: data.lastPlayed.present
          ? data.lastPlayed.value
          : this.lastPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizStatsRow(')
          ..write('id: $id, ')
          ..write('correct: $correct, ')
          ..write('answered: $answered, ')
          ..write('streak: $streak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastPlayed: $lastPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, correct, answered, streak, bestStreak, lastPlayed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizStatsRow &&
          other.id == this.id &&
          other.correct == this.correct &&
          other.answered == this.answered &&
          other.streak == this.streak &&
          other.bestStreak == this.bestStreak &&
          other.lastPlayed == this.lastPlayed);
}

class QuizStatsRowsCompanion extends UpdateCompanion<QuizStatsRow> {
  final Value<int> id;
  final Value<int> correct;
  final Value<int> answered;
  final Value<int> streak;
  final Value<int> bestStreak;
  final Value<DateTime?> lastPlayed;
  const QuizStatsRowsCompanion({
    this.id = const Value.absent(),
    this.correct = const Value.absent(),
    this.answered = const Value.absent(),
    this.streak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastPlayed = const Value.absent(),
  });
  QuizStatsRowsCompanion.insert({
    this.id = const Value.absent(),
    this.correct = const Value.absent(),
    this.answered = const Value.absent(),
    this.streak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastPlayed = const Value.absent(),
  });
  static Insertable<QuizStatsRow> custom({
    Expression<int>? id,
    Expression<int>? correct,
    Expression<int>? answered,
    Expression<int>? streak,
    Expression<int>? bestStreak,
    Expression<DateTime>? lastPlayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (correct != null) 'correct': correct,
      if (answered != null) 'answered': answered,
      if (streak != null) 'streak': streak,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (lastPlayed != null) 'last_played': lastPlayed,
    });
  }

  QuizStatsRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? correct,
    Value<int>? answered,
    Value<int>? streak,
    Value<int>? bestStreak,
    Value<DateTime?>? lastPlayed,
  }) {
    return QuizStatsRowsCompanion(
      id: id ?? this.id,
      correct: correct ?? this.correct,
      answered: answered ?? this.answered,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (answered.present) {
      map['answered'] = Variable<int>(answered.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizStatsRowsCompanion(')
          ..write('id: $id, ')
          ..write('correct: $correct, ')
          ..write('answered: $answered, ')
          ..write('streak: $streak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastPlayed: $lastPlayed')
          ..write(')'))
        .toString();
  }
}

class $CachedPricesTable extends CachedPrices
    with TableInfo<$CachedPricesTable, CachedPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granularityMeta = const VerificationMeta(
    'granularity',
  );
  @override
  late final GeneratedColumn<String> granularity = GeneratedColumn<String>(
    'granularity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closeMeta = const VerificationMeta('close');
  @override
  late final GeneratedColumn<double> close = GeneratedColumn<double>(
    'close',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, granularity, date, close];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPrice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('granularity')) {
      context.handle(
        _granularityMeta,
        granularity.isAcceptableOrUnknown(
          data['granularity']!,
          _granularityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_granularityMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('close')) {
      context.handle(
        _closeMeta,
        close.isAcceptableOrUnknown(data['close']!, _closeMeta),
      );
    } else if (isInserting) {
      context.missing(_closeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol, granularity, date};
  @override
  CachedPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPrice(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      granularity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}granularity'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      close: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}close'],
      )!,
    );
  }

  @override
  $CachedPricesTable createAlias(String alias) {
    return $CachedPricesTable(attachedDatabase, alias);
  }
}

class CachedPrice extends DataClass implements Insertable<CachedPrice> {
  final String symbol;
  final String granularity;
  final DateTime date;
  final double close;
  const CachedPrice({
    required this.symbol,
    required this.granularity,
    required this.date,
    required this.close,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['granularity'] = Variable<String>(granularity);
    map['date'] = Variable<DateTime>(date);
    map['close'] = Variable<double>(close);
    return map;
  }

  CachedPricesCompanion toCompanion(bool nullToAbsent) {
    return CachedPricesCompanion(
      symbol: Value(symbol),
      granularity: Value(granularity),
      date: Value(date),
      close: Value(close),
    );
  }

  factory CachedPrice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPrice(
      symbol: serializer.fromJson<String>(json['symbol']),
      granularity: serializer.fromJson<String>(json['granularity']),
      date: serializer.fromJson<DateTime>(json['date']),
      close: serializer.fromJson<double>(json['close']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'granularity': serializer.toJson<String>(granularity),
      'date': serializer.toJson<DateTime>(date),
      'close': serializer.toJson<double>(close),
    };
  }

  CachedPrice copyWith({
    String? symbol,
    String? granularity,
    DateTime? date,
    double? close,
  }) => CachedPrice(
    symbol: symbol ?? this.symbol,
    granularity: granularity ?? this.granularity,
    date: date ?? this.date,
    close: close ?? this.close,
  );
  CachedPrice copyWithCompanion(CachedPricesCompanion data) {
    return CachedPrice(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      granularity: data.granularity.present
          ? data.granularity.value
          : this.granularity,
      date: data.date.present ? data.date.value : this.date,
      close: data.close.present ? data.close.value : this.close,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPrice(')
          ..write('symbol: $symbol, ')
          ..write('granularity: $granularity, ')
          ..write('date: $date, ')
          ..write('close: $close')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, granularity, date, close);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPrice &&
          other.symbol == this.symbol &&
          other.granularity == this.granularity &&
          other.date == this.date &&
          other.close == this.close);
}

class CachedPricesCompanion extends UpdateCompanion<CachedPrice> {
  final Value<String> symbol;
  final Value<String> granularity;
  final Value<DateTime> date;
  final Value<double> close;
  final Value<int> rowid;
  const CachedPricesCompanion({
    this.symbol = const Value.absent(),
    this.granularity = const Value.absent(),
    this.date = const Value.absent(),
    this.close = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPricesCompanion.insert({
    required String symbol,
    required String granularity,
    required DateTime date,
    required double close,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       granularity = Value(granularity),
       date = Value(date),
       close = Value(close);
  static Insertable<CachedPrice> custom({
    Expression<String>? symbol,
    Expression<String>? granularity,
    Expression<DateTime>? date,
    Expression<double>? close,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (granularity != null) 'granularity': granularity,
      if (date != null) 'date': date,
      if (close != null) 'close': close,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPricesCompanion copyWith({
    Value<String>? symbol,
    Value<String>? granularity,
    Value<DateTime>? date,
    Value<double>? close,
    Value<int>? rowid,
  }) {
    return CachedPricesCompanion(
      symbol: symbol ?? this.symbol,
      granularity: granularity ?? this.granularity,
      date: date ?? this.date,
      close: close ?? this.close,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (granularity.present) {
      map['granularity'] = Variable<String>(granularity.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (close.present) {
      map['close'] = Variable<double>(close.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPricesCompanion(')
          ..write('symbol: $symbol, ')
          ..write('granularity: $granularity, ')
          ..write('date: $date, ')
          ..write('close: $close, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheMetaTable extends CacheMeta
    with TableInfo<$CacheMetaTable, CacheMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granularityMeta = const VerificationMeta(
    'granularity',
  );
  @override
  late final GeneratedColumn<String> granularity = GeneratedColumn<String>(
    'granularity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, granularity, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('granularity')) {
      context.handle(
        _granularityMeta,
        granularity.isAcceptableOrUnknown(
          data['granularity']!,
          _granularityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_granularityMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol, granularity};
  @override
  CacheMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetaData(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      granularity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}granularity'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CacheMetaTable createAlias(String alias) {
    return $CacheMetaTable(attachedDatabase, alias);
  }
}

class CacheMetaData extends DataClass implements Insertable<CacheMetaData> {
  final String symbol;
  final String granularity;
  final DateTime fetchedAt;
  const CacheMetaData({
    required this.symbol,
    required this.granularity,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['granularity'] = Variable<String>(granularity);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CacheMetaCompanion toCompanion(bool nullToAbsent) {
    return CacheMetaCompanion(
      symbol: Value(symbol),
      granularity: Value(granularity),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CacheMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetaData(
      symbol: serializer.fromJson<String>(json['symbol']),
      granularity: serializer.fromJson<String>(json['granularity']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'granularity': serializer.toJson<String>(granularity),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CacheMetaData copyWith({
    String? symbol,
    String? granularity,
    DateTime? fetchedAt,
  }) => CacheMetaData(
    symbol: symbol ?? this.symbol,
    granularity: granularity ?? this.granularity,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CacheMetaData copyWithCompanion(CacheMetaCompanion data) {
    return CacheMetaData(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      granularity: data.granularity.present
          ? data.granularity.value
          : this.granularity,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetaData(')
          ..write('symbol: $symbol, ')
          ..write('granularity: $granularity, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, granularity, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetaData &&
          other.symbol == this.symbol &&
          other.granularity == this.granularity &&
          other.fetchedAt == this.fetchedAt);
}

class CacheMetaCompanion extends UpdateCompanion<CacheMetaData> {
  final Value<String> symbol;
  final Value<String> granularity;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CacheMetaCompanion({
    this.symbol = const Value.absent(),
    this.granularity = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetaCompanion.insert({
    required String symbol,
    required String granularity,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       granularity = Value(granularity),
       fetchedAt = Value(fetchedAt);
  static Insertable<CacheMetaData> custom({
    Expression<String>? symbol,
    Expression<String>? granularity,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (granularity != null) 'granularity': granularity,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetaCompanion copyWith({
    Value<String>? symbol,
    Value<String>? granularity,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CacheMetaCompanion(
      symbol: symbol ?? this.symbol,
      granularity: granularity ?? this.granularity,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (granularity.present) {
      map['granularity'] = Variable<String>(granularity.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetaCompanion(')
          ..write('symbol: $symbol, ')
          ..write('granularity: $granularity, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $SimulationsTable simulations = $SimulationsTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $QuizStatsRowsTable quizStatsRows = $QuizStatsRowsTable(this);
  late final $CachedPricesTable cachedPrices = $CachedPricesTable(this);
  late final $CacheMetaTable cacheMeta = $CacheMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    favorites,
    simulations,
    preferences,
    quizStatsRows,
    cachedPrices,
    cacheMeta,
  ];
}

typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      required String symbol,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<String> symbol,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion(
                symbol: symbol,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion.insert(
                symbol: symbol,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoritesTable, Favorite>(table),
                  BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$SimulationsTableCreateCompanionBuilder =
    SimulationsCompanion Function({
      Value<int> id,
      required String kind,
      required String title,
      required String payload,
      required DateTime createdAt,
    });
typedef $$SimulationsTableUpdateCompanionBuilder =
    SimulationsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> title,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$SimulationsTableFilterComposer
    extends Composer<_$AppDatabase, $SimulationsTable> {
  $$SimulationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SimulationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SimulationsTable> {
  $$SimulationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SimulationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SimulationsTable> {
  $$SimulationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SimulationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SimulationsTable,
          Simulation,
          $$SimulationsTableFilterComposer,
          $$SimulationsTableOrderingComposer,
          $$SimulationsTableAnnotationComposer,
          $$SimulationsTableCreateCompanionBuilder,
          $$SimulationsTableUpdateCompanionBuilder,
          (
            Simulation,
            BaseReferences<_$AppDatabase, $SimulationsTable, Simulation>,
          ),
          Simulation,
          PrefetchHooks Function()
        > {
  $$SimulationsTableTableManager(_$AppDatabase db, $SimulationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SimulationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SimulationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SimulationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SimulationsCompanion(
                id: id,
                kind: kind,
                title: title,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String title,
                required String payload,
                required DateTime createdAt,
              }) => SimulationsCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SimulationsTable, Simulation>(table),
                  BaseReferences<_$AppDatabase, $SimulationsTable, Simulation>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SimulationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SimulationsTable,
      Simulation,
      $$SimulationsTableFilterComposer,
      $$SimulationsTableOrderingComposer,
      $$SimulationsTableAnnotationComposer,
      $$SimulationsTableCreateCompanionBuilder,
      $$SimulationsTableUpdateCompanionBuilder,
      (
        Simulation,
        BaseReferences<_$AppDatabase, $SimulationsTable, Simulation>,
      ),
      Simulation,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, Preference>(table),
                  BaseReferences<_$AppDatabase, $PreferencesTable, Preference>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;
typedef $$QuizStatsRowsTableCreateCompanionBuilder =
    QuizStatsRowsCompanion Function({
      Value<int> id,
      Value<int> correct,
      Value<int> answered,
      Value<int> streak,
      Value<int> bestStreak,
      Value<DateTime?> lastPlayed,
    });
typedef $$QuizStatsRowsTableUpdateCompanionBuilder =
    QuizStatsRowsCompanion Function({
      Value<int> id,
      Value<int> correct,
      Value<int> answered,
      Value<int> streak,
      Value<int> bestStreak,
      Value<DateTime?> lastPlayed,
    });

class $$QuizStatsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizStatsRowsTable> {
  $$QuizStatsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizStatsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizStatsRowsTable> {
  $$QuizStatsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizStatsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizStatsRowsTable> {
  $$QuizStatsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get answered =>
      $composableBuilder(column: $table.answered, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => column,
  );
}

class $$QuizStatsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizStatsRowsTable,
          QuizStatsRow,
          $$QuizStatsRowsTableFilterComposer,
          $$QuizStatsRowsTableOrderingComposer,
          $$QuizStatsRowsTableAnnotationComposer,
          $$QuizStatsRowsTableCreateCompanionBuilder,
          $$QuizStatsRowsTableUpdateCompanionBuilder,
          (
            QuizStatsRow,
            BaseReferences<_$AppDatabase, $QuizStatsRowsTable, QuizStatsRow>,
          ),
          QuizStatsRow,
          PrefetchHooks Function()
        > {
  $$QuizStatsRowsTableTableManager(_$AppDatabase db, $QuizStatsRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizStatsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizStatsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizStatsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> answered = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastPlayed = const Value.absent(),
              }) => QuizStatsRowsCompanion(
                id: id,
                correct: correct,
                answered: answered,
                streak: streak,
                bestStreak: bestStreak,
                lastPlayed: lastPlayed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> answered = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastPlayed = const Value.absent(),
              }) => QuizStatsRowsCompanion.insert(
                id: id,
                correct: correct,
                answered: answered,
                streak: streak,
                bestStreak: bestStreak,
                lastPlayed: lastPlayed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuizStatsRowsTable, QuizStatsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $QuizStatsRowsTable,
                    QuizStatsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizStatsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizStatsRowsTable,
      QuizStatsRow,
      $$QuizStatsRowsTableFilterComposer,
      $$QuizStatsRowsTableOrderingComposer,
      $$QuizStatsRowsTableAnnotationComposer,
      $$QuizStatsRowsTableCreateCompanionBuilder,
      $$QuizStatsRowsTableUpdateCompanionBuilder,
      (
        QuizStatsRow,
        BaseReferences<_$AppDatabase, $QuizStatsRowsTable, QuizStatsRow>,
      ),
      QuizStatsRow,
      PrefetchHooks Function()
    >;
typedef $$CachedPricesTableCreateCompanionBuilder =
    CachedPricesCompanion Function({
      required String symbol,
      required String granularity,
      required DateTime date,
      required double close,
      Value<int> rowid,
    });
typedef $$CachedPricesTableUpdateCompanionBuilder =
    CachedPricesCompanion Function({
      Value<String> symbol,
      Value<String> granularity,
      Value<DateTime> date,
      Value<double> close,
      Value<int> rowid,
    });

class $$CachedPricesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPricesTable> {
  $$CachedPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get close => $composableBuilder(
    column: $table.close,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPricesTable> {
  $$CachedPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get close => $composableBuilder(
    column: $table.close,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPricesTable> {
  $$CachedPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get close =>
      $composableBuilder(column: $table.close, builder: (column) => column);
}

class $$CachedPricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPricesTable,
          CachedPrice,
          $$CachedPricesTableFilterComposer,
          $$CachedPricesTableOrderingComposer,
          $$CachedPricesTableAnnotationComposer,
          $$CachedPricesTableCreateCompanionBuilder,
          $$CachedPricesTableUpdateCompanionBuilder,
          (
            CachedPrice,
            BaseReferences<_$AppDatabase, $CachedPricesTable, CachedPrice>,
          ),
          CachedPrice,
          PrefetchHooks Function()
        > {
  $$CachedPricesTableTableManager(_$AppDatabase db, $CachedPricesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<String> granularity = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> close = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPricesCompanion(
                symbol: symbol,
                granularity: granularity,
                date: date,
                close: close,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required String granularity,
                required DateTime date,
                required double close,
                Value<int> rowid = const Value.absent(),
              }) => CachedPricesCompanion.insert(
                symbol: symbol,
                granularity: granularity,
                date: date,
                close: close,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedPricesTable, CachedPrice>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedPricesTable,
                    CachedPrice
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPricesTable,
      CachedPrice,
      $$CachedPricesTableFilterComposer,
      $$CachedPricesTableOrderingComposer,
      $$CachedPricesTableAnnotationComposer,
      $$CachedPricesTableCreateCompanionBuilder,
      $$CachedPricesTableUpdateCompanionBuilder,
      (
        CachedPrice,
        BaseReferences<_$AppDatabase, $CachedPricesTable, CachedPrice>,
      ),
      CachedPrice,
      PrefetchHooks Function()
    >;
typedef $$CacheMetaTableCreateCompanionBuilder =
    CacheMetaCompanion Function({
      required String symbol,
      required String granularity,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CacheMetaTableUpdateCompanionBuilder =
    CacheMetaCompanion Function({
      Value<String> symbol,
      Value<String> granularity,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CacheMetaTableFilterComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheMetaTable> {
  $$CacheMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CacheMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheMetaTable,
          CacheMetaData,
          $$CacheMetaTableFilterComposer,
          $$CacheMetaTableOrderingComposer,
          $$CacheMetaTableAnnotationComposer,
          $$CacheMetaTableCreateCompanionBuilder,
          $$CacheMetaTableUpdateCompanionBuilder,
          (
            CacheMetaData,
            BaseReferences<_$AppDatabase, $CacheMetaTable, CacheMetaData>,
          ),
          CacheMetaData,
          PrefetchHooks Function()
        > {
  $$CacheMetaTableTableManager(_$AppDatabase db, $CacheMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<String> granularity = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheMetaCompanion(
                symbol: symbol,
                granularity: granularity,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required String granularity,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CacheMetaCompanion.insert(
                symbol: symbol,
                granularity: granularity,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CacheMetaTable, CacheMetaData>(table),
                  BaseReferences<_$AppDatabase, $CacheMetaTable, CacheMetaData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheMetaTable,
      CacheMetaData,
      $$CacheMetaTableFilterComposer,
      $$CacheMetaTableOrderingComposer,
      $$CacheMetaTableAnnotationComposer,
      $$CacheMetaTableCreateCompanionBuilder,
      $$CacheMetaTableUpdateCompanionBuilder,
      (
        CacheMetaData,
        BaseReferences<_$AppDatabase, $CacheMetaTable, CacheMetaData>,
      ),
      CacheMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$SimulationsTableTableManager get simulations =>
      $$SimulationsTableTableManager(_db, _db.simulations);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$QuizStatsRowsTableTableManager get quizStatsRows =>
      $$QuizStatsRowsTableTableManager(_db, _db.quizStatsRows);
  $$CachedPricesTableTableManager get cachedPrices =>
      $$CachedPricesTableTableManager(_db, _db.cachedPrices);
  $$CacheMetaTableTableManager get cacheMeta =>
      $$CacheMetaTableTableManager(_db, _db.cacheMeta);
}
