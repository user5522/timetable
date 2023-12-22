// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, location, note, color, rotationWeek, day, startTime, endTime];
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
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    context.handle(_rotationWeekMeta, const VerificationResult.success());
    context.handle(_dayMeta, const VerificationResult.success());
    context.handle(_startTimeMeta, const VerificationResult.success());
    context.handle(_endTimeMeta, const VerificationResult.success());
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
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
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
    );
  }

  @override
  $SubjectTable createAlias(String alias) {
    return $SubjectTable(attachedDatabase, alias);
  }

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
  final int color;
  final RotationWeeks rotationWeek;
  final Days day;
  final material.TimeOfDay startTime;
  final material.TimeOfDay endTime;
  const SubjectData(
      {required this.id,
      required this.label,
      this.location,
      this.note,
      required this.color,
      required this.rotationWeek,
      required this.day,
      required this.startTime,
      required this.endTime});
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
    map['color'] = Variable<int>(color);
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
      color: serializer.fromJson<int>(json['color']),
      rotationWeek: $SubjectTable.$converterrotationWeek
          .fromJson(serializer.fromJson<int>(json['rotationWeek'])),
      day: $SubjectTable.$converterday
          .fromJson(serializer.fromJson<int>(json['day'])),
      startTime: serializer.fromJson<material.TimeOfDay>(json['startTime']),
      endTime: serializer.fromJson<material.TimeOfDay>(json['endTime']),
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
      'color': serializer.toJson<int>(color),
      'rotationWeek': serializer.toJson<int>(
          $SubjectTable.$converterrotationWeek.toJson(rotationWeek)),
      'day': serializer.toJson<int>($SubjectTable.$converterday.toJson(day)),
      'startTime': serializer.toJson<material.TimeOfDay>(startTime),
      'endTime': serializer.toJson<material.TimeOfDay>(endTime),
    };
  }

  SubjectData copyWith(
          {int? id,
          String? label,
          Value<String?> location = const Value.absent(),
          Value<String?> note = const Value.absent(),
          int? color,
          RotationWeeks? rotationWeek,
          Days? day,
          material.TimeOfDay? startTime,
          material.TimeOfDay? endTime}) =>
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
          ..write('endTime: $endTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, label, location, note, color, rotationWeek, day, startTime, endTime);
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
          other.endTime == this.endTime);
}

class SubjectCompanion extends UpdateCompanion<SubjectData> {
  final Value<int> id;
  final Value<String> label;
  final Value<String?> location;
  final Value<String?> note;
  final Value<int> color;
  final Value<RotationWeeks> rotationWeek;
  final Value<Days> day;
  final Value<material.TimeOfDay> startTime;
  final Value<material.TimeOfDay> endTime;
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
  });
  SubjectCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    required int color,
    required RotationWeeks rotationWeek,
    required Days day,
    required material.TimeOfDay startTime,
    required material.TimeOfDay endTime,
  })  : label = Value(label),
        color = Value(color),
        rotationWeek = Value(rotationWeek),
        day = Value(day),
        startTime = Value(startTime),
        endTime = Value(endTime);
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
    });
  }

  SubjectCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<String?>? location,
      Value<String?>? note,
      Value<int>? color,
      Value<RotationWeeks>? rotationWeek,
      Value<Days>? day,
      Value<material.TimeOfDay>? startTime,
      Value<material.TimeOfDay>? endTime}) {
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
      map['color'] = Variable<int>(color.value);
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
          ..write('endTime: $endTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $SubjectTable subject = $SubjectTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [subject];
}
