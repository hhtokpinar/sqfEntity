///****************************   LICENSE   *****************************
/// Copyright (C) 2019, HUSEYIN TOKPUNAR http://huseyintokpinar.com/
/// Download & Update Latest Version: https://github.com/hhtokpinar/sqfEntity
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at

///    http://www.apache.org/licenses/LICENSE-2.0

/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///**********************************************************************/

import 'package:analyzer/dart/constant/value.dart';
//import 'package:source_gen/source_gen.dart'; // throws dart:mirror exception when import here

part 'sqfentity_base.dart';
part 'sqfentity_form_gen.dart';

class SqfEntityFormCreator {
  SqfEntityFormCreator(this.tableModel, this.instancename);
  final DartObject tableModel;
  final String instancename;
  String get tableModelName =>
      getStringValue(tableModel, 'modelName') ??
      toCamelCase(getStringValue(tableModel, 'tableName'));

  List<SqfEntityTableBase> toTables() {
    final table = toSqfEntityTable(tableModel, instancename);
    // print('before ConvertedModel()');
    final model = ConvertedModel()
      ..databaseTables = [table!]
      ..init();
    // print('before return model.databaseTables;');
    return model.databaseTables!;
  }
}

class SqfEntityModelBuilder extends SqfEntityModelBase {
  SqfEntityModelBuilder(this.model, this.instancename);
  final DartObject model;
  final String? instancename;
  String get dbModelName {
    dynamic val = getStringValue(model, 'modelName') ?? '';
    if (val.toString().isEmpty) {
      val = toCamelCase(instancename);
    }
    return val.toString();
  }

  SqfEntityModelBase toModel() {
    final dbModel = _DbModel()
      ..instanceName = instancename
      ..modelName = dbModelName
      ..databaseName = getStringValue(model, 'databaseName')
      ..password = getStringValue(model, 'password')
      ..dbVersion = getIntValue(model, 'dbVersion')
      ..sequences = toSequenceList(getListValue(model, 'sequences'))
      ..databaseTables = toTableList(
          getListValue(model, 'databaseTables') ?? <DartObject>[], dbModelName,
          defaultColumns: toFields(getListValue(model, 'defaultColumns'),
              dbModelName, 'defaultColumns of Model $dbModelName'))
      ..formTables = toTableList(
        getListValue(model, 'formTables') ?? <DartObject>[],
        dbModelName,
      )
      ..bundledDatabasePath = getStringValue(model, 'bundledDatabasePath')
      ..ignoreForFile = toListString(getListValue(model, 'ignoreForFile'))
      ..init();
    return dbModel;
  }

  List<SqfEntityTableBase>? toTableList(
      List<DartObject> objTables, String dbModelName,
      {List<SqfEntityFieldType>? defaultColumns}) {
    final retVal = <SqfEntityTableBase>[];
    //if (objTables != null) {
    print('SQFENTITY_GEN.DART: recognizing Tables ($dbModelName)');

    for (var obj in objTables) {
      //  print(   '-------------------------------------------------------ModelBuilder: ${getStringValue(obj, 'tableName')}');
      final table = toSqfEntityTable(
        obj,
        dbModelName,
        defaultColumns: defaultColumns,
      );
      if (retVal.where((t) => t.tableName == table!.tableName).isEmpty) {
        retVal.add(table!);
      }
    }
    //}
    return retVal;
  }

  List<SqfEntitySequenceBase>? toSequenceList(List<DartObject>? objSequences) {
    if (objSequences == null) {
      //  print('SQFENTITY_GEN.DART: toSequenceList() returned null');
      return null;
    }
    print('SQFENTITY_GEN.DART: recognizing Sequences ($modelName)');
    final sqfEntitySQEList = <SqfEntitySequenceBase>[];
    for (var obj in objSequences) {
      try {
        sqfEntitySQEList.add(toSequence(obj));
      } catch (e) {
        print(
            'SQFENTITY_GEN.DART: recognizing Sequences ERROR. ($modelName) tried obj=>${obj.toString()}\nError Message:${e.toString()}');
      }
    }
    return sqfEntitySQEList;
  }
}

SqfEntitySequenceBase toSequence(DartObject obj) {
  return SqfEntitySequenceBase()
    ..sequenceName = getStringValue(obj, 'sequenceName')
    ..modelName = getStringValue(obj, 'modelName')
    ..init();
}

dynamic getDynamicValue(DartObject obj, String name) {
  // print('getDynamicValue name:$name, obj: ${obj.toString()}');
  if (!ifExist(obj, name)) {
    return null;
  }
  final String type = obj
      .getField(name)
      .toString()
      .substring(0, obj.getField(name).toString().indexOf(' '))
      .toLowerCase();
  switch (type) {
    case 'string':
      return getStringValue(obj, name);
    case 'int':
      return getIntValue(obj, name);
    case 'bool':
      return getBoolValue(obj, name);
    default:
      return null;
  }
}

String? getStringValue(DartObject obj, String name) =>
    ifExist(obj, name) ? obj.getField(name)!.toStringValue() : null;
bool getBoolValue(DartObject obj, String name) =>
    ifExist(obj, name) ? obj.getField(name)!.toBoolValue() ?? false : false;
int? getIntValue(DartObject obj, String name) =>
    ifExist(obj, name) ? obj.getField(name)!.toIntValue() : null;
List<DartObject>? getListValue(DartObject obj, String name) =>
    ifExist(obj, name) ? obj.getField(name)!.toListValue() : null;
dynamic getTypeValue(DartObject obj, String name) =>
    ifExist(obj, name) ? convertType(obj.getField(name)) : null;

bool ifExistTableProperty(DartObject obj, String name) =>
    obj.getField(name).toString().contains('(null)') == false;
bool ifExist(DartObject obj, String name) => obj.getField(name) != null;

SqfEntityTableBase? toSqfEntityTable(DartObject obj, String dbModelName,
    {List<SqfEntityFieldType>? defaultColumns}) {
  final String? _tableName = getStringValue(obj, 'tableName');

  if (_tableName == null) {
    print('__________toSqfEntityTable() returned null');
    return null;
  }
  final table = SqfEntityTables.tableList
      .where((t) => t.tableName == _tableName && (t.dbModel == dbModelName));
  if (table.isNotEmpty) {
    // print('--------TABLE FOUND: ${table.toList().first.tableName}');
    table.toList().first..dbModel = dbModelName;

    return table.toList().first;
  }
  print('------TABLE RECOGNIZING: $_tableName');
  final newTable = SqfEntityTableBase()
    ..tableName = _tableName
    ..useSoftDeleting = ifExistTableProperty(obj, 'useSoftDeleting')
        ? getBoolValue(obj, 'useSoftDeleting')
        : false
    ..fields = toFields(
        getListValue(obj, 'fields')!,
        dbModelName //keepFieldNamesAsOriginal
        ,
        _tableName)
    ..primaryKeyType = getTypeValue(obj, 'primaryKeyType') as PrimaryKeyType?
    ..objectType = getTypeValue(obj, 'objectType') as ObjectType?
    ..defaultJsonUrl = getStringValue(obj, 'defaultJsonUrl')
    ..modelName = getStringValue(obj, 'modelName')
    ..dbModel = dbModelName
    ..formListTitleField = getStringValue(obj, 'formListTitleField')
    ..formListSubTitleField = getStringValue(obj, 'formListSubTitleField')
    ..customCode = getStringValue(obj, 'customCode')
    ..primaryKeyName = getStringValue(obj, 'primaryKeyName')
    ..abstractModelName = getStringValue(obj, 'abstractModelName');

  newTable.primaryKeyName = getStringValue(obj, 'primaryKeyName') == null &&
          newTable.objectType == ObjectType.table
      ? newTable.primaryKeyNames.isEmpty
          ? '${_tableName}Id'
          : ''
      : getStringValue(obj, 'primaryKeyName');

  if (defaultColumns != null && defaultColumns.isNotEmpty) {
    print('adding default columns on ${newTable.tableName}');
    for (SqfEntityFieldType defaultField in defaultColumns) {
      final SqfEntityFieldBase newField = SqfEntityFieldBase(
          defaultField.fieldName, defaultField.dbType,
          defaultValue: defaultField.defaultValue,
          minValue: defaultField.minValue,
          maxValue: defaultField.maxValue,
          sequencedBy: defaultField.sequencedBy,
          isPrimaryKeyField: defaultField.isPrimaryKeyField,
          primaryKeyIndex: defaultField.primaryKeyIndex,
          isNotNull: defaultField.isNotNull,
          isUnique: defaultField.isUnique,
          isIndex: defaultField.isIndex,
          isIndexGroup: defaultField.isIndexGroup,
          checkCondition: defaultField.checkCondition,
          collate: defaultField.collate,
          formLabelText: defaultField.formLabelText);
      if (!newTable.primaryKeyNames
              .any((element) => element == defaultField.fieldName) &&
          !newTable.fields!
              .any((element) => element.fieldName == defaultField.fieldName)) {
        print(
            'added: ${defaultField.fieldName}, defaultField table=${defaultField.table != null ? defaultField.table!.tableName : 'null'}');
        newTable.fields!.add(newField);
      }
    }
  }
  newTable.init();
  SqfEntityTables.add(newTable);

  print(
      'SqfEntityModelBuilder: $dbModelName/$_tableName added to SqfEntityTables');
  return newTable;
}

SqfEntityFieldType getFieldProperties(
    SqfEntityFieldType field, DartObject obj) {
  final _retVal = field
    ..defaultValue = getDynamicValue(obj, 'defaultValue')
    ..minValue = getDynamicValue(obj, 'minValue')
    ..maxValue = getDynamicValue(obj, 'maxValue')
    ..isPrimaryKeyField = getBoolValue(obj, 'isPrimaryKeyField')
    ..isNotNull = getBoolValue(obj, 'isNotNull')
    ..isUnique = getBoolValue(obj, 'isUnique')
    ..isIndex = getBoolValue(obj, 'isIndex')
    ..isIndexGroup = getIntValue(obj, 'isIndexGroup')
    ..checkCondition = getStringValue(obj, 'checkCondition')
    ..collate = getTypeValue(obj, 'collate') as Collate?
    ..sequencedBy =
        obj.getField('sequencedBy').toString().contains('SqfEntitySequence')
            ? toSequence(obj.getField('sequencedBy')!)
            : null;
  return _retVal;
}

SqfEntityFieldType toField(
  DartObject obj,
  String dbModelName,
) {
  final fieldName =
      ifExist(obj, 'fieldName') ? getStringValue(obj, 'fieldName') : null;
  if (fieldName != null && forbiddenNames.contains(fieldName)) {
    throw Exception(
        'SQFENTITY ERROR: fieldName: [$fieldName] IS FORBIDDEN. PLEASE CHANGE THE FIELD NAME');
  }
  final dbType = getTypeValue(obj, 'dbType') as DbType? ?? DbType.text;

  if (obj.toString().startsWith('SqfEntityFieldVirtual')) {
    return SqfEntityFieldVirtualBase(fieldName!, dbType);
  } else if (obj.toString().startsWith('SqfEntityFieldRelationship')) {
    final parentTable = toSqfEntityTable(
      obj.getField('parentTable')!,
      dbModelName,
    );
    // final SqfEntityFieldRelationshipBase retVal = SqfEntityFieldRelationshipBase(
    //     parentTable, getTypeValue(obj, 'deleteRule') as DeleteRule)
    //   ..formDropDownTextField = getStringValue(obj, 'formDropDownTextField')
    //   ..manyToManyTableName = getStringValue(obj, 'manyToManyTableName')
    //   ..relationType = getTypeValue(obj, 'relationType') as RelationType
    //   ..init();
    // return getFieldProperties(retVal, obj);

    return SqfEntityFieldRelationshipBase(
        parentTable, getTypeValue(obj, 'deleteRule') as DeleteRule?)
      ..defaultValue = getDynamicValue(obj, 'defaultValue')
      ..minValue = getDynamicValue(obj, 'minValue')
      ..maxValue = getDynamicValue(obj, 'maxValue')
      ..fieldName =
          ifExist(obj, 'fieldName') ? getStringValue(obj, 'fieldName') : null
      ..formDropDownTextField = getStringValue(obj, 'formDropDownTextField')
      ..isPrimaryKeyField = getBoolValue(obj, 'isPrimaryKeyField')
      ..isNotNull = getBoolValue(obj, 'isNotNull')
      ..isUnique = getBoolValue(obj, 'isUnique')
      ..isIndex = getBoolValue(obj, 'isIndex')
      ..isIndexGroup = getIntValue(obj, 'isIndexGroup')
      ..checkCondition = getStringValue(obj, 'checkCondition')
      ..manyToManyTableName = getStringValue(obj, 'manyToManyTableName')
      ..relationType = getTypeValue(obj, 'relationType') as RelationType?
      ..collate = getTypeValue(obj, 'collate') as Collate?
      ..init();
  } else {
    final SqfEntityFieldType retVal = SqfEntityFieldBase(fieldName!, dbType);
    return getFieldProperties(retVal, obj);
  }
}

List<SqfEntityFieldType>? toFields(List<DartObject>? objFields,
    String dbModelName, String tableName //bool keepFieldNamesAsOriginal
    ) {
  final sqfEntityFieldList = <SqfEntityFieldType>[];
  // print('--------RECOGNIZING FIELDS:');
  if (objFields == null) {
    return <SqfEntityFieldType>[];
  }
  for (var obj in objFields) {
    sqfEntityFieldList.add(toField(
      obj,
      dbModelName,
    ));
  }
  return sqfEntityFieldList;
}

List<String>? toListString(
  List<DartObject>? objList,
) {
  if (objList == null) {
    return null;
  }
  final stringList = <String>[];
  // print('------RECOGNIZING FIELDS:');
  for (var obj in objList) {
    stringList.add(obj.toStringValue()!);
  }
  return stringList;
}

class SqfEntityTables {
  static List<SqfEntityTableBase>? tables;
  static List<SqfEntityTableBase> get tableList =>
      tables ?? <SqfEntityTableBase>[];

  static void add(SqfEntityTableBase table) {
    tables = tables ?? <SqfEntityTableBase>[]
      ..add(table);
  }
}

dynamic convertType(dynamic T) {
  final type = T.type;
  var types = <String, dynamic>{};
  if (type.toString().contains('DbType')) {
    types = dbTypes();
  } else if (type.toString().contains('PrimaryKeyType')) {
    types = primaryKeyTypes();
  } else if (type.toString().contains('DeleteRule')) {
    types = deleteRuleTypes();
  } else if (type.toString().contains('RelationType')) {
    types = relationTypes();
  } else if (type.toString().contains('ObjectType')) {
    types = objectTypes();
  } else if (type.toString().contains('Collate')) {
    types = collateTypes();
  }
  for (var typ in types.entries) {
    if (T.toString().contains('${typ.key} ')) {
      // print('-----------convertType: T:$T----------typ.key:${typ.key}');
      return typ.value;
    }
  }
  return types['default'];
}

Map<String, dynamic> dbTypes() {
  final types = <String, dynamic>{};
  types['default'] = DbType.unknown;
  for (var typ in DbType.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

Map<String, dynamic> primaryKeyTypes() {
  final types = <String, dynamic>{};
  types['default'] = PrimaryKeyType.integer_auto_incremental;
  for (var typ in PrimaryKeyType.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

Map<String, dynamic> objectTypes() {
  final types = <String, dynamic>{};
  types['default'] = ObjectType.table;
  for (var typ in ObjectType.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

Map<String, dynamic> deleteRuleTypes() {
  final types = <String, dynamic>{};
  types['default'] = DeleteRule.NO_ACTION;
  for (var typ in DeleteRule.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

Map<String, dynamic> collateTypes() {
  final types = <String, dynamic>{};
  types['default'] = Collate.BINARY;
  for (var typ in Collate.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

Map<String, dynamic> relationTypes() {
  final types = <String, dynamic>{};
  types['default'] = RelationType.ONE_TO_MANY;
  for (var typ in RelationType.values) {
    types[typ.toString().substring(typ.toString().indexOf('.') + 1)] = typ;
  }
  return types;
}

class SqfEntityConverter {
  SqfEntityConverter(this._m);
  final SqfEntityModelBase _m;
  String _tableList() {
    if (_m.databaseTables == null || _m.databaseTables!.isEmpty) {
      return '';
    }
    final list = StringBuffer()..writeln('databaseTables = [');
    for (final table in _m.databaseTables!
        //.where((table) => table.relationType != RelationType.MANY_TO_MANY)
        ) {
      list.writeln('Table${table.modelName}.getInstance,');
    }
    list.writeln('];');
    return list.toString();
  }

  String _tableListConst(bool includeViews) {
    if (_m.databaseTables == null || _m.databaseTables!.isEmpty) {
      return '';
    }
    final list = StringBuffer();
    for (final table in _m.databaseTables!
        .where((table) => table.relationType != RelationType.MANY_TO_MANY)) {
      if (includeViews || table.objectType == ObjectType.table) {
        list.writeln('table${table.modelName},');
      }
    }
    return list.toString();
  }

  String _sequenceList() {
    if (_m.sequences == null || _m.sequences!.isEmpty) {
      return '';
    }
    final list = StringBuffer()..writeln('sequences = [');

    for (final seq in _m.sequences!) {
      list.writeln('Sequence${seq.modelName}.getInstance,');
    }
    list.writeln('];');
    return list.toString();
  }

  String get __createModelTables => _createModelTables();
  String get __createModelTablesConst => _createModelTablesConst();
  String get __createModelSequences => _createModelSequences();
  String get __tableList => _tableList();
  String get __tableListConst => _tableListConst(false);
  String get __tableViewListConst => _tableListConst(true);
  String get __sequenceList => _sequenceList();

  String createModelDatabase() {
    _m.modelName = toModelName(_m.modelName, 'MyDbModel');
    return '''
//  These classes was generated by SqfEntity 
//  Copyright (c) 2019, All rights reserved. Use of this source code is governed by a
//  Apache license that can be found in the LICENSE file.

//  To use these SqfEntity classes do following: 
//  - import model.dart into where to use
//  - start typing ex:${_m.databaseTables!.isNotEmpty ? _m.databaseTables![0].modelName : ''}.select()... (add a few filters with fluent methods)...(add orderBy/orderBydesc if you want)...
//  - and then just put end of filters / or end of only select()  toSingle() / or toList() 
//  - you can select one or return List<yourObject> by your filters and orders
//  - also you can batch update or batch delete by using delete/update methods instead of tosingle/tolist methods
//    Enjoy.. Huseyin Tokpunar    

${_m.ignoreForFile != null ? '// ignore_for_file: ${_m.ignoreForFile!.join(', ')}' : ''}
$__createModelTables

$__createModelSequences

// BEGIN DATABASE MODEL
class ${_m.modelName} extends SqfEntityModelProvider {
  ${_m.modelName}() {
    databaseName = $_dbName;
    $_dbPassword $_dbVersion
    preSaveAction = ${_m.instanceName}.preSaveAction;
    logFunction = ${_m.instanceName}.logFunction;
    $__tableList
    $__sequenceList
    bundledDatabasePath =
        $_bundledDbName; //'assets/sample.db'; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  }
  Map<String, dynamic> getControllers() {
    final controllers= <String, dynamic>{};
    ${controllers().toString()}
    return controllers;
  }
}
// END DATABASE MODEL

  ''';
  }

  String controllers() {
    if (_m.formTables == null) {
      return '';
    }
    final retVal = StringBuffer();
    for (final table in _m.formTables!) {
      retVal.writeln(
          'controllers[\'${table.tableName!.toLowerCase()}\'] = ${table.modelName}Controller.getController;');
    }
    return retVal.toString();
  }

  String get _dbName => _m.instanceName != null
      ? '${_m.instanceName}.databaseName'
      : '\'${_m.databaseName}\'';
  String get _dbPassword => _m.instanceName != null
      ? 'password = ${_m.instanceName}.password;'
      : 'password = ${getValueWithQuotes(_m.password)};';
  String get _dbVersion => _m.instanceName != null
      ? 'dbVersion = ${_m.instanceName}.dbVersion;'
      : 'dbVersion = ${_m.dbVersion};';
  String get _bundledDbName => _m.instanceName != null
      ? '${_m.instanceName}.bundledDatabasePath'
      : _m.bundledDatabasePath == null
          ? 'null'
          : '\'${_m.bundledDatabasePath}\'';
  String createConstDatabase() {
    _m.modelName = toModelName(_m.modelName, 'MyDbModel');
    return '''
//  BEGIN ${_m.databaseName} MODEL
//  Paste the following code into your model.dart
//  Enjoy.. Huseyin Tokpunar    

$__createModelTablesConst

// BEGIN DATABASE MODEL
@SqfEntityBuilder(${tocamelCase(_m.modelName)})
const ${tocamelCase(_m.modelName)} = SqfEntityModel(
    modelName: '${_m.modelName}',
    databaseName: '${_m.databaseName}',
    databaseTables: [$__tableViewListConst],
    formTables: [$__tableListConst]
    ${_getNullableValueField(_m.bundledDatabasePath, 'bundledDatabasePath')} 
);
// END ${_m.databaseName} MODEL
''';
  }

  String _createModelTables() {
    if (_m.databaseTables == null) {
      return '';
    }

    final strTables = StringBuffer()..writeln('// BEGIN TABLES');

    final List<String> addedTables = <String>[];
    final List<SqfEntityTableBase> removeTables = <SqfEntityTableBase>[];
    int index = 0;
    for (final table in _m.databaseTables!) {
      if (addedTables.contains(table.modelName)) {
        removeTables.add(table);
        continue;
      }
      addedTables.add(table.modelName!);
      strTables.writeln('''
// ${table.modelName} TABLE      
class Table${table.modelName} extends SqfEntityTableBase {
  Table${table.modelName}() {
    // declare properties of EntityTable
    tableName = '${table.tableName}';${table.relationType != null && table.relationType != RelationType.ONE_TO_MANY ? _getNullableValueTable(table.relationType, 'relationType') : ''}
    ${table.objectType == ObjectType.table ? '${table.primaryKeyName != null ? 'primaryKeyName = \'${table.primaryKeyName}\';' : ''} ${table.primaryKeyName != null && table.primaryKeyName!.isNotEmpty ? 'primaryKeyType = ${table.primaryKeyType.toString()};' : ''}' : 'objectType = ${table.objectType.toString()}; sqlStatement = ${_m.instanceName}.databaseTables![$index].sqlStatement;'}
    useSoftDeleting = ${table.useSoftDeleting};
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      ${_createModelFields(table)}
    ];
    super.init();
  }
  static SqfEntityTableBase? _instance;
  static SqfEntityTableBase get getInstance {
    return _instance = _instance ?? Table${table.modelName}();
  }
}''');
      index++;
    }
    print('${addedTables.length} tables found in ${_m.modelName}');
    for (final table in removeTables) {
      _m.databaseTables!.remove(table);
    }
    strTables.writeln('// END TABLES');
    return strTables.toString();
  }

  String _createModelTablesConst() {
    if (_m.databaseTables == null || _m.databaseTables!.isEmpty) {
      return '';
    }
    final strTables = StringBuffer()..writeln('// BEGIN TABLES');
    for (final table in _m.databaseTables!
        .where((table) => table.relationType != RelationType.MANY_TO_MANY)) {
      strTables.writeln('''

const table${toCamelCase(table.tableName)} = SqfEntityTable(
    tableName: '${table.tableName}' 
    ${_getNullableValueField(table.primaryKeyName != null && table.primaryKeyName!.isNotEmpty ? table.primaryKeyName : null, 'primaryKeyName')} ${_getNullableValueField(table.primaryKeyName != null && table.primaryKeyName!.isNotEmpty ? table.primaryKeyType : null, 'primaryKeyType')}
    ${_getNullableValueField(table.relationType, 'relationType')} ${_getNullableValueField(table.sqlStatement, 'sqlStatement', true)} ${_getNullableValueField(table.objectType == ObjectType.table ? null : table.objectType, 'objectType')}
    ,fields: [
      ${_createModelFieldsConst(table)}
    ]);''');
    }
    strTables.writeln('// END TABLES');
    return strTables.toString();
  }

  String _createModelSequences() {
    final strSequences = StringBuffer();
    if (_m.sequences == null) {
      return '';
    }
    strSequences.writeln('// BEGIN SEQUENCES');
    for (var seq in _m.sequences!) {
      strSequences.writeln('''
// ${seq.sequenceName} SEQUENCE
class Sequence${seq.modelName} extends SqfEntitySequenceBase {
  Sequence${seq.modelName}() {
    sequenceName = '${seq.sequenceName}';
    maxValue = ${seq.maxValue};     /* optional. default is max int (9.223.372.036.854.775.807) */
    cycle = ${seq.cycle};      /* optional. default is false; */
    minValue = ${seq.minValue};    /* optional. default is 0 */
    incrementBy = ${seq.incrementBy}; /* optional. default is 1 */
    startWith = ${seq.startWith};  /* optional. default is 0 */
    super.init();
  }
  static Sequence${seq.modelName}? _instance;
  static Sequence${seq.modelName} get getInstance {
    return _instance = _instance ?? Sequence${seq.modelName}();
  }
}''');
    }
    strSequences.writeln('// END SEQUENCES');
    return strSequences.toString();
  }

  String _createModelFields(SqfEntityTableBase table) {
    final strFields = StringBuffer();

    for (final field in table.fields!) {
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.MANY_TO_MANY &&
          table.relationType != RelationType.MANY_TO_MANY) {
        continue;
      }
      final String commonProperties =
          '${_getNullableValueField(field.defaultValue, 'defaultValue')}${field.isPrimaryKeyField ?? false ? _getNullableValueField(field.isPrimaryKeyField, 'isPrimaryKeyField') : ''}${field.isPrimaryKeyField != null && field.isPrimaryKeyField == true ? '' : _getNullableValueField(field.isUnique, 'isUnique')}${field.isPrimaryKeyField != null && field.isPrimaryKeyField == true ? '' : _getNullableValueField(field.isNotNull, 'isNotNull')}${field.isPrimaryKeyField != null && field.isPrimaryKeyField == true ? '' : _getNullableValueField(field.isIndex, 'isIndex')}${_getNullableValueField(field.isIndexGroup, 'isIndexGroup')}${_getNullableValueField(field.checkCondition, 'checkCondition')}${_getNullableValueField(field.minValue, 'minValue')}${_getNullableValueField(field.maxValue, 'maxValue')}${_getNullableValueField(field.collate, 'collate')}';
      if (field is SqfEntityFieldVirtualBase) {
        strFields.writeln(
            'SqfEntityFieldVirtualBase(\'${field.fieldName}\', ${field.dbType.toString()}),');
      } else if (field is SqfEntityFieldRelationshipBase) {
        strFields.writeln(
            'SqfEntityFieldRelationshipBase(${field.table == null || field.table!.tableName == table.tableName ? 'null' : 'Table${field.table!.modelName}.getInstance'}, ${field.deleteRule.toString()}${_getNullableValueField(field.relationType, 'relationType')}${_getNullableValueField(field.fieldName!, 'fieldName')}$commonProperties),');
      } else {
        strFields.writeln(
            'SqfEntityFieldBase(\'${field.fieldName}\', ${field.dbType.toString()}$commonProperties),');
      }
    }

    return strFields.toString();
  }

  String _createModelFieldsConst(SqfEntityTableBase table) {
    final strFields = StringBuffer();

    for (final field in table.fields!) {
      if (field is SqfEntityFieldRelationshipBase) {
        strFields.writeln(
            'SqfEntityFieldRelationship(parentTable: ${field.table == null || field.table!.tableName == table.tableName ? 'null' : 'table${field.table!.modelName}'}, deleteRule: ${field.deleteRule.toString()}${_getNullableValueField(field.fieldName!, 'fieldName')}${field.isPrimaryKeyField != null && field.isPrimaryKeyField! ? _getNullableValueField(field.isPrimaryKeyField, 'isPrimaryKeyField') : ''}${_getNullableValueField(field.relationType, 'relationType')}${_getNullableValueField(field.manyToManyTableName, 'manyToManyTableName')}),');
      } else {
        strFields.writeln(
            'SqfEntityField(\'${field.fieldName}\', ${field.dbType.toString()}),');
      }
    }
    return strFields.toString();
  }

  // dynamic _getNullableStringValue(dynamic value) {
  //   return value is String
  //       ? '\'${value.toString().replaceAll('\'', '\\\'')}\''
  //       : value;
  // }

  /// Creates model of tables
  String createEntites() {
    print('createEntites() started');
    final modelString = MyStringBuffer();
    if (_m.databaseTables != null) {
      modelString.writeln('// BEGIN ENTITIES');
      for (var table in _m.databaseTables!) {
        final fieldNames = StringBuffer();
        for (final field in table.fields!) {
          fieldNames.write('${field.fieldName},');
        }
        print(
            '>>> ${table.objectType.toString().toUpperCase()} ${table.tableName}(${fieldNames.toString()}) converting to entity');
        table.dbModel = _m.modelName;
        modelString
          // ..printToDebug('0: ${table.tableName}')
          ..writeln(SqfEntityObjectBuilder(table).toString())
          // ..printToDebug('1: ${table.tableName}')
          ..writeln(SqfEntityObjectField(table).toString())
          //  ..printToDebug('2: ${table.tableName}')
          ..writeln(SqfEntityObjectFilterBuilder(table,
                  _m.formTables != null && _m.formTables!.contains(table))
              .toString())
          //  ..printToDebug('3: ${table.tableName}')
          ..writeln(SqfEntityFieldBuilder(table).toString())
          //  ..printToDebug('4: ${table.tableName}')
          ..writeln(SqfEntityObjectManagerBuilder(table).toString());
      }
    }

    if (_m.sequences != null) {
      for (var sequence in _m.sequences!) {
        modelString.writeln(
            SqfEntitySequenceBuilder(sequence, _m.modelName!).toString());
      }
    }
    modelString
      ..writeln(
          '''class ${_m.modelName}SequenceManager extends SqfEntityProvider {
${_m.modelName}SequenceManager() : super(${_m.modelName}());
}''')
      ..writeln('// END OF ENTITIES');
    print('SQFENTITY: [databaseTables] Model was created successfully. ');
    return modelString.toString();
  }

  /// Creates model of tables
  String createControllers() {
    if (_m.formTables!.isEmpty) {
      return '';
    }
    // print('createControllers() started');
    final modelString = MyStringBuffer()..writeln('// BEGIN CONTROLLERS');
    for (var table in _m.formTables!) {
      modelString
        ..printToDebug('CREATE CONTROLLER FOR TABLE: ${table.tableName}')
        ..writeln(SqfEntityControllerBuilder(table, _m.formTables!)
            .toControllersCode()
            .toString());
    }

    modelString.writeln('// END OF CONTROLLERS');
    print('SQFENTITY: [databaseTables] Controllers was created successfully. ');
    return modelString.toString();
  }
}

dynamic _getNullableValueField(dynamic value, String name,
    [bool multiRows = false]) {
  final quotes = multiRows ? '\'\'\'' : '\'';
  if (value is String) {
    dynamic val = DateTime.tryParse(value);
    if (val != null) {
      return ', $name: DateTime.parse(\'$value\')';
    }
    val = int.tryParse(value);

    if (value.contains('DateTime') || val != null) {
      return ', $name: $value';
    } else {
      return ', $name: $quotes${value.toString().replaceAll('\'', '\\\'')}$quotes';
    }
  } else {
    return value != null ? ', $name: $value' : '';
  }
}

dynamic _getNullableValueTable(dynamic value, String name) {
  if (value is String) {
    dynamic val = DateTime.tryParse(value);
    if (val != null) {
      return '$name= DateTime.parse(\'$value\');';
    }
    val = int.tryParse(value);

    if (value.contains('DateTime') || val != null) {
      return '$name = $value;';
    } else {
      return '$name = \'${value.toString().replaceAll('\'', '\\\'')}\';';
    }
  } else {
    return value != null ? '$name = $value;' : '';
  }
}

class _DbModel extends SqfEntityModelBase {}

class MyStringBuffer extends StringBuffer {
  void printToDebug(String text) {
    print(text);
  }
}

List<String> forbiddenNames = [
  'case',
  'select',
  'delete',
  'not',
  'extends',
  'class',
  'return',
  'if',
  'else',
  'and',
  'or'
];
