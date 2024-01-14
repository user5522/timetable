// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TimetableTable extends Timetable
    with TableInfo<$TimetableTable, TimetableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'timetable';
  @override
  VerificationContext validateIntegrity(Insertable<TimetableData> instance,
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
  TimetableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $TimetableTable createAlias(String alias) {
    return $TimetableTable(attachedDatabase, alias);
  }
}

class TimetableData extends DataClass implements Insertable<TimetableData> {
  final int id;
  final String name;
  const TimetableData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TimetableCompanion toCompanion(bool nullToAbsent) {
    return TimetableCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory TimetableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableData(
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

  TimetableData copyWith({int? id, String? name}) => TimetableData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('TimetableData(')
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
      (other is TimetableData &&
          other.id == this.id &&
          other.name == this.name);
}

class TimetableCompanion extends UpdateCompanion<TimetableData> {
  final Value<int> id;
  final Value<String> name;
  const TimetableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TimetableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<TimetableData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TimetableCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TimetableCompanion(
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
    return (StringBuffer('TimetableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $SubjectTable extends Subject with TableInfo<$SubjectTable, SubjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectTable(this.attachedDatabase, [this._alias]);
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
          .withConverter<material.Color>($SubjectTable.$convertercolor);
  static const VerificationMeta _rotationWeekMeta =
      const VerificationMeta('rotationWeek');
  @override
  late final GeneratedColumnWithTypeConverter<RotationWeeks, int> rotationWeek =
      GeneratedColumn<int>('rotation_week', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<RotationWeeks>($SubjectTable.$converterrotationWeek);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumnWithTypeConverter<Days, int> day =
      GeneratedColumn<int>('day', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Days>($SubjectTable.$converterday);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumnWithTypeConverter<material.TimeOfDay, String>
      startTime = GeneratedColumn<String>('start_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<material.TimeOfDay>($SubjectTable.$converterstartTime);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumnWithTypeConverter<material.TimeOfDay, String>
      endTime = GeneratedColumn<String>('end_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<material.TimeOfDay>($SubjectTable.$converterendTime);
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
  static const String $name = 'subject';
  @override
  VerificationContext validateIntegrity(Insertable<SubjectData> instance,
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
  SubjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      color: $SubjectTable.$convertercolor.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
      rotationWeek: $SubjectTable.$converterrotationWeek.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}rotation_week'])!),
      day: $SubjectTable.$converterday.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!),
      startTime: $SubjectTable.$converterstartTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!),
      endTime: $SubjectTable.$converterendTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!),
      timetable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timetable'])!,
    );
  }

  @override
  $SubjectTable createAlias(String alias) {
    return $SubjectTable(attachedDatabase, alias);
  }

  static TypeConverter<material.Color, int> $convertercolor =
      const ColorConverter();
  static JsonTypeConverter2<RotationWeeks, int, int> $converterrotationWeek =
      const EnumIndexConverter<RotationWeeks>(RotationWeeks.values);
  static JsonTypeConverter2<Days, int, int> $converterday =
      const EnumIndexConverter<Days>(Days.values);
  static TypeConverter<material.TimeOfDay, String> $converterstartTime =
      const TimeOfDayConverter();
  static TypeConverter<material.TimeOfDay, String> $converterendTime =
      const TimeOfDayConverter();
}

class SubjectData extends DataClass implements Insertable<SubjectData> {
  final int id;
  final String label;
  final String? location;
  final String? note;
  final material.Color color;
  final RotationWeeks rotationWeek;
  final Days day;
  final material.TimeOfDay startTime;
  final material.TimeOfDay endTime;
  final String timetable;
  const SubjectData(
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
      map['color'] = Variable<int>($SubjectTable.$convertercolor.toSql(color));
    }
    {
      map['rotation_week'] = Variable<int>(
          $SubjectTable.$converterrotationWeek.toSql(rotationWeek));
    }
    {
      map['day'] = Variable<int>($SubjectTable.$converterday.toSql(day));
    }
    {
      map['start_time'] =
          Variable<String>($SubjectTable.$converterstartTime.toSql(startTime));
    }
    {
      map['end_time'] =
          Variable<String>($SubjectTable.$converterendTime.toSql(endTime));
    }
    map['timetable'] = Variable<String>(timetable);
    return map;
  }

  SubjectCompanion toCompanion(bool nullToAbsent) {
    return SubjectCompanion(
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

  factory SubjectData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      location: serializer.fromJson<String?>(json['location']),
      note: serializer.fromJson<String?>(json['note']),
      color: serializer.fromJson<material.Color>(material.Color(json['color'])),
      rotationWeek: $SubjectTable.$converterrotationWeek
          .fromJson(serializer.fromJson<int>(json['rotationWeek'])),
      day: $SubjectTable.$converterday
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
      'color': serializer.toJson<int>(color.value),
      'rotationWeek': serializer.toJson<int>(
          $SubjectTable.$converterrotationWeek.toJson(rotationWeek)),
      'day': serializer.toJson<int>($SubjectTable.$converterday.toJson(day)),
      'startTimeHour': serializer.toJson<int>(startTime.hour),
      'startTimeMinute': serializer.toJson<int>(startTime.minute),
      'endTimeHour': serializer.toJson<int>(endTime.hour),
      'endTimeMinute': serializer.toJson<int>(endTime.minute),
      'timetable': serializer.toJson<String>(timetable),
    };
  }

  SubjectData copyWith(
          {int? id,
          String? label,
          Value<String?> location = const Value.absent(),
          Value<String?> note = const Value.absent(),
          material.Color? color,
          RotationWeeks? rotationWeek,
          Days? day,
          material.TimeOfDay? startTime,
          material.TimeOfDay? endTime,
          String? timetable}) =>
      SubjectData(
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
  @override
  String toString() {
    return (StringBuffer('SubjectData(')
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
      (other is SubjectData &&
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

class SubjectCompanion extends UpdateCompanion<SubjectData> {
  final Value<int> id;
  final Value<String> label;
  final Value<String?> location;
  final Value<String?> note;
  final Value<material.Color> color;
  final Value<RotationWeeks> rotationWeek;
  final Value<Days> day;
  final Value<material.TimeOfDay> startTime;
  final Value<material.TimeOfDay> endTime;
  final Value<String> timetable;
  const SubjectCompanion({
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
  SubjectCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    required material.Color color,
    required RotationWeeks rotationWeek,
    required Days day,
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
  static Insertable<SubjectData> custom({
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

  SubjectCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<String?>? location,
      Value<String?>? note,
      Value<material.Color>? color,
      Value<RotationWeeks>? rotationWeek,
      Value<Days>? day,
      Value<material.TimeOfDay>? startTime,
      Value<material.TimeOfDay>? endTime,
      Value<String>? timetable}) {
    return SubjectCompanion(
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
          Variable<int>($SubjectTable.$convertercolor.toSql(color.value));
    }
    if (rotationWeek.present) {
      map['rotation_week'] = Variable<int>(
          $SubjectTable.$converterrotationWeek.toSql(rotationWeek.value));
    }
    if (day.present) {
      map['day'] = Variable<int>($SubjectTable.$converterday.toSql(day.value));
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(
          $SubjectTable.$converterstartTime.toSql(startTime.value));
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(
          $SubjectTable.$converterendTime.toSql(endTime.value));
    }
    if (timetable.present) {
      map['timetable'] = Variable<String>(timetable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectCompanion(')
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
  late final $TimetableTable timetable = $TimetableTable(this);
  late final $SubjectTable subject = $SubjectTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [timetable, subject];
}
