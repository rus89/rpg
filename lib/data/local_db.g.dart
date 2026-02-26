// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// ignore_for_file: type=lint
class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, Snapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, date, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at'],
      ),
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }
}

class Snapshot extends DataClass implements Insertable<Snapshot> {
  final String id;
  final String label;
  final String? date;
  final int? fetchedAt;
  const Snapshot({
    required this.id,
    required this.label,
    this.date,
    this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || fetchedAt != null) {
      map['fetched_at'] = Variable<int>(fetchedAt);
    }
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      label: Value(label),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      fetchedAt: fetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(fetchedAt),
    );
  }

  factory Snapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snapshot(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      date: serializer.fromJson<String?>(json['date']),
      fetchedAt: serializer.fromJson<int?>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'date': serializer.toJson<String?>(date),
      'fetchedAt': serializer.toJson<int?>(fetchedAt),
    };
  }

  Snapshot copyWith({
    String? id,
    String? label,
    Value<String?> date = const Value.absent(),
    Value<int?> fetchedAt = const Value.absent(),
  }) => Snapshot(
    id: id ?? this.id,
    label: label ?? this.label,
    date: date.present ? date.value : this.date,
    fetchedAt: fetchedAt.present ? fetchedAt.value : this.fetchedAt,
  );
  Snapshot copyWithCompanion(SnapshotsCompanion data) {
    return Snapshot(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      date: data.date.present ? data.date.value : this.date,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snapshot(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('date: $date, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, date, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snapshot &&
          other.id == this.id &&
          other.label == this.label &&
          other.date == this.date &&
          other.fetchedAt == this.fetchedAt);
}

class SnapshotsCompanion extends UpdateCompanion<Snapshot> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> date;
  final Value<int?> fetchedAt;
  final Value<int> rowid;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.date = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    required String id,
    required String label,
    this.date = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label);
  static Insertable<Snapshot> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? date,
    Expression<int>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (date != null) 'date': date,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? date,
    Value<int?>? fetchedAt,
    Value<int>? rowid,
  }) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      date: date ?? this.date,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('date: $date, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HoldingsTable extends Holdings with TableInfo<$HoldingsTable, Holding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snapshotIdMeta = const VerificationMeta(
    'snapshotId',
  );
  @override
  late final GeneratedColumn<String> snapshotId = GeneratedColumn<String>(
    'snapshot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _municipalityNameMeta = const VerificationMeta(
    'municipalityName',
  );
  @override
  late final GeneratedColumn<String> municipalityName = GeneratedColumn<String>(
    'municipality_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registeredMeta = const VerificationMeta(
    'registered',
  );
  @override
  late final GeneratedColumn<int> registered = GeneratedColumn<int>(
    'registered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<int> active = GeneratedColumn<int>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    snapshotId,
    municipalityName,
    registered,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holdings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Holding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snapshot_id')) {
      context.handle(
        _snapshotIdMeta,
        snapshotId.isAcceptableOrUnknown(data['snapshot_id']!, _snapshotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_snapshotIdMeta);
    }
    if (data.containsKey('municipality_name')) {
      context.handle(
        _municipalityNameMeta,
        municipalityName.isAcceptableOrUnknown(
          data['municipality_name']!,
          _municipalityNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_municipalityNameMeta);
    }
    if (data.containsKey('registered')) {
      context.handle(
        _registeredMeta,
        registered.isAcceptableOrUnknown(data['registered']!, _registeredMeta),
      );
    } else if (isInserting) {
      context.missing(_registeredMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snapshotId, municipalityName};
  @override
  Holding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Holding(
      snapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_id'],
      )!,
      municipalityName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}municipality_name'],
      )!,
      registered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}registered'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $HoldingsTable createAlias(String alias) {
    return $HoldingsTable(attachedDatabase, alias);
  }
}

class Holding extends DataClass implements Insertable<Holding> {
  final String snapshotId;
  final String municipalityName;
  final int registered;
  final int active;
  const Holding({
    required this.snapshotId,
    required this.municipalityName,
    required this.registered,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snapshot_id'] = Variable<String>(snapshotId);
    map['municipality_name'] = Variable<String>(municipalityName);
    map['registered'] = Variable<int>(registered);
    map['active'] = Variable<int>(active);
    return map;
  }

  HoldingsCompanion toCompanion(bool nullToAbsent) {
    return HoldingsCompanion(
      snapshotId: Value(snapshotId),
      municipalityName: Value(municipalityName),
      registered: Value(registered),
      active: Value(active),
    );
  }

  factory Holding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Holding(
      snapshotId: serializer.fromJson<String>(json['snapshotId']),
      municipalityName: serializer.fromJson<String>(json['municipalityName']),
      registered: serializer.fromJson<int>(json['registered']),
      active: serializer.fromJson<int>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snapshotId': serializer.toJson<String>(snapshotId),
      'municipalityName': serializer.toJson<String>(municipalityName),
      'registered': serializer.toJson<int>(registered),
      'active': serializer.toJson<int>(active),
    };
  }

  Holding copyWith({
    String? snapshotId,
    String? municipalityName,
    int? registered,
    int? active,
  }) => Holding(
    snapshotId: snapshotId ?? this.snapshotId,
    municipalityName: municipalityName ?? this.municipalityName,
    registered: registered ?? this.registered,
    active: active ?? this.active,
  );
  Holding copyWithCompanion(HoldingsCompanion data) {
    return Holding(
      snapshotId: data.snapshotId.present
          ? data.snapshotId.value
          : this.snapshotId,
      municipalityName: data.municipalityName.present
          ? data.municipalityName.value
          : this.municipalityName,
      registered: data.registered.present
          ? data.registered.value
          : this.registered,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Holding(')
          ..write('snapshotId: $snapshotId, ')
          ..write('municipalityName: $municipalityName, ')
          ..write('registered: $registered, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(snapshotId, municipalityName, registered, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Holding &&
          other.snapshotId == this.snapshotId &&
          other.municipalityName == this.municipalityName &&
          other.registered == this.registered &&
          other.active == this.active);
}

class HoldingsCompanion extends UpdateCompanion<Holding> {
  final Value<String> snapshotId;
  final Value<String> municipalityName;
  final Value<int> registered;
  final Value<int> active;
  final Value<int> rowid;
  const HoldingsCompanion({
    this.snapshotId = const Value.absent(),
    this.municipalityName = const Value.absent(),
    this.registered = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HoldingsCompanion.insert({
    required String snapshotId,
    required String municipalityName,
    required int registered,
    required int active,
    this.rowid = const Value.absent(),
  }) : snapshotId = Value(snapshotId),
       municipalityName = Value(municipalityName),
       registered = Value(registered),
       active = Value(active);
  static Insertable<Holding> custom({
    Expression<String>? snapshotId,
    Expression<String>? municipalityName,
    Expression<int>? registered,
    Expression<int>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (snapshotId != null) 'snapshot_id': snapshotId,
      if (municipalityName != null) 'municipality_name': municipalityName,
      if (registered != null) 'registered': registered,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HoldingsCompanion copyWith({
    Value<String>? snapshotId,
    Value<String>? municipalityName,
    Value<int>? registered,
    Value<int>? active,
    Value<int>? rowid,
  }) {
    return HoldingsCompanion(
      snapshotId: snapshotId ?? this.snapshotId,
      municipalityName: municipalityName ?? this.municipalityName,
      registered: registered ?? this.registered,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snapshotId.present) {
      map['snapshot_id'] = Variable<String>(snapshotId.value);
    }
    if (municipalityName.present) {
      map['municipality_name'] = Variable<String>(municipalityName.value);
    }
    if (registered.present) {
      map['registered'] = Variable<int>(registered.value);
    }
    if (active.present) {
      map['active'] = Variable<int>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsCompanion(')
          ..write('snapshotId: $snapshotId, ')
          ..write('municipalityName: $municipalityName, ')
          ..write('registered: $registered, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$RpgDatabase extends GeneratedDatabase {
  _$RpgDatabase(QueryExecutor e) : super(e);
  $RpgDatabaseManager get managers => $RpgDatabaseManager(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  late final $HoldingsTable holdings = $HoldingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [snapshots, holdings];
}

typedef $$SnapshotsTableCreateCompanionBuilder =
    SnapshotsCompanion Function({
      required String id,
      required String label,
      Value<String?> date,
      Value<int?> fetchedAt,
      Value<int> rowid,
    });
typedef $$SnapshotsTableUpdateCompanionBuilder =
    SnapshotsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String?> date,
      Value<int?> fetchedAt,
      Value<int> rowid,
    });

class $$SnapshotsTableFilterComposer
    extends Composer<_$RpgDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$RpgDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$RpgDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$SnapshotsTableTableManager
    extends
        RootTableManager<
          _$RpgDatabase,
          $SnapshotsTable,
          Snapshot,
          $$SnapshotsTableFilterComposer,
          $$SnapshotsTableOrderingComposer,
          $$SnapshotsTableAnnotationComposer,
          $$SnapshotsTableCreateCompanionBuilder,
          $$SnapshotsTableUpdateCompanionBuilder,
          (Snapshot, BaseReferences<_$RpgDatabase, $SnapshotsTable, Snapshot>),
          Snapshot,
          PrefetchHooks Function()
        > {
  $$SnapshotsTableTableManager(_$RpgDatabase db, $SnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<int?> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion(
                id: id,
                label: label,
                date: date,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String?> date = const Value.absent(),
                Value<int?> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion.insert(
                id: id,
                label: label,
                date: date,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$RpgDatabase,
      $SnapshotsTable,
      Snapshot,
      $$SnapshotsTableFilterComposer,
      $$SnapshotsTableOrderingComposer,
      $$SnapshotsTableAnnotationComposer,
      $$SnapshotsTableCreateCompanionBuilder,
      $$SnapshotsTableUpdateCompanionBuilder,
      (Snapshot, BaseReferences<_$RpgDatabase, $SnapshotsTable, Snapshot>),
      Snapshot,
      PrefetchHooks Function()
    >;
typedef $$HoldingsTableCreateCompanionBuilder =
    HoldingsCompanion Function({
      required String snapshotId,
      required String municipalityName,
      required int registered,
      required int active,
      Value<int> rowid,
    });
typedef $$HoldingsTableUpdateCompanionBuilder =
    HoldingsCompanion Function({
      Value<String> snapshotId,
      Value<String> municipalityName,
      Value<int> registered,
      Value<int> active,
      Value<int> rowid,
    });

class $$HoldingsTableFilterComposer
    extends Composer<_$RpgDatabase, $HoldingsTable> {
  $$HoldingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get snapshotId => $composableBuilder(
    column: $table.snapshotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get municipalityName => $composableBuilder(
    column: $table.municipalityName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get registered => $composableBuilder(
    column: $table.registered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HoldingsTableOrderingComposer
    extends Composer<_$RpgDatabase, $HoldingsTable> {
  $$HoldingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get snapshotId => $composableBuilder(
    column: $table.snapshotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get municipalityName => $composableBuilder(
    column: $table.municipalityName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get registered => $composableBuilder(
    column: $table.registered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HoldingsTableAnnotationComposer
    extends Composer<_$RpgDatabase, $HoldingsTable> {
  $$HoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get snapshotId => $composableBuilder(
    column: $table.snapshotId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get municipalityName => $composableBuilder(
    column: $table.municipalityName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get registered => $composableBuilder(
    column: $table.registered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$HoldingsTableTableManager
    extends
        RootTableManager<
          _$RpgDatabase,
          $HoldingsTable,
          Holding,
          $$HoldingsTableFilterComposer,
          $$HoldingsTableOrderingComposer,
          $$HoldingsTableAnnotationComposer,
          $$HoldingsTableCreateCompanionBuilder,
          $$HoldingsTableUpdateCompanionBuilder,
          (Holding, BaseReferences<_$RpgDatabase, $HoldingsTable, Holding>),
          Holding,
          PrefetchHooks Function()
        > {
  $$HoldingsTableTableManager(_$RpgDatabase db, $HoldingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoldingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> snapshotId = const Value.absent(),
                Value<String> municipalityName = const Value.absent(),
                Value<int> registered = const Value.absent(),
                Value<int> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HoldingsCompanion(
                snapshotId: snapshotId,
                municipalityName: municipalityName,
                registered: registered,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String snapshotId,
                required String municipalityName,
                required int registered,
                required int active,
                Value<int> rowid = const Value.absent(),
              }) => HoldingsCompanion.insert(
                snapshotId: snapshotId,
                municipalityName: municipalityName,
                registered: registered,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HoldingsTableProcessedTableManager =
    ProcessedTableManager<
      _$RpgDatabase,
      $HoldingsTable,
      Holding,
      $$HoldingsTableFilterComposer,
      $$HoldingsTableOrderingComposer,
      $$HoldingsTableAnnotationComposer,
      $$HoldingsTableCreateCompanionBuilder,
      $$HoldingsTableUpdateCompanionBuilder,
      (Holding, BaseReferences<_$RpgDatabase, $HoldingsTable, Holding>),
      Holding,
      PrefetchHooks Function()
    >;

class $RpgDatabaseManager {
  final _$RpgDatabase _db;
  $RpgDatabaseManager(this._db);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$HoldingsTableTableManager get holdings =>
      $$HoldingsTableTableManager(_db, _db.holdings);
}
