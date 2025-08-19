// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TimetablesTable extends Timetables
    with TableInfo<$TimetablesTable, Timetable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetablesTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetables';
  @override
  VerificationContext validateIntegrity(Insertable<Timetable> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Timetable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Timetable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $TimetablesTable createAlias(String alias) {
    return $TimetablesTable(attachedDatabase, alias);
  }
}

class Timetable extends DataClass implements Insertable<Timetable> {
  final int id;
  final String name;
  const Timetable({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TimetablesCompanion toCompanion(bool nullToAbsent) {
    return TimetablesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Timetable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Timetable(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Timetable copyWith({int? id, String? name}) => Timetable(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Timetable copyWithCompanion(TimetablesCompanion data) {
    return Timetable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Timetable(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Timetable && other.id == this.id && other.name == this.name);
}

class TimetablesCompanion extends UpdateCompanion<Timetable> {
  final Value<int> id;
  final Value<String> name;
  const TimetablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TimetablesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Timetable> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TimetablesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TimetablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumnWithTypeConverter<material.Color, int> color =
      GeneratedColumn<int>('color', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<material.Color>($SubjectsTable.$convertercolor);
  static const VerificationMeta _rotationWeekMeta =
      const VerificationMeta('rotationWeek');
  @override
  late final GeneratedColumnWithTypeConverter<RotationWeeks, int> rotationWeek =
      GeneratedColumn<int>('rotation_week', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<RotationWeeks>($SubjectsTable.$converterrotationWeek);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumnWithTypeConverter<Day, int> day =
      GeneratedColumn<int>('day', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Day>($SubjectsTable.$converterday);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumnWithTypeConverter<material.TimeOfDay, String>
      startTime = GeneratedColumn<String>('start_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<material.TimeOfDay>(
              $SubjectsTable.$converterstartTime);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumnWithTypeConverter<material.TimeOfDay, String>
      endTime = GeneratedColumn<String>('end_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<material.TimeOfDay>($SubjectsTable.$converterendTime);
  static const VerificationMeta _timetableMeta =
      const VerificationMeta('timetable');
  @override
  late final GeneratedColumn<String> timetable = GeneratedColumn<String>(
      'timetable', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        label,
        location,
        note,
        color,
        rotationWeek,
        day,
        startTime,
        endTime,
        timetable
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<Subject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    context.handle(_colorMeta, const VerificationResult.success());
    context.handle(_rotationWeekMeta, const VerificationResult.success());
    context.handle(_dayMeta, const VerificationResult.success());
    context.handle(_startTimeMeta, const VerificationResult.success());
    context.handle(_endTimeMeta, const VerificationResult.success());
    if (data.containsKey('timetable')) {
      context.handle(_timetableMeta,
          timetable.isAcceptableOrUnknown(data['timetable']!, _timetableMeta));
    } else if (isInserting) {
      context.missing(_timetableMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      color: $SubjectsTable.$convertercolor.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
      rotationWeek: $SubjectsTable.$converterrotationWeek.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}rotation_week'])!),
      day: $SubjectsTable.$converterday.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!),
      startTime: $SubjectsTable.$converterstartTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!),
      endTime: $SubjectsTable.$converterendTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!),
      timetable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timetable'])!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }

  static TypeConverter<material.Color, int> $convertercolor =
      const ColorConverter();
  static JsonTypeConverter2<RotationWeeks, int, int> $converterrotationWeek =
      const EnumIndexConverter<RotationWeeks>(RotationWeeks.values);
  static JsonTypeConverter2<Day, int, int> $converterday =
      const EnumIndexConverter<Day>(Day.values);
  static TypeConverter<material.TimeOfDay, String> $converterstartTime =
      const TimeOfDayConverter();
  static TypeConverter<material.TimeOfDay, String> $converterendTime =
      const TimeOfDayConverter();
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String label;
  final String? location;
  final String? note;
  final material.Color color;
  final RotationWeeks rotationWeek;
  final Day day;
  final material.TimeOfDay startTime;
  final material.TimeOfDay endTime;
  final String timetable;
  const Subject(
      {required this.id,
      required this.label,
      this.location,
      this.note,
      required this.color,
      required this.rotationWeek,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.timetable});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['color'] = Variable<int>($SubjectsTable.$convertercolor.toSql(color));
    }
    {
      map['rotation_week'] = Variable<int>(
          $SubjectsTable.$converterrotationWeek.toSql(rotationWeek));
    }
    {
      map['day'] = Variable<int>($SubjectsTable.$converterday.toSql(day));
    }
    {
      map['start_time'] =
          Variable<String>($SubjectsTable.$converterstartTime.toSql(startTime));
    }
    {
      map['end_time'] =
          Variable<String>($SubjectsTable.$converterendTime.toSql(endTime));
    }
    map['timetable'] = Variable<String>(timetable);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      label: Value(label),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      color: Value(color),
      rotationWeek: Value(rotationWeek),
      day: Value(day),
      startTime: Value(startTime),
      endTime: Value(endTime),
      timetable: Value(timetable),
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      location: serializer.fromJson<String?>(json['location']),
      note: serializer.fromJson<String?>(json['note']),
      color: serializer.fromJson<material.Color>(material.Color(json['color'])),
      rotationWeek: $SubjectsTable.$converterrotationWeek
          .fromJson(serializer.fromJson<int>(json['rotationWeek'])),
      day: $SubjectsTable.$converterday
          .fromJson(serializer.fromJson<int>(json['day'])),
      startTime: serializer.fromJson<material.TimeOfDay>(
        material.TimeOfDay(
          hour: json['startTimeHour'],
          minute: json['startTimeMinute'],
        ),
      ),
      endTime: serializer.fromJson<material.TimeOfDay>(
        material.TimeOfDay(
          hour: json['endTimeHour'],
          minute: json['endTimeMinute'],
        ),
      ),
      timetable: serializer.fromJson<String>(json['timetable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'location': serializer.toJson<String?>(location),
      'note': serializer.toJson<String?>(note),
      'color': serializer.toJson<int>(color.toInt()),
      'rotationWeek': serializer.toJson<int>(
          $SubjectsTable.$converterrotationWeek.toJson(rotationWeek)),
      'day': serializer.toJson<int>($SubjectsTable.$converterday.toJson(day)),
      'startTimeHour': serializer.toJson<int>(startTime.hour),
      'startTimeMinute': serializer.toJson<int>(startTime.minute),
      'endTimeHour': serializer.toJson<int>(endTime.hour),
      'endTimeMinute': serializer.toJson<int>(endTime.minute),
      'timetable': serializer.toJson<String>(timetable),
    };
  }

  Subject copyWith(
          {int? id,
          String? label,
          Value<String?> location = const Value.absent(),
          Value<String?> note = const Value.absent(),
          material.Color? color,
          RotationWeeks? rotationWeek,
          Day? day,
          material.TimeOfDay? startTime,
          material.TimeOfDay? endTime,
          String? timetable}) =>
      Subject(
        id: id ?? this.id,
        label: label ?? this.label,
        location: location.present ? location.value : this.location,
        note: note.present ? note.value : this.note,
        color: color ?? this.color,
        rotationWeek: rotationWeek ?? this.rotationWeek,
        day: day ?? this.day,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        timetable: timetable ?? this.timetable,
      );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      location: data.location.present ? data.location.value : this.location,
      note: data.note.present ? data.note.value : this.note,
      color: data.color.present ? data.color.value : this.color,
      rotationWeek: data.rotationWeek.present
          ? data.rotationWeek.value
          : this.rotationWeek,
      day: data.day.present ? data.day.value : this.day,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      timetable: data.timetable.present ? data.timetable.value : this.timetable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('location: $location, ')
          ..write('note: $note, ')
          ..write('color: $color, ')
          ..write('rotationWeek: $rotationWeek, ')
          ..write('day: $day, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('timetable: $timetable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, location, note, color,
      rotationWeek, day, startTime, endTime, timetable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.label == this.label &&
          other.location == this.location &&
          other.note == this.note &&
          other.color == this.color &&
          other.rotationWeek == this.rotationWeek &&
          other.day == this.day &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.timetable == this.timetable);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> label;
  final Value<String?> location;
  final Value<String?> note;
  final Value<material.Color> color;
  final Value<RotationWeeks> rotationWeek;
  final Value<Day> day;
  final Value<material.TimeOfDay> startTime;
  final Value<material.TimeOfDay> endTime;
  final Value<String> timetable;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    this.color = const Value.absent(),
    this.rotationWeek = const Value.absent(),
    this.day = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.timetable = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    required material.Color color,
    required RotationWeeks rotationWeek,
    required Day day,
    required material.TimeOfDay startTime,
    required material.TimeOfDay endTime,
    required String timetable,
  })  : label = Value(label),
        color = Value(color),
        rotationWeek = Value(rotationWeek),
        day = Value(day),
        startTime = Value(startTime),
        endTime = Value(endTime),
        timetable = Value(timetable);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? location,
    Expression<String>? note,
    Expression<int>? color,
    Expression<int>? rotationWeek,
    Expression<int>? day,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? timetable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (location != null) 'location': location,
      if (note != null) 'note': note,
      if (color != null) 'color': color,
      if (rotationWeek != null) 'rotation_week': rotationWeek,
      if (day != null) 'day': day,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (timetable != null) 'timetable': timetable,
    });
  }

  SubjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<String?>? location,
      Value<String?>? note,
      Value<material.Color>? color,
      Value<RotationWeeks>? rotationWeek,
      Value<Day>? day,
      Value<material.TimeOfDay>? startTime,
      Value<material.TimeOfDay>? endTime,
      Value<String>? timetable}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      location: location ?? this.location,
      note: note ?? this.note,
      color: color ?? this.color,
      rotationWeek: rotationWeek ?? this.rotationWeek,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timetable: timetable ?? this.timetable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (color.present) {
      map['color'] =
          Variable<int>($SubjectsTable.$convertercolor.toSql(color.value));
    }
    if (rotationWeek.present) {
      map['rotation_week'] = Variable<int>(
          $SubjectsTable.$converterrotationWeek.toSql(rotationWeek.value));
    }
    if (day.present) {
      map['day'] = Variable<int>($SubjectsTable.$converterday.toSql(day.value));
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(
          $SubjectsTable.$converterstartTime.toSql(startTime.value));
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(
          $SubjectsTable.$converterendTime.toSql(endTime.value));
    }
    if (timetable.present) {
      map['timetable'] = Variable<String>(timetable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('location: $location, ')
          ..write('note: $note, ')
          ..write('color: $color, ')
          ..write('rotationWeek: $rotationWeek, ')
          ..write('day: $day, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('timetable: $timetable')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TimetablesTable timetables = $TimetablesTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [timetables, subjects];
}

typedef $$TimetablesTableCreateCompanionBuilder = TimetablesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$TimetablesTableUpdateCompanionBuilder = TimetablesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$TimetablesTableFilterComposer
    extends Composer<_$AppDatabase, $TimetablesTable> {
  $$TimetablesTableFilterComposer({
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
}

class $$TimetablesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetablesTable> {
  $$TimetablesTableOrderingComposer({
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
}

class $$TimetablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetablesTable> {
  $$TimetablesTableAnnotationComposer({
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
}

class $$TimetablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TimetablesTable,
    Timetable,
    $$TimetablesTableFilterComposer,
    $$TimetablesTableOrderingComposer,
    $$TimetablesTableAnnotationComposer,
    $$TimetablesTableCreateCompanionBuilder,
    $$TimetablesTableUpdateCompanionBuilder,
    (Timetable, BaseReferences<_$AppDatabase, $TimetablesTable, Timetable>),
    Timetable,
    PrefetchHooks Function()> {
  $$TimetablesTableTableManager(_$AppDatabase db, $TimetablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimetablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimetablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimetablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              TimetablesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              TimetablesCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TimetablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TimetablesTable,
    Timetable,
    $$TimetablesTableFilterComposer,
    $$TimetablesTableOrderingComposer,
    $$TimetablesTableAnnotationComposer,
    $$TimetablesTableCreateCompanionBuilder,
    $$TimetablesTableUpdateCompanionBuilder,
    (Timetable, BaseReferences<_$AppDatabase, $TimetablesTable, Timetable>),
    Timetable,
    PrefetchHooks Function()>;
typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  Value<int> id,
  required String label,
  Value<String?> location,
  Value<String?> note,
  required material.Color color,
  required RotationWeeks rotationWeek,
  required Day day,
  required material.TimeOfDay startTime,
  required material.TimeOfDay endTime,
  required String timetable,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<int> id,
  Value<String> label,
  Value<String?> location,
  Value<String?> note,
  Value<material.Color> color,
  Value<RotationWeeks> rotationWeek,
  Value<Day> day,
  Value<material.TimeOfDay> startTime,
  Value<material.TimeOfDay> endTime,
  Value<String> timetable,
});

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<material.Color, material.Color, int>
      get color => $composableBuilder(
          column: $table.color,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<RotationWeeks, RotationWeeks, int>
      get rotationWeek => $composableBuilder(
          column: $table.rotationWeek,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Day, Day, int> get day => $composableBuilder(
      column: $table.day,
      builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<material.TimeOfDay, material.TimeOfDay, String>
      get startTime => $composableBuilder(
          column: $table.startTime,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<material.TimeOfDay, material.TimeOfDay, String>
      get endTime => $composableBuilder(
          column: $table.endTime,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get timetable => $composableBuilder(
      column: $table.timetable, builder: (column) => ColumnFilters(column));
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rotationWeek => $composableBuilder(
      column: $table.rotationWeek,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timetable => $composableBuilder(
      column: $table.timetable, builder: (column) => ColumnOrderings(column));
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<material.Color, int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RotationWeeks, int> get rotationWeek =>
      $composableBuilder(
          column: $table.rotationWeek, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Day, int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<material.TimeOfDay, String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<material.TimeOfDay, String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get timetable =>
      $composableBuilder(column: $table.timetable, builder: (column) => column);
}

class $$SubjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
    Subject,
    PrefetchHooks Function()> {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<material.Color> color = const Value.absent(),
            Value<RotationWeeks> rotationWeek = const Value.absent(),
            Value<Day> day = const Value.absent(),
            Value<material.TimeOfDay> startTime = const Value.absent(),
            Value<material.TimeOfDay> endTime = const Value.absent(),
            Value<String> timetable = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            label: label,
            location: location,
            note: note,
            color: color,
            rotationWeek: rotationWeek,
            day: day,
            startTime: startTime,
            endTime: endTime,
            timetable: timetable,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String label,
            Value<String?> location = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required material.Color color,
            required RotationWeeks rotationWeek,
            required Day day,
            required material.TimeOfDay startTime,
            required material.TimeOfDay endTime,
            required String timetable,
          }) =>
              SubjectsCompanion.insert(
            id: id,
            label: label,
            location: location,
            note: note,
            color: color,
            rotationWeek: rotationWeek,
            day: day,
            startTime: startTime,
            endTime: endTime,
            timetable: timetable,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
    Subject,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TimetablesTableTableManager get timetables =>
      $$TimetablesTableTableManager(_db, _db.timetables);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
}
