// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, SessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _specimenCodeMeta = const VerificationMeta(
    'specimenCode',
  );
  @override
  late final GeneratedColumn<String> specimenCode = GeneratedColumn<String>(
    'specimen_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specimenTypeMeta = const VerificationMeta(
    'specimenType',
  );
  @override
  late final GeneratedColumn<String> specimenType = GeneratedColumn<String>(
    'specimen_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleNameMeta = const VerificationMeta(
    'moduleName',
  );
  @override
  late final GeneratedColumn<String> moduleName = GeneratedColumn<String>(
    'module_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captureProfileMeta = const VerificationMeta(
    'captureProfile',
  );
  @override
  late final GeneratedColumn<String> captureProfile = GeneratedColumn<String>(
    'capture_profile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('40x Achromat • Brightfield'),
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
  static const VerificationMeta _operatorLabelMeta = const VerificationMeta(
    'operatorLabel',
  );
  @override
  late final GeneratedColumn<String> operatorLabel = GeneratedColumn<String>(
    'operator_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Lab Tech (Primary)'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inProgress'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    specimenCode,
    specimenType,
    moduleId,
    moduleName,
    captureProfile,
    createdAt,
    operatorLabel,
    notes,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('specimen_code')) {
      context.handle(
        _specimenCodeMeta,
        specimenCode.isAcceptableOrUnknown(
          data['specimen_code']!,
          _specimenCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_specimenCodeMeta);
    }
    if (data.containsKey('specimen_type')) {
      context.handle(
        _specimenTypeMeta,
        specimenType.isAcceptableOrUnknown(
          data['specimen_type']!,
          _specimenTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_specimenTypeMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('module_name')) {
      context.handle(
        _moduleNameMeta,
        moduleName.isAcceptableOrUnknown(data['module_name']!, _moduleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleNameMeta);
    }
    if (data.containsKey('capture_profile')) {
      context.handle(
        _captureProfileMeta,
        captureProfile.isAcceptableOrUnknown(
          data['capture_profile']!,
          _captureProfileMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('operator_label')) {
      context.handle(
        _operatorLabelMeta,
        operatorLabel.isAcceptableOrUnknown(
          data['operator_label']!,
          _operatorLabelMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      specimenCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specimen_code'],
      )!,
      specimenType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specimen_type'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      moduleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_name'],
      )!,
      captureProfile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capture_profile'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      operatorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_label'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SessionsTableTable createAlias(String alias) {
    return $SessionsTableTable(attachedDatabase, alias);
  }
}

class SessionsTableData extends DataClass
    implements Insertable<SessionsTableData> {
  final String id;
  final String title;
  final String specimenCode;
  final String specimenType;
  final String moduleId;
  final String moduleName;
  final String captureProfile;
  final DateTime createdAt;
  final String operatorLabel;
  final String notes;
  final String status;
  const SessionsTableData({
    required this.id,
    required this.title,
    required this.specimenCode,
    required this.specimenType,
    required this.moduleId,
    required this.moduleName,
    required this.captureProfile,
    required this.createdAt,
    required this.operatorLabel,
    required this.notes,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['specimen_code'] = Variable<String>(specimenCode);
    map['specimen_type'] = Variable<String>(specimenType);
    map['module_id'] = Variable<String>(moduleId);
    map['module_name'] = Variable<String>(moduleName);
    map['capture_profile'] = Variable<String>(captureProfile);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['operator_label'] = Variable<String>(operatorLabel);
    map['notes'] = Variable<String>(notes);
    map['status'] = Variable<String>(status);
    return map;
  }

  SessionsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionsTableCompanion(
      id: Value(id),
      title: Value(title),
      specimenCode: Value(specimenCode),
      specimenType: Value(specimenType),
      moduleId: Value(moduleId),
      moduleName: Value(moduleName),
      captureProfile: Value(captureProfile),
      createdAt: Value(createdAt),
      operatorLabel: Value(operatorLabel),
      notes: Value(notes),
      status: Value(status),
    );
  }

  factory SessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      specimenCode: serializer.fromJson<String>(json['specimenCode']),
      specimenType: serializer.fromJson<String>(json['specimenType']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      moduleName: serializer.fromJson<String>(json['moduleName']),
      captureProfile: serializer.fromJson<String>(json['captureProfile']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      operatorLabel: serializer.fromJson<String>(json['operatorLabel']),
      notes: serializer.fromJson<String>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'specimenCode': serializer.toJson<String>(specimenCode),
      'specimenType': serializer.toJson<String>(specimenType),
      'moduleId': serializer.toJson<String>(moduleId),
      'moduleName': serializer.toJson<String>(moduleName),
      'captureProfile': serializer.toJson<String>(captureProfile),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'operatorLabel': serializer.toJson<String>(operatorLabel),
      'notes': serializer.toJson<String>(notes),
      'status': serializer.toJson<String>(status),
    };
  }

  SessionsTableData copyWith({
    String? id,
    String? title,
    String? specimenCode,
    String? specimenType,
    String? moduleId,
    String? moduleName,
    String? captureProfile,
    DateTime? createdAt,
    String? operatorLabel,
    String? notes,
    String? status,
  }) => SessionsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    specimenCode: specimenCode ?? this.specimenCode,
    specimenType: specimenType ?? this.specimenType,
    moduleId: moduleId ?? this.moduleId,
    moduleName: moduleName ?? this.moduleName,
    captureProfile: captureProfile ?? this.captureProfile,
    createdAt: createdAt ?? this.createdAt,
    operatorLabel: operatorLabel ?? this.operatorLabel,
    notes: notes ?? this.notes,
    status: status ?? this.status,
  );
  SessionsTableData copyWithCompanion(SessionsTableCompanion data) {
    return SessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      specimenCode: data.specimenCode.present
          ? data.specimenCode.value
          : this.specimenCode,
      specimenType: data.specimenType.present
          ? data.specimenType.value
          : this.specimenType,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      moduleName: data.moduleName.present
          ? data.moduleName.value
          : this.moduleName,
      captureProfile: data.captureProfile.present
          ? data.captureProfile.value
          : this.captureProfile,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      operatorLabel: data.operatorLabel.present
          ? data.operatorLabel.value
          : this.operatorLabel,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('specimenCode: $specimenCode, ')
          ..write('specimenType: $specimenType, ')
          ..write('moduleId: $moduleId, ')
          ..write('moduleName: $moduleName, ')
          ..write('captureProfile: $captureProfile, ')
          ..write('createdAt: $createdAt, ')
          ..write('operatorLabel: $operatorLabel, ')
          ..write('notes: $notes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    specimenCode,
    specimenType,
    moduleId,
    moduleName,
    captureProfile,
    createdAt,
    operatorLabel,
    notes,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.specimenCode == this.specimenCode &&
          other.specimenType == this.specimenType &&
          other.moduleId == this.moduleId &&
          other.moduleName == this.moduleName &&
          other.captureProfile == this.captureProfile &&
          other.createdAt == this.createdAt &&
          other.operatorLabel == this.operatorLabel &&
          other.notes == this.notes &&
          other.status == this.status);
}

class SessionsTableCompanion extends UpdateCompanion<SessionsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> specimenCode;
  final Value<String> specimenType;
  final Value<String> moduleId;
  final Value<String> moduleName;
  final Value<String> captureProfile;
  final Value<DateTime> createdAt;
  final Value<String> operatorLabel;
  final Value<String> notes;
  final Value<String> status;
  final Value<int> rowid;
  const SessionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.specimenCode = const Value.absent(),
    this.specimenType = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.moduleName = const Value.absent(),
    this.captureProfile = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.operatorLabel = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsTableCompanion.insert({
    required String id,
    required String title,
    required String specimenCode,
    required String specimenType,
    required String moduleId,
    required String moduleName,
    this.captureProfile = const Value.absent(),
    required DateTime createdAt,
    this.operatorLabel = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       specimenCode = Value(specimenCode),
       specimenType = Value(specimenType),
       moduleId = Value(moduleId),
       moduleName = Value(moduleName),
       createdAt = Value(createdAt);
  static Insertable<SessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? specimenCode,
    Expression<String>? specimenType,
    Expression<String>? moduleId,
    Expression<String>? moduleName,
    Expression<String>? captureProfile,
    Expression<DateTime>? createdAt,
    Expression<String>? operatorLabel,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (specimenCode != null) 'specimen_code': specimenCode,
      if (specimenType != null) 'specimen_type': specimenType,
      if (moduleId != null) 'module_id': moduleId,
      if (moduleName != null) 'module_name': moduleName,
      if (captureProfile != null) 'capture_profile': captureProfile,
      if (createdAt != null) 'created_at': createdAt,
      if (operatorLabel != null) 'operator_label': operatorLabel,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? specimenCode,
    Value<String>? specimenType,
    Value<String>? moduleId,
    Value<String>? moduleName,
    Value<String>? captureProfile,
    Value<DateTime>? createdAt,
    Value<String>? operatorLabel,
    Value<String>? notes,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SessionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      specimenCode: specimenCode ?? this.specimenCode,
      specimenType: specimenType ?? this.specimenType,
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      captureProfile: captureProfile ?? this.captureProfile,
      createdAt: createdAt ?? this.createdAt,
      operatorLabel: operatorLabel ?? this.operatorLabel,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (specimenCode.present) {
      map['specimen_code'] = Variable<String>(specimenCode.value);
    }
    if (specimenType.present) {
      map['specimen_type'] = Variable<String>(specimenType.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (moduleName.present) {
      map['module_name'] = Variable<String>(moduleName.value);
    }
    if (captureProfile.present) {
      map['capture_profile'] = Variable<String>(captureProfile.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (operatorLabel.present) {
      map['operator_label'] = Variable<String>(operatorLabel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('specimenCode: $specimenCode, ')
          ..write('specimenType: $specimenType, ')
          ..write('moduleId: $moduleId, ')
          ..write('moduleName: $moduleName, ')
          ..write('captureProfile: $captureProfile, ')
          ..write('createdAt: $createdAt, ')
          ..write('operatorLabel: $operatorLabel, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImagesTableTable extends ImagesTable
    with TableInfo<$ImagesTableTable, ImagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fieldIndexMeta = const VerificationMeta(
    'fieldIndex',
  );
  @override
  late final GeneratedColumn<int> fieldIndex = GeneratedColumn<int>(
    'field_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetPathMeta = const VerificationMeta(
    'assetPath',
  );
  @override
  late final GeneratedColumn<String> assetPath = GeneratedColumn<String>(
    'asset_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _derivedPathMeta = const VerificationMeta(
    'derivedPath',
  );
  @override
  late final GeneratedColumn<String> derivedPath = GeneratedColumn<String>(
    'derived_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1920),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1080),
  );
  static const VerificationMeta _captureProfileMeta = const VerificationMeta(
    'captureProfile',
  );
  @override
  late final GeneratedColumn<String> captureProfile = GeneratedColumn<String>(
    'capture_profile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('40x Achromat • Brightfield'),
  );
  static const VerificationMeta _isUsableMeta = const VerificationMeta(
    'isUsable',
  );
  @override
  late final GeneratedColumn<bool> isUsable = GeneratedColumn<bool>(
    'is_usable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_usable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recaptureNeededMeta = const VerificationMeta(
    'recaptureNeeded',
  );
  @override
  late final GeneratedColumn<bool> recaptureNeeded = GeneratedColumn<bool>(
    'recapture_needed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recapture_needed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _laplacianSharpnessMeta =
      const VerificationMeta('laplacianSharpness');
  @override
  late final GeneratedColumn<double> laplacianSharpness =
      GeneratedColumn<double>(
        'laplacian_sharpness',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _meanLuminanceMeta = const VerificationMeta(
    'meanLuminance',
  );
  @override
  late final GeneratedColumn<double> meanLuminance = GeneratedColumn<double>(
    'mean_luminance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contrastRatioMeta = const VerificationMeta(
    'contrastRatio',
  );
  @override
  late final GeneratedColumn<double> contrastRatio = GeneratedColumn<double>(
    'contrast_ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fovCircularCoverageMeta =
      const VerificationMeta('fovCircularCoverage');
  @override
  late final GeneratedColumn<double> fovCircularCoverage =
      GeneratedColumn<double>(
        'fov_circular_coverage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isQualityPassedMeta = const VerificationMeta(
    'isQualityPassed',
  );
  @override
  late final GeneratedColumn<bool> isQualityPassed = GeneratedColumn<bool>(
    'is_quality_passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quality_passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _qualityWarningsJsonMeta =
      const VerificationMeta('qualityWarningsJson');
  @override
  late final GeneratedColumn<String> qualityWarningsJson =
      GeneratedColumn<String>(
        'quality_warnings_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    fieldIndex,
    assetPath,
    derivedPath,
    capturedAt,
    width,
    height,
    captureProfile,
    isUsable,
    recaptureNeeded,
    notes,
    laplacianSharpness,
    meanLuminance,
    contrastRatio,
    fovCircularCoverage,
    isQualityPassed,
    qualityWarningsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'images_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('field_index')) {
      context.handle(
        _fieldIndexMeta,
        fieldIndex.isAcceptableOrUnknown(data['field_index']!, _fieldIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIndexMeta);
    }
    if (data.containsKey('asset_path')) {
      context.handle(
        _assetPathMeta,
        assetPath.isAcceptableOrUnknown(data['asset_path']!, _assetPathMeta),
      );
    } else if (isInserting) {
      context.missing(_assetPathMeta);
    }
    if (data.containsKey('derived_path')) {
      context.handle(
        _derivedPathMeta,
        derivedPath.isAcceptableOrUnknown(
          data['derived_path']!,
          _derivedPathMeta,
        ),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('capture_profile')) {
      context.handle(
        _captureProfileMeta,
        captureProfile.isAcceptableOrUnknown(
          data['capture_profile']!,
          _captureProfileMeta,
        ),
      );
    }
    if (data.containsKey('is_usable')) {
      context.handle(
        _isUsableMeta,
        isUsable.isAcceptableOrUnknown(data['is_usable']!, _isUsableMeta),
      );
    }
    if (data.containsKey('recapture_needed')) {
      context.handle(
        _recaptureNeededMeta,
        recaptureNeeded.isAcceptableOrUnknown(
          data['recapture_needed']!,
          _recaptureNeededMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('laplacian_sharpness')) {
      context.handle(
        _laplacianSharpnessMeta,
        laplacianSharpness.isAcceptableOrUnknown(
          data['laplacian_sharpness']!,
          _laplacianSharpnessMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_laplacianSharpnessMeta);
    }
    if (data.containsKey('mean_luminance')) {
      context.handle(
        _meanLuminanceMeta,
        meanLuminance.isAcceptableOrUnknown(
          data['mean_luminance']!,
          _meanLuminanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_meanLuminanceMeta);
    }
    if (data.containsKey('contrast_ratio')) {
      context.handle(
        _contrastRatioMeta,
        contrastRatio.isAcceptableOrUnknown(
          data['contrast_ratio']!,
          _contrastRatioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contrastRatioMeta);
    }
    if (data.containsKey('fov_circular_coverage')) {
      context.handle(
        _fovCircularCoverageMeta,
        fovCircularCoverage.isAcceptableOrUnknown(
          data['fov_circular_coverage']!,
          _fovCircularCoverageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fovCircularCoverageMeta);
    }
    if (data.containsKey('is_quality_passed')) {
      context.handle(
        _isQualityPassedMeta,
        isQualityPassed.isAcceptableOrUnknown(
          data['is_quality_passed']!,
          _isQualityPassedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isQualityPassedMeta);
    }
    if (data.containsKey('quality_warnings_json')) {
      context.handle(
        _qualityWarningsJsonMeta,
        qualityWarningsJson.isAcceptableOrUnknown(
          data['quality_warnings_json']!,
          _qualityWarningsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      fieldIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}field_index'],
      )!,
      assetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_path'],
      )!,
      derivedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}derived_path'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      captureProfile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capture_profile'],
      )!,
      isUsable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_usable'],
      )!,
      recaptureNeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recapture_needed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      laplacianSharpness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}laplacian_sharpness'],
      )!,
      meanLuminance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mean_luminance'],
      )!,
      contrastRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}contrast_ratio'],
      )!,
      fovCircularCoverage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fov_circular_coverage'],
      )!,
      isQualityPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quality_passed'],
      )!,
      qualityWarningsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality_warnings_json'],
      )!,
    );
  }

  @override
  $ImagesTableTable createAlias(String alias) {
    return $ImagesTableTable(attachedDatabase, alias);
  }
}

class ImagesTableData extends DataClass implements Insertable<ImagesTableData> {
  final String id;
  final String sessionId;
  final int fieldIndex;
  final String assetPath;
  final String? derivedPath;
  final DateTime capturedAt;
  final int width;
  final int height;
  final String captureProfile;
  final bool isUsable;
  final bool recaptureNeeded;
  final String notes;
  final double laplacianSharpness;
  final double meanLuminance;
  final double contrastRatio;
  final double fovCircularCoverage;
  final bool isQualityPassed;
  final String qualityWarningsJson;
  const ImagesTableData({
    required this.id,
    required this.sessionId,
    required this.fieldIndex,
    required this.assetPath,
    this.derivedPath,
    required this.capturedAt,
    required this.width,
    required this.height,
    required this.captureProfile,
    required this.isUsable,
    required this.recaptureNeeded,
    required this.notes,
    required this.laplacianSharpness,
    required this.meanLuminance,
    required this.contrastRatio,
    required this.fovCircularCoverage,
    required this.isQualityPassed,
    required this.qualityWarningsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['field_index'] = Variable<int>(fieldIndex);
    map['asset_path'] = Variable<String>(assetPath);
    if (!nullToAbsent || derivedPath != null) {
      map['derived_path'] = Variable<String>(derivedPath);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['capture_profile'] = Variable<String>(captureProfile);
    map['is_usable'] = Variable<bool>(isUsable);
    map['recapture_needed'] = Variable<bool>(recaptureNeeded);
    map['notes'] = Variable<String>(notes);
    map['laplacian_sharpness'] = Variable<double>(laplacianSharpness);
    map['mean_luminance'] = Variable<double>(meanLuminance);
    map['contrast_ratio'] = Variable<double>(contrastRatio);
    map['fov_circular_coverage'] = Variable<double>(fovCircularCoverage);
    map['is_quality_passed'] = Variable<bool>(isQualityPassed);
    map['quality_warnings_json'] = Variable<String>(qualityWarningsJson);
    return map;
  }

  ImagesTableCompanion toCompanion(bool nullToAbsent) {
    return ImagesTableCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      fieldIndex: Value(fieldIndex),
      assetPath: Value(assetPath),
      derivedPath: derivedPath == null && nullToAbsent
          ? const Value.absent()
          : Value(derivedPath),
      capturedAt: Value(capturedAt),
      width: Value(width),
      height: Value(height),
      captureProfile: Value(captureProfile),
      isUsable: Value(isUsable),
      recaptureNeeded: Value(recaptureNeeded),
      notes: Value(notes),
      laplacianSharpness: Value(laplacianSharpness),
      meanLuminance: Value(meanLuminance),
      contrastRatio: Value(contrastRatio),
      fovCircularCoverage: Value(fovCircularCoverage),
      isQualityPassed: Value(isQualityPassed),
      qualityWarningsJson: Value(qualityWarningsJson),
    );
  }

  factory ImagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImagesTableData(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      fieldIndex: serializer.fromJson<int>(json['fieldIndex']),
      assetPath: serializer.fromJson<String>(json['assetPath']),
      derivedPath: serializer.fromJson<String?>(json['derivedPath']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      captureProfile: serializer.fromJson<String>(json['captureProfile']),
      isUsable: serializer.fromJson<bool>(json['isUsable']),
      recaptureNeeded: serializer.fromJson<bool>(json['recaptureNeeded']),
      notes: serializer.fromJson<String>(json['notes']),
      laplacianSharpness: serializer.fromJson<double>(
        json['laplacianSharpness'],
      ),
      meanLuminance: serializer.fromJson<double>(json['meanLuminance']),
      contrastRatio: serializer.fromJson<double>(json['contrastRatio']),
      fovCircularCoverage: serializer.fromJson<double>(
        json['fovCircularCoverage'],
      ),
      isQualityPassed: serializer.fromJson<bool>(json['isQualityPassed']),
      qualityWarningsJson: serializer.fromJson<String>(
        json['qualityWarningsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'fieldIndex': serializer.toJson<int>(fieldIndex),
      'assetPath': serializer.toJson<String>(assetPath),
      'derivedPath': serializer.toJson<String?>(derivedPath),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'captureProfile': serializer.toJson<String>(captureProfile),
      'isUsable': serializer.toJson<bool>(isUsable),
      'recaptureNeeded': serializer.toJson<bool>(recaptureNeeded),
      'notes': serializer.toJson<String>(notes),
      'laplacianSharpness': serializer.toJson<double>(laplacianSharpness),
      'meanLuminance': serializer.toJson<double>(meanLuminance),
      'contrastRatio': serializer.toJson<double>(contrastRatio),
      'fovCircularCoverage': serializer.toJson<double>(fovCircularCoverage),
      'isQualityPassed': serializer.toJson<bool>(isQualityPassed),
      'qualityWarningsJson': serializer.toJson<String>(qualityWarningsJson),
    };
  }

  ImagesTableData copyWith({
    String? id,
    String? sessionId,
    int? fieldIndex,
    String? assetPath,
    Value<String?> derivedPath = const Value.absent(),
    DateTime? capturedAt,
    int? width,
    int? height,
    String? captureProfile,
    bool? isUsable,
    bool? recaptureNeeded,
    String? notes,
    double? laplacianSharpness,
    double? meanLuminance,
    double? contrastRatio,
    double? fovCircularCoverage,
    bool? isQualityPassed,
    String? qualityWarningsJson,
  }) => ImagesTableData(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    fieldIndex: fieldIndex ?? this.fieldIndex,
    assetPath: assetPath ?? this.assetPath,
    derivedPath: derivedPath.present ? derivedPath.value : this.derivedPath,
    capturedAt: capturedAt ?? this.capturedAt,
    width: width ?? this.width,
    height: height ?? this.height,
    captureProfile: captureProfile ?? this.captureProfile,
    isUsable: isUsable ?? this.isUsable,
    recaptureNeeded: recaptureNeeded ?? this.recaptureNeeded,
    notes: notes ?? this.notes,
    laplacianSharpness: laplacianSharpness ?? this.laplacianSharpness,
    meanLuminance: meanLuminance ?? this.meanLuminance,
    contrastRatio: contrastRatio ?? this.contrastRatio,
    fovCircularCoverage: fovCircularCoverage ?? this.fovCircularCoverage,
    isQualityPassed: isQualityPassed ?? this.isQualityPassed,
    qualityWarningsJson: qualityWarningsJson ?? this.qualityWarningsJson,
  );
  ImagesTableData copyWithCompanion(ImagesTableCompanion data) {
    return ImagesTableData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      fieldIndex: data.fieldIndex.present
          ? data.fieldIndex.value
          : this.fieldIndex,
      assetPath: data.assetPath.present ? data.assetPath.value : this.assetPath,
      derivedPath: data.derivedPath.present
          ? data.derivedPath.value
          : this.derivedPath,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      captureProfile: data.captureProfile.present
          ? data.captureProfile.value
          : this.captureProfile,
      isUsable: data.isUsable.present ? data.isUsable.value : this.isUsable,
      recaptureNeeded: data.recaptureNeeded.present
          ? data.recaptureNeeded.value
          : this.recaptureNeeded,
      notes: data.notes.present ? data.notes.value : this.notes,
      laplacianSharpness: data.laplacianSharpness.present
          ? data.laplacianSharpness.value
          : this.laplacianSharpness,
      meanLuminance: data.meanLuminance.present
          ? data.meanLuminance.value
          : this.meanLuminance,
      contrastRatio: data.contrastRatio.present
          ? data.contrastRatio.value
          : this.contrastRatio,
      fovCircularCoverage: data.fovCircularCoverage.present
          ? data.fovCircularCoverage.value
          : this.fovCircularCoverage,
      isQualityPassed: data.isQualityPassed.present
          ? data.isQualityPassed.value
          : this.isQualityPassed,
      qualityWarningsJson: data.qualityWarningsJson.present
          ? data.qualityWarningsJson.value
          : this.qualityWarningsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImagesTableData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('fieldIndex: $fieldIndex, ')
          ..write('assetPath: $assetPath, ')
          ..write('derivedPath: $derivedPath, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('captureProfile: $captureProfile, ')
          ..write('isUsable: $isUsable, ')
          ..write('recaptureNeeded: $recaptureNeeded, ')
          ..write('notes: $notes, ')
          ..write('laplacianSharpness: $laplacianSharpness, ')
          ..write('meanLuminance: $meanLuminance, ')
          ..write('contrastRatio: $contrastRatio, ')
          ..write('fovCircularCoverage: $fovCircularCoverage, ')
          ..write('isQualityPassed: $isQualityPassed, ')
          ..write('qualityWarningsJson: $qualityWarningsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    fieldIndex,
    assetPath,
    derivedPath,
    capturedAt,
    width,
    height,
    captureProfile,
    isUsable,
    recaptureNeeded,
    notes,
    laplacianSharpness,
    meanLuminance,
    contrastRatio,
    fovCircularCoverage,
    isQualityPassed,
    qualityWarningsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImagesTableData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.fieldIndex == this.fieldIndex &&
          other.assetPath == this.assetPath &&
          other.derivedPath == this.derivedPath &&
          other.capturedAt == this.capturedAt &&
          other.width == this.width &&
          other.height == this.height &&
          other.captureProfile == this.captureProfile &&
          other.isUsable == this.isUsable &&
          other.recaptureNeeded == this.recaptureNeeded &&
          other.notes == this.notes &&
          other.laplacianSharpness == this.laplacianSharpness &&
          other.meanLuminance == this.meanLuminance &&
          other.contrastRatio == this.contrastRatio &&
          other.fovCircularCoverage == this.fovCircularCoverage &&
          other.isQualityPassed == this.isQualityPassed &&
          other.qualityWarningsJson == this.qualityWarningsJson);
}

class ImagesTableCompanion extends UpdateCompanion<ImagesTableData> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> fieldIndex;
  final Value<String> assetPath;
  final Value<String?> derivedPath;
  final Value<DateTime> capturedAt;
  final Value<int> width;
  final Value<int> height;
  final Value<String> captureProfile;
  final Value<bool> isUsable;
  final Value<bool> recaptureNeeded;
  final Value<String> notes;
  final Value<double> laplacianSharpness;
  final Value<double> meanLuminance;
  final Value<double> contrastRatio;
  final Value<double> fovCircularCoverage;
  final Value<bool> isQualityPassed;
  final Value<String> qualityWarningsJson;
  final Value<int> rowid;
  const ImagesTableCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.fieldIndex = const Value.absent(),
    this.assetPath = const Value.absent(),
    this.derivedPath = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.captureProfile = const Value.absent(),
    this.isUsable = const Value.absent(),
    this.recaptureNeeded = const Value.absent(),
    this.notes = const Value.absent(),
    this.laplacianSharpness = const Value.absent(),
    this.meanLuminance = const Value.absent(),
    this.contrastRatio = const Value.absent(),
    this.fovCircularCoverage = const Value.absent(),
    this.isQualityPassed = const Value.absent(),
    this.qualityWarningsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImagesTableCompanion.insert({
    required String id,
    required String sessionId,
    required int fieldIndex,
    required String assetPath,
    this.derivedPath = const Value.absent(),
    required DateTime capturedAt,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.captureProfile = const Value.absent(),
    this.isUsable = const Value.absent(),
    this.recaptureNeeded = const Value.absent(),
    this.notes = const Value.absent(),
    required double laplacianSharpness,
    required double meanLuminance,
    required double contrastRatio,
    required double fovCircularCoverage,
    required bool isQualityPassed,
    this.qualityWarningsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       fieldIndex = Value(fieldIndex),
       assetPath = Value(assetPath),
       capturedAt = Value(capturedAt),
       laplacianSharpness = Value(laplacianSharpness),
       meanLuminance = Value(meanLuminance),
       contrastRatio = Value(contrastRatio),
       fovCircularCoverage = Value(fovCircularCoverage),
       isQualityPassed = Value(isQualityPassed);
  static Insertable<ImagesTableData> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? fieldIndex,
    Expression<String>? assetPath,
    Expression<String>? derivedPath,
    Expression<DateTime>? capturedAt,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? captureProfile,
    Expression<bool>? isUsable,
    Expression<bool>? recaptureNeeded,
    Expression<String>? notes,
    Expression<double>? laplacianSharpness,
    Expression<double>? meanLuminance,
    Expression<double>? contrastRatio,
    Expression<double>? fovCircularCoverage,
    Expression<bool>? isQualityPassed,
    Expression<String>? qualityWarningsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (fieldIndex != null) 'field_index': fieldIndex,
      if (assetPath != null) 'asset_path': assetPath,
      if (derivedPath != null) 'derived_path': derivedPath,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (captureProfile != null) 'capture_profile': captureProfile,
      if (isUsable != null) 'is_usable': isUsable,
      if (recaptureNeeded != null) 'recapture_needed': recaptureNeeded,
      if (notes != null) 'notes': notes,
      if (laplacianSharpness != null) 'laplacian_sharpness': laplacianSharpness,
      if (meanLuminance != null) 'mean_luminance': meanLuminance,
      if (contrastRatio != null) 'contrast_ratio': contrastRatio,
      if (fovCircularCoverage != null)
        'fov_circular_coverage': fovCircularCoverage,
      if (isQualityPassed != null) 'is_quality_passed': isQualityPassed,
      if (qualityWarningsJson != null)
        'quality_warnings_json': qualityWarningsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? fieldIndex,
    Value<String>? assetPath,
    Value<String?>? derivedPath,
    Value<DateTime>? capturedAt,
    Value<int>? width,
    Value<int>? height,
    Value<String>? captureProfile,
    Value<bool>? isUsable,
    Value<bool>? recaptureNeeded,
    Value<String>? notes,
    Value<double>? laplacianSharpness,
    Value<double>? meanLuminance,
    Value<double>? contrastRatio,
    Value<double>? fovCircularCoverage,
    Value<bool>? isQualityPassed,
    Value<String>? qualityWarningsJson,
    Value<int>? rowid,
  }) {
    return ImagesTableCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      fieldIndex: fieldIndex ?? this.fieldIndex,
      assetPath: assetPath ?? this.assetPath,
      derivedPath: derivedPath ?? this.derivedPath,
      capturedAt: capturedAt ?? this.capturedAt,
      width: width ?? this.width,
      height: height ?? this.height,
      captureProfile: captureProfile ?? this.captureProfile,
      isUsable: isUsable ?? this.isUsable,
      recaptureNeeded: recaptureNeeded ?? this.recaptureNeeded,
      notes: notes ?? this.notes,
      laplacianSharpness: laplacianSharpness ?? this.laplacianSharpness,
      meanLuminance: meanLuminance ?? this.meanLuminance,
      contrastRatio: contrastRatio ?? this.contrastRatio,
      fovCircularCoverage: fovCircularCoverage ?? this.fovCircularCoverage,
      isQualityPassed: isQualityPassed ?? this.isQualityPassed,
      qualityWarningsJson: qualityWarningsJson ?? this.qualityWarningsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (fieldIndex.present) {
      map['field_index'] = Variable<int>(fieldIndex.value);
    }
    if (assetPath.present) {
      map['asset_path'] = Variable<String>(assetPath.value);
    }
    if (derivedPath.present) {
      map['derived_path'] = Variable<String>(derivedPath.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (captureProfile.present) {
      map['capture_profile'] = Variable<String>(captureProfile.value);
    }
    if (isUsable.present) {
      map['is_usable'] = Variable<bool>(isUsable.value);
    }
    if (recaptureNeeded.present) {
      map['recapture_needed'] = Variable<bool>(recaptureNeeded.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (laplacianSharpness.present) {
      map['laplacian_sharpness'] = Variable<double>(laplacianSharpness.value);
    }
    if (meanLuminance.present) {
      map['mean_luminance'] = Variable<double>(meanLuminance.value);
    }
    if (contrastRatio.present) {
      map['contrast_ratio'] = Variable<double>(contrastRatio.value);
    }
    if (fovCircularCoverage.present) {
      map['fov_circular_coverage'] = Variable<double>(
        fovCircularCoverage.value,
      );
    }
    if (isQualityPassed.present) {
      map['is_quality_passed'] = Variable<bool>(isQualityPassed.value);
    }
    if (qualityWarningsJson.present) {
      map['quality_warnings_json'] = Variable<String>(
        qualityWarningsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImagesTableCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('fieldIndex: $fieldIndex, ')
          ..write('assetPath: $assetPath, ')
          ..write('derivedPath: $derivedPath, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('captureProfile: $captureProfile, ')
          ..write('isUsable: $isUsable, ')
          ..write('recaptureNeeded: $recaptureNeeded, ')
          ..write('notes: $notes, ')
          ..write('laplacianSharpness: $laplacianSharpness, ')
          ..write('meanLuminance: $meanLuminance, ')
          ..write('contrastRatio: $contrastRatio, ')
          ..write('fovCircularCoverage: $fovCircularCoverage, ')
          ..write('isQualityPassed: $isQualityPassed, ')
          ..write('qualityWarningsJson: $qualityWarningsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnalysisRunsTableTable extends AnalysisRunsTable
    with TableInfo<$AnalysisRunsTableTable, AnalysisRunsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisRunsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageIdMeta = const VerificationMeta(
    'imageId',
  );
  @override
  late final GeneratedColumn<String> imageId = GeneratedColumn<String>(
    'image_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES images_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelVersionMeta = const VerificationMeta(
    'modelVersion',
  );
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
    'model_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processingMsMeta = const VerificationMeta(
    'processingMs',
  );
  @override
  late final GeneratedColumn<int> processingMs = GeneratedColumn<int>(
    'processing_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topPredictionJsonMeta = const VerificationMeta(
    'topPredictionJson',
  );
  @override
  late final GeneratedColumn<String> topPredictionJson =
      GeneratedColumn<String>(
        'top_prediction_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _allPredictionsJsonMeta =
      const VerificationMeta('allPredictionsJson');
  @override
  late final GeneratedColumn<String> allPredictionsJson =
      GeneratedColumn<String>(
        'all_predictions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _reviewerNotesMeta = const VerificationMeta(
    'reviewerNotes',
  );
  @override
  late final GeneratedColumn<String> reviewerNotes = GeneratedColumn<String>(
    'reviewer_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _correctedClassMeta = const VerificationMeta(
    'correctedClass',
  );
  @override
  late final GeneratedColumn<String> correctedClass = GeneratedColumn<String>(
    'corrected_class',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSimulatedMeta = const VerificationMeta(
    'isSimulated',
  );
  @override
  late final GeneratedColumn<bool> isSimulated = GeneratedColumn<bool>(
    'is_simulated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_simulated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imageId,
    modelId,
    modelVersion,
    taskType,
    startedAt,
    completedAt,
    processingMs,
    topPredictionJson,
    allPredictionsJson,
    reviewStatus,
    reviewerNotes,
    correctedClass,
    isSimulated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_runs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisRunsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('image_id')) {
      context.handle(
        _imageIdMeta,
        imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_imageIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('model_version')) {
      context.handle(
        _modelVersionMeta,
        modelVersion.isAcceptableOrUnknown(
          data['model_version']!,
          _modelVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('processing_ms')) {
      context.handle(
        _processingMsMeta,
        processingMs.isAcceptableOrUnknown(
          data['processing_ms']!,
          _processingMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processingMsMeta);
    }
    if (data.containsKey('top_prediction_json')) {
      context.handle(
        _topPredictionJsonMeta,
        topPredictionJson.isAcceptableOrUnknown(
          data['top_prediction_json']!,
          _topPredictionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_topPredictionJsonMeta);
    }
    if (data.containsKey('all_predictions_json')) {
      context.handle(
        _allPredictionsJsonMeta,
        allPredictionsJson.isAcceptableOrUnknown(
          data['all_predictions_json']!,
          _allPredictionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    }
    if (data.containsKey('reviewer_notes')) {
      context.handle(
        _reviewerNotesMeta,
        reviewerNotes.isAcceptableOrUnknown(
          data['reviewer_notes']!,
          _reviewerNotesMeta,
        ),
      );
    }
    if (data.containsKey('corrected_class')) {
      context.handle(
        _correctedClassMeta,
        correctedClass.isAcceptableOrUnknown(
          data['corrected_class']!,
          _correctedClassMeta,
        ),
      );
    }
    if (data.containsKey('is_simulated')) {
      context.handle(
        _isSimulatedMeta,
        isSimulated.isAcceptableOrUnknown(
          data['is_simulated']!,
          _isSimulatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisRunsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisRunsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      imageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      modelVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version'],
      )!,
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      processingMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processing_ms'],
      )!,
      topPredictionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_prediction_json'],
      )!,
      allPredictionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}all_predictions_json'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      reviewerNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewer_notes'],
      )!,
      correctedClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corrected_class'],
      ),
      isSimulated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_simulated'],
      )!,
    );
  }

  @override
  $AnalysisRunsTableTable createAlias(String alias) {
    return $AnalysisRunsTableTable(attachedDatabase, alias);
  }
}

class AnalysisRunsTableData extends DataClass
    implements Insertable<AnalysisRunsTableData> {
  final String id;
  final String imageId;
  final String modelId;
  final String modelVersion;
  final String taskType;
  final DateTime startedAt;
  final DateTime completedAt;
  final int processingMs;
  final String topPredictionJson;
  final String allPredictionsJson;
  final String reviewStatus;
  final String reviewerNotes;
  final String? correctedClass;
  final bool isSimulated;
  const AnalysisRunsTableData({
    required this.id,
    required this.imageId,
    required this.modelId,
    required this.modelVersion,
    required this.taskType,
    required this.startedAt,
    required this.completedAt,
    required this.processingMs,
    required this.topPredictionJson,
    required this.allPredictionsJson,
    required this.reviewStatus,
    required this.reviewerNotes,
    this.correctedClass,
    required this.isSimulated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['image_id'] = Variable<String>(imageId);
    map['model_id'] = Variable<String>(modelId);
    map['model_version'] = Variable<String>(modelVersion);
    map['task_type'] = Variable<String>(taskType);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['processing_ms'] = Variable<int>(processingMs);
    map['top_prediction_json'] = Variable<String>(topPredictionJson);
    map['all_predictions_json'] = Variable<String>(allPredictionsJson);
    map['review_status'] = Variable<String>(reviewStatus);
    map['reviewer_notes'] = Variable<String>(reviewerNotes);
    if (!nullToAbsent || correctedClass != null) {
      map['corrected_class'] = Variable<String>(correctedClass);
    }
    map['is_simulated'] = Variable<bool>(isSimulated);
    return map;
  }

  AnalysisRunsTableCompanion toCompanion(bool nullToAbsent) {
    return AnalysisRunsTableCompanion(
      id: Value(id),
      imageId: Value(imageId),
      modelId: Value(modelId),
      modelVersion: Value(modelVersion),
      taskType: Value(taskType),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      processingMs: Value(processingMs),
      topPredictionJson: Value(topPredictionJson),
      allPredictionsJson: Value(allPredictionsJson),
      reviewStatus: Value(reviewStatus),
      reviewerNotes: Value(reviewerNotes),
      correctedClass: correctedClass == null && nullToAbsent
          ? const Value.absent()
          : Value(correctedClass),
      isSimulated: Value(isSimulated),
    );
  }

  factory AnalysisRunsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisRunsTableData(
      id: serializer.fromJson<String>(json['id']),
      imageId: serializer.fromJson<String>(json['imageId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
      taskType: serializer.fromJson<String>(json['taskType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      processingMs: serializer.fromJson<int>(json['processingMs']),
      topPredictionJson: serializer.fromJson<String>(json['topPredictionJson']),
      allPredictionsJson: serializer.fromJson<String>(
        json['allPredictionsJson'],
      ),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      reviewerNotes: serializer.fromJson<String>(json['reviewerNotes']),
      correctedClass: serializer.fromJson<String?>(json['correctedClass']),
      isSimulated: serializer.fromJson<bool>(json['isSimulated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'imageId': serializer.toJson<String>(imageId),
      'modelId': serializer.toJson<String>(modelId),
      'modelVersion': serializer.toJson<String>(modelVersion),
      'taskType': serializer.toJson<String>(taskType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'processingMs': serializer.toJson<int>(processingMs),
      'topPredictionJson': serializer.toJson<String>(topPredictionJson),
      'allPredictionsJson': serializer.toJson<String>(allPredictionsJson),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'reviewerNotes': serializer.toJson<String>(reviewerNotes),
      'correctedClass': serializer.toJson<String?>(correctedClass),
      'isSimulated': serializer.toJson<bool>(isSimulated),
    };
  }

  AnalysisRunsTableData copyWith({
    String? id,
    String? imageId,
    String? modelId,
    String? modelVersion,
    String? taskType,
    DateTime? startedAt,
    DateTime? completedAt,
    int? processingMs,
    String? topPredictionJson,
    String? allPredictionsJson,
    String? reviewStatus,
    String? reviewerNotes,
    Value<String?> correctedClass = const Value.absent(),
    bool? isSimulated,
  }) => AnalysisRunsTableData(
    id: id ?? this.id,
    imageId: imageId ?? this.imageId,
    modelId: modelId ?? this.modelId,
    modelVersion: modelVersion ?? this.modelVersion,
    taskType: taskType ?? this.taskType,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    processingMs: processingMs ?? this.processingMs,
    topPredictionJson: topPredictionJson ?? this.topPredictionJson,
    allPredictionsJson: allPredictionsJson ?? this.allPredictionsJson,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    reviewerNotes: reviewerNotes ?? this.reviewerNotes,
    correctedClass: correctedClass.present
        ? correctedClass.value
        : this.correctedClass,
    isSimulated: isSimulated ?? this.isSimulated,
  );
  AnalysisRunsTableData copyWithCompanion(AnalysisRunsTableCompanion data) {
    return AnalysisRunsTableData(
      id: data.id.present ? data.id.value : this.id,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      processingMs: data.processingMs.present
          ? data.processingMs.value
          : this.processingMs,
      topPredictionJson: data.topPredictionJson.present
          ? data.topPredictionJson.value
          : this.topPredictionJson,
      allPredictionsJson: data.allPredictionsJson.present
          ? data.allPredictionsJson.value
          : this.allPredictionsJson,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      reviewerNotes: data.reviewerNotes.present
          ? data.reviewerNotes.value
          : this.reviewerNotes,
      correctedClass: data.correctedClass.present
          ? data.correctedClass.value
          : this.correctedClass,
      isSimulated: data.isSimulated.present
          ? data.isSimulated.value
          : this.isSimulated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRunsTableData(')
          ..write('id: $id, ')
          ..write('imageId: $imageId, ')
          ..write('modelId: $modelId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('taskType: $taskType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('processingMs: $processingMs, ')
          ..write('topPredictionJson: $topPredictionJson, ')
          ..write('allPredictionsJson: $allPredictionsJson, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewerNotes: $reviewerNotes, ')
          ..write('correctedClass: $correctedClass, ')
          ..write('isSimulated: $isSimulated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    imageId,
    modelId,
    modelVersion,
    taskType,
    startedAt,
    completedAt,
    processingMs,
    topPredictionJson,
    allPredictionsJson,
    reviewStatus,
    reviewerNotes,
    correctedClass,
    isSimulated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisRunsTableData &&
          other.id == this.id &&
          other.imageId == this.imageId &&
          other.modelId == this.modelId &&
          other.modelVersion == this.modelVersion &&
          other.taskType == this.taskType &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.processingMs == this.processingMs &&
          other.topPredictionJson == this.topPredictionJson &&
          other.allPredictionsJson == this.allPredictionsJson &&
          other.reviewStatus == this.reviewStatus &&
          other.reviewerNotes == this.reviewerNotes &&
          other.correctedClass == this.correctedClass &&
          other.isSimulated == this.isSimulated);
}

class AnalysisRunsTableCompanion
    extends UpdateCompanion<AnalysisRunsTableData> {
  final Value<String> id;
  final Value<String> imageId;
  final Value<String> modelId;
  final Value<String> modelVersion;
  final Value<String> taskType;
  final Value<DateTime> startedAt;
  final Value<DateTime> completedAt;
  final Value<int> processingMs;
  final Value<String> topPredictionJson;
  final Value<String> allPredictionsJson;
  final Value<String> reviewStatus;
  final Value<String> reviewerNotes;
  final Value<String?> correctedClass;
  final Value<bool> isSimulated;
  final Value<int> rowid;
  const AnalysisRunsTableCompanion({
    this.id = const Value.absent(),
    this.imageId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.taskType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.processingMs = const Value.absent(),
    this.topPredictionJson = const Value.absent(),
    this.allPredictionsJson = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewerNotes = const Value.absent(),
    this.correctedClass = const Value.absent(),
    this.isSimulated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisRunsTableCompanion.insert({
    required String id,
    required String imageId,
    required String modelId,
    required String modelVersion,
    required String taskType,
    required DateTime startedAt,
    required DateTime completedAt,
    required int processingMs,
    required String topPredictionJson,
    this.allPredictionsJson = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewerNotes = const Value.absent(),
    this.correctedClass = const Value.absent(),
    this.isSimulated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       imageId = Value(imageId),
       modelId = Value(modelId),
       modelVersion = Value(modelVersion),
       taskType = Value(taskType),
       startedAt = Value(startedAt),
       completedAt = Value(completedAt),
       processingMs = Value(processingMs),
       topPredictionJson = Value(topPredictionJson);
  static Insertable<AnalysisRunsTableData> custom({
    Expression<String>? id,
    Expression<String>? imageId,
    Expression<String>? modelId,
    Expression<String>? modelVersion,
    Expression<String>? taskType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? processingMs,
    Expression<String>? topPredictionJson,
    Expression<String>? allPredictionsJson,
    Expression<String>? reviewStatus,
    Expression<String>? reviewerNotes,
    Expression<String>? correctedClass,
    Expression<bool>? isSimulated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imageId != null) 'image_id': imageId,
      if (modelId != null) 'model_id': modelId,
      if (modelVersion != null) 'model_version': modelVersion,
      if (taskType != null) 'task_type': taskType,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (processingMs != null) 'processing_ms': processingMs,
      if (topPredictionJson != null) 'top_prediction_json': topPredictionJson,
      if (allPredictionsJson != null)
        'all_predictions_json': allPredictionsJson,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (reviewerNotes != null) 'reviewer_notes': reviewerNotes,
      if (correctedClass != null) 'corrected_class': correctedClass,
      if (isSimulated != null) 'is_simulated': isSimulated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisRunsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? imageId,
    Value<String>? modelId,
    Value<String>? modelVersion,
    Value<String>? taskType,
    Value<DateTime>? startedAt,
    Value<DateTime>? completedAt,
    Value<int>? processingMs,
    Value<String>? topPredictionJson,
    Value<String>? allPredictionsJson,
    Value<String>? reviewStatus,
    Value<String>? reviewerNotes,
    Value<String?>? correctedClass,
    Value<bool>? isSimulated,
    Value<int>? rowid,
  }) {
    return AnalysisRunsTableCompanion(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      modelId: modelId ?? this.modelId,
      modelVersion: modelVersion ?? this.modelVersion,
      taskType: taskType ?? this.taskType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      processingMs: processingMs ?? this.processingMs,
      topPredictionJson: topPredictionJson ?? this.topPredictionJson,
      allPredictionsJson: allPredictionsJson ?? this.allPredictionsJson,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewerNotes: reviewerNotes ?? this.reviewerNotes,
      correctedClass: correctedClass ?? this.correctedClass,
      isSimulated: isSimulated ?? this.isSimulated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<String>(imageId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (processingMs.present) {
      map['processing_ms'] = Variable<int>(processingMs.value);
    }
    if (topPredictionJson.present) {
      map['top_prediction_json'] = Variable<String>(topPredictionJson.value);
    }
    if (allPredictionsJson.present) {
      map['all_predictions_json'] = Variable<String>(allPredictionsJson.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (reviewerNotes.present) {
      map['reviewer_notes'] = Variable<String>(reviewerNotes.value);
    }
    if (correctedClass.present) {
      map['corrected_class'] = Variable<String>(correctedClass.value);
    }
    if (isSimulated.present) {
      map['is_simulated'] = Variable<bool>(isSimulated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisRunsTableCompanion(')
          ..write('id: $id, ')
          ..write('imageId: $imageId, ')
          ..write('modelId: $modelId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('taskType: $taskType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('processingMs: $processingMs, ')
          ..write('topPredictionJson: $topPredictionJson, ')
          ..write('allPredictionsJson: $allPredictionsJson, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewerNotes: $reviewerNotes, ')
          ..write('correctedClass: $correctedClass, ')
          ..write('isSimulated: $isSimulated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTableTable extends AnnotationsTable
    with TableInfo<$AnnotationsTableTable, AnnotationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisRunIdMeta = const VerificationMeta(
    'analysisRunId',
  );
  @override
  late final GeneratedColumn<String> analysisRunId = GeneratedColumn<String>(
    'analysis_run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES analysis_runs_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<String> classId = GeneratedColumn<String>(
    'class_id',
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
  static const VerificationMeta _boxXMeta = const VerificationMeta('boxX');
  @override
  late final GeneratedColumn<double> boxX = GeneratedColumn<double>(
    'box_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxYMeta = const VerificationMeta('boxY');
  @override
  late final GeneratedColumn<double> boxY = GeneratedColumn<double>(
    'box_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxWidthMeta = const VerificationMeta(
    'boxWidth',
  );
  @override
  late final GeneratedColumn<double> boxWidth = GeneratedColumn<double>(
    'box_width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxHeightMeta = const VerificationMeta(
    'boxHeight',
  );
  @override
  late final GeneratedColumn<double> boxHeight = GeneratedColumn<double>(
    'box_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isModelGeneratedMeta = const VerificationMeta(
    'isModelGenerated',
  );
  @override
  late final GeneratedColumn<bool> isModelGenerated = GeneratedColumn<bool>(
    'is_model_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_model_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isUserModifiedMeta = const VerificationMeta(
    'isUserModified',
  );
  @override
  late final GeneratedColumn<bool> isUserModified = GeneratedColumn<bool>(
    'is_user_modified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user_modified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisRunId,
    classId,
    label,
    boxX,
    boxY,
    boxWidth,
    boxHeight,
    confidence,
    isModelGenerated,
    isUserModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnnotationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_run_id')) {
      context.handle(
        _analysisRunIdMeta,
        analysisRunId.isAcceptableOrUnknown(
          data['analysis_run_id']!,
          _analysisRunIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisRunIdMeta);
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('box_x')) {
      context.handle(
        _boxXMeta,
        boxX.isAcceptableOrUnknown(data['box_x']!, _boxXMeta),
      );
    } else if (isInserting) {
      context.missing(_boxXMeta);
    }
    if (data.containsKey('box_y')) {
      context.handle(
        _boxYMeta,
        boxY.isAcceptableOrUnknown(data['box_y']!, _boxYMeta),
      );
    } else if (isInserting) {
      context.missing(_boxYMeta);
    }
    if (data.containsKey('box_width')) {
      context.handle(
        _boxWidthMeta,
        boxWidth.isAcceptableOrUnknown(data['box_width']!, _boxWidthMeta),
      );
    } else if (isInserting) {
      context.missing(_boxWidthMeta);
    }
    if (data.containsKey('box_height')) {
      context.handle(
        _boxHeightMeta,
        boxHeight.isAcceptableOrUnknown(data['box_height']!, _boxHeightMeta),
      );
    } else if (isInserting) {
      context.missing(_boxHeightMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('is_model_generated')) {
      context.handle(
        _isModelGeneratedMeta,
        isModelGenerated.isAcceptableOrUnknown(
          data['is_model_generated']!,
          _isModelGeneratedMeta,
        ),
      );
    }
    if (data.containsKey('is_user_modified')) {
      context.handle(
        _isUserModifiedMeta,
        isUserModified.isAcceptableOrUnknown(
          data['is_user_modified']!,
          _isUserModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnnotationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnotationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_run_id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      boxX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}box_x'],
      )!,
      boxY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}box_y'],
      )!,
      boxWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}box_width'],
      )!,
      boxHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}box_height'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      isModelGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_model_generated'],
      )!,
      isUserModified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user_modified'],
      )!,
    );
  }

  @override
  $AnnotationsTableTable createAlias(String alias) {
    return $AnnotationsTableTable(attachedDatabase, alias);
  }
}

class AnnotationsTableData extends DataClass
    implements Insertable<AnnotationsTableData> {
  final String id;
  final String analysisRunId;
  final String classId;
  final String label;
  final double boxX;
  final double boxY;
  final double boxWidth;
  final double boxHeight;
  final double confidence;
  final bool isModelGenerated;
  final bool isUserModified;
  const AnnotationsTableData({
    required this.id,
    required this.analysisRunId,
    required this.classId,
    required this.label,
    required this.boxX,
    required this.boxY,
    required this.boxWidth,
    required this.boxHeight,
    required this.confidence,
    required this.isModelGenerated,
    required this.isUserModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_run_id'] = Variable<String>(analysisRunId);
    map['class_id'] = Variable<String>(classId);
    map['label'] = Variable<String>(label);
    map['box_x'] = Variable<double>(boxX);
    map['box_y'] = Variable<double>(boxY);
    map['box_width'] = Variable<double>(boxWidth);
    map['box_height'] = Variable<double>(boxHeight);
    map['confidence'] = Variable<double>(confidence);
    map['is_model_generated'] = Variable<bool>(isModelGenerated);
    map['is_user_modified'] = Variable<bool>(isUserModified);
    return map;
  }

  AnnotationsTableCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsTableCompanion(
      id: Value(id),
      analysisRunId: Value(analysisRunId),
      classId: Value(classId),
      label: Value(label),
      boxX: Value(boxX),
      boxY: Value(boxY),
      boxWidth: Value(boxWidth),
      boxHeight: Value(boxHeight),
      confidence: Value(confidence),
      isModelGenerated: Value(isModelGenerated),
      isUserModified: Value(isUserModified),
    );
  }

  factory AnnotationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnotationsTableData(
      id: serializer.fromJson<String>(json['id']),
      analysisRunId: serializer.fromJson<String>(json['analysisRunId']),
      classId: serializer.fromJson<String>(json['classId']),
      label: serializer.fromJson<String>(json['label']),
      boxX: serializer.fromJson<double>(json['boxX']),
      boxY: serializer.fromJson<double>(json['boxY']),
      boxWidth: serializer.fromJson<double>(json['boxWidth']),
      boxHeight: serializer.fromJson<double>(json['boxHeight']),
      confidence: serializer.fromJson<double>(json['confidence']),
      isModelGenerated: serializer.fromJson<bool>(json['isModelGenerated']),
      isUserModified: serializer.fromJson<bool>(json['isUserModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisRunId': serializer.toJson<String>(analysisRunId),
      'classId': serializer.toJson<String>(classId),
      'label': serializer.toJson<String>(label),
      'boxX': serializer.toJson<double>(boxX),
      'boxY': serializer.toJson<double>(boxY),
      'boxWidth': serializer.toJson<double>(boxWidth),
      'boxHeight': serializer.toJson<double>(boxHeight),
      'confidence': serializer.toJson<double>(confidence),
      'isModelGenerated': serializer.toJson<bool>(isModelGenerated),
      'isUserModified': serializer.toJson<bool>(isUserModified),
    };
  }

  AnnotationsTableData copyWith({
    String? id,
    String? analysisRunId,
    String? classId,
    String? label,
    double? boxX,
    double? boxY,
    double? boxWidth,
    double? boxHeight,
    double? confidence,
    bool? isModelGenerated,
    bool? isUserModified,
  }) => AnnotationsTableData(
    id: id ?? this.id,
    analysisRunId: analysisRunId ?? this.analysisRunId,
    classId: classId ?? this.classId,
    label: label ?? this.label,
    boxX: boxX ?? this.boxX,
    boxY: boxY ?? this.boxY,
    boxWidth: boxWidth ?? this.boxWidth,
    boxHeight: boxHeight ?? this.boxHeight,
    confidence: confidence ?? this.confidence,
    isModelGenerated: isModelGenerated ?? this.isModelGenerated,
    isUserModified: isUserModified ?? this.isUserModified,
  );
  AnnotationsTableData copyWithCompanion(AnnotationsTableCompanion data) {
    return AnnotationsTableData(
      id: data.id.present ? data.id.value : this.id,
      analysisRunId: data.analysisRunId.present
          ? data.analysisRunId.value
          : this.analysisRunId,
      classId: data.classId.present ? data.classId.value : this.classId,
      label: data.label.present ? data.label.value : this.label,
      boxX: data.boxX.present ? data.boxX.value : this.boxX,
      boxY: data.boxY.present ? data.boxY.value : this.boxY,
      boxWidth: data.boxWidth.present ? data.boxWidth.value : this.boxWidth,
      boxHeight: data.boxHeight.present ? data.boxHeight.value : this.boxHeight,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      isModelGenerated: data.isModelGenerated.present
          ? data.isModelGenerated.value
          : this.isModelGenerated,
      isUserModified: data.isUserModified.present
          ? data.isUserModified.value
          : this.isUserModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsTableData(')
          ..write('id: $id, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('classId: $classId, ')
          ..write('label: $label, ')
          ..write('boxX: $boxX, ')
          ..write('boxY: $boxY, ')
          ..write('boxWidth: $boxWidth, ')
          ..write('boxHeight: $boxHeight, ')
          ..write('confidence: $confidence, ')
          ..write('isModelGenerated: $isModelGenerated, ')
          ..write('isUserModified: $isUserModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisRunId,
    classId,
    label,
    boxX,
    boxY,
    boxWidth,
    boxHeight,
    confidence,
    isModelGenerated,
    isUserModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnotationsTableData &&
          other.id == this.id &&
          other.analysisRunId == this.analysisRunId &&
          other.classId == this.classId &&
          other.label == this.label &&
          other.boxX == this.boxX &&
          other.boxY == this.boxY &&
          other.boxWidth == this.boxWidth &&
          other.boxHeight == this.boxHeight &&
          other.confidence == this.confidence &&
          other.isModelGenerated == this.isModelGenerated &&
          other.isUserModified == this.isUserModified);
}

class AnnotationsTableCompanion extends UpdateCompanion<AnnotationsTableData> {
  final Value<String> id;
  final Value<String> analysisRunId;
  final Value<String> classId;
  final Value<String> label;
  final Value<double> boxX;
  final Value<double> boxY;
  final Value<double> boxWidth;
  final Value<double> boxHeight;
  final Value<double> confidence;
  final Value<bool> isModelGenerated;
  final Value<bool> isUserModified;
  final Value<int> rowid;
  const AnnotationsTableCompanion({
    this.id = const Value.absent(),
    this.analysisRunId = const Value.absent(),
    this.classId = const Value.absent(),
    this.label = const Value.absent(),
    this.boxX = const Value.absent(),
    this.boxY = const Value.absent(),
    this.boxWidth = const Value.absent(),
    this.boxHeight = const Value.absent(),
    this.confidence = const Value.absent(),
    this.isModelGenerated = const Value.absent(),
    this.isUserModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnotationsTableCompanion.insert({
    required String id,
    required String analysisRunId,
    required String classId,
    required String label,
    required double boxX,
    required double boxY,
    required double boxWidth,
    required double boxHeight,
    required double confidence,
    this.isModelGenerated = const Value.absent(),
    this.isUserModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisRunId = Value(analysisRunId),
       classId = Value(classId),
       label = Value(label),
       boxX = Value(boxX),
       boxY = Value(boxY),
       boxWidth = Value(boxWidth),
       boxHeight = Value(boxHeight),
       confidence = Value(confidence);
  static Insertable<AnnotationsTableData> custom({
    Expression<String>? id,
    Expression<String>? analysisRunId,
    Expression<String>? classId,
    Expression<String>? label,
    Expression<double>? boxX,
    Expression<double>? boxY,
    Expression<double>? boxWidth,
    Expression<double>? boxHeight,
    Expression<double>? confidence,
    Expression<bool>? isModelGenerated,
    Expression<bool>? isUserModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisRunId != null) 'analysis_run_id': analysisRunId,
      if (classId != null) 'class_id': classId,
      if (label != null) 'label': label,
      if (boxX != null) 'box_x': boxX,
      if (boxY != null) 'box_y': boxY,
      if (boxWidth != null) 'box_width': boxWidth,
      if (boxHeight != null) 'box_height': boxHeight,
      if (confidence != null) 'confidence': confidence,
      if (isModelGenerated != null) 'is_model_generated': isModelGenerated,
      if (isUserModified != null) 'is_user_modified': isUserModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnotationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisRunId,
    Value<String>? classId,
    Value<String>? label,
    Value<double>? boxX,
    Value<double>? boxY,
    Value<double>? boxWidth,
    Value<double>? boxHeight,
    Value<double>? confidence,
    Value<bool>? isModelGenerated,
    Value<bool>? isUserModified,
    Value<int>? rowid,
  }) {
    return AnnotationsTableCompanion(
      id: id ?? this.id,
      analysisRunId: analysisRunId ?? this.analysisRunId,
      classId: classId ?? this.classId,
      label: label ?? this.label,
      boxX: boxX ?? this.boxX,
      boxY: boxY ?? this.boxY,
      boxWidth: boxWidth ?? this.boxWidth,
      boxHeight: boxHeight ?? this.boxHeight,
      confidence: confidence ?? this.confidence,
      isModelGenerated: isModelGenerated ?? this.isModelGenerated,
      isUserModified: isUserModified ?? this.isUserModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisRunId.present) {
      map['analysis_run_id'] = Variable<String>(analysisRunId.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<String>(classId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (boxX.present) {
      map['box_x'] = Variable<double>(boxX.value);
    }
    if (boxY.present) {
      map['box_y'] = Variable<double>(boxY.value);
    }
    if (boxWidth.present) {
      map['box_width'] = Variable<double>(boxWidth.value);
    }
    if (boxHeight.present) {
      map['box_height'] = Variable<double>(boxHeight.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (isModelGenerated.present) {
      map['is_model_generated'] = Variable<bool>(isModelGenerated.value);
    }
    if (isUserModified.present) {
      map['is_user_modified'] = Variable<bool>(isUserModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsTableCompanion(')
          ..write('id: $id, ')
          ..write('analysisRunId: $analysisRunId, ')
          ..write('classId: $classId, ')
          ..write('label: $label, ')
          ..write('boxX: $boxX, ')
          ..write('boxY: $boxY, ')
          ..write('boxWidth: $boxWidth, ')
          ..write('boxHeight: $boxHeight, ')
          ..write('confidence: $confidence, ')
          ..write('isModelGenerated: $isModelGenerated, ')
          ..write('isUserModified: $isUserModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelInstallationsTableTable extends ModelInstallationsTable
    with TableInfo<$ModelInstallationsTableTable, ModelInstallationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelInstallationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runtimeMeta = const VerificationMeta(
    'runtime',
  );
  @override
  late final GeneratedColumn<String> runtime = GeneratedColumn<String>(
    'runtime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256ChecksumMeta = const VerificationMeta(
    'sha256Checksum',
  );
  @override
  late final GeneratedColumn<String> sha256Checksum = GeneratedColumn<String>(
    'sha256_checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInstalledMeta = const VerificationMeta(
    'isInstalled',
  );
  @override
  late final GeneratedColumn<bool> isInstalled = GeneratedColumn<bool>(
    'is_installed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_installed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyReportMeta = const VerificationMeta(
    'accuracyReport',
  );
  @override
  late final GeneratedColumn<String> accuracyReport = GeneratedColumn<String>(
    'accuracy_report',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputDimensionsMeta = const VerificationMeta(
    'inputDimensions',
  );
  @override
  late final GeneratedColumn<String> inputDimensions = GeneratedColumn<String>(
    'input_dimensions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    modelId,
    name,
    version,
    moduleId,
    runtime,
    taskType,
    sizeBytes,
    sha256Checksum,
    isInstalled,
    installedAt,
    accuracyReport,
    inputDimensions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_installations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelInstallationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('runtime')) {
      context.handle(
        _runtimeMeta,
        runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta),
      );
    } else if (isInserting) {
      context.missing(_runtimeMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256_checksum')) {
      context.handle(
        _sha256ChecksumMeta,
        sha256Checksum.isAcceptableOrUnknown(
          data['sha256_checksum']!,
          _sha256ChecksumMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sha256ChecksumMeta);
    }
    if (data.containsKey('is_installed')) {
      context.handle(
        _isInstalledMeta,
        isInstalled.isAcceptableOrUnknown(
          data['is_installed']!,
          _isInstalledMeta,
        ),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('accuracy_report')) {
      context.handle(
        _accuracyReportMeta,
        accuracyReport.isAcceptableOrUnknown(
          data['accuracy_report']!,
          _accuracyReportMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyReportMeta);
    }
    if (data.containsKey('input_dimensions')) {
      context.handle(
        _inputDimensionsMeta,
        inputDimensions.isAcceptableOrUnknown(
          data['input_dimensions']!,
          _inputDimensionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputDimensionsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {modelId};
  @override
  ModelInstallationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelInstallationsTableData(
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      runtime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}runtime'],
      )!,
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      sha256Checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256_checksum'],
      )!,
      isInstalled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_installed'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
      accuracyReport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accuracy_report'],
      )!,
      inputDimensions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_dimensions'],
      )!,
    );
  }

  @override
  $ModelInstallationsTableTable createAlias(String alias) {
    return $ModelInstallationsTableTable(attachedDatabase, alias);
  }
}

class ModelInstallationsTableData extends DataClass
    implements Insertable<ModelInstallationsTableData> {
  final String modelId;
  final String name;
  final String version;
  final String moduleId;
  final String runtime;
  final String taskType;
  final int sizeBytes;
  final String sha256Checksum;
  final bool isInstalled;
  final DateTime installedAt;
  final String accuracyReport;
  final String inputDimensions;
  const ModelInstallationsTableData({
    required this.modelId,
    required this.name,
    required this.version,
    required this.moduleId,
    required this.runtime,
    required this.taskType,
    required this.sizeBytes,
    required this.sha256Checksum,
    required this.isInstalled,
    required this.installedAt,
    required this.accuracyReport,
    required this.inputDimensions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['model_id'] = Variable<String>(modelId);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    map['module_id'] = Variable<String>(moduleId);
    map['runtime'] = Variable<String>(runtime);
    map['task_type'] = Variable<String>(taskType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256_checksum'] = Variable<String>(sha256Checksum);
    map['is_installed'] = Variable<bool>(isInstalled);
    map['installed_at'] = Variable<DateTime>(installedAt);
    map['accuracy_report'] = Variable<String>(accuracyReport);
    map['input_dimensions'] = Variable<String>(inputDimensions);
    return map;
  }

  ModelInstallationsTableCompanion toCompanion(bool nullToAbsent) {
    return ModelInstallationsTableCompanion(
      modelId: Value(modelId),
      name: Value(name),
      version: Value(version),
      moduleId: Value(moduleId),
      runtime: Value(runtime),
      taskType: Value(taskType),
      sizeBytes: Value(sizeBytes),
      sha256Checksum: Value(sha256Checksum),
      isInstalled: Value(isInstalled),
      installedAt: Value(installedAt),
      accuracyReport: Value(accuracyReport),
      inputDimensions: Value(inputDimensions),
    );
  }

  factory ModelInstallationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelInstallationsTableData(
      modelId: serializer.fromJson<String>(json['modelId']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<String>(json['version']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      runtime: serializer.fromJson<String>(json['runtime']),
      taskType: serializer.fromJson<String>(json['taskType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256Checksum: serializer.fromJson<String>(json['sha256Checksum']),
      isInstalled: serializer.fromJson<bool>(json['isInstalled']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
      accuracyReport: serializer.fromJson<String>(json['accuracyReport']),
      inputDimensions: serializer.fromJson<String>(json['inputDimensions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'modelId': serializer.toJson<String>(modelId),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<String>(version),
      'moduleId': serializer.toJson<String>(moduleId),
      'runtime': serializer.toJson<String>(runtime),
      'taskType': serializer.toJson<String>(taskType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256Checksum': serializer.toJson<String>(sha256Checksum),
      'isInstalled': serializer.toJson<bool>(isInstalled),
      'installedAt': serializer.toJson<DateTime>(installedAt),
      'accuracyReport': serializer.toJson<String>(accuracyReport),
      'inputDimensions': serializer.toJson<String>(inputDimensions),
    };
  }

  ModelInstallationsTableData copyWith({
    String? modelId,
    String? name,
    String? version,
    String? moduleId,
    String? runtime,
    String? taskType,
    int? sizeBytes,
    String? sha256Checksum,
    bool? isInstalled,
    DateTime? installedAt,
    String? accuracyReport,
    String? inputDimensions,
  }) => ModelInstallationsTableData(
    modelId: modelId ?? this.modelId,
    name: name ?? this.name,
    version: version ?? this.version,
    moduleId: moduleId ?? this.moduleId,
    runtime: runtime ?? this.runtime,
    taskType: taskType ?? this.taskType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256Checksum: sha256Checksum ?? this.sha256Checksum,
    isInstalled: isInstalled ?? this.isInstalled,
    installedAt: installedAt ?? this.installedAt,
    accuracyReport: accuracyReport ?? this.accuracyReport,
    inputDimensions: inputDimensions ?? this.inputDimensions,
  );
  ModelInstallationsTableData copyWithCompanion(
    ModelInstallationsTableCompanion data,
  ) {
    return ModelInstallationsTableData(
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256Checksum: data.sha256Checksum.present
          ? data.sha256Checksum.value
          : this.sha256Checksum,
      isInstalled: data.isInstalled.present
          ? data.isInstalled.value
          : this.isInstalled,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      accuracyReport: data.accuracyReport.present
          ? data.accuracyReport.value
          : this.accuracyReport,
      inputDimensions: data.inputDimensions.present
          ? data.inputDimensions.value
          : this.inputDimensions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelInstallationsTableData(')
          ..write('modelId: $modelId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('moduleId: $moduleId, ')
          ..write('runtime: $runtime, ')
          ..write('taskType: $taskType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256Checksum: $sha256Checksum, ')
          ..write('isInstalled: $isInstalled, ')
          ..write('installedAt: $installedAt, ')
          ..write('accuracyReport: $accuracyReport, ')
          ..write('inputDimensions: $inputDimensions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    modelId,
    name,
    version,
    moduleId,
    runtime,
    taskType,
    sizeBytes,
    sha256Checksum,
    isInstalled,
    installedAt,
    accuracyReport,
    inputDimensions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelInstallationsTableData &&
          other.modelId == this.modelId &&
          other.name == this.name &&
          other.version == this.version &&
          other.moduleId == this.moduleId &&
          other.runtime == this.runtime &&
          other.taskType == this.taskType &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256Checksum == this.sha256Checksum &&
          other.isInstalled == this.isInstalled &&
          other.installedAt == this.installedAt &&
          other.accuracyReport == this.accuracyReport &&
          other.inputDimensions == this.inputDimensions);
}

class ModelInstallationsTableCompanion
    extends UpdateCompanion<ModelInstallationsTableData> {
  final Value<String> modelId;
  final Value<String> name;
  final Value<String> version;
  final Value<String> moduleId;
  final Value<String> runtime;
  final Value<String> taskType;
  final Value<int> sizeBytes;
  final Value<String> sha256Checksum;
  final Value<bool> isInstalled;
  final Value<DateTime> installedAt;
  final Value<String> accuracyReport;
  final Value<String> inputDimensions;
  final Value<int> rowid;
  const ModelInstallationsTableCompanion({
    this.modelId = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.runtime = const Value.absent(),
    this.taskType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256Checksum = const Value.absent(),
    this.isInstalled = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.accuracyReport = const Value.absent(),
    this.inputDimensions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelInstallationsTableCompanion.insert({
    required String modelId,
    required String name,
    required String version,
    required String moduleId,
    required String runtime,
    required String taskType,
    required int sizeBytes,
    required String sha256Checksum,
    this.isInstalled = const Value.absent(),
    required DateTime installedAt,
    required String accuracyReport,
    required String inputDimensions,
    this.rowid = const Value.absent(),
  }) : modelId = Value(modelId),
       name = Value(name),
       version = Value(version),
       moduleId = Value(moduleId),
       runtime = Value(runtime),
       taskType = Value(taskType),
       sizeBytes = Value(sizeBytes),
       sha256Checksum = Value(sha256Checksum),
       installedAt = Value(installedAt),
       accuracyReport = Value(accuracyReport),
       inputDimensions = Value(inputDimensions);
  static Insertable<ModelInstallationsTableData> custom({
    Expression<String>? modelId,
    Expression<String>? name,
    Expression<String>? version,
    Expression<String>? moduleId,
    Expression<String>? runtime,
    Expression<String>? taskType,
    Expression<int>? sizeBytes,
    Expression<String>? sha256Checksum,
    Expression<bool>? isInstalled,
    Expression<DateTime>? installedAt,
    Expression<String>? accuracyReport,
    Expression<String>? inputDimensions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (modelId != null) 'model_id': modelId,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (moduleId != null) 'module_id': moduleId,
      if (runtime != null) 'runtime': runtime,
      if (taskType != null) 'task_type': taskType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256Checksum != null) 'sha256_checksum': sha256Checksum,
      if (isInstalled != null) 'is_installed': isInstalled,
      if (installedAt != null) 'installed_at': installedAt,
      if (accuracyReport != null) 'accuracy_report': accuracyReport,
      if (inputDimensions != null) 'input_dimensions': inputDimensions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelInstallationsTableCompanion copyWith({
    Value<String>? modelId,
    Value<String>? name,
    Value<String>? version,
    Value<String>? moduleId,
    Value<String>? runtime,
    Value<String>? taskType,
    Value<int>? sizeBytes,
    Value<String>? sha256Checksum,
    Value<bool>? isInstalled,
    Value<DateTime>? installedAt,
    Value<String>? accuracyReport,
    Value<String>? inputDimensions,
    Value<int>? rowid,
  }) {
    return ModelInstallationsTableCompanion(
      modelId: modelId ?? this.modelId,
      name: name ?? this.name,
      version: version ?? this.version,
      moduleId: moduleId ?? this.moduleId,
      runtime: runtime ?? this.runtime,
      taskType: taskType ?? this.taskType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256Checksum: sha256Checksum ?? this.sha256Checksum,
      isInstalled: isInstalled ?? this.isInstalled,
      installedAt: installedAt ?? this.installedAt,
      accuracyReport: accuracyReport ?? this.accuracyReport,
      inputDimensions: inputDimensions ?? this.inputDimensions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<String>(runtime.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256Checksum.present) {
      map['sha256_checksum'] = Variable<String>(sha256Checksum.value);
    }
    if (isInstalled.present) {
      map['is_installed'] = Variable<bool>(isInstalled.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (accuracyReport.present) {
      map['accuracy_report'] = Variable<String>(accuracyReport.value);
    }
    if (inputDimensions.present) {
      map['input_dimensions'] = Variable<String>(inputDimensions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelInstallationsTableCompanion(')
          ..write('modelId: $modelId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('moduleId: $moduleId, ')
          ..write('runtime: $runtime, ')
          ..write('taskType: $taskType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256Checksum: $sha256Checksum, ')
          ..write('isInstalled: $isInstalled, ')
          ..write('installedAt: $installedAt, ')
          ..write('accuracyReport: $accuracyReport, ')
          ..write('inputDimensions: $inputDimensions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  late final $ImagesTableTable imagesTable = $ImagesTableTable(this);
  late final $AnalysisRunsTableTable analysisRunsTable =
      $AnalysisRunsTableTable(this);
  late final $AnnotationsTableTable annotationsTable = $AnnotationsTableTable(
    this,
  );
  late final $ModelInstallationsTableTable modelInstallationsTable =
      $ModelInstallationsTableTable(this);
  late final Index sessionCreatedAtIdx = Index(
    'session_created_at_idx',
    'CREATE INDEX session_created_at_idx ON sessions_table (created_at)',
  );
  late final Index sessionSpecimenCodeIdx = Index(
    'session_specimen_code_idx',
    'CREATE INDEX session_specimen_code_idx ON sessions_table (specimen_code)',
  );
  late final Index imageSessionIdIdx = Index(
    'image_session_id_idx',
    'CREATE INDEX image_session_id_idx ON images_table (session_id)',
  );
  late final Index analysisRunImageIdIdx = Index(
    'analysis_run_image_id_idx',
    'CREATE INDEX analysis_run_image_id_idx ON analysis_runs_table (image_id)',
  );
  late final Index annotationRunIdIdx = Index(
    'annotation_run_id_idx',
    'CREATE INDEX annotation_run_id_idx ON annotations_table (analysis_run_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessionsTable,
    imagesTable,
    analysisRunsTable,
    annotationsTable,
    modelInstallationsTable,
    sessionCreatedAtIdx,
    sessionSpecimenCodeIdx,
    imageSessionIdIdx,
    analysisRunImageIdIdx,
    annotationRunIdIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('images_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'images_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('analysis_runs_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'analysis_runs_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('annotations_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SessionsTableTableCreateCompanionBuilder =
    SessionsTableCompanion Function({
      required String id,
      required String title,
      required String specimenCode,
      required String specimenType,
      required String moduleId,
      required String moduleName,
      Value<String> captureProfile,
      required DateTime createdAt,
      Value<String> operatorLabel,
      Value<String> notes,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$SessionsTableTableUpdateCompanionBuilder =
    SessionsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> specimenCode,
      Value<String> specimenType,
      Value<String> moduleId,
      Value<String> moduleName,
      Value<String> captureProfile,
      Value<DateTime> createdAt,
      Value<String> operatorLabel,
      Value<String> notes,
      Value<String> status,
      Value<int> rowid,
    });

final class $$SessionsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $SessionsTableTable, SessionsTableData> {
  $$SessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ImagesTableTable, List<ImagesTableData>>
  _imagesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.imagesTable,
    aliasName: 'sessions_table__id__images_table__session_id',
  );

  $$ImagesTableTableProcessedTableManager get imagesTableRefs {
    final manager = $$ImagesTableTableTableManager(
      $_db,
      $_db.imagesTable,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_imagesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specimenCode => $composableBuilder(
    column: $table.specimenCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specimenType => $composableBuilder(
    column: $table.specimenType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatorLabel => $composableBuilder(
    column: $table.operatorLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> imagesTableRefs(
    Expression<bool> Function($$ImagesTableTableFilterComposer f) f,
  ) {
    final $$ImagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imagesTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableTableFilterComposer(
            $db: $db,
            $table: $db.imagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specimenCode => $composableBuilder(
    column: $table.specimenCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specimenType => $composableBuilder(
    column: $table.specimenType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatorLabel => $composableBuilder(
    column: $table.operatorLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get specimenCode => $composableBuilder(
    column: $table.specimenCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specimenType => $composableBuilder(
    column: $table.specimenType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get operatorLabel => $composableBuilder(
    column: $table.operatorLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> imagesTableRefs<T extends Object>(
    Expression<T> Function($$ImagesTableTableAnnotationComposer a) f,
  ) {
    final $$ImagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.imagesTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.imagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTableTable,
          SessionsTableData,
          $$SessionsTableTableFilterComposer,
          $$SessionsTableTableOrderingComposer,
          $$SessionsTableTableAnnotationComposer,
          $$SessionsTableTableCreateCompanionBuilder,
          $$SessionsTableTableUpdateCompanionBuilder,
          (SessionsTableData, $$SessionsTableTableReferences),
          SessionsTableData,
          PrefetchHooks Function({bool imagesTableRefs})
        > {
  $$SessionsTableTableTableManager(_$AppDatabase db, $SessionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> specimenCode = const Value.absent(),
                Value<String> specimenType = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> moduleName = const Value.absent(),
                Value<String> captureProfile = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> operatorLabel = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion(
                id: id,
                title: title,
                specimenCode: specimenCode,
                specimenType: specimenType,
                moduleId: moduleId,
                moduleName: moduleName,
                captureProfile: captureProfile,
                createdAt: createdAt,
                operatorLabel: operatorLabel,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String specimenCode,
                required String specimenType,
                required String moduleId,
                required String moduleName,
                Value<String> captureProfile = const Value.absent(),
                required DateTime createdAt,
                Value<String> operatorLabel = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion.insert(
                id: id,
                title: title,
                specimenCode: specimenCode,
                specimenType: specimenType,
                moduleId: moduleId,
                moduleName: moduleName,
                captureProfile: captureProfile,
                createdAt: createdAt,
                operatorLabel: operatorLabel,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTableTable, SessionsTableData>(table),
                  $$SessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({imagesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (imagesTableRefs) db.imagesTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (imagesTableRefs)
                    await $_getPrefetchedDataByColumns<
                      SessionsTableData,
                      $SessionsTableTable,
                      ImagesTableData,
                      $ImagesTableTable
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableTableReferences
                          ._imagesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).imagesTableRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTableTable,
      SessionsTableData,
      $$SessionsTableTableFilterComposer,
      $$SessionsTableTableOrderingComposer,
      $$SessionsTableTableAnnotationComposer,
      $$SessionsTableTableCreateCompanionBuilder,
      $$SessionsTableTableUpdateCompanionBuilder,
      (SessionsTableData, $$SessionsTableTableReferences),
      SessionsTableData,
      PrefetchHooks Function({bool imagesTableRefs})
    >;
typedef $$ImagesTableTableCreateCompanionBuilder =
    ImagesTableCompanion Function({
      required String id,
      required String sessionId,
      required int fieldIndex,
      required String assetPath,
      Value<String?> derivedPath,
      required DateTime capturedAt,
      Value<int> width,
      Value<int> height,
      Value<String> captureProfile,
      Value<bool> isUsable,
      Value<bool> recaptureNeeded,
      Value<String> notes,
      required double laplacianSharpness,
      required double meanLuminance,
      required double contrastRatio,
      required double fovCircularCoverage,
      required bool isQualityPassed,
      Value<String> qualityWarningsJson,
      Value<int> rowid,
    });
typedef $$ImagesTableTableUpdateCompanionBuilder =
    ImagesTableCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> fieldIndex,
      Value<String> assetPath,
      Value<String?> derivedPath,
      Value<DateTime> capturedAt,
      Value<int> width,
      Value<int> height,
      Value<String> captureProfile,
      Value<bool> isUsable,
      Value<bool> recaptureNeeded,
      Value<String> notes,
      Value<double> laplacianSharpness,
      Value<double> meanLuminance,
      Value<double> contrastRatio,
      Value<double> fovCircularCoverage,
      Value<bool> isQualityPassed,
      Value<String> qualityWarningsJson,
      Value<int> rowid,
    });

final class $$ImagesTableTableReferences
    extends BaseReferences<_$AppDatabase, $ImagesTableTable, ImagesTableData> {
  $$ImagesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTableTable _sessionIdTable(_$AppDatabase db) => db
      .sessionsTable
      .createAlias('images_table__session_id__sessions_table__id');

  $$SessionsTableTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableTableManager(
      $_db,
      $_db.sessionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $AnalysisRunsTableTable,
    List<AnalysisRunsTableData>
  >
  _analysisRunsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.analysisRunsTable,
        aliasName: 'images_table__id__analysis_runs_table__image_id',
      );

  $$AnalysisRunsTableTableProcessedTableManager get analysisRunsTableRefs {
    final manager = $$AnalysisRunsTableTableTableManager(
      $_db,
      $_db.analysisRunsTable,
    ).filter((f) => f.imageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _analysisRunsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ImagesTableTable> {
  $$ImagesTableTableFilterComposer({
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

  ColumnFilters<int> get fieldIndex => $composableBuilder(
    column: $table.fieldIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get derivedPath => $composableBuilder(
    column: $table.derivedPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUsable => $composableBuilder(
    column: $table.isUsable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recaptureNeeded => $composableBuilder(
    column: $table.recaptureNeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get laplacianSharpness => $composableBuilder(
    column: $table.laplacianSharpness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meanLuminance => $composableBuilder(
    column: $table.meanLuminance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get contrastRatio => $composableBuilder(
    column: $table.contrastRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fovCircularCoverage => $composableBuilder(
    column: $table.fovCircularCoverage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQualityPassed => $composableBuilder(
    column: $table.isQualityPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualityWarningsJson => $composableBuilder(
    column: $table.qualityWarningsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableTableFilterComposer get sessionId {
    final $$SessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.sessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> analysisRunsTableRefs(
    Expression<bool> Function($$AnalysisRunsTableTableFilterComposer f) f,
  ) {
    final $$AnalysisRunsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisRunsTable,
      getReferencedColumn: (t) => t.imageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisRunsTableTableFilterComposer(
            $db: $db,
            $table: $db.analysisRunsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ImagesTableTable> {
  $$ImagesTableTableOrderingComposer({
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

  ColumnOrderings<int> get fieldIndex => $composableBuilder(
    column: $table.fieldIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get derivedPath => $composableBuilder(
    column: $table.derivedPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUsable => $composableBuilder(
    column: $table.isUsable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recaptureNeeded => $composableBuilder(
    column: $table.recaptureNeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get laplacianSharpness => $composableBuilder(
    column: $table.laplacianSharpness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meanLuminance => $composableBuilder(
    column: $table.meanLuminance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get contrastRatio => $composableBuilder(
    column: $table.contrastRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fovCircularCoverage => $composableBuilder(
    column: $table.fovCircularCoverage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQualityPassed => $composableBuilder(
    column: $table.isQualityPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualityWarningsJson => $composableBuilder(
    column: $table.qualityWarningsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableTableOrderingComposer get sessionId {
    final $$SessionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.sessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImagesTableTable> {
  $$ImagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fieldIndex => $composableBuilder(
    column: $table.fieldIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetPath =>
      $composableBuilder(column: $table.assetPath, builder: (column) => column);

  GeneratedColumn<String> get derivedPath => $composableBuilder(
    column: $table.derivedPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get captureProfile => $composableBuilder(
    column: $table.captureProfile,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUsable =>
      $composableBuilder(column: $table.isUsable, builder: (column) => column);

  GeneratedColumn<bool> get recaptureNeeded => $composableBuilder(
    column: $table.recaptureNeeded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get laplacianSharpness => $composableBuilder(
    column: $table.laplacianSharpness,
    builder: (column) => column,
  );

  GeneratedColumn<double> get meanLuminance => $composableBuilder(
    column: $table.meanLuminance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get contrastRatio => $composableBuilder(
    column: $table.contrastRatio,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fovCircularCoverage => $composableBuilder(
    column: $table.fovCircularCoverage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isQualityPassed => $composableBuilder(
    column: $table.isQualityPassed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qualityWarningsJson => $composableBuilder(
    column: $table.qualityWarningsJson,
    builder: (column) => column,
  );

  $$SessionsTableTableAnnotationComposer get sessionId {
    final $$SessionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> analysisRunsTableRefs<T extends Object>(
    Expression<T> Function($$AnalysisRunsTableTableAnnotationComposer a) f,
  ) {
    final $$AnalysisRunsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.analysisRunsTable,
          getReferencedColumn: (t) => t.imageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisRunsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisRunsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ImagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImagesTableTable,
          ImagesTableData,
          $$ImagesTableTableFilterComposer,
          $$ImagesTableTableOrderingComposer,
          $$ImagesTableTableAnnotationComposer,
          $$ImagesTableTableCreateCompanionBuilder,
          $$ImagesTableTableUpdateCompanionBuilder,
          (ImagesTableData, $$ImagesTableTableReferences),
          ImagesTableData,
          PrefetchHooks Function({bool sessionId, bool analysisRunsTableRefs})
        > {
  $$ImagesTableTableTableManager(_$AppDatabase db, $ImagesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> fieldIndex = const Value.absent(),
                Value<String> assetPath = const Value.absent(),
                Value<String?> derivedPath = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<String> captureProfile = const Value.absent(),
                Value<bool> isUsable = const Value.absent(),
                Value<bool> recaptureNeeded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double> laplacianSharpness = const Value.absent(),
                Value<double> meanLuminance = const Value.absent(),
                Value<double> contrastRatio = const Value.absent(),
                Value<double> fovCircularCoverage = const Value.absent(),
                Value<bool> isQualityPassed = const Value.absent(),
                Value<String> qualityWarningsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImagesTableCompanion(
                id: id,
                sessionId: sessionId,
                fieldIndex: fieldIndex,
                assetPath: assetPath,
                derivedPath: derivedPath,
                capturedAt: capturedAt,
                width: width,
                height: height,
                captureProfile: captureProfile,
                isUsable: isUsable,
                recaptureNeeded: recaptureNeeded,
                notes: notes,
                laplacianSharpness: laplacianSharpness,
                meanLuminance: meanLuminance,
                contrastRatio: contrastRatio,
                fovCircularCoverage: fovCircularCoverage,
                isQualityPassed: isQualityPassed,
                qualityWarningsJson: qualityWarningsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int fieldIndex,
                required String assetPath,
                Value<String?> derivedPath = const Value.absent(),
                required DateTime capturedAt,
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<String> captureProfile = const Value.absent(),
                Value<bool> isUsable = const Value.absent(),
                Value<bool> recaptureNeeded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required double laplacianSharpness,
                required double meanLuminance,
                required double contrastRatio,
                required double fovCircularCoverage,
                required bool isQualityPassed,
                Value<String> qualityWarningsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImagesTableCompanion.insert(
                id: id,
                sessionId: sessionId,
                fieldIndex: fieldIndex,
                assetPath: assetPath,
                derivedPath: derivedPath,
                capturedAt: capturedAt,
                width: width,
                height: height,
                captureProfile: captureProfile,
                isUsable: isUsable,
                recaptureNeeded: recaptureNeeded,
                notes: notes,
                laplacianSharpness: laplacianSharpness,
                meanLuminance: meanLuminance,
                contrastRatio: contrastRatio,
                fovCircularCoverage: fovCircularCoverage,
                isQualityPassed: isQualityPassed,
                qualityWarningsJson: qualityWarningsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImagesTableTable, ImagesTableData>(table),
                  $$ImagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, analysisRunsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (analysisRunsTableRefs) db.analysisRunsTable,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$ImagesTableTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$ImagesTableTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (analysisRunsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          ImagesTableData,
                          $ImagesTableTable,
                          AnalysisRunsTableData,
                          $AnalysisRunsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$ImagesTableTableReferences
                              ._analysisRunsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImagesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).analysisRunsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'image_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImagesTableTable,
      ImagesTableData,
      $$ImagesTableTableFilterComposer,
      $$ImagesTableTableOrderingComposer,
      $$ImagesTableTableAnnotationComposer,
      $$ImagesTableTableCreateCompanionBuilder,
      $$ImagesTableTableUpdateCompanionBuilder,
      (ImagesTableData, $$ImagesTableTableReferences),
      ImagesTableData,
      PrefetchHooks Function({bool sessionId, bool analysisRunsTableRefs})
    >;
typedef $$AnalysisRunsTableTableCreateCompanionBuilder =
    AnalysisRunsTableCompanion Function({
      required String id,
      required String imageId,
      required String modelId,
      required String modelVersion,
      required String taskType,
      required DateTime startedAt,
      required DateTime completedAt,
      required int processingMs,
      required String topPredictionJson,
      Value<String> allPredictionsJson,
      Value<String> reviewStatus,
      Value<String> reviewerNotes,
      Value<String?> correctedClass,
      Value<bool> isSimulated,
      Value<int> rowid,
    });
typedef $$AnalysisRunsTableTableUpdateCompanionBuilder =
    AnalysisRunsTableCompanion Function({
      Value<String> id,
      Value<String> imageId,
      Value<String> modelId,
      Value<String> modelVersion,
      Value<String> taskType,
      Value<DateTime> startedAt,
      Value<DateTime> completedAt,
      Value<int> processingMs,
      Value<String> topPredictionJson,
      Value<String> allPredictionsJson,
      Value<String> reviewStatus,
      Value<String> reviewerNotes,
      Value<String?> correctedClass,
      Value<bool> isSimulated,
      Value<int> rowid,
    });

final class $$AnalysisRunsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnalysisRunsTableTable,
          AnalysisRunsTableData
        > {
  $$AnalysisRunsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ImagesTableTable _imageIdTable(_$AppDatabase db) => db.imagesTable
      .createAlias('analysis_runs_table__image_id__images_table__id');

  $$ImagesTableTableProcessedTableManager get imageId {
    final $_column = $_itemColumn<String>('image_id')!;

    final manager = $$ImagesTableTableTableManager(
      $_db,
      $_db.imagesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_imageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AnnotationsTableTable, List<AnnotationsTableData>>
  _annotationsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotationsTable,
    aliasName: 'analysis_runs_table__id__annotations_table__analysis_run_id',
  );

  $$AnnotationsTableTableProcessedTableManager get annotationsTableRefs {
    final manager = $$AnnotationsTableTableTableManager(
      $_db,
      $_db.annotationsTable,
    ).filter((f) => f.analysisRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _annotationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AnalysisRunsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTableTable> {
  $$AnalysisRunsTableTableFilterComposer({
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

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processingMs => $composableBuilder(
    column: $table.processingMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topPredictionJson => $composableBuilder(
    column: $table.topPredictionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allPredictionsJson => $composableBuilder(
    column: $table.allPredictionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewerNotes => $composableBuilder(
    column: $table.reviewerNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctedClass => $composableBuilder(
    column: $table.correctedClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSimulated => $composableBuilder(
    column: $table.isSimulated,
    builder: (column) => ColumnFilters(column),
  );

  $$ImagesTableTableFilterComposer get imageId {
    final $$ImagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.imageId,
      referencedTable: $db.imagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableTableFilterComposer(
            $db: $db,
            $table: $db.imagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> annotationsTableRefs(
    Expression<bool> Function($$AnnotationsTableTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotationsTable,
      getReferencedColumn: (t) => t.analysisRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableTableFilterComposer(
            $db: $db,
            $table: $db.annotationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnalysisRunsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTableTable> {
  $$AnalysisRunsTableTableOrderingComposer({
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

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processingMs => $composableBuilder(
    column: $table.processingMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topPredictionJson => $composableBuilder(
    column: $table.topPredictionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allPredictionsJson => $composableBuilder(
    column: $table.allPredictionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewerNotes => $composableBuilder(
    column: $table.reviewerNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctedClass => $composableBuilder(
    column: $table.correctedClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSimulated => $composableBuilder(
    column: $table.isSimulated,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImagesTableTableOrderingComposer get imageId {
    final $$ImagesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.imageId,
      referencedTable: $db.imagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableTableOrderingComposer(
            $db: $db,
            $table: $db.imagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnalysisRunsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisRunsTableTable> {
  $$AnalysisRunsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processingMs => $composableBuilder(
    column: $table.processingMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topPredictionJson => $composableBuilder(
    column: $table.topPredictionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allPredictionsJson => $composableBuilder(
    column: $table.allPredictionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewerNotes => $composableBuilder(
    column: $table.reviewerNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctedClass => $composableBuilder(
    column: $table.correctedClass,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSimulated => $composableBuilder(
    column: $table.isSimulated,
    builder: (column) => column,
  );

  $$ImagesTableTableAnnotationComposer get imageId {
    final $$ImagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.imageId,
      referencedTable: $db.imagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.imagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> annotationsTableRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotationsTable,
      getReferencedColumn: (t) => t.analysisRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.annotationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnalysisRunsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisRunsTableTable,
          AnalysisRunsTableData,
          $$AnalysisRunsTableTableFilterComposer,
          $$AnalysisRunsTableTableOrderingComposer,
          $$AnalysisRunsTableTableAnnotationComposer,
          $$AnalysisRunsTableTableCreateCompanionBuilder,
          $$AnalysisRunsTableTableUpdateCompanionBuilder,
          (AnalysisRunsTableData, $$AnalysisRunsTableTableReferences),
          AnalysisRunsTableData,
          PrefetchHooks Function({bool imageId, bool annotationsTableRefs})
        > {
  $$AnalysisRunsTableTableTableManager(
    _$AppDatabase db,
    $AnalysisRunsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisRunsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisRunsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisRunsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> imageId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> modelVersion = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> processingMs = const Value.absent(),
                Value<String> topPredictionJson = const Value.absent(),
                Value<String> allPredictionsJson = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<String> reviewerNotes = const Value.absent(),
                Value<String?> correctedClass = const Value.absent(),
                Value<bool> isSimulated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisRunsTableCompanion(
                id: id,
                imageId: imageId,
                modelId: modelId,
                modelVersion: modelVersion,
                taskType: taskType,
                startedAt: startedAt,
                completedAt: completedAt,
                processingMs: processingMs,
                topPredictionJson: topPredictionJson,
                allPredictionsJson: allPredictionsJson,
                reviewStatus: reviewStatus,
                reviewerNotes: reviewerNotes,
                correctedClass: correctedClass,
                isSimulated: isSimulated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String imageId,
                required String modelId,
                required String modelVersion,
                required String taskType,
                required DateTime startedAt,
                required DateTime completedAt,
                required int processingMs,
                required String topPredictionJson,
                Value<String> allPredictionsJson = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<String> reviewerNotes = const Value.absent(),
                Value<String?> correctedClass = const Value.absent(),
                Value<bool> isSimulated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisRunsTableCompanion.insert(
                id: id,
                imageId: imageId,
                modelId: modelId,
                modelVersion: modelVersion,
                taskType: taskType,
                startedAt: startedAt,
                completedAt: completedAt,
                processingMs: processingMs,
                topPredictionJson: topPredictionJson,
                allPredictionsJson: allPredictionsJson,
                reviewStatus: reviewStatus,
                reviewerNotes: reviewerNotes,
                correctedClass: correctedClass,
                isSimulated: isSimulated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnalysisRunsTableTable, AnalysisRunsTableData>(
                    table,
                  ),
                  $$AnalysisRunsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({imageId = false, annotationsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (annotationsTableRefs) db.annotationsTable,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (imageId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.imageId,
                            referencedTable: $$AnalysisRunsTableTableReferences
                                ._imageIdTable(db),
                            referencedColumn: $$AnalysisRunsTableTableReferences
                                ._imageIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (annotationsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          AnalysisRunsTableData,
                          $AnalysisRunsTableTable,
                          AnnotationsTableData,
                          $AnnotationsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$AnalysisRunsTableTableReferences
                              ._annotationsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnalysisRunsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'analysis_run_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AnalysisRunsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisRunsTableTable,
      AnalysisRunsTableData,
      $$AnalysisRunsTableTableFilterComposer,
      $$AnalysisRunsTableTableOrderingComposer,
      $$AnalysisRunsTableTableAnnotationComposer,
      $$AnalysisRunsTableTableCreateCompanionBuilder,
      $$AnalysisRunsTableTableUpdateCompanionBuilder,
      (AnalysisRunsTableData, $$AnalysisRunsTableTableReferences),
      AnalysisRunsTableData,
      PrefetchHooks Function({bool imageId, bool annotationsTableRefs})
    >;
typedef $$AnnotationsTableTableCreateCompanionBuilder =
    AnnotationsTableCompanion Function({
      required String id,
      required String analysisRunId,
      required String classId,
      required String label,
      required double boxX,
      required double boxY,
      required double boxWidth,
      required double boxHeight,
      required double confidence,
      Value<bool> isModelGenerated,
      Value<bool> isUserModified,
      Value<int> rowid,
    });
typedef $$AnnotationsTableTableUpdateCompanionBuilder =
    AnnotationsTableCompanion Function({
      Value<String> id,
      Value<String> analysisRunId,
      Value<String> classId,
      Value<String> label,
      Value<double> boxX,
      Value<double> boxY,
      Value<double> boxWidth,
      Value<double> boxHeight,
      Value<double> confidence,
      Value<bool> isModelGenerated,
      Value<bool> isUserModified,
      Value<int> rowid,
    });

final class $$AnnotationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AnnotationsTableTable,
          AnnotationsTableData
        > {
  $$AnnotationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnalysisRunsTableTable _analysisRunIdTable(_$AppDatabase db) =>
      db.analysisRunsTable.createAlias(
        'annotations_table__analysis_run_id__analysis_runs_table__id',
      );

  $$AnalysisRunsTableTableProcessedTableManager get analysisRunId {
    final $_column = $_itemColumn<String>('analysis_run_id')!;

    final manager = $$AnalysisRunsTableTableTableManager(
      $_db,
      $_db.analysisRunsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnotationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTableTable> {
  $$AnnotationsTableTableFilterComposer({
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

  ColumnFilters<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boxX => $composableBuilder(
    column: $table.boxX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boxY => $composableBuilder(
    column: $table.boxY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boxWidth => $composableBuilder(
    column: $table.boxWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boxHeight => $composableBuilder(
    column: $table.boxHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isModelGenerated => $composableBuilder(
    column: $table.isModelGenerated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUserModified => $composableBuilder(
    column: $table.isUserModified,
    builder: (column) => ColumnFilters(column),
  );

  $$AnalysisRunsTableTableFilterComposer get analysisRunId {
    final $$AnalysisRunsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisRunId,
      referencedTable: $db.analysisRunsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisRunsTableTableFilterComposer(
            $db: $db,
            $table: $db.analysisRunsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTableTable> {
  $$AnnotationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boxX => $composableBuilder(
    column: $table.boxX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boxY => $composableBuilder(
    column: $table.boxY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boxWidth => $composableBuilder(
    column: $table.boxWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boxHeight => $composableBuilder(
    column: $table.boxHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isModelGenerated => $composableBuilder(
    column: $table.isModelGenerated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUserModified => $composableBuilder(
    column: $table.isUserModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnalysisRunsTableTableOrderingComposer get analysisRunId {
    final $$AnalysisRunsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisRunId,
      referencedTable: $db.analysisRunsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnalysisRunsTableTableOrderingComposer(
            $db: $db,
            $table: $db.analysisRunsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTableTable> {
  $$AnnotationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get boxX =>
      $composableBuilder(column: $table.boxX, builder: (column) => column);

  GeneratedColumn<double> get boxY =>
      $composableBuilder(column: $table.boxY, builder: (column) => column);

  GeneratedColumn<double> get boxWidth =>
      $composableBuilder(column: $table.boxWidth, builder: (column) => column);

  GeneratedColumn<double> get boxHeight =>
      $composableBuilder(column: $table.boxHeight, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isModelGenerated => $composableBuilder(
    column: $table.isModelGenerated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUserModified => $composableBuilder(
    column: $table.isUserModified,
    builder: (column) => column,
  );

  $$AnalysisRunsTableTableAnnotationComposer get analysisRunId {
    final $$AnalysisRunsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.analysisRunId,
          referencedTable: $db.analysisRunsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AnalysisRunsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.analysisRunsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AnnotationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTableTable,
          AnnotationsTableData,
          $$AnnotationsTableTableFilterComposer,
          $$AnnotationsTableTableOrderingComposer,
          $$AnnotationsTableTableAnnotationComposer,
          $$AnnotationsTableTableCreateCompanionBuilder,
          $$AnnotationsTableTableUpdateCompanionBuilder,
          (AnnotationsTableData, $$AnnotationsTableTableReferences),
          AnnotationsTableData,
          PrefetchHooks Function({bool analysisRunId})
        > {
  $$AnnotationsTableTableTableManager(
    _$AppDatabase db,
    $AnnotationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisRunId = const Value.absent(),
                Value<String> classId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> boxX = const Value.absent(),
                Value<double> boxY = const Value.absent(),
                Value<double> boxWidth = const Value.absent(),
                Value<double> boxHeight = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<bool> isModelGenerated = const Value.absent(),
                Value<bool> isUserModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsTableCompanion(
                id: id,
                analysisRunId: analysisRunId,
                classId: classId,
                label: label,
                boxX: boxX,
                boxY: boxY,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
                confidence: confidence,
                isModelGenerated: isModelGenerated,
                isUserModified: isUserModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisRunId,
                required String classId,
                required String label,
                required double boxX,
                required double boxY,
                required double boxWidth,
                required double boxHeight,
                required double confidence,
                Value<bool> isModelGenerated = const Value.absent(),
                Value<bool> isUserModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsTableCompanion.insert(
                id: id,
                analysisRunId: analysisRunId,
                classId: classId,
                label: label,
                boxX: boxX,
                boxY: boxY,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
                confidence: confidence,
                isModelGenerated: isModelGenerated,
                isUserModified: isUserModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnnotationsTableTable, AnnotationsTableData>(
                    table,
                  ),
                  $$AnnotationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisRunId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (analysisRunId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.analysisRunId,
                        referencedTable: $$AnnotationsTableTableReferences
                            ._analysisRunIdTable(db),
                        referencedColumn: $$AnnotationsTableTableReferences
                            ._analysisRunIdTable(db)
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
        ),
      );
}

typedef $$AnnotationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTableTable,
      AnnotationsTableData,
      $$AnnotationsTableTableFilterComposer,
      $$AnnotationsTableTableOrderingComposer,
      $$AnnotationsTableTableAnnotationComposer,
      $$AnnotationsTableTableCreateCompanionBuilder,
      $$AnnotationsTableTableUpdateCompanionBuilder,
      (AnnotationsTableData, $$AnnotationsTableTableReferences),
      AnnotationsTableData,
      PrefetchHooks Function({bool analysisRunId})
    >;
typedef $$ModelInstallationsTableTableCreateCompanionBuilder =
    ModelInstallationsTableCompanion Function({
      required String modelId,
      required String name,
      required String version,
      required String moduleId,
      required String runtime,
      required String taskType,
      required int sizeBytes,
      required String sha256Checksum,
      Value<bool> isInstalled,
      required DateTime installedAt,
      required String accuracyReport,
      required String inputDimensions,
      Value<int> rowid,
    });
typedef $$ModelInstallationsTableTableUpdateCompanionBuilder =
    ModelInstallationsTableCompanion Function({
      Value<String> modelId,
      Value<String> name,
      Value<String> version,
      Value<String> moduleId,
      Value<String> runtime,
      Value<String> taskType,
      Value<int> sizeBytes,
      Value<String> sha256Checksum,
      Value<bool> isInstalled,
      Value<DateTime> installedAt,
      Value<String> accuracyReport,
      Value<String> inputDimensions,
      Value<int> rowid,
    });

class $$ModelInstallationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ModelInstallationsTableTable> {
  $$ModelInstallationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256Checksum => $composableBuilder(
    column: $table.sha256Checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accuracyReport => $composableBuilder(
    column: $table.accuracyReport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputDimensions => $composableBuilder(
    column: $table.inputDimensions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelInstallationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelInstallationsTableTable> {
  $$ModelInstallationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256Checksum => $composableBuilder(
    column: $table.sha256Checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accuracyReport => $composableBuilder(
    column: $table.accuracyReport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputDimensions => $composableBuilder(
    column: $table.inputDimensions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelInstallationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelInstallationsTableTable> {
  $$ModelInstallationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256Checksum => $composableBuilder(
    column: $table.sha256Checksum,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accuracyReport => $composableBuilder(
    column: $table.accuracyReport,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inputDimensions => $composableBuilder(
    column: $table.inputDimensions,
    builder: (column) => column,
  );
}

class $$ModelInstallationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelInstallationsTableTable,
          ModelInstallationsTableData,
          $$ModelInstallationsTableTableFilterComposer,
          $$ModelInstallationsTableTableOrderingComposer,
          $$ModelInstallationsTableTableAnnotationComposer,
          $$ModelInstallationsTableTableCreateCompanionBuilder,
          $$ModelInstallationsTableTableUpdateCompanionBuilder,
          (
            ModelInstallationsTableData,
            BaseReferences<
              _$AppDatabase,
              $ModelInstallationsTableTable,
              ModelInstallationsTableData
            >,
          ),
          ModelInstallationsTableData,
          PrefetchHooks Function()
        > {
  $$ModelInstallationsTableTableTableManager(
    _$AppDatabase db,
    $ModelInstallationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelInstallationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ModelInstallationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ModelInstallationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> modelId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> runtime = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256Checksum = const Value.absent(),
                Value<bool> isInstalled = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<String> accuracyReport = const Value.absent(),
                Value<String> inputDimensions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelInstallationsTableCompanion(
                modelId: modelId,
                name: name,
                version: version,
                moduleId: moduleId,
                runtime: runtime,
                taskType: taskType,
                sizeBytes: sizeBytes,
                sha256Checksum: sha256Checksum,
                isInstalled: isInstalled,
                installedAt: installedAt,
                accuracyReport: accuracyReport,
                inputDimensions: inputDimensions,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String modelId,
                required String name,
                required String version,
                required String moduleId,
                required String runtime,
                required String taskType,
                required int sizeBytes,
                required String sha256Checksum,
                Value<bool> isInstalled = const Value.absent(),
                required DateTime installedAt,
                required String accuracyReport,
                required String inputDimensions,
                Value<int> rowid = const Value.absent(),
              }) => ModelInstallationsTableCompanion.insert(
                modelId: modelId,
                name: name,
                version: version,
                moduleId: moduleId,
                runtime: runtime,
                taskType: taskType,
                sizeBytes: sizeBytes,
                sha256Checksum: sha256Checksum,
                isInstalled: isInstalled,
                installedAt: installedAt,
                accuracyReport: accuracyReport,
                inputDimensions: inputDimensions,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ModelInstallationsTableTable,
                    ModelInstallationsTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ModelInstallationsTableTable,
                    ModelInstallationsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelInstallationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelInstallationsTableTable,
      ModelInstallationsTableData,
      $$ModelInstallationsTableTableFilterComposer,
      $$ModelInstallationsTableTableOrderingComposer,
      $$ModelInstallationsTableTableAnnotationComposer,
      $$ModelInstallationsTableTableCreateCompanionBuilder,
      $$ModelInstallationsTableTableUpdateCompanionBuilder,
      (
        ModelInstallationsTableData,
        BaseReferences<
          _$AppDatabase,
          $ModelInstallationsTableTable,
          ModelInstallationsTableData
        >,
      ),
      ModelInstallationsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
  $$ImagesTableTableTableManager get imagesTable =>
      $$ImagesTableTableTableManager(_db, _db.imagesTable);
  $$AnalysisRunsTableTableTableManager get analysisRunsTable =>
      $$AnalysisRunsTableTableTableManager(_db, _db.analysisRunsTable);
  $$AnnotationsTableTableTableManager get annotationsTable =>
      $$AnnotationsTableTableTableManager(_db, _db.annotationsTable);
  $$ModelInstallationsTableTableTableManager get modelInstallationsTable =>
      $$ModelInstallationsTableTableTableManager(
        _db,
        _db.modelInstallationsTable,
      );
}
