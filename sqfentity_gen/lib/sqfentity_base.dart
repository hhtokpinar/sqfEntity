part of 'sqfentity_gen.dart';

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

class SqfEntityBuilder {
  const SqfEntityBuilder(this.model);
  final SqfEntityModel model;
}

// REMOVED AFTER sqfentity_gen 1.4.0
// Just use formTables property in your db model
// class SqfEntityBuilderForm {
//   const SqfEntityBuilderForm(this.table);
//   final SqfEntityTable table;
// }

class SqfEntityTable {
  const SqfEntityTable(
      {this.tableName,
      this.primaryKeyName,
      this.fields,
      //this.primaryKeyfields,
      this.useSoftDeleting,
      this.primaryKeyType,
      this.defaultJsonUrl,
      this.modelName,
      this.customCode,
      this.relationType,this.formListTitleField,this.formListSubTitleField});
  final String tableName;
  final String primaryKeyName;
  final List<SqfEntityField> fields;
  // final List<String> primaryKeyfields;
  final bool useSoftDeleting;
  final PrimaryKeyType primaryKeyType;
  final String modelName;
  final String defaultJsonUrl;
  final String customCode;
  final RelationType relationType;
  final String formListTitleField;
  final String formListSubTitleField;
}

class TableCollection {
  const TableCollection(this.childTable, this.childTableField);
  final SqfEntityTable childTable;
  final SqfEntityFieldRelationship childTableField;
}

class SqfEntitySequence {
  const SqfEntitySequence(
      {this.sequenceName,
      this.startWith,
      this.incrementBy,
      this.minValue,
      this.maxValue,
      this.cycle,
      this.modelName});

  /// Name of the sequence.
  final String sequenceName;

  /// starting value from where the sequence starts. startWith value should be greater than or equal
  /// to minimum value and less than equal to maximum value.
  final int startWith;

  ///Value by which sequence will increment itself. Increment_value can be positive or negative.
  final int incrementBy;

  /// Minimum value of the sequence.
  final int minValue;

  /// Maximum value of the sequence.
  final int maxValue;

  /// cycle if true then, When sequence reaches its max value it starts from beginning. otherwise An exception will be thrown if sequence exceeds its max_value.
  final bool cycle;

  final String modelName;
}

class SqfEntityField {
  const SqfEntityField(this.fieldName, this.dbType,
      {this.defaultValue,
      this.minValue,
      this.maxValue,
      this.sequencedBy,
      this.formIsRequired,
      this.isPrimaryKeyField});
  final String fieldName;
  final DbType dbType;
  final dynamic defaultValue;
  final dynamic minValue;
  final dynamic maxValue;
  final SqfEntitySequence sequencedBy;
  final bool formIsRequired;
  final bool isPrimaryKeyField;
}

class SqfEntityFieldVirtual implements SqfEntityField {
  const SqfEntityFieldVirtual(this.fieldName, this.dbType);

  @override
  final DbType dbType;

  @override
  dynamic get defaultValue => null;

  @override
  final String fieldName;

  @override
  bool get formIsRequired => null;

  @override
  dynamic get maxValue => null;

  @override
  dynamic get minValue => null;

  @override
  SqfEntitySequence get sequencedBy => null;

  @override
  // TODO: implement isPrimaryKeyField
  bool get isPrimaryKeyField => null;
}

class SqfEntityFieldPrimaryKey extends SqfEntityField {
  const SqfEntityFieldPrimaryKey(
      this.primaryKeyFieldName, this.primaryKeyDbType)
      : super(primaryKeyFieldName, primaryKeyDbType);
  final DbType primaryKeyDbType;
  final String primaryKeyFieldName;
}

class SqfEntityFieldRelationship implements SqfEntityField {
  const SqfEntityFieldRelationship(
      {this.parentTable,
      this.deleteRule,
      this.fieldName,
      this.isPrimaryKeyField,
      this.defaultValue,
      this.minValue,
      this.maxValue,
      this.formDropDownTextField,
      this.formIsRequired,
      this.relationType,
      this.manyToManyTableName});
  @override
  final String fieldName;
  @override
  final dynamic defaultValue;
  @override
  final dynamic minValue;
  @override
  final dynamic maxValue;
  @override
  final bool formIsRequired;
  final String manyToManyTableName;
  final DeleteRule deleteRule;
  final RelationType relationType;
  final SqfEntityTable parentTable;
  final String formDropDownTextField;
  @override
  final bool isPrimaryKeyField;
  @override
  SqfEntitySequence get sequencedBy => null;
  @override
  DbType get dbType => null;
}

class SqfEntityModel {
  const SqfEntityModel(
      {this.databaseName,
      this.databaseTables,
      this.bundledDatabasePath,
      this.modelName,
      this.sequences,
this.formTables,
      this.password});
  // STEPS FOR CREATE YOUR DB CONTEXT

  // 1. declare your sqlite database name
  final String databaseName;

  // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing database
  final String bundledDatabasePath;
  final String password;
  // 2. Add the object you defined above to your list of database tables and sequences.
  final List<SqfEntityTable> databaseTables;
    final List<SqfEntityTable> formTables;
  final List<SqfEntitySequence> sequences;

  // set this property to your DBModel.dart path for ex: "import 'MyDbModel.dart';"
  final String modelName;
  // that's all.. one more step left for create models.dart file.
  // ATTENTION: Defining the table here provides automatic processing for database configuration only.
  // you may call the SqfEntityDbContext.createModel(MyDbModel.databaseTables) function to create your model and use it in your project
}

// END ANNOTATIONS

// BEGIN CONVERTERS
class ConvertedModel extends SqfEntityModelBase {}

class SqfEntityModelConverter {
  SqfEntityModelConverter(this.model);
  final SqfEntityModel model;

  SqfEntityModelBase toModelBase() {
    return ConvertedModel()
      ..databaseName = model.databaseName
      ..modelName = model.modelName
      ..databaseTables = toTables()
      ..sequences = toSequences()
      ..bundledDatabasePath = model.bundledDatabasePath
      ..init();
  }

  List<SqfEntityTableBase> toTables() {
    if (model.databaseTables == null) return null;
    final tables = <SqfEntityTableBase>[];
    for (final table in model.databaseTables) {
      tables.add(toTable(table));
    }
    return tables;
  }

  SqfEntityTableBase toTable(SqfEntityTable table) {
    return SqfEntityTableBase()
      ..tableName = table.tableName
      ..modelName = table.modelName
      ..primaryKeyName = table.primaryKeyName
      ..primaryKeyType = table.primaryKeyType
      ..useSoftDeleting = table.useSoftDeleting ?? false
      ..defaultJsonUrl = table.defaultJsonUrl
      ..customCode = table.customCode
      ..fields = toFields(table)
      ..init();
  }

  List<SqfEntityFieldType> toFields(SqfEntityTable table) {
    if (table.fields == null) return null;
    final fields = <SqfEntityFieldType>[];
    for (final field in table.fields) {
      if (field is SqfEntityFieldRelationship) {
        fields.add(SqfEntityFieldRelationshipBase(
            field.parentTable == null ? null : toTable(field.parentTable),
            field.deleteRule,
            fieldName: field.fieldName,
            isPrimaryKeyField: field.isPrimaryKeyField,
            relationType: field.relationType,
            manyToManyTableName: field.manyToManyTableName,
            defaultValue: field.defaultValue));
      } else {
        fields.add(SqfEntityFieldBase(field.fieldName, field.dbType)
          ..defaultValue = field.defaultValue
          ..isPrimaryKeyField = field.isPrimaryKeyField
          ..sequencedBy =
              field.sequencedBy == null ? null : toSequence(field.sequencedBy));
      }
    }
    return fields;
  }

  List<SqfEntitySequenceBase> toSequences() {
    if (model.sequences == null) return null;
    final sequenceList = <SqfEntitySequenceBase>[];
    for (final seq in model.sequences) {
      sequenceList.add(toSequence(seq));
    }
    return sequenceList;
  }

  SqfEntitySequenceBase toSequence(SqfEntitySequence seq) {
    if (seq == null) {
      return null;
    } else {
      return SqfEntitySequenceBase()
        ..sequenceName = seq.sequenceName
        ..modelName = seq.modelName
        ..minValue = seq.minValue
        ..maxValue = seq.maxValue
        ..startWith = seq.startWith
        ..incrementBy = seq.incrementBy
        ..cycle = seq.cycle
        ..init();
    }
  }
}
// END CONVERTERS

// BEGIN SQFENTITY BUILDERS

class SqfEntityFieldBuilder {
  SqfEntityFieldBuilder(this._table);
  SqfEntityTableBase _table;
  String get _createObjectField => __createObjectField();

  @override
  String toString() {
    final String toString = '''\n
// region ${_table.modelName}Fields
class ${_table.modelName}Fields {
$_createObjectField
}
// endregion ${_table.modelName}Fields
''';

    return toString;
  }

  String __createObjectField() {
    final retVal = StringBuffer();

    if (_table.primaryKeyName.isNotEmpty &&
        !_table.primaryKeyName.startsWith('_')) {
      retVal.writeln(
          '''static TableField _f${toCamelCase(_table.primaryKeyNames[0])};
  static TableField get ${_table.primaryKeyNames[0]} {
  return _f${toCamelCase(_table.primaryKeyNames[0])} = _f${toCamelCase(_table.primaryKeyNames[0])} ?? SqlSyntax.setField(_f${toCamelCase(_table.primaryKeyNames[0])}, '${_table.primaryKeyNames[0].toLowerCase()}', ${DbType.integer.toString()});
  }
''');
    }
    for (SqfEntityFieldType field
        in _table.fields.where((f) => !f.fieldName.startsWith('_'))) {
      if (field is SqfEntityFieldVirtualBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.MANY_TO_MANY &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      retVal.writeln(
          '''static TableField _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)};
  static TableField get ${field.fieldName} {
   return _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)} = _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)} ?? SqlSyntax.setField(_f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)}, '${field.fieldName}', ${field.dbType.toString()});
  }
''');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      retVal.writeln('''static TableField _fIsDeleted;
  static TableField get isDeleted {
   return  _fIsDeleted = _fIsDeleted ?? SqlSyntax.setField(_fIsDeleted, 'isDeleted', ${DbType.integer.toString()});
  }''');
    }
    return retVal.toString();
  }
}

class Controllers {
  static List<String> controllersub = <String>[];
  static List<String> controllers = <String>[];
}

class SqfEntityControllerBuilder {
  SqfEntityControllerBuilder(this.table, this.formTables);
  final SqfEntityTableBase table;
  final List<SqfEntityTableBase> formTables;
  String toControllersCode() {
    final String modelName = table.modelName ?? toCamelCase(table.tableName);

    final StringBuffer subItemsCodeList = StringBuffer();
    final StringBuffer subMenuCodeList = StringBuffer();
    String subControllers() {
      final retVal = StringBuffer();
      for (final collection in table.collections) {
        String objName = table.modelName;
        objName += 'To${collection.childTable.modelName}';
        //  print('subControllers: ${table.tableName} -> ${field.fieldName} -> objName:$objName');
        if (!Controllers.controllersub.contains(objName) && formTables.contains(collection.childTable)) {
          retVal.writeln(
              '''class ${objName}ControllerSub extends ${collection.childTable.modelName}Controller {
            static String relationshipFieldName='${collection.childTableField.fieldName}';
            static String primaryKeyName= '${collection.childTable.primaryKeyNames[0]}';
            static bool useSoftDeleting = ${collection.childTable.useSoftDeleting.toString()};
            //static String formListTitleField = '${getformListTitleField(table)}'; 
            //static String formListSubTitleField = '${getformListSubTitleField(table)}'; 
            }''');
          Controllers.controllersub.add(objName);
          // PlaylistId IN (SELECT PlaylistId FROM PlaylistTrack WHERE TrackId=$id)
          final filterExpression = collection.relationType ==
                  RelationType.MANY_TO_MANY
              ? '${collection.childTable.primaryKeyNames[0]} IN (SELECT ${collection.childTable.primaryKeyNames[0]} FROM ${collection.childTableField.manyToManyTableName} WHERE ${table.primaryKeyNames[0]}=?)'
              : '\${${objName}ControllerSub.relationshipFieldName}=?';

          subItemsCodeList.writeln('''
            case '$objName':
            return SQFViewList(${objName}ControllerSub(),
              primaryKeyName: ${objName}ControllerSub.primaryKeyName,
              useSoftDeleting: ${objName}ControllerSub.useSoftDeleting,
              //formListTitleField: '${getformListTitleField(table)}',
              //formListSubTitleField: '${getformListSubTitleField(table)}',
              filterExpression: '$filterExpression',filterParameter: id,);''');
          subMenuCodeList.writeln('''
              menu['$objName'] = '${table.modelName} To ${collection.childTable.modelName}';''');
        }
      }
      return retVal.toString();
    }

    String subItemsCode() => subItemsCodeList.isNotEmpty
        ? '''SQFViewList subList(${table.primaryKeyTypes[0]} id, String controllerName) {
             switch (controllerName) {
            ${subItemsCodeList.toString()}
             default:
            return null;
      }
    }'''
        : '';

    String subMenuCode() => '''
          Map<String, String> subMenu() {
    final menu = <String, String>{};
    ${subMenuCodeList.toString()}
    return menu;
  }
          ''';

    return '''
  // BEGIN CONTROLLER (${table.modelName})
    ${subControllers().toString()}
    class ${modelName}Controller extends $modelName{
    String formListTitleField  = '${getformListTitleField(table)}';
    String formListSubTitleField  = '${getformListSubTitleField(table)}';
     static SQFViewList getController = SQFViewList(
      ${table.modelName}Controller(),
      primaryKeyName: '${table.primaryKeyNames[0]}',
      useSoftDeleting: ${table.useSoftDeleting.toString()},
    );
    ${subMenuCode().toString()}
    ${subItemsCode().toString()}
    Future<Widget> gotoEdit(dynamic obj) async{
       return ${modelName}Add(obj==null ? $modelName() : await $modelName().getById(${__gotoEditgetByIdParameters(table)}) ?? $modelName());
  }
}
// END CONTROLLER (${table.modelName}) 
''';
  }

  String __gotoEditgetByIdParameters(SqfEntityTableBase _table) {
    final retVal = StringBuffer()..write(
        //'${(withTypes ? _table.primaryKeyTypes[0] : '')} ${_table.primaryKeyNames[0]}'
        'obj[\'${_table.primaryKeyNames[0]}\']${table.primaryKeyTypes[0].toLowerCase() == 'string' ? '.toString()' : ' as ${table.primaryKeyTypes[0]}'}');
    for (int i = 1; i < _table.primaryKeyNames.length; i++) {
      retVal.write(
          ', obj[\'${_table.primaryKeyNames[i]}\']${table.primaryKeyTypes[i].toLowerCase() == 'string' ? '.toString()' : ' as ${table.primaryKeyTypes[i]}'}');
    }

    return retVal.toString();
  }
}

class SqfEntityObjectBuilder {
  SqfEntityObjectBuilder(this._table);
  SqfEntityTableBase _table;
  String get _createProperties => __createProperties();
  String get _createObjectRelations => __createObjectRelations();
  String get _createObjectCollections => __createObjectCollections();
  String get _createObjectCollectionsToMap => __createObjectCollectionsToMap();
  String get _createConstructure => __createConstructure(false, false);
  String get _createConstructureWithId => __createConstructure(false, true);
  String get _createBaseConstructure => __createBaseConstructure();
  String get _createListParameterForQuery => __createConstructure(true, false);
  String get _createListParameterForQueryWithId =>
      __createConstructure(true, true);
  String get _createConstructureArgs => __createConstructureArgs(false);
  String get _createConstructureArgsWithId => __createConstructureArgs(true);
  String get _toMapString => __toMapString();
  String get _toFromMapString => __toFromMapString();
  String get _fromWebUrl => __fromWebUrl();
  String get _saveMethod => __saveMethod();
  String get _upsertAllMethod => __upsertAllMethod();
  String get _saveAllMethod => __saveAllMethod();
  String get _deleteMethodSingle => __deleteMethodSingle();
  String get _recoverMethodSingle => __recoverMethodSingle();
  String get _createDefaultValues => __createDefaultValues();
  String get _toOnetoOneCollections => __toOnetoOneCollections(_table);
  String get _getByIdParameters => __getByIdParameters(_table, false);
  String get _getByIdWhereStr => __getByIdWhereStr(_table);
  //String get _getUpdateStr => __getUpdateStr(_table);
  String get _getByIdParametersWithTypes => __getByIdParameters(_table, true);
  String get _toOnetoManyCollections => __toOnetoManyCollections(_table);
  String get _createObjectRelationsPreLoad =>
      __createObjectRelationsPreLoad(_table);
  String get _toOnetoOneSaveCode => __toOnetoOneSaveCode(_table);
  String get _toOnetoOneSaveAsCode => __toOnetoOneSaveAsCode(_table);
  String get _hiddenMethod =>
      _table.relationType == RelationType.ONE_TO_ONE ? '_' : '';

  @override
  String toString() {
    final String toString = '''
  // region ${_table.modelName}
  class ${_table.modelName} {
    ${_table.modelName}({$_createBaseConstructure}) { _setDefaultValues();}
    ${_table.modelName}.withFields($_createConstructure){ _setDefaultValues();}
    ${_table.modelName}.withId($_createConstructureWithId){ _setDefaultValues();}
    ${_table.modelName}.fromMap(Map<String, dynamic> o) {
      _setDefaultValues();
      $_toFromMapString
      }
    // FIELDS (${_table.modelName})
    $_createProperties      // end FIELDS (${_table.modelName})
    $_createObjectRelations
    $_createObjectCollections
    static const bool _softDeleteActivated=${_table.useSoftDeleting.toString()};
    ${_table.modelName}Manager __mn${_table.modelName};
  
    ${_table.modelName}Manager get _mn${_table.modelName} {
      return __mn${_table.modelName} = __mn${_table.modelName} ?? ${_table.modelName}Manager();
    }
  
    // METHODS
    Map<String, dynamic> toMap({bool forQuery = false, bool forJson = false, bool forView=false}) {
      final map = <String, dynamic>{};
      $_toMapString
      return map;
      }
  
    
    Future<Map<String, dynamic>> toMapWithChildren([bool forQuery = false, bool forJson=false, bool forView=false]) async {
      final map = <String, dynamic>{};
      $_toMapString
      $_createObjectCollectionsToMap
      return map;
      }
  
    /// This method returns Json String
    String toJson() {
      return json.encode(toMap(forJson: true));
    }
    
    /// This method returns Json String
    Future<String> toJsonWithChilds() async {
      return json.encode(await toMapWithChildren(false,true));
    }
  
  
    List<dynamic> toArgs() {
      return[${_createListParameterForQuery.replaceAll('this.', '')}];   
    }  
    List<dynamic> toArgsWithIds() {
      return[${_createListParameterForQueryWithId.replaceAll('this.', '')}];   
    }  
  
    $_fromWebUrl  
    static Future<List<${_table.modelName}>> fromWebUrl(String url) async {
      try {
        final response = await http.get(url);
        return await fromJson(response.body);
      } catch (e) {
        print('SQFENTITY ERROR ${_table.modelName}.fromWebUrl: ErrorMessage: \${e.toString()}');
        return null;
      }
    }
  
    static Future<List<${_table.modelName}>> fromJson(String jsonBody) async{
      final Iterable list = await json.decode(jsonBody) as Iterable;
      var objList = <${_table.modelName}>[];
      try {
        objList = list.map((${_table._modelLowerCase}) => ${_table.modelName}.fromMap(${_table._modelLowerCase} as Map<String, dynamic>)).toList();
      } catch (e) {
        print('SQFENTITY ERROR ${_table.modelName}.fromJson: ErrorMessage: \${e.toString()}');
      }
      return objList;
    }
  
    /*
    /// REMOVED AFTER v1.2.1+14 
    static Future<List<${_table.modelName}>> fromObjectList(Future<List<dynamic>> o) async {
      final data = await o;
      return await ${_table.modelName}.fromMapList(data);
    } 
    */

    static Future<List<${_table.modelName}>> fromMapList(List<dynamic> data,{bool preload=false, List<String> preloadFields, bool loadParents=false, List<String> loadedFields}) async{
      final List<${_table.modelName}> objList = <${_table.modelName}>[];
      loadedFields = loadedFields ?? [];
      for (final map in data) {
        final obj = ${_table.modelName}.fromMap(map as Map<String, dynamic>);
        final List<String> _loadedFields = List<String>.from(loadedFields);
        $_toOnetoOneCollections
        $_toOnetoManyCollections
        $_createObjectRelationsPreLoad
        objList.add(obj);
      }
      return objList;
    }
  
  
    /// returns ${_table.modelName} by ID if exist, otherwise returns null
    /// 
    /// Primary Keys: $_getByIdParametersWithTypes
    /// 
    ${commentPreload.replaceAll('methodname', 'getById')}
    /// 
    /// <returns>returns ${_table.modelName} if exist, otherwise returns null
    Future<${_table.modelName}> getById($_getByIdParametersWithTypes, {bool preload=false, List<String> preloadFields,bool loadParents=false, List<String> loadedFields}) async{
      if(${_table.primaryKeyNames[0]}==null){return null;}
      ${_table.modelName} obj;
      final data = await _mn${_table.modelName}.getById([$_getByIdParameters]);
      if (data.length != 0) 
          {obj = ${_table.modelName}.fromMap(data[0] as Map<String, dynamic>);
          final List<String> _loadedFields = loadedFields ?? [];
            $_toOnetoOneCollections
            $_toOnetoManyCollections
            $_createObjectRelationsPreLoad
          }
      else
          {obj = null;}
      return obj;
    }
  
    $_saveMethod
  

    $_saveAllMethod
    
    
    /// Updates if the record exists, otherwise adds a new row
    
    /// <returns>Returns ${_table.primaryKeyNames[0]}
    Future<int> upsert() async {
       try {
         if (await _mn${_table.modelName}.rawInsert( 
          'INSERT OR REPLACE INTO ${_table.tableName} (${_createConstructureWithId.replaceAll('this.', '')})  VALUES ($_createConstructureArgsWithId)', [${_createListParameterForQueryWithId.replaceAll('this.', '')}]) ==
           1) {
          saveResult = BoolResult(success: true, successMessage: '${_table.modelName} ${_table.primaryKeyNames[0]}=\$${_table.primaryKeyNames[0]} updated successfully');
          } else {
        saveResult = BoolResult(
            success: false, errorMessage: '${_table.modelName} ${_table.primaryKeyNames[0]}=\$${_table.primaryKeyNames[0]} did not update');
         }
          return ${_table.primaryKeyType == PrimaryKeyType.text ? '1' : '${_table.primaryKeyNames[0]}'};
       } catch (e) {
        saveResult = BoolResult(success: false,errorMessage: '${_table.modelName} Save failed. Error: \${e.toString()}');
        return 0;
      }
    }
    
    
    $_upsertAllMethod
  
    /// Deletes ${_table.modelName}
    
    /// <returns>BoolResult res.success=Deleted, not res.success=Can not deleted
    Future<BoolResult> delete([bool hardDelete=false]) async {
      print('SQFENTITIY: delete ${_table.modelName} invoked (${_table.primaryKeyNames[0]}=\$${_table.primaryKeyNames[0]})');
      $_deleteMethodSingle
    }
      $_recoverMethodSingle
    //private ${_table.modelName}FilterBuilder _Select;
    ${_table.modelName}FilterBuilder select(
        {List<String> columnsToSelect, bool getIsDeleted}) {
      return ${_table.modelName}FilterBuilder(this)
      .._getIsDeleted = getIsDeleted==true
      ..qparams.selectColumns = columnsToSelect;
    }
  
    ${_table.modelName}FilterBuilder distinct(
        {List<String> columnsToSelect, bool getIsDeleted}) {
      return ${_table.modelName}FilterBuilder(this)
      .._getIsDeleted = getIsDeleted==true
      ..qparams.selectColumns = columnsToSelect
      ..qparams.distinct = true;
    }
  
    void _setDefaultValues() {
      $_createDefaultValues
    }
    // END METHODS
    // CUSTOM CODES
    ${_table.customCode != null ? _table.customCode : '''/*
      you must define customCode property of your SqfEntityTable constant for ex:
      const tablePerson = SqfEntityTable(
      tableName: 'person',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
        SqfEntityField('firstName', DbType.text),
        SqfEntityField('lastName', DbType.text),
      ],
      customCode: \'\'\'
       String fullName()
       { 
         return '\$firstName \$lastName';
       }
      \'\'\');
     */'''}
    // END CUSTOM CODES
    }
  // endregion ${_table._modelLowerCase}
              ''';
    return toString;
  }

  String __createProperties() {
    final _retVal = StringBuffer();
    if (_table.primaryKeyName.isNotEmpty)
      _retVal.writeln(
          '${_table.primaryKeyType == PrimaryKeyType.text ? 'String' : 'int'} ${_table.primaryKeyNames[0]};');
    for (final field in _table.fields) {
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.MANY_TO_MANY &&
          _table.relationType != RelationType.MANY_TO_MANY) continue;
      //     field.table.primaryKeyNames.isNotEmpty) {
      //   for (int i = 0; i < field.table.primaryKeyNames.length; i++) {
      //     _retVal.writeln(
      //         '${field.table.primaryKeyTypes[i]} ${field.table.primaryKeyNames[i]};');
      //   }
      // } else {
      //   _retVal.writeln(field.toPropertiesString());
      // }
      _retVal.writeln(field.toPropertiesString());
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.writeln('    bool isDeleted;');
    }

    _retVal
      ..writeln(
          _table.primaryKeyType != PrimaryKeyType.integer_auto_incremental ||
                  _table.primaryKeyName.isEmpty
              ? 'bool isSaved;'
              : '')
      ..writeln('BoolResult saveResult;');
    return _retVal.toString();
  }

  String __createConstructure(bool isQuery, bool withId) {
    final _retVal = StringBuffer();
    if (_table.primaryKeyName.isNotEmpty &&
        _table.relationType != RelationType.ONE_TO_ONE &&
        (withId ||
            _table.primaryKeyType != PrimaryKeyType.integer_auto_incremental)) {
      _retVal..write(',')..write(_table.primaryKeyName);
    }

    if (_table.fields[0].isPrimaryKeyField != true ||
        _table.relationType == RelationType.MANY_TO_MANY ||
        withId) {
      _retVal..write(',')..write(_table.fields[0].toConstructureString());
    }

    for (int i = 1; i < _table.fields.length; i++) {
      if (_table.fields[i] is SqfEntityFieldVirtualBase ||
          (_table.fields[i].isPrimaryKeyField == true &&
              !withId &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      if (_table.fields[i] is SqfEntityFieldRelationshipBase) {
        final SqfEntityFieldRelationshipBase field =
            _table.fields[i] as SqfEntityFieldRelationshipBase;
        if (field.relationType == RelationType.MANY_TO_MANY &&
            _table.relationType != RelationType.MANY_TO_MANY) continue;
      }
      final consStr = _table.fields[i].toConstructureString();
      _retVal.write(', $consStr');
      if (isQuery &&
          (_table.fields[i].dbType == DbType.date ||
              _table.fields[i].dbType == DbType.datetime ||
              _table.fields[i].dbType == DbType.datetimeUtc)) {
        _retVal.write(' != null ? $consStr.millisecondsSinceEpoch: null');
      }
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.write(',this.isDeleted');
    }
    if (_retVal.length > 0)
      return _retVal.toString().substring(1);
    else
      return '';
  }

  String __createBaseConstructure() {
    final _retVal = StringBuffer();

    if (_table.primaryKeyName.isNotEmpty &&
        _table.relationType != RelationType.ONE_TO_ONE) {
      _retVal..write(', this.')..write(_table.primaryKeyName);
    }

    for (final field in _table.fields
        .where((f) => !f.fieldName.startsWith('_') && f.fieldName.isNotEmpty)) {
      if (field is SqfEntityFieldVirtualBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.MANY_TO_MANY &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      final consStr = field.toConstructureString();
      _retVal.write(', $consStr');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.write(',this.isDeleted');
    }
    if (_retVal.length > 0) {
      return _retVal.toString().substring(1);
    } else
      return '';
  }

  String __createConstructureArgs(bool withId) {
    final _retVal = StringBuffer('?');
    //  for (var i = 1; i < _table.primaryKeyNames.length; i++) {
    //   _retVal.write(',?');
    // }
    if (_table.primaryKeyName.isNotEmpty &&
        _table.relationType != RelationType.ONE_TO_ONE &&
        (withId ||
            _table.primaryKeyType != PrimaryKeyType.integer_auto_incremental)) {
      _retVal.write(',?');
    }
    for (var i = 1; i < _table.fields.length; i++) {
      //if (_table.fields[i] is SqfEntityFieldVirtualBase) continue;
      if (_table.fields[i] is SqfEntityFieldVirtualBase ||
          (_table.fields[i].isPrimaryKeyField == true &&
              !withId &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      if (_table.fields[i] is SqfEntityFieldRelationshipBase) {
        final SqfEntityFieldRelationshipBase field =
            _table.fields[i] as SqfEntityFieldRelationshipBase;
        if (field.relationType == RelationType.MANY_TO_MANY &&
            _table.relationType != RelationType.MANY_TO_MANY) continue;
      }
      _retVal.write(',?');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.write(',?');
    }
    return _retVal.toString(); //.substring(1);
  }

  String __toMapString() {
    final _retVal = StringBuffer();
    if (_table.relationType != RelationType.ONE_TO_ONE &&
        _table.primaryKeyName.isNotEmpty)
      _retVal.writeln(
          'if (${_table.primaryKeyNames[0]} != null) {map[\'${_table.primaryKeyNames[0]}\'] = ${_table.primaryKeyNames[0]};}');
    for (var field in _table.fields) {
      if (field is SqfEntityFieldVirtualBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.MANY_TO_MANY &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;

      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.ONE_TO_MANY) {
        _retVal.writeln(
            'if (${field.fieldName} != null) {map[\'${field.fieldName}\'] = forView ? pl${field.relationshipName}.${field.formDropDownTextField} : ${field.fieldName};}\n');

//   'map['MediaTypeId'] = forView ? plMediaType.Name : MediaTypeId;')
      } else {
        _retVal.writeln('    ${field.toMapString()}');
      }
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.writeln(
          '  if (isDeleted != null) {map[\'isDeleted\'] = forQuery? (isDeleted ? 1 : 0):isDeleted;}');
    }
    return _retVal.toString();
  }

  String __toFromMapString() {
    final _retVal = StringBuffer();
    if (_table.primaryKeyName.isNotEmpty) {
      if (_table.primaryKeyType == PrimaryKeyType.text) {
        _retVal.writeln(
            '${_table.primaryKeyNames[0]} = o[\'${_table.primaryKeyNames[0]}\'] as String;');
      } else {
        _retVal.writeln(
            '${_table.primaryKeyNames[0]} = int.tryParse(o[\'${_table.primaryKeyNames[0]}\'].toString());');
      }
    }
    for (final field in _table.fields) {
      if (field is SqfEntityFieldVirtualBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.MANY_TO_MANY &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      _retVal.writeln('    ${field.toFromMapString()}');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.writeln(
          '  isDeleted = o[\'isDeleted\'] != null ? o[\'isDeleted\'] == 1 || o[\'isDeleted\'] == true : null;');
    }
    _retVal
      //..writeln(__createObjectCollectionsFromMap().toString()) // Not tested yet
      ..writeln(__createObjectRelationsFromMap().toString());
    if (_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental ||
        _table.primaryKeyName.isEmpty) {
      _retVal.writeln('isSaved=true;');
    }
    return _retVal.toString();
  }

  String __createDefaultValues() {
    final _retVal = StringBuffer(
        _table.primaryKeyType != PrimaryKeyType.integer_auto_incremental ||
                _table.primaryKeyName.isEmpty
            ? 'isSaved=false;'
            : '');
    for (final field in _table.fields.where((f) => f.defaultValue != null)) {
      switch (field.dbType) {
        case DbType.text:
          field.defaultValue =
              "'${field.defaultValue.replaceAll('\'', '\\\'')}'";
          break;
        case DbType.bool:
          field.defaultValue =
              '${field.defaultValue.toString() == '1' || field.defaultValue.toString() == 'true' ? 'true' : 'false'}';
          break;
        default:
      }
      _retVal.writeln(
          ' ${field.fieldName}=${field.fieldName} ?? ${field.defaultValue};');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      _retVal.writeln(' isDeleted= isDeleted ?? false;');
    }

    return _retVal.toString();
  }

  String __createObjectRelations() {
   // print('__createObjectRelations for ${_table.tableName}');
    var retVal = '';
    final relations = <String>[];
    for (final field
        in _table.fields.where((f) => f is SqfEntityFieldRelationshipBase)) {
      print('- Recognizing RelationShip named ${field.fieldName}');
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.ONE_TO_MANY) {
        // final objName = field.relationshipName == null
        //     ? _table.modelName.toLowerCase()
        //     : field.relationshipName.toLowerCase();

        final modelName = field.relationshipName ?? _table.modelName;
        String funcName = modelName;

        if (relations.contains(funcName)) {
          funcName += 'By${toCamelCase(field.fieldName)}';
          if (relations.contains(funcName)) continue;
        }
        if (field.relationshipFields == null) {
          print(
              'field.relationshipFields = null funcName:$funcName, field.fieldName: ${field.fieldName}');
        }
        //print('funcName: $funcName');
        retVal +=
            '''/// to load parent of items to this field, use preload parameter ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
            /// You can also specify this object into certain preload fields. Ex: toList(preload:true, preloadFields:['pl$funcName', 'plField2'..]) or so on..
        $modelName pl$funcName;
        /// get $modelName By ${toCamelCase(field.fieldName)}
        Future<$modelName> get$funcName({bool loadParents = false, List<String> loadedFields}) async{
            final _obj = await $modelName().getById(${field.relationshipFields.join(',')}, loadParents: loadParents, loadedFields: loadedFields);
            return _obj;
          }
        ''';
        relations.add(funcName);
      }
    }
    if (retVal.isNotEmpty) {
      retVal =
          '\n// RELATIONSHIPS (${_table.modelName})\n$retVal// END RELATIONSHIPS (${_table.modelName})\n';
    }
    return retVal;
  }

  // final StringBuffer subItemsCodeList = StringBuffer();
  // String subItemsCode() => subItemsCodeList.isNotEmpty
  //     ? '''SQFViewList subList(${_table.primaryKeyTypes[0]} id, String controllerName) {
  //          switch (controllerName) {
  //         ${subItemsCodeList.toString()}
  //          default:
  //         return null;
  //   }

  // }'''
  //    : '';
  String __createObjectCollections() {
    if(_table.collections == null) return '';
    print('__createObjectCollections for ${_table.tableName}');
    final retVal = StringBuffer();
    final collections = <String>[];
    for (var tableCollection in _table.collections) {
      if (_table.relationType == RelationType.MANY_TO_MANY &&
          tableCollection.childTable.relationType == RelationType.MANY_TO_MANY)
        continue;
      String funcName = getFuncName(tableCollection, false, _table);

      if (collections.contains(funcName)) {
        funcName = getFuncName(tableCollection, true, _table);
        if (collections.contains(funcName)) continue;
      }
      if (tableCollection.childTableField.relationType ==
          RelationType.ONE_TO_ONE) {
        final o2oName = tableCollection.childTable.modelName;
        final o2oNameLower = o2oName.toLowerCase();
        retVal.writeln('''$o2oName _$o2oNameLower;
            $o2oName get $o2oNameLower {
            return _$o2oNameLower = _$o2oNameLower ?? $o2oName();
            }
            set $o2oNameLower($o2oName $o2oNameLower) {_$o2oNameLower=$o2oNameLower;}    
              ''');
        continue;
      }
      final childTableFieldTablePrimaryKeyName =
          tableCollection.childTableField.table == null
              ? _table.primaryKeyNames[0]
              : tableCollection.childTableField.table.primaryKeyNames[0];

      if (tableCollection.relationType == RelationType.MANY_TO_MANY) {
        retVal.writeln(
            '''///(RelationType.MANY_TO_MANY) to load children of items to this field, use preload parameter. Ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
            /// You can also specify this object into certain preload fields. Ex: toList(preload:true, preloadFields:['pl$funcName', 'plField2'..]) or so on..
            List<${tableCollection.childTable.modelName}> pl$funcName;
            /// get ${tableCollection.childTable.modelName}(s) filtered by ${tableCollection.childTable.primaryKeyNames[0]} IN ${tableCollection.childTableField.manyToManyTableName}
              ${tableCollection.childTable.modelName}FilterBuilder get$funcName({List<String> columnsToSelect, bool getIsDeleted}){
           return ${tableCollection.childTable.modelName}().select(columnsToSelect: columnsToSelect,getIsDeleted: getIsDeleted)
           .where('${tableCollection.childTable.primaryKeyNames[0]} IN (SELECT ${tableCollection.childTable.primaryKeyNames[0]} FROM ${tableCollection.childTableField.manyToManyTableName} WHERE $childTableFieldTablePrimaryKeyName=?)',
            parameterValue: $childTableFieldTablePrimaryKeyName) 
            .and;


          }''');
      } else if (_table.tableName == tableCollection.childTable.tableName) {
        retVal.writeln('''
            /// to load children of items to this field, use preload parameter. Ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
            /// You can also specify this object into certain preload fields. Ex: toList(preload:true, preloadFields:['pl$funcName', 'plField2'..]) or so on..
            List<${_table.modelName}> pl$funcName;
            /// get ${_table.modelName}(s) filtered by ${_table.primaryKeyNames[0]}=${tableCollection.childTableField.fieldName}
              ${_table.modelName}FilterBuilder get$funcName({List<String> columnsToSelect, bool getIsDeleted}){
           return ${_table.modelName}().select(columnsToSelect: columnsToSelect,getIsDeleted: getIsDeleted).${_table.primaryKeyNames[0]}.equals(${tableCollection.childTableField.fieldName}).and;
          }''');
      } else {
        retVal.writeln(
            '''/// to load children of items to this field, use preload parameter. Ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
            /// You can also specify this object into certain preload fields. Ex: toList(preload:true, preloadFields:['pl$funcName', 'plField2'..]) or so on..
            List<${tableCollection.childTable.modelName}> pl$funcName;
            /// get ${tableCollection.childTable.modelName}(s) filtered by ${tableCollection.childTableField.fieldName}=$childTableFieldTablePrimaryKeyName
              ${tableCollection.childTable.modelName}FilterBuilder get$funcName({List<String> columnsToSelect, bool getIsDeleted}){
           return ${tableCollection.childTable.modelName}().select(columnsToSelect: columnsToSelect,getIsDeleted: getIsDeleted).${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).and;
          }''');
      }
      collections.add(funcName);
    }

    return retVal.length > 0
        ? '\n// COLLECTIONS & VIRTUALS (${_table.modelName})\n${retVal.toString()}\n// END COLLECTIONS & VIRTUALS (${_table.modelName})\n'
        : '';
  }

  String __createObjectCollectionsToMap() {
     if(_table.collections == null) return '';
    print('__createObjectCollectionsToMap for ${_table.tableName}');
    final retVal = StringBuffer();
    final collections = <String>[];

    for (var tableCollection in _table.collections) {
      if (_table.relationType == RelationType.MANY_TO_MANY &&
          tableCollection.childTable.relationType == RelationType.MANY_TO_MANY)
        continue;
      String funcName = getFuncName(tableCollection, false, _table);
      if (collections.contains(funcName)) {
        funcName = getFuncName(tableCollection, true, _table);
        if (collections.contains(funcName)) continue;
      }
      if (tableCollection.childTableField.table != null) {
        if (tableCollection.childTableField.relationType ==
            RelationType.ONE_TO_ONE) {
          final relationName =
              tableCollection.childTable.modelName.toLowerCase();
          retVal.writeln(
              '''if (!forQuery && $relationName != null) {map['$relationName'] = await $relationName.toMapWithChildren();}''');
        } else {
          retVal.writeln(
              '''if (!forQuery) {map['$funcName'] = await get$funcName().toMapList();}''');
        }
      }
    }
    return retVal.length > 0
        ? '\n// COLLECTIONS (${_table.modelName})\n${retVal.toString()}// END COLLECTIONS (${_table.modelName})\n'
        : '';
  }

  String __createObjectRelationsFromMap() {
    print('__createObjectRelationsFromMap for ${_table.tableName}');
    final retVal = StringBuffer();
    final relations = <String>[];
    for (final field
        in _table.fields.where((f) => f is SqfEntityFieldRelationshipBase)) {
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.ONE_TO_MANY) {
        final modelName = field.relationshipName ?? _table.modelName;
        final String mapName =
            field.fieldName.toLowerCase() == modelName.toLowerCase()
                ? 'pl$modelName'
                : tocamelCase(modelName);
        String funcName = modelName;
        if (relations.contains(funcName)) {
          funcName += 'By${toCamelCase(field.fieldName)}';
          if (relations.contains(funcName)) continue;
        }
        //retVal.writeln('if (preloadFields == null || preloadFields.contains(\'pl$funcName\')) {obj.pl$funcName = await obj.get$funcName();}');
        retVal.writeln(
            'pl$funcName = o[\'$mapName\'] != null ? $modelName.fromMap(o[\'$mapName\'] as Map<String, dynamic>) : null;');
        relations.add(funcName);
      }
    }
    if (retVal.isNotEmpty) {
      return '\n      // RELATIONSHIPS FromMAP\n${retVal.toString()}          // END RELATIONSHIPS FromMAP\n';
    }
    return '';
  }

  String __fromWebUrl() {
    if (_table.defaultJsonUrl != null && _table.defaultJsonUrl.isNotEmpty) {
      return '''
         static Future<List<${_table.modelName}>> fromWeb([VoidCallback Function(List<${_table.modelName}> o) ${_table._modelLowerCase}List]) async {
              final objList = await fromWebUrl('${_table.defaultJsonUrl}');
              if (${_table._modelLowerCase}List != null) {${_table._modelLowerCase}List (objList); } 
              return objList;
          }
              ''';
    } else {
      return '';
    }
  }

  String __deleteMethodSingle() {
     if(_table.collections == null) return '';
    var retVal = '';
    final varResult = 'var result= BoolResult();';

    for (var tableCollection in _table.collections) {
      // if (tableCollection.childTable._hasManyToMany == true) {
      if (tableCollection.childTableField.relationType ==
          RelationType.MANY_TO_MANY) {
        continue;
      }
      final childTableFieldTablePrimaryKeyName =
          tableCollection.childTableField.table == null
              ? _table.primaryKeyNames[0]
              : tableCollection.childTableField.table.primaryKeyNames[0];

      switch (tableCollection.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          retVal += '''
      {result = await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).update({"${tableCollection.childTableField.fieldName}": null});}
      if (!result.success) {return result;}
      ''';
          break;
        case DeleteRule.NO_ACTION:
          retVal += '''
      if (await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).toCount()>0) {return BoolResult(success: false,errorMessage: 'SQFENTITY ERROR: The DELETE statement conflicted with the REFERENCE RELATIONSHIP (${tableCollection.childTable.modelName}.${tableCollection.childTableField.fieldName})');}''';
          break;
        case DeleteRule.CASCADE:
          retVal += '''
      {result = await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).delete(hardDelete);}
      if (!result.success) {return result;}''';
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          retVal += '''
      {result = await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).update({'${tableCollection.childTableField.fieldName}': ${tableCollection.childTableField.defaultValue}});}
      if (!result.success) {return result;}''';
          break;
        default:
      }
    }
    if (retVal.contains('result =')) {
      retVal = varResult + retVal;
    }

    return retVal += '''
      if (!_softDeleteActivated || hardDelete${_table.useSoftDeleting != null && _table.useSoftDeleting ? ' || isDeleted' : ''}) {
      return _mn${_table.modelName}.delete(QueryParams(whereString: '$_getByIdWhereStr', whereArguments: [$_getByIdParameters]));}
      else {
      return _mn${_table.modelName}.updateBatch(QueryParams(whereString: '$_getByIdWhereStr', whereArguments: [$_getByIdParameters]), {'isDeleted': 1});}''';
  }

  String __recoverMethodSingle() {
     if(_table.collections == null) return '';
    if (_table.useSoftDeleting == null || !_table.useSoftDeleting) {
      return '';
    }
    var retVal = '';
    final varResult = 'var result= BoolResult();';

    for (var tableCollection in _table.collections) {
      final childTableFieldTablePrimaryKeyName =
          tableCollection.childTableField.table == null
              ? _table.primaryKeyNames[0]
              : tableCollection.childTableField.table.primaryKeyNames[0];
      switch (tableCollection.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        case DeleteRule.CASCADE:
          if (tableCollection.childTable.useSoftDeleting) {
            retVal += '''
      if(recoverChilds) {result = await ${tableCollection.childTable.modelName}().select(getIsDeleted: true).isDeleted.equals(true).and.${tableCollection.childTableField.fieldName}.equals($childTableFieldTablePrimaryKeyName).update({'isDeleted': 0});}
      if (!result.success && recoverChilds) {return result;}''';
          }
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          //IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        default:
      }
    }
    if (retVal.contains('result =')) {
      retVal = varResult + retVal;
    }
    retVal += '''
      {return _mn${_table.modelName}.updateBatch(QueryParams(whereString: '$_getByIdWhereStr', whereArguments: [$_getByIdParameters]), {'isDeleted': 0});}''';

    return '''
    
      /// Recover ${_table.modelName}>
      
      /// <returns>BoolResult res.success=Recovered, not res.success=Can not recovered
      Future<BoolResult> recover([bool recoverChilds=true]) async {
      print('SQFENTITIY: recover ${_table.modelName} invoked (${_table.primaryKeyNames[0]}=\$${_table.primaryKeyNames[0]})');
          $retVal 
      }''';
  }

  String __saveAllMethod() {
    return _hiddenMethod == '_'
        ? ''
        : '''
  
    /// saveAll method saves the sent List<${_table.modelName}> as a bulk in one transaction 
    /// 
    /// Returns a <List<BoolResult>>
    Future<List<dynamic>> saveAll(List<${_table.modelName}> ${toPluralName(_table._modelLowerCase)}) async {
      // final results = _mn${_table.modelName}.saveAll('INSERT OR REPLACE INTO ${_table.tableName} (${_createConstructureWithId.replaceAll('this.', '')})  VALUES ($_createConstructureArgsWithId)',${toPluralName(_table._modelLowerCase)});
      // return results; removed in sqfentity_gen 1.3.0+6
      ${_table.dbModel}().batchStart();
          for(final obj in ${toPluralName(_table._modelLowerCase)})
          { await obj.save(); }
          return ${_table.dbModel}().batchCommit();
      }''';
  }

  String __upsertAllMethod() {
    return _table.primaryKeyType == PrimaryKeyType.text || _hiddenMethod == '_'
        ? ''
        : '''      /// inserts or replaces the sent List<<${_table.modelName}>> as a bulk in one transaction.
    ///    
    /// upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero
    /// 
    /// Returns a BoolCommitResult 
    Future<BoolCommitResult> ${_hiddenMethod}upsertAll(List<${_table.modelName}> ${toPluralName(_table._modelLowerCase)}) async {
      final results = await _mn${_table.modelName}.rawInsertAll(
          'INSERT OR REPLACE INTO ${_table.tableName} (${_createConstructureWithId.replaceAll('this.', '')})  VALUES ($_createConstructureArgsWithId)', ${toPluralName(_table._modelLowerCase)});
      return results;
    }''';
  }

  String __saveMethod() {
    final seq = StringBuffer();
    for (var sequencedField
        in _table.fields.where((i) => i.sequencedBy != null)) {
      seq.writeln(
          'if (${_table.primaryKeyNames[0]} != null) { ${sequencedField.fieldName} = await ${sequencedField.sequencedBy.modelName}().nextVal(); ${_hiddenMethod}save();}');
    }
    final retVal = StringBuffer();
    if (_table.primaryKeyTypes[0].startsWith('int') && _table.primaryKeyNames.length==1) {

   retVal.write('''
  
    /// Saves the (${_table.modelName}) object. If the ${_table.primaryKeyNames[0]} field is null, saves as a new record and returns new ${_table.primaryKeyNames[0]}, if ${_table.primaryKeyNames[0]} is not null then updates record
    
    /// <returns>Returns ${_table.primaryKeyNames[0]}
    Future<int> ${_hiddenMethod}save() async {
      if (${_table.primaryKeyNames[0]} == null || ${_table.primaryKeyNames[0]} == 0 ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? '|| !isSaved' : ''}) {
        ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? '' : '${_table.primaryKeyNames[0]} ='} await _mn${_table.modelName}.insert(this);
        ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? 'if (saveResult != null && saveResult.success) isSaved = true;' : ''}
        ${seq.toString()}
          }
      else {
        // ${_table.primaryKeyNames[0]}= await _upsert(); // removed in sqfentity_gen 1.3.0+6
        await _mn${_table.modelName}.update(this);
         }
        $_toOnetoOneSaveCode
      return ${_table.primaryKeyNames[0]};
    }''');
      if (_table.relationType != RelationType.ONE_TO_ONE &&
          _table.primaryKeyName.isNotEmpty &&
          _table.primaryKeyType == PrimaryKeyType.integer_auto_incremental) {
        retVal.writeln(
            '''/// saveAs ${_table.modelName}. Returns a new Primary Key value of ${_table.modelName}
    
    /// <returns>Returns a new Primary Key value of ${_table.modelName}
    Future<int> ${_hiddenMethod}saveAs() async {
      ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? 'isSaved = false;' : ''}
      ${_table.primaryKeyType == PrimaryKeyType.integer_auto_incremental ? '${_table.primaryKeyNames[0]} = null;' : ''}
      $_toOnetoOneSaveAsCode
      return ${_hiddenMethod}save();
    }''');
      }

    } else {
      retVal.write('''
  
    /// Saves the (${_table.modelName}) object. If the Primary Key (${_table.primaryKeyNames[0]}) field is null, returns Error. 
    /// 
    /// INSERTS (If not exist) OR REPLACES (If exist) data while Primary Key is not null. 
    /// 
    /// Call the saveAs() method if you do not want to save it when there is another row with the same ${_table.primaryKeyNames[0]}
    
    /// <returns>Returns BoolResult
    Future<BoolResult> ${_hiddenMethod}save() async {
      final result = BoolResult(success: false);
      try {         
        await _mn${_table.modelName}.rawInsert( 
       'INSERT ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? '\${isSaved ? \'OR REPLACE\':\'\'}' : 'OR REPLACE'} INTO ${_table.tableName} (${_createConstructureWithId.replaceAll("this.", "")})  VALUES ($_createConstructureArgsWithId)', toArgsWithIds());
        result.success=true;
        ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? 'isSaved = true;' : ''}
        
      } catch (e){
        result.errorMessage = e.toString();
      }
      $_toOnetoOneSaveCode
      saveResult = result;
      return result;
    }
  ''');
      if (_table.relationType != RelationType.ONE_TO_ONE &&
          _table.primaryKeyName.isNotEmpty &&
          _table.primaryKeyType == PrimaryKeyType.integer_auto_incremental) {
        retVal.write('''    /// saveAs ${_table.modelName}
    /// Use this method if you do not want to update existing row when conflicts another row that have the same ${_table.primaryKeyNames[0]}
    
    /// Returns a BoolResult
    Future<BoolResult> ${_hiddenMethod}saveAs() async {
      final result = BoolResult(success: false);
      try {         
        await _mn${_table.modelName}.rawInsert(
          'INSERT INTO ${_table.tableName} (${_createConstructure.replaceAll("this.", "")})  VALUES ($_createConstructureArgs)', [${_createConstructure.replaceAll("this.", "")}]);
      ${seq.toString()}              
        result.success=true;
        ${_table.primaryKeyType != PrimaryKeyType.integer_auto_incremental || _table.primaryKeyName.isEmpty ? 'isSaved = true;' : ''}
      } catch (e){
        result.errorMessage = e.toString();
      }
      $_toOnetoOneSaveAsCode
      return result;
    }
         
    ''');
      }
    }

    return retVal.toString();
  }
}

String getFuncName(TableCollectionBase tableCollection, bool ifExist,
    SqfEntityTableBase _table) {
  String funcName = _table.tableName == tableCollection.childTable.tableName
      ? toPluralName(tableCollection.childTableField.fieldName)
      : toPluralName(tableCollection.childTable.modelName);
  return funcName +=
      ifExist ? 'By${tableCollection.childTableField.fieldName}' : '';
}

String __createObjectRelationsPreLoad(SqfEntityTableBase _table) {
  final retVal = StringBuffer();
  final relations = <String>[];
  for (final field
      in _table.fields.where((f) => f is SqfEntityFieldRelationshipBase)) {
    if (field is SqfEntityFieldRelationshipBase &&
        field.relationType == RelationType.ONE_TO_MANY) {
      final modelName = field.relationshipName ?? _table.modelName;
      String funcName = modelName;
      if (relations.contains(funcName)) {
        funcName += 'By${toCamelCase(field.fieldName)}';
        if (relations.contains(funcName)) continue;
      }
      retVal.writeln(
          'if (!loadedFields.contains(\'${field.table.tableName}.pl$funcName\') && (preloadFields == null || loadParents || preloadFields.contains(\'pl$funcName\'))) {_loadedFields.add(\'${field.table.tableName}.pl$funcName\'); obj.pl$funcName = obj.pl$funcName ?? await obj.get$funcName(loadParents: loadParents, loadedFields: _loadedFields);}');
      relations.add(funcName);
    }
  }
  if (retVal.isNotEmpty) {
    return '\n      // RELATIONSHIPS PRELOAD\nif (preload || loadParents){\nloadedFields = loadedFields ?? [];\n ${retVal.toString()}\n}          // END RELATIONSHIPS PRELOAD\n';
  }
  return '';
}

String __getByIdParameters(SqfEntityTableBase _table, bool withTypes) {
  final retVal = StringBuffer()
    ..write(
        '${(withTypes ? _table.primaryKeyTypes[0] : '')} ${_table.primaryKeyNames[0]}');
  for (int i = 1; i < _table.primaryKeyNames.length; i++) {
    retVal.write(
        ', ${(withTypes ? _table.primaryKeyTypes[i] : '')} ${_table.primaryKeyNames[i]}');
  }
  return retVal.toString();
}

String __getByIdWhereStr(SqfEntityTableBase _table) {
  final retVal = StringBuffer()..write('${_table.primaryKeyNames[0]}=?');
  for (int i = 1; i < _table.primaryKeyNames.length; i++) {
    retVal.write(' AND ${_table.primaryKeyNames[i]}=?');
  }
  return retVal.toString();
}

// String __getUpdateStr(SqfEntityTableBase _table) {
//   final retVal = StringBuffer();
//   for (final field in _table.fields) {
//     if(!_table.primaryKeyNames.contains(field.fieldName)){
//     retVal.write(',${field.fieldName}=?');
//     }
//   }
//   return retVal.toString().substring(1);
// }

String __toOnetoOneCollections(SqfEntityTableBase _table) {
   if(_table.collections == null) return '';
  final retVal = StringBuffer();
  final collections = <String>[];
  for (var tableCollection in _table.collections) {
    final String funcName = tableCollection.childTableField.table.modelName;

    if (collections.contains(funcName)) continue;

    final childTableFieldTablePrimaryKeyName =
        tableCollection.childTableField.table == null
            ? _table.primaryKeyNames[0]
            : tableCollection.childTableField.table.primaryKeyNames[0];
    if (tableCollection.childTableField.relationType ==
        RelationType.ONE_TO_ONE) {
      /*  obj.property = await Property()
              .select()
              ._productProductId
              .equals(obj.productId)
              .toSingle() ??
          Property();
          obj.property._productProductId = obj.productId;
      */
      retVal.writeln(
          '''obj._${tableCollection.childTable.modelName.toLowerCase()} = await ${tableCollection.childTable.modelName}()
          .select()
          .${tableCollection.childTableField.fieldName}
          .equals(obj.$childTableFieldTablePrimaryKeyName)
          .toSingle();          
          ''');
      collections.add(funcName);
    }
  }

  return retVal.length > 0
      ? '\n//      RELATIONS OneToOne (${_table.modelName})\n${retVal.toString()}//      END RELATIONS OneToOne (${_table.modelName})\n'
      : '';
}

String __toOnetoManyCollections(SqfEntityTableBase _table) {
   if(_table.collections == null) return '';
  final retVal = StringBuffer();
  final collections = <String>[];
  for (var tableCollection in _table.collections) {
    String funcName = getFuncName(tableCollection, false, _table);

    if (collections.contains(funcName)) {
      funcName = getFuncName(tableCollection, true, _table);
      if (collections.contains(funcName)) continue;
    }
    if (tableCollection.childTableField.relationType ==
            RelationType.ONE_TO_ONE ||
        tableCollection.childTable.relationType == RelationType.MANY_TO_MANY) {
      continue;
    }
    retVal.writeln(
        'if (!loadedFields.contains(\'${_table.tableName}.pl$funcName\') && (preloadFields == null || preloadFields.contains(\'pl$funcName\'))) {_loadedFields.add(\'${_table.tableName}.pl$funcName\'); obj.pl$funcName = obj.pl$funcName ?? await obj.get$funcName().toList(preload: preload, preloadFields: preloadFields, loadParents: false, loadedFields:_loadedFields);}');

    collections.add(funcName);
  }

  return retVal.length > 0
      ? '\n      // RELATIONSHIPS PRELOAD CHILD\nif (preload) {\nloadedFields = loadedFields ?? [];\n${retVal.toString()}\n}// END RELATIONSHIPS PRELOAD CHILD\n'
      : '';
}

String __toOnetoOneSaveCode(SqfEntityTableBase _table) {
   if(_table.collections == null) return '';
  final retVal = StringBuffer();
  /*
  property
    .._productProductId = productId
    .._save();*/

  for (var tableCollection in _table.collections) {
    if (tableCollection.childTableField.relationType ==
        RelationType.ONE_TO_ONE) {
      final childTableFieldTablePrimaryKeyName =
          tableCollection.childTableField.table == null
              ? _table.primaryKeyNames[0]
              : tableCollection.childTableField.table.primaryKeyNames[0];
      final objName = tableCollection.childTable.modelName.toLowerCase();
      retVal.writeln(
          '''_$objName?.${tableCollection.childTableField.fieldName} = $childTableFieldTablePrimaryKeyName;
                        await _$objName?._save();''');
    }
  }
  return retVal.length > 0
      ? '\n// save() OneToOne relations (${_table.modelName})\n${retVal.toString()}// END save() OneToOne relations (${_table.modelName})\n'
      : '';
}

String __toOnetoOneSaveAsCode(SqfEntityTableBase _table) {
   if(_table.collections == null) return '';
  final retVal = StringBuffer();
  //     property._propertyId = null;

  for (var tableCollection in _table.collections) {
    if (tableCollection.childTableField.relationType ==
        RelationType.ONE_TO_ONE) {
      final objName = tableCollection.childTable.modelName.toLowerCase();
      retVal.writeln(
          '$objName.${tableCollection.childTable.primaryKeyNames[0]} = null;');
    }
  }
  return retVal.length > 0
      ? '\n// saveAs() OneToOne relations (${_table.modelName})\n${retVal.toString()}// END saveAs() OneToOne relations (${_table.modelName})\n'
      : '';
}

class SqfEntityObjectManagerBuilder {
  SqfEntityObjectManagerBuilder(this._table);
  SqfEntityTableBase _table;

  @override
  String toString() {
    final String toString = '''//region ${_table.modelName}Manager
class ${_table.modelName}Manager extends SqfEntityProvider {
  ${_table.modelName}Manager() : super(${_table.dbModel}(),tableName: _tableName,
  primaryKeyList: _primaryKeyList,
  whereStr : _whereStr
  );
  static String _tableName = '${_table.tableName}';
  //static String _colId = '${_table.primaryKeyNames[0]}';
  static List<String> _primaryKeyList = ['${_table.primaryKeyNames != null ? _table.primaryKeyNames.join('\',\'') : _table.primaryKeyNames[0]}'];
  static String _whereStr = '${__getByIdWhereStr(_table).toString()}';
}
//endregion ${_table.modelName}Manager''';

    return toString;
  }
}

class SqfEntitySequenceBuilder {
  SqfEntitySequenceBuilder(this.sequence, this.modelName);
  SqfEntitySequenceBase sequence;
  String modelName;
  @override
  String toString() {
    return '''
/// Region SEQUENCE ${sequence.modelName}    
class ${sequence.modelName} {
  /// Assigns a new value when it is triggered and returns the new value
  /// returns Future<int>
  Future<int> nextVal([VoidCallback Function(int o) nextval]) async {
    final val = await ${modelName}SequenceManager().sequence(Sequence${sequence.modelName}.getInstance, true);
    if (nextval != null) {
      nextval(val);
    }
    return val;
  }
  /// Get the current value
  /// returns Future<int>
  Future<int> currentVal([VoidCallback Function(int o) currentval]) async {
    final val = await ${modelName}SequenceManager().sequence(Sequence${sequence.modelName}.getInstance, false);
    if (currentval != null) {
      currentval(val);
    }
    return val;
  }
  /// Reset sequence to start value
  /// returns start value
  Future<int> reset([VoidCallback Function(int o) currentval]) async {
    final val = await ${modelName}SequenceManager().sequence(Sequence${sequence.modelName}.getInstance, false, reset: true);
    if (currentval != null) {
      currentval(val);
    }
    return val;
  }
}
/// End Region SEQUENCE ${sequence.modelName}
''';
  }
}

class SqfEntityObjectField {
  SqfEntityObjectField(this._table);
  SqfEntityTableBase _table;
  @override
  String toString() {
    final String toString = '''// region ${_table.modelName}Field
class ${_table.modelName}Field extends SearchCriteria {
  ${_table.modelName}Field(this.${_table._modelLowerCase}FB) {
    param = DbParameter();
  }
  DbParameter param;
  String _waitingNot = '';
  ${_table.modelName}FilterBuilder ${_table._modelLowerCase}FB;
  
  ${_table.modelName}Field get not {
    _waitingNot = ' NOT ';
    return this;
  }

  ${_table.modelName}FilterBuilder equals(dynamic pValue) {
    param.expression = '=';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.EQuals,
            ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.NotEQuals,
            ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }
  ${_table.modelName}FilterBuilder equalsOrNull(dynamic pValue) {
    param.expression = '=';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.EQualsOrNull,
            ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.NotEQualsOrNull,
            ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder isNull() {
    ${_table._modelLowerCase}FB._addedBlocks = setCriteria(
        0,
        ${_table._modelLowerCase}FB.parameters,
        param,
        SqlSyntax.IsNULL.replaceAll(SqlSyntax.notKeyword, _waitingNot),
        ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder contains(dynamic pValue) {
     if(pValue != null){${_table._modelLowerCase}FB._addedBlocks = setCriteria(
        '%\${pValue.toString()}%',
        ${_table._modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.notKeyword, _waitingNot),
        ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;}
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder startsWith(dynamic pValue) {
     if(pValue != null){${_table._modelLowerCase}FB._addedBlocks = setCriteria(
        '\${pValue.toString()}%',
        ${_table._modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.notKeyword, _waitingNot),
        ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;}
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder endsWith(dynamic pValue) {
     if(pValue != null){${_table._modelLowerCase}FB._addedBlocks = setCriteria(
        '%\${pValue.toString()}',
        ${_table._modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.notKeyword, _waitingNot),
        ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;}
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder between(dynamic pFirst, dynamic pLast) {
    if (pFirst != null && pLast != null) {
      ${_table._modelLowerCase}FB._addedBlocks = setCriteria(
          pFirst,
          ${_table._modelLowerCase}FB.parameters,
          param,
          SqlSyntax.Between.replaceAll(SqlSyntax.notKeyword, _waitingNot),
          ${_table._modelLowerCase}FB._addedBlocks,
          pLast);
    } else if (pFirst != null) {
      if (_waitingNot != '') {
        ${_table._modelLowerCase}FB._addedBlocks = setCriteria(pFirst, ${_table._modelLowerCase}FB.parameters,
            param, SqlSyntax.LessThan, ${_table._modelLowerCase}FB._addedBlocks); }
      else {
        ${_table._modelLowerCase}FB._addedBlocks = setCriteria(pFirst, ${_table._modelLowerCase}FB.parameters,
            param, SqlSyntax.GreaterThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks); }
    } else if (pLast != null) {
      if (_waitingNot != '') {
        ${_table._modelLowerCase}FB._addedBlocks = setCriteria(pLast, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table._modelLowerCase}FB._addedBlocks);}
      else {
        ${_table._modelLowerCase}FB._addedBlocks = setCriteria(pLast, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks); }
    }
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder greaterThan(dynamic pValue) {
    param.expression = '>';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder lessThan(dynamic pValue) {
    param.expression = '<';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.LessThan,
            ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder greaterThanOrEquals(dynamic pValue) {
    param.expression = '>=';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param, SqlSyntax.LessThan,
            ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder lessThanOrEquals(dynamic pValue) {
    param.expression = '<=';
    ${_table._modelLowerCase}FB._addedBlocks = _waitingNot == ''
        ? setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table._modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table._modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder inValues(dynamic pValue) {
    ${_table._modelLowerCase}FB._addedBlocks = setCriteria(
        pValue,
        ${_table._modelLowerCase}FB.parameters,
        param,
        SqlSyntax.IN.replaceAll(SqlSyntax.notKeyword, _waitingNot),
        ${_table._modelLowerCase}FB._addedBlocks);
    _waitingNot = '';
    ${_table._modelLowerCase}FB._addedBlocks.needEndBlock[${_table._modelLowerCase}FB._blockIndex] =
        ${_table._modelLowerCase}FB._addedBlocks.retVal;
    return ${_table._modelLowerCase}FB;
  }
}
// endregion ${_table.modelName}Field
''';
    return toString;
  }
}

class SqfEntityObjectFilterBuilder {
  SqfEntityObjectFilterBuilder(SqfEntityTableBase table) {
    _table = table;
  }
  SqfEntityTableBase _table;
  String get _createObjectFieldProperty => __createObjectFieldProperty();
  String get _recoverMethodList => __recoverMethodList();
  String get _deleteMethodList => __deleteMethodList();
  String get _toOnetoOneCollections => __toOnetoOneCollections(_table);
  String get _toOnetoManyCollections => __toOnetoManyCollections(_table);
  String get _createObjectRelationsPreLoad =>
      __createObjectRelationsPreLoad(_table);
  @override
  String toString() {
    final String toString = '''
       // region ${_table.modelName}FilterBuilder
class ${_table.modelName}FilterBuilder extends SearchCriteria {
  ${_table.modelName}FilterBuilder(${_table.modelName} obj) {
    whereString = '';
    qparams = QueryParams();
    parameters = <DbParameter>[];
    orderByList = <String>[];
    groupByList = <String>[];
    _addedBlocks = AddedBlocks(<bool>[], <bool>[]);
    _addedBlocks.needEndBlock.add(false);
    _addedBlocks.waitingStartBlock.add(false);
    _pagesize = 0;
    _page = 0;
    _obj = obj;
  }
  AddedBlocks _addedBlocks;
  int _blockIndex = 0;
  List<DbParameter> parameters;
  List<String> orderByList;
  ${_table.modelName} _obj;
  QueryParams qparams;
  int _pagesize;
  int _page;


  /// put the sql keyword 'AND'
  ${_table.modelName}FilterBuilder get and {
    if (parameters.isNotEmpty)
      {parameters[parameters.length - 1].wOperator = ' AND ';}
    return this;
  }

  /// put the sql keyword 'OR'
  ${_table.modelName}FilterBuilder get or {
    if (parameters.isNotEmpty)
      {parameters[parameters.length - 1].wOperator = ' OR ';}
    return this;
  }

  /// open parentheses
  ${_table.modelName}FilterBuilder get startBlock {
    _addedBlocks.waitingStartBlock.add(true);
    _addedBlocks.needEndBlock.add(false);
    _blockIndex++;
    if (_blockIndex > 1) _addedBlocks.needEndBlock[_blockIndex - 1] = true;
    return this;
  }

  /// String whereCriteria, write raw query without 'where' keyword. Like this: 'field1 like 'test%' and field2 = 3'
  ${_table.modelName}FilterBuilder where(String whereCriteria, {dynamic parameterValue}) {
    if (whereCriteria != null && whereCriteria != '') {
      final DbParameter param = DbParameter(columnName: parameterValue == null ? null : '');
      _addedBlocks = setCriteria(
          parameterValue ?? 0, parameters, param, '(\$whereCriteria)', _addedBlocks);
      _addedBlocks.needEndBlock[_blockIndex] = _addedBlocks.retVal;
    }
    return this;
  }

  /// page = page number,
  /// 
  /// pagesize = row(s) per page
  ${_table.modelName}FilterBuilder page(int page, int pagesize) {
    if (page > 0) _page = page;
    if (pagesize > 0) _pagesize = pagesize;
    return this;
  }

  /// int count = LIMIT
  ${_table.modelName}FilterBuilder top(int count) {
    if (count > 0) {
      _pagesize = count;
    }
    return this;
  }

  /// close parentheses
  ${_table.modelName}FilterBuilder get endBlock {
    if (_addedBlocks.needEndBlock[_blockIndex]) {
      parameters[parameters.length - 1].whereString += ' ) ';
    }
    _addedBlocks.needEndBlock.removeAt(_blockIndex);
    _addedBlocks.waitingStartBlock.removeAt(_blockIndex);
    _blockIndex--;
    return this;
  }

  /// argFields might be String or List<String>.
  /// 
  /// Example 1: argFields='name, date' 
  /// 
  /// Example 2: argFields = ['name', 'date']
  ${_table.modelName}FilterBuilder orderBy(dynamic argFields) {
    if (argFields != null) {
      if (argFields is String) {
        orderByList.add(argFields); }
      else {
        for (String s in argFields as List<String>) {
          if (s != null && s != '') orderByList.add(' \$s ');
        } }
    }
    return this;
  }

  /// argFields might be String or List<String>.
  /// 
  /// Example 1: argFields='field1, field2' 
  /// 
  /// Example 2: argFields = ['field1', 'field2']
  ${_table.modelName}FilterBuilder orderByDesc(dynamic argFields) {
    if (argFields != null) {
      if (argFields is String) {
        orderByList.add('\$argFields desc '); }
      else {
        for (String s in argFields as List<String>) {
          if (s != null && s != '') orderByList.add(' \$s desc ');
        } }
    }
    return this;
  }

  /// argFields might be String or List<String>.
  /// 
  /// Example 1: argFields='field1, field2' 
  /// 
  /// Example 2: argFields = ['field1', 'field2']
  ${_table.modelName}FilterBuilder groupBy(dynamic argFields) {
    if (argFields != null) {
      if (argFields is String) {
        groupByList.add(' \$argFields '); }
      else {
        for (String s in argFields as List<String>) {
          if (s != null && s != '') groupByList.add(' \$s ');
        } }
    }
    return this;
  }

  ${_table.modelName}Field setField(${_table.modelName}Field field, String colName, DbType dbtype) {
    return ${_table.modelName}Field(this)
    ..param = DbParameter(
        dbType: dbtype,
        columnName: colName,
        wStartBlock: _addedBlocks.waitingStartBlock[_blockIndex]);
  }

  $_createObjectFieldProperty

  bool _getIsDeleted;

  void _buildParameters() {
     if (_page > 0 && _pagesize > 0) {
      qparams
      ..limit = _pagesize
      ..offset = (_page - 1) * _pagesize;
    } else {
      qparams
      ..limit = _pagesize
      ..offset = _page;
    }
    for (DbParameter param in parameters) {
      if (param.columnName != null) {
        if (param.value is List) {
          param.value = param.value
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .toString();
          whereString += param.whereString
              .replaceAll('{field}', param.columnName)
              .replaceAll('?', param.value.toString());
          param.value = null;
        } else {
          whereString +=
              param.whereString.replaceAll('{field}', param.columnName); }
        if (!param.whereString.contains('?')) {} else 
        {
          switch (param.dbType) {
            case DbType.bool:
              param.value = param.value == null ? null : param.value == true ? 1 : 0;
              param.value2 = param.value2 == null ? null : param.value2 == true ? 1 : 0;
              break;
              case DbType.date:
              case DbType.datetime:
              case DbType.datetimeUtc:
              param.value = param.value == null ? null :  (param.value as DateTime).millisecondsSinceEpoch ;
              param.value2 = param.value2 == null ? null :  (param.value2 as DateTime).millisecondsSinceEpoch ;
              break;
            default:
          }
        if (param.value != null) {whereArguments.add(param.value);}
        if (param.value2 != null) {whereArguments.add(param.value2);}
        }
      } else {
        whereString += param.whereString;
        }
    }
    if (${_table.modelName}._softDeleteActivated) {
      if (whereString != '') {
        whereString = '\${!_getIsDeleted ? 'ifnull(isDeleted,0)=0 AND' : ''} (\$whereString)';}
      else if (!_getIsDeleted) {whereString = 'ifnull(isDeleted,0)=0';}
    }

    if (whereString != '') {qparams.whereString = whereString;}
        qparams
    ..whereArguments = whereArguments
    ..groupBy = groupByList.join(',')
    ..orderBy = orderByList.join(',');
  }

  

/// Deletes List<${_table.modelName}> bulk by query 
/// 
/// <returns>BoolResult res.success=Deleted, not res.success=Can not deleted
Future<BoolResult> delete([bool hardDelete=false]) async {
  _buildParameters();
  var r= BoolResult();
  $_deleteMethodList
    if(${_table.modelName}._softDeleteActivated && !hardDelete) {
      r = await _obj._mn${_table.modelName}.updateBatch(qparams,{'isDeleted':1}); }
  else {
      r = await _obj._mn${_table.modelName}.delete(qparams); }
  return r;    
}
  $_recoverMethodList

  /// using:
  /// 
  /// update({'fieldName': Value})
  /// 
  /// fieldName must be String. Value is dynamic, it can be any of the (int, bool, String.. )
  Future<BoolResult> update(Map<String, dynamic> values) {
    _buildParameters();
    if (qparams.limit > 0 || qparams.offset > 0) {
      qparams.whereString = '${_table.primaryKeyNames[0]} IN (SELECT ${_table.primaryKeyNames[0]} from ${_table.tableName} \${qparams.whereString.isNotEmpty ? 'WHERE \${qparams.whereString}': ''}\${qparams.limit>0 ? ' LIMIT \${qparams.limit}':''}\${qparams.offset>0 ? ' OFFSET \${qparams.offset}':''})';
    }
     return _obj._mn${_table.modelName}.updateBatch(qparams, values);
  }

  /// This method always returns ${_table.modelName} Obj if exist, otherwise returns null 
  /// 
  ${commentPreload.replaceAll('methodname', 'toSingle')}
  /// 
  /// <returns>List<${_table.modelName}>
  Future<${_table.modelName}> toSingle({bool preload=false, List<String> preloadFields, bool loadParents=false, List<String> loadedFields}) async{
    _pagesize = 1;
    _buildParameters();
    final objFuture = _obj._mn${_table.modelName}.toList(qparams);
    final data = await objFuture;
    ${_table.modelName} obj;
    if (data.isNotEmpty) { obj = ${_table.modelName}.fromMap(data[0] as Map<String, dynamic>);
    final List<String> _loadedFields = loadedFields ?? [];
    $_toOnetoOneCollections
    $_toOnetoManyCollections
    $_createObjectRelationsPreLoad
     } else {obj = null;}
    return obj;
  }
  

  /// This method returns int.
  /// 
  /// <returns>int
  Future<int> toCount([VoidCallback Function(int c) ${_table._modelLowerCase}Count]) async {
    _buildParameters();
    qparams.selectColumns = ['COUNT(1) AS CNT'];   
    final ${toPluralLowerName(_table._modelLowerCase)}Future = await _obj._mn${_table.modelName}.toList(qparams);
    final int count = ${toPluralLowerName(_table._modelLowerCase)}Future[0]['CNT'] as int;
    if(${_table._modelLowerCase}Count != null) {${_table._modelLowerCase}Count (count);}
    return count;
  }
  
  /// This method returns List<${_table.modelName}>. 
  /// 
  ${commentPreload.replaceAll('methodname', 'toList')}
  /// 
  /// <returns>List<${_table.modelName}>
  Future<List<${_table.modelName}>> toList({bool preload=false, List<String> preloadFields, bool loadParents=false, List<String> loadedFields}) async {
    final data = await toMapList();
    final List<${_table.modelName}> ${toPluralLowerName(_table._modelLowerCase)}Data = await ${_table.modelName}.fromMapList(data,preload: preload, preloadFields: preloadFields, loadParents: loadParents, loadedFields:loadedFields);
    return ${toPluralLowerName(_table._modelLowerCase)}Data;
  }

  /// This method returns Json String
  Future<String> toJson() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(o.toMap(forJson: true));
    }
    return json.encode(list);
  }

  /// This method returns Json String.
  Future<String> toJsonWithChilds() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(await o.toMapWithChildren(false,true));
    }
    return json.encode(list);
  }

  /// This method returns List<dynamic>.
  /// 
  /// <returns>List<dynamic>
  Future<List<dynamic>> toMapList() async {
    _buildParameters();
    return await _obj._mn${_table.modelName}.toList(qparams);
  } 

  /// Returns List<DropdownMenuItem<${_table.modelName}>>
  Future<List<DropdownMenuItem<${_table.modelName}>>> toDropDownMenu(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<${_table.modelName}>> o) dropDownMenu]) async {
    _buildParameters();
    final ${toPluralLowerName(_table._modelLowerCase)}Future = _obj._mn${_table.modelName}.toList(qparams);

    final data = await ${toPluralLowerName(_table._modelLowerCase)}Future;
    final int count = data.length;
    final List<DropdownMenuItem<${_table.modelName}>> items = []
    ..add(DropdownMenuItem(
      value: ${_table.modelName}(),
      child: Text('Select ${_table.modelName}'),
    ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: ${_table.modelName}.fromMap(data[i] as Map<String, dynamic>),
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// Returns List<DropdownMenuItem<${_table.primaryKeyTypes[0]}>>
  Future<List<DropdownMenuItem<${_table.primaryKeyTypes[0]}>>> toDropDownMenuInt(
      String displayTextColumn,
	  [VoidCallback Function(List<DropdownMenuItem<${_table.primaryKeyTypes[0]}>> o) dropDownMenu]) async {
    _buildParameters();
    qparams.selectColumns=['${_table.primaryKeyNames[0]}',displayTextColumn];
    final ${toPluralLowerName(_table._modelLowerCase)}Future = _obj._mn${_table.modelName}.toList(qparams);

    final data = await ${toPluralLowerName(_table._modelLowerCase)}Future;
    final int count = data.length;
    final List<DropdownMenuItem<${_table.primaryKeyTypes[0]}>> items = []
    ..add(DropdownMenuItem(
      value: ${_table.primaryKeyTypes[0] == 'int' ? '0' : '\'0\''},
      child: Text('Select ${_table.modelName}'),
    ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: data[i]['${_table.primaryKeyNames[0]}']${_table.primaryKeyTypes[0] == 'int' ? ' as int' : '.toString()'},
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }


/// This method returns Primary Key List<${_table.primaryKeyTypes[0]}>. 
/// <returns>List<${_table.primaryKeyTypes[0]}>
Future<List<${_table.primaryKeyTypes[0]}>> toListPrimaryKey([bool buildParameters=true]) async {
  if(buildParameters) _buildParameters();
  final List<${_table.primaryKeyTypes[0]}> ${_table.primaryKeyNames[0]}Data = <${_table.primaryKeyTypes[0]}>[];
  qparams.selectColumns= ['${_table.primaryKeyNames[0]}'];
  final ${_table.primaryKeyNames[0]}Future = await _obj._mn${_table.modelName}.toList(qparams);


    final int count = ${_table.primaryKeyNames[0]}Future.length;
    for (int i = 0; i < count; i++) {
      ${_table.primaryKeyNames[0]}Data.add(${_table.primaryKeyNames[0]}Future[i]['${_table.primaryKeyNames[0]}'] as ${_table.primaryKeyTypes[0]});
    }
    return ${_table.primaryKeyNames[0]}Data;

}


/// Returns List<dynamic> for selected columns. Use this method for 'groupBy' with min,max,avg.. 
/// 
/// Sample usage: (see EXAMPLE 4.2 at https://github.com/hhtokpinar/sqfEntity#group-by)  
Future<List<dynamic>> toListObject() async {
  _buildParameters();

  final objectFuture = _obj._mn${_table.modelName}.toList(qparams);

  final List<dynamic> objectsData = <dynamic>[];
  final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i]);
    }
    return objectsData;
}

/// Returns List<String> for selected first column
/// 
/// Sample usage: await ${_table.modelName}.select(columnsToSelect: ['columnName']).toListString()
Future<List<String>> toListString([VoidCallback Function(List<String> o) listString]) async {
  _buildParameters();

  final objectFuture = _obj._mn${_table.modelName}.toList(qparams);

  final List<String> objectsData = <String>[];
  final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i][qparams.selectColumns[0]].toString());
    }
    if (listString != null) {listString(objectsData);}
    return objectsData;

}
}
// endregion ${_table.modelName}FilterBuilder
  
       ''';

    return toString;
  }

  String __createObjectFieldProperty() {
    final retVal = StringBuffer();
    if (_table.primaryKeyName.isNotEmpty &&
        !_table.primaryKeyName.startsWith('_')) {
      retVal.writeln('''${_table.modelName}Field _${_table.primaryKeyNames[0]};
${_table.modelName}Field get ${_table.primaryKeyNames[0]} {
return _${_table.primaryKeyNames[0]} = setField(_${_table.primaryKeyNames[0]}, '${_table.primaryKeyNames[0]}', ${DbType.integer.toString()});
}''');
    }
    for (SqfEntityFieldType field in _table.fields) {
      if (field is SqfEntityFieldVirtualBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.MANY_TO_MANY &&
              _table.relationType != RelationType.MANY_TO_MANY)) continue;
      retVal.writeln('''${_table.modelName}Field _${field.fieldName};
${_table.modelName}Field get ${field.fieldName} {
return _${field.fieldName} = setField(_${field.fieldName}, '${field.fieldName}', ${field.dbType});
}''');
    }
    if (_table.useSoftDeleting != null && _table.useSoftDeleting) {
      retVal.writeln('''${_table.modelName}Field _isDeleted;
${_table.modelName}Field get isDeleted {
return _isDeleted = setField(_isDeleted, 'isDeleted', DbType.bool);
}''');
    }

    return retVal.toString();
  }

  String __recoverMethodList() {
     if(_table.collections == null) return '';
    if (_table.useSoftDeleting == null || !_table.useSoftDeleting) {
      return '';
    }
    String retVal = '';

    for (var tableCollection in _table.collections) {
      final idList =
          '${tocamelCase(tableCollection.childTable.tableName)}By${tableCollection.childTableField.fieldName}idList'
              .replaceAll('_', '');
      switch (tableCollection.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RELATE CHILD ROWS TO PREVIOUS PARENT ROW
          break;
        case DeleteRule.CASCADE:
          if (tableCollection.childTable.useSoftDeleting) {
            retVal += '''
      final $idList = await toListPrimaryKey(false);
      await ${tableCollection.childTable.modelName}().select(getIsDeleted: true).isDeleted.equals(true).and.${tableCollection.childTableField.fieldName}.inValues($idList).update({'isDeleted': 0}); 
    ''';
          }
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          // IN THIS CASE YOU CAN NOT RELATE CHILD ROWS TO PREVIOUS PARENT ROW
          break;
        default:
      }
    }

    retVal += '''
            return _obj._mn${_table.modelName}.updateBatch(qparams,{'isDeleted':0});
      ''';

    return '''
  Future<BoolResult> recover() async {
  _getIsDeleted = true;
  _buildParameters();
  print('SQFENTITIY: recover ${_table.modelName} bulk invoked');
  $retVal 
  }''';
  }

  String __deleteMethodList() {
     if(_table.collections == null) return '';
    String retVal = '';
    //Track().select().PlaylistPlaylistId.inValues
    for (var tableCollection in _table.collections) {
      // if (tableCollection.childTable._hasManyToMany == true) {
      if (tableCollection.childTableField.relationType ==
          RelationType.MANY_TO_MANY) {
        continue;
      }
      final idList =
          '${tocamelCase(tableCollection.childTable.tableName)}By${tableCollection.childTableField.fieldName}idList'
              .replaceAll('_', '');
      switch (tableCollection.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        case DeleteRule.NO_ACTION:
          retVal += '''
    final $idList = await toListPrimaryKey(false);
    if (await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.inValues($idList).toCount()>0) {
    return BoolResult(
    success: false,
    errorMessage: 
          'SQFENTITY ERROR: The DELETE statement conflicted with the REFERENCE RELATIONSHIP (${tableCollection.childTable.modelName}.${tableCollection.childTableField.fieldName})');
    }''';

          break;
        case DeleteRule.CASCADE:
          if (tableCollection.childTable.useSoftDeleting) {
            retVal += '''
    final $idList = await toListPrimaryKey(false);
    await ${tableCollection.childTable.modelName}().select().${tableCollection.childTableField.fieldName}.inValues($idList).delete(hardDelete);
           ''';
          }
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          //IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        default:
      }
    }

    return retVal;
  }
}

// END SQFENTITY BUILDERS

// BEGIN ENUMS, CLASSES AND ABSTRACTS
class TableCollectionBase {
  TableCollectionBase(this.childTable, this.childTableField,
      {this.relationType});
  SqfEntityTableBase childTable;
  SqfEntityFieldRelationshipBase childTableField;
  RelationType relationType;
}

class TableField {
  TableField([this.fieldName, this.fieldType]);
  String fieldName;
  DbType fieldType;

  //start SQL Aggregate Functions
  String max([String alias]) {
    return 'MAX($fieldName) AS ${(alias ?? fieldName)}';
  }

  String min([String alias]) {
    return 'MIN($fieldName) AS ${(alias ?? fieldName)}';
  }

  String sum([String alias]) {
    return 'SUM($fieldName) AS ${(alias ?? fieldName)}';
  }

  String avg([String alias]) {
    return 'AVG($fieldName) AS ${(alias ?? fieldName)}';
  }

  String count([String alias]) {
    return 'COUNT($fieldName) AS ${(alias ?? fieldName)}';
  }

  //end  SQL Aggregate Functions

  // start SQL Scalar Functions

  String lTrim([String alias]) {
    return 'LTRIM($fieldName) AS ${(alias ?? fieldName)}';
  }

  String trim([String alias]) {
    return 'RTRIM(LTRIM($fieldName)) AS ${(alias ?? fieldName)}';
  }

  String rTrim([String alias]) {
    return 'RTRIM($fieldName) AS ${(alias ?? fieldName)}';
  }

  String len([String alias]) {
    return 'LEN($fieldName) AS ${(alias ?? fieldName)}';
  }

  // end SQL Scalar Functions

  String isNull(String val, [String alias]) {
    return "ifnull($fieldName,'$val') AS ${(alias ?? fieldName)}";
  }

  @override
  String toString([String alias]) {
    return '$fieldName${alias != null ? ' AS $alias' : ''}';
  }
}

class SqlSyntax {
  static TableField setField(TableField field, String fName, [DbType fType]) {
    if (field == null) {
      field = TableField()..fieldName = fName;
      if (fType != null) {
        field.fieldType = fType;
      }
    }
    return field;
  }

  static const String notKeyword = '{isNot}';
// SQLITE keywords
// 'and','as','between','in','isnull','not','notnull','null','or'
  static const String EQuals = ' {field}=? ';
  static const String EQualsOrNull = ' ({field}=? OR {field} IS NULL) ';
  static const String IsNULL = ' {field} IS $notKeyword NULL '; // *
  static const String NotEQuals = ' {field}<>? ';
  static const String NotEQualsOrNull = ' ({field}<>? OR {field} IS NULL) ';
  static const String Contains = ' {field} $notKeyword LIKE ? '; // *
  static const String Between = ' {field} $notKeyword BETWEEN ? AND ? '; // *
  static const String GreaterThan = ' {field}>? ';
  static const String LessThan = ' {field}<? ';
  static const String GreaterOrEqualsThan = ' {field}>=? ';
  static const String LessOrEqualsThan = ' {field}<=? ';
  static const String GreaterThanOrEquals = ' {field}>=? ';
  static const String LessThanOrEquals = ' {field}<=? ';
  static const String IN = ' {field} $notKeyword IN (?) '; // *
}

class QueryParams {
  QueryParams(
      {this.selectColumns,
      this.whereString,
      this.whereArguments,
      this.orderBy,
      this.groupBy,
      this.having,
      this.distinct,
      this.limit,
      this.offset});
  List<String> selectColumns;
  String whereString;
  List<dynamic> whereArguments;
  String orderBy;
  int limit;
  int offset;
  String groupBy;
  String having;
  bool distinct;
}

abstract class SearchCriteria {
  BoolResult result;
  List<String> groupByList = <String>[];
  List<dynamic> whereArguments = <dynamic>[];
  String whereString = '';

  AddedBlocks setCriteria(dynamic pValue, List<DbParameter> parameters,
      DbParameter param, String sqlSyntax, AddedBlocks addedBlocks,
      [dynamic pValue2]) {
    bool sp = addedBlocks.needEndBlock[addedBlocks.needEndBlock.length - 1];
    if (pValue != null) {
      param.whereString += parameters.isNotEmpty
          ? parameters[parameters.length - 1].wOperator
          : '';

      for (int i = 1; i < addedBlocks.waitingStartBlock.length; i++) {
        if (addedBlocks.waitingStartBlock[i]) {
          param.whereString += ' ( ';
          addedBlocks.waitingStartBlock[i] = false;
          sp = true;
        }
      }

      param.value = pValue;
      if (pValue2 != null) {
        param.value2 = pValue2;
      }
      param.whereString += sqlSyntax;
      parameters.add(param);
    }
    addedBlocks.retVal = sp;

    return addedBlocks;
  }
}

class AddedBlocks {
  AddedBlocks([this.needEndBlock, this.waitingStartBlock, this.retVal = false]);
  bool retVal;
  List<bool> needEndBlock;
  List<bool> waitingStartBlock;
}

class BoolResult {
  BoolResult({this.success, this.successMessage, this.errorMessage});
  String successMessage;
  String errorMessage;
  bool success = false;

  @override
  String toString() {
    if (success) {
      return successMessage != null && successMessage != ''
          ? successMessage
          : 'Result: OK! Successful';
    } else {
      return errorMessage != null && errorMessage != ''
          ? errorMessage
          : 'Result: ERROR!';
    }
  }
}

class BoolCommitResult {
  BoolCommitResult(
      {this.success,
      this.successMessage,
      this.errorMessage,
      this.commitResult});
  String successMessage;
  String errorMessage;
  List<dynamic> commitResult;
  bool success = false;

  @override
  String toString() {
    if (success) {
      return successMessage != null && successMessage != ''
          ? successMessage
          : 'Result: OK! Successful';
    } else {
      return errorMessage != null && errorMessage != ''
          ? errorMessage
          : 'Result: ERROR!';
    }
  }
}

class DbParameter {
  DbParameter(
      {this.columnName,
      this.dbType,
      this.expression = '',
      this.value,
      this.value2,
      this.whereString = '',
      this.wOperator = '',
      this.wStartBlock = false});
  String columnName;
  DbType dbType;
  dynamic value;
  dynamic value2;
  String whereString;
  bool wStartBlock;
  String wOperator;
  String expression;
}

class SqfEntityTableBase {
  String tableName;
  String primaryKeyName;
  List<SqfEntityFieldType> fields;
  List<TableCollectionBase> collections;
  bool useSoftDeleting = false;
  PrimaryKeyType primaryKeyType = PrimaryKeyType.integer_auto_incremental;
  String modelName;
  String dbModel;
  String customCode;
  List<String> primaryKeyNames = <String>[];
  List<String> primaryKeyTypes = <String>[];
  String defaultJsonUrl;
  bool initialized;
  String formListTitleField;
  String formListSubTitleField;
  RelationType relationType;
  void init() {
    print('init() -> modelname: $modelName, tableName:$tableName');

    modelName = toModelName(modelName, tableName);
    primaryKeyType = primaryKeyType ?? PrimaryKeyType.integer_auto_incremental;
    useSoftDeleting = useSoftDeleting ?? false;
    initialized = false;
    if (primaryKeyName != null && primaryKeyName.isNotEmpty) {
      if (!primaryKeyNames.contains(primaryKeyName)) {
        primaryKeyNames.add(primaryKeyName);
        primaryKeyTypes
            .add(primaryKeyType == PrimaryKeyType.text ? 'String' : 'int');
      }
    }
    for (final field in fields) {
      field
        ..table = field.table ?? this
        ..formIsRequired = field.formIsRequired ?? false;

      if (field is SqfEntityFieldRelationshipBase) {
        field
          ..relationshipName = field.relationshipName ?? modelName
          ..formDropDownTextField =
              field.formDropDownTextField ?? getformListTitleField(field.table)
          ..dbType = field.table == null
              ? primaryKeyType != PrimaryKeyType.text
                  ? DbType.integer
                  : DbType.text
              : field.table.primaryKeyType != PrimaryKeyType.text
                  ? DbType.integer
                  : DbType.text
          ..deleteRule = field.deleteRule ?? DeleteRule.NO_ACTION
          ..relationType = field.relationType ?? RelationType.ONE_TO_MANY;
        if (field.relationType != RelationType.MANY_TO_MANY) {
          relationType = relationType ?? field.relationType;
        }
        if (field.relationType == RelationType.ONE_TO_ONE) {
          primaryKeyName = primaryKeyName != null && primaryKeyName.isNotEmpty
              ? '_$primaryKeyName'
              : '';
          if (primaryKeyName.isEmpty && field.isPrimaryKeyField)
          {
            primaryKeyType = field.table.primaryKeyType;
          }    
          field.fieldName =
              field.fieldName == null || field.fieldName.startsWith('_')
                  ? field.fieldName
                  : '_${field.fieldName}';
        }
      }
      if (field.isPrimaryKeyField != null && field.isPrimaryKeyField) {
        if (!primaryKeyNames.contains(field.fieldName)) {
          primaryKeyNames.add(field.fieldName);
          primaryKeyTypes.add(dartType[field.dbType.index].toString());
        }
      }
      if (field.dbType == DbType.date ||
          field.dbType == DbType.datetime ||
          field.dbType == DbType.datetimeUtc) {
        field.minValue = field.minValue ?? '1900-01-01';
      }
    }
   // print(    '>>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntityTableBase of [$tableName](${primaryKeyNames.join(',')}) init() successfully');
  }

  String get _modelLowerCase => modelName.toLowerCase();

  String get createTableSQL => _createTableSQL();
  String _createTableSQL() {
    final _createTableSQL = StringBuffer('');

    if (primaryKeyName.isNotEmpty) {
      switch (primaryKeyType) {
        case PrimaryKeyType.integer_unique:
          _createTableSQL.write('int UNIQUE');
          break;
        case PrimaryKeyType.text:
          _createTableSQL.write('text UNIQUE');
          break;
        default:
          _createTableSQL.write('integer primary key');
      }
    }
    for (SqfEntityFieldType field in fields) {
      if (field is! SqfEntityFieldVirtualBase) {
        _createTableSQL.write(', ${field.toSqLiteFieldString()}');
      }
    }

    if (useSoftDeleting) {
      _createTableSQL.write(', isDeleted numeric');
    }

    final List<String> primaryKeys = <String>[];

    for (SqfEntityFieldType field in fields) {
      if (field.isPrimaryKeyField != null && field.isPrimaryKeyField) {
        primaryKeys.add(field.fieldName);
      }
      if (field is SqfEntityFieldRelationshipBase) {
        // FOREIGN KEY(column_name) REFERENCES parent_table_name(reference_to) ON DELETE CASCADE
        _createTableSQL.write(
            ', FOREIGN KEY(${field.fieldName}) REFERENCES ${field.table.tableName}(${field.table.primaryKeyNames[0]}) ON DELETE ${field.deleteRule.toString().replaceAll('_', ' ').replaceAll('DeleteRule.', '')}');
      }
    }
    String createTableSQL = _createTableSQL.toString();
    if (primaryKeys.isNotEmpty) {
      if (primaryKeyName.isNotEmpty) {
        primaryKeys.add(primaryKeyName);
      }
      createTableSQL = createTableSQL.replaceAll('primary key', '');
      createTableSQL += (', PRIMARY KEY (${primaryKeys.join(',')})');
    }
    if (primaryKeyName == null || primaryKeyName.isEmpty) {
      createTableSQL = createTableSQL.substring(1);
    }
    return 'Create table $tableName ($primaryKeyName $createTableSQL)';
  }
}

class SqfEntitySequenceBase {
  /// Name of the sequence.
  String sequenceName;

  /// starting value from where the sequence starts. startWith value should be greater than or equal
  /// to minimum value and less than equal to maximum value.
  int startWith = 0;

  ///Value by which sequence will increment itself. Increment_value can be positive or negative.
  int incrementBy = 1;

  /// Minimum value of the sequence.
  int minValue = 0;

  /// Maximum value of the sequence.
  int maxValue = 9007199254740991;

  /// cycle if true then, When sequence reaches its max value it starts from beginning. otherwise An exception will be thrown if sequence exceeds its max_value.
  bool cycle = false;

  String modelName;

  bool initialized = false;
  SqfEntitySequenceBase init() {
    startWith = startWith ?? 0;
    incrementBy = incrementBy ?? 1;
    minValue = minValue ?? 0;
    maxValue = maxValue ?? 9007199254740991;
    cycle = cycle ?? false;
    if (minValue >= maxValue) {
      throw Exception(
          'SQFENTITIY: SEQUENCE ($sequenceName) INITIALIZE ERROR! The maxValue must be greater than minValue');
    } else if (!(minValue <= startWith && startWith < maxValue)) {
      throw Exception(
          'SQFENTITIY: SEQUENCE ($sequenceName) INITIALIZE ERROR! The startWith value must between minValue and maxValue');
    }

    modelName = modelName ??
        '${sequenceName.substring(0, 1).toUpperCase() + sequenceName.substring(1).toLowerCase()}Sequence';

    // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntitySequenceBase of [$sequenceName] initialized successfully');
    return this;
  }
}

abstract class SqfEntityFieldType {
  SqfEntityFieldType(
    this.fieldName,
    this.dbType, {
    this.defaultValue,
    this.minValue,
    this.maxValue,
    this.table,
    this.sequencedBy,
    this.formIsRequired,
  });
  String fieldName;
  DbType dbType;
  dynamic defaultValue;
  dynamic minValue;
  dynamic maxValue;
  SqfEntityTableBase table;
  SqfEntitySequenceBase sequencedBy;
  bool formIsRequired;
  bool isPrimaryKeyField;
  String toSqLiteFieldString();

  String toPropertiesString();

  String toConstructureString();

  String toMapString();

  String toFromMapString();
}

class SqfEntityFieldBase implements SqfEntityFieldType {
  @override
  SqfEntityFieldBase(this.fieldName, this.dbType,
      {this.defaultValue,
      this.minValue,
      this.maxValue,
      this.table,
      this.sequencedBy,
      this.formIsRequired,
      this.isPrimaryKeyField});
  @override
  String fieldName;
  @override
  DbType dbType;
  // @override
  String _dbType;
  @override
  dynamic defaultValue;
  @override
  dynamic maxValue;
  @override
  dynamic minValue;
  @override
  SqfEntityTableBase table;
  @override
  SqfEntitySequenceBase sequencedBy;
  @override
  bool formIsRequired;

  @override
  String toSqLiteFieldString() {
    switch (dbType) {
      case DbType.bool:
        _dbType = 'numeric';
        break;
      default:
        _dbType = dbType.toString().replaceAll('DbType.', '');
    }
    return '$fieldName $_dbType';
  }

  @override
  String toPropertiesString() {
    return '${dartType[dbType.index]} $fieldName;';
  }

  @override
  String toConstructureString() {
    return 'this.$fieldName';
  }

  @override
  String toMapString() {
    switch (dbType) {
      case DbType.bool:
        return 'if ($fieldName != null) {map[\'$fieldName\'] =  forQuery? ($fieldName ? 1 : 0) : $fieldName;}\n';
        break;
      case DbType.date:
        return 'if ($fieldName != null) {map[\'$fieldName\'] = forJson ? \'\$$fieldName.year-\$$fieldName.month-\$$fieldName.day\' : forQuery? DateTime($fieldName.year,$fieldName.month, $fieldName.day).millisecondsSinceEpoch : $fieldName;}\n';
      case DbType.datetime:
        return 'if ($fieldName != null) {map[\'$fieldName\'] = forJson ? $fieldName.toString(): forQuery? $fieldName.millisecondsSinceEpoch : $fieldName;}\n';
      case DbType.datetimeUtc:
        return 'if ($fieldName != null) {map[\'$fieldName\'] = forJson ? $fieldName.toUtc().toString(): forQuery? $fieldName.millisecondsSinceEpoch : $fieldName;}\n';
      default:
        {
          return 'if ($fieldName != null) {map[\'$fieldName\'] = $fieldName;}\n';
        }
    }
  }

  @override
  String toFromMapString() {
    switch (dbType) {
      case DbType.bool:
        //if(o['isActive'] != null) isActive =          o['isActive'] == 1 || o['isActive'] == true;
        return 'if (o[\'$fieldName\'] != null) $fieldName = o[\'$fieldName\'] == 1 || o[\'$fieldName\'] == true;';

      case DbType.date:
      case DbType.datetime:
        return 'if (o[\'$fieldName\'] != null) $fieldName = int.tryParse(o[\'$fieldName\'].toString()) != null ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(o[\'$fieldName\'].toString())) : DateTime.tryParse(o[\'$fieldName\'].toString());';
      case DbType.datetimeUtc:
        return 'if (o[\'$fieldName\'] != null) $fieldName = int.tryParse(o[\'$fieldName\'].toString()) != null ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(o[\'$fieldName\'].toString()), isUtc: true) : DateTime.tryParse(o[\'$fieldName\'].toString());';
      case DbType.real:
        return 'if(o[\'$fieldName\'] != null) $fieldName = double.tryParse(o[\'$fieldName\'].toString());';
      case DbType.integer:
      case DbType.numeric:
        return 'if(o[\'$fieldName\'] != null) $fieldName = int.tryParse(o[\'$fieldName\'].toString());';
      default:
        return 'if(o[\'$fieldName\'] != null) $fieldName = o[\'$fieldName\'] as ${dartType[dbType.index].toString()};';
    }
  }

  @override
  bool isPrimaryKeyField;
}

class SqfEntityFieldVirtualBase implements SqfEntityFieldType {
  SqfEntityFieldVirtualBase(this.fieldName, this.dbType);

  @override
  DbType dbType;

  @override
  dynamic defaultValue;

  @override
  String fieldName;

  @override
  bool formIsRequired;

  @override
  dynamic maxValue;

  @override
  dynamic minValue;

  @override
  SqfEntitySequenceBase sequencedBy;

  @override
  SqfEntityTableBase table;

  @override
  String toConstructureString() {
    return '';
  }

  @override
  String toFromMapString() {
    return '';
  }

  @override
  String toMapString() {
    return '';
  }

  @override
  String toPropertiesString() {
    return '${dartType[dbType.index]} $fieldName;';
  }

  @override
  String toSqLiteFieldString() {
    return '';
  }

  @override
  bool isPrimaryKeyField;
}

class SqfEntityFieldRelationshipBase implements SqfEntityFieldType {
  SqfEntityFieldRelationshipBase(this.table, this.deleteRule,
      {this.fieldName,
      this.defaultValue,
      this.isPrimaryKeyField,
      this.minValue,
      this.maxValue,
      this.formDropDownTextField,
      this.formIsRequired,
      this.relationshipName,
      this.relationType,
      this.manyToManyTableName}) {
    init();
  }
  void init() {
    if (table != null) {
      relationshipName = table.modelName;
      dbType = table.primaryKeyType == PrimaryKeyType.text
          ? DbType.text
          : DbType.integer;
      table.relationType =
          relationType == RelationType.ONE_TO_MANY ? relationType : null;
      fieldName = fieldName ??
          table.tableName +
              table.primaryKeyNames[0].substring(0, 1).toUpperCase() +
              table.primaryKeyNames[0].substring(1);
      relationshipFields = <String>[]..add(fieldName);
      // print('0- relationshipFields added $fieldName on ${table.tableName}');
      for (int i = 1; i < table.primaryKeyNames.length; i++) {
        relationshipFields.add(table.tableName +
            table.primaryKeyNames[0].substring(0, 1).toUpperCase() +
            table.primaryKeyNames[0].substring(1));
        //      print('$i- relationshipFields added ${relationshipFields.last} on ${table.tableName}');
      }
    } else {
      if (fieldName != null && fieldName.isNotEmpty)
        relationshipFields = <String>[]..add(fieldName);
      print(
          'SqfEntityFieldRelationshipBase constructor: table = null: fieldName=$fieldName');
    }
  }

  @override
  String fieldName;
  String relationshipName;
  String formDropDownTextField;
  @override
  DbType dbType;
  //@override
  String _dbType;
  @override
  dynamic defaultValue;
  @override
  dynamic maxValue;
  @override
  dynamic minValue;
  @override
  SqfEntityTableBase table;
  @override
  SqfEntitySequenceBase sequencedBy;
  @override
  bool formIsRequired;
  List<String> relationshipFields;
  String manyToManyTableName;
  DeleteRule deleteRule = DeleteRule.NO_ACTION;
  RelationType relationType;
  @override
  bool isPrimaryKeyField;
  @override
  String toSqLiteFieldString() {
    //_dbType = 'integer';
    _dbType = dbType.toString().replaceAll('DbType.', '');
    return '$fieldName $_dbType';
  }

  @override
  String toPropertiesString() {
    //return 'int $fieldName';
    return '${dartType[dbType.index]} $fieldName;';
  }

  @override
  String toConstructureString() {
    return 'this.$fieldName';
  }

  @override
  String toMapString() {
    switch (dbType) {
      case DbType.bool:
        return 'if ($fieldName != null) {map[\'$fieldName\'] = forQuery? ($fieldName ? 1 : 0) : $fieldName;}\n';
      default:
        return 'if ($fieldName != null) {map[\'$fieldName\'] = $fieldName;}\n';
    }
  }

  @override
  String toFromMapString() {
    try {
      switch (dbType) {
        case DbType.bool:
          return '$fieldName = o[\'$fieldName\'] != null ? o[\'$fieldName\'] == 1 : null;\n';
        default:
          {
            if (dartType[dbType.index].toString() == 'int')
              return '$fieldName = int.tryParse(o[\'$fieldName\'].toString());\n';
            else
              return '$fieldName = o[\'$fieldName\'] as ${dartType[dbType.index].toString()};\n';
          }
      }
    } catch (e) {
      print('ERROR when calling toFromMapString: dbType=${dbType.toString()}');
      throw Exception(
          'ERROR when calling toFromMapString: fieldName:$fieldName dbType=${dbType.toString()}');
    }
  }
}

abstract class SqfEntityModelBase {
  String modelName;
  String databaseName;
  String bundledDatabasePath;
  String instanceName;
  String password;
  List<SqfEntityTableBase> databaseTables;
  List<SqfEntityTableBase> formTables;
  List<SqfEntitySequenceBase> sequences;
  void init() {
    final manyToManyTables = <SqfEntityTableBase>[];
    print('ModelBase init() begin');
    for (final table in databaseTables) {
      if (table.dbModel == null) {
        if (instanceName == null) {
          table.dbModel = toCamelCase(table.tableName);
        } else {
          table.dbModel = toCamelCase(instanceName);
        }
      }
      //print('CHECK AND CONFIGURE MANY_TO_MANY RELATIONS');
      // CHECK AND CONFIGURE MANY_TO_MANY RELATIONS
      for (final field
          in table.fields.where((f) => f is SqfEntityFieldRelationshipBase)) {
        if (field is SqfEntityFieldRelationshipBase &&
            field.relationType == RelationType.MANY_TO_MANY) {
          print('found RelationShip ManyToMany');
          final manyToManyTable = field.manyToManyTableName ??
              '${table.tableName}${toCamelCase(field.table.tableName)}';
          table.relationType = table.relationType != RelationType.ONE_TO_ONE ? null : table.relationType;
          field.table.relationType = field.table.relationType != RelationType.ONE_TO_ONE ? null : field.table.relationType;
          field.manyToManyTableName = manyToManyTable;

          if (databaseTables.length > 1) {
            if (field.table.fields
                .where((element) =>
                    element is SqfEntityFieldRelationshipBase &&
                    element.relationType == RelationType.MANY_TO_MANY &&
                    element.table == table)
                .isEmpty) {
              databaseTables
                  .singleWhere((t) => t.tableName == field.table.tableName)
                    ..fields.add(SqfEntityFieldRelationshipBase(
                        table, field.deleteRule,
                        manyToManyTableName: manyToManyTable,
                        relationType: RelationType.MANY_TO_MANY));
              field.table.init();
            }
          }
          if (databaseTables
              .where((t) =>
                  t.tableName.toLowerCase() == manyToManyTable.toLowerCase())
              .isEmpty) {
            manyToManyTables.add(SqfEntityTableBase()
              ..tableName = manyToManyTable
              ..modelName = toModelName(manyToManyTable, manyToManyTable)
              ..primaryKeyName = ''
              ..primaryKeyType = null
              ..relationType = RelationType.MANY_TO_MANY
              ..useSoftDeleting = table.useSoftDeleting
              ..fields = [
                SqfEntityFieldRelationshipBase(table, field.deleteRule,
                    fieldName: table.primaryKeyNames[0],
                    isPrimaryKeyField: true,
                    relationType: RelationType.ONE_TO_MANY),
                SqfEntityFieldRelationshipBase(field.table, field.deleteRule,
                    fieldName: field.table.primaryKeyNames[0],
                    isPrimaryKeyField: true,
                    relationType: RelationType.ONE_TO_MANY)
              ]
              
              ..init());
          }
        } else if (field is SqfEntityFieldRelationshipBase && field.relationType == RelationType.ONE_TO_ONE) {
          table.relationType = RelationType.ONE_TO_ONE;
        }
      }
      table.collections = _getCollections(table,this);
    }
    //print('before final table in manyToManyTables lenght=${manyToManyTables.length}');
    for (final table in manyToManyTables) {
      table.collections = _getCollections(table, this);
      databaseTables.add(table);
    }
  }
}

  List<TableCollectionBase> _getCollections(SqfEntityTableBase table, SqfEntityModelBase _m) {
    final collectionList = <TableCollectionBase>[];
    for (var _table in _m.databaseTables
        .where((t) => t.relationType != RelationType.MANY_TO_MANY)) {
      for (var field
          in _table.fields.where((f) => f is SqfEntityFieldRelationshipBase)) {
        if (field is SqfEntityFieldRelationshipBase) {
          if (field.table == null && _table.tableName == table.tableName) {
            collectionList.add(TableCollectionBase(table, field,
                relationType: field.relationType));
          } else if (field.table != null &&
              field.table.tableName == table.tableName) {
            collectionList.add(TableCollectionBase(_table, field,
                relationType: field.relationType));
          }
        }
      }
    }
    return collectionList;
  }
String toCamelCase(String fieldName) => fieldName != null
    ? fieldName.length == 1
        ? fieldName.toUpperCase()
        : fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1)
    : '';

String tocamelCase(String fieldName) => fieldName != null
    ? fieldName.length == 1
        ? fieldName.toLowerCase()
        : fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1)
    : '';

String toPluralName(String s) => s.endsWith('y')
    ? '${s.substring(0, s.length - 1)}ies'
    : (s.endsWith('s') || s.endsWith('o ')) ? '${s}es' : '${s}s';

String toPluralLowerName(String s) => s.endsWith('y')
    ? '${s.substring(0, s.length - 1).toLowerCase()}ies'
    : (s.endsWith('s') || s.endsWith('o '))
        ? '${s.toLowerCase()}es'
        : '${s.toLowerCase()}s';

String toSingularName(String s) => s.endsWith('ies')
    ? '${s.substring(0, s.length - 3)}y'
    : s.endsWith('ses') || s.endsWith('oes')
        ? '${s.substring(0, s.length - 2)}'
        : s.endsWith('s') ? s.substring(0, s.length - 1) : s;

String toSingularLowerName(String s) => s.endsWith('ies')
    ? '${s.substring(0, s.length - 3).toLowerCase()}y'
    : s.endsWith('ses') || s.endsWith('oes')
        ? '${s.substring(0, s.length - 2).toLowerCase()}'
        : s.endsWith('s')
            ? s.substring(0, s.length - 1).toLowerCase()
            : s.toLowerCase();

String toModelName(String modelName, String definedName) => modelName == null
    ? toCamelCase(toSingularName(definedName))
    : toCamelCase(modelName);

const String commentPreload =
    '''/// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
    /// 
    /// ex: methodname(preload:true) -> Loads all related objects
    /// 
    /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true") 
    /// 
    /// ex: methodname(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
    /// 
    /// bool loadParents: if true, loads all parent objects until the object has no parent
''';

/*
SQFLITE NOTES:
Supported SQLite types
No validity check is done on values yet so please avoid non supported types https://www.sqlite.org/datatype3.html

DateTime is not a supported SQLite type. Personally I store them as int (millisSinceEpoch) or string (iso8601)

bool is not a supported SQLite type. Use INTEGER and 0 and 1 values.

Each value stored in an SQLite database (or manipulated by the database engine) has one of the following storage classes:

-- NULL    -> The value is a NULL value.
-- INTEGER -> The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
-- REAL    -> The value is a floating point value, stored as an 8-byte IEEE floating point number.
-- TEXT    -> The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
-- BLOB    -> The value is a blob of data, stored exactly as it was input.


SQLite KEYWORDS

'add','all','alter','and','as','autoincrement',
'between','case','check','collate','commit','constraint','create',
'default','deferrable','delete','distinct','drop',
'else','escape','except','exists',
'foreign','from','group','having',
'if','in','index','insert','intersect','into','is','isnull',
'join','limit','not','notnull','null','on','or','order',
'primary','references','select','set',
'table','then','to','transaction',
'union','unique','update','using',
'values','when','where'

*/

// List<String> dartType: each element of the list corresponds to the DbType enum index
const List<String> dartType = [
  'int',
  'String',
  'Uint8List',
  'double',
  'int',
  'bool',
  'DateTime',
  'DateTime',
  'String',
  'DateTime',
];
const List<String> sqLiteType = [
  'integer',
  'text',
  'blob',
  'real',
  'numeric',
  'numeric',
  'datetime',
  'date',
  'text',
  'datetimeutc',
];
enum DeleteRule { CASCADE, SET_DEFAULT_VALUE, SET_NULL, NO_ACTION }
enum RelationType { ONE_TO_ONE, ONE_TO_MANY, MANY_TO_MANY }
enum PrimaryKeyType { integer_auto_incremental, text, integer_unique }
//enum DefaultValues { date_now, datetime_now }
enum DbType {
  integer,
// ------------------------------------------------------
// INT                             |
// INTEGER                         |
// TINYINT                         |
// SMALLINT                        |
// MEDIUMINT                       |
// BIGINT                          |        INTEGER
// UNSIGNED BIG INT                |
// INT2                            |
// INT8	                           |
// -----------------------------------------------------
  text,
// -----------------------------------------------------
// CHARACTER(20)                   |
// VARCHAR(255)                    |
// VARYING CHARACTER(255)          |
// NCHAR(55)                       |
// NATIVE CHARACTER(70)            |        TEXT
// NVARCHAR(100)                   |
// TEXT                            |
// CLOB                            |
// ------------------------------------------------------
  blob,
// ------------------------------------------------------
// BLOB                            |        BLOB
// ------------------------------------------------------
  real,
// ------------------------------------------------------
// REAL                            |
// DOUBLE                          |
// DOUBLE PRECISION                |        REAL
// FLOAT	                         |
// ------------------------------------------------------
  numeric,
// ------------------------------------------------------
// NUMERIC                         |
// DECIMAL(10,5)                   |
// BOOLEAN                         |       NUMERIC
// DATE                            |
// DATETIME	                       |
// -------------------------------------------------------
  bool,
  // bool is not a supported SQLite type. Builder converts this type to numeric values (false=0, true=1)
  datetime,
  date,
  unknown,
  datetimeUtc
}

DbType parseDbType(String val) {
  if (val.isEmpty) {
    return DbType.unknown;
  }
  val = val.toLowerCase();
  if (val.contains('char') || val.contains('clob')) {
    val = 'text';
  } else if (val.contains('int')) {
    val = 'integer';
  } else if (val.contains('double') ||
      val.contains('float') ||
      val.contains('numeric(')) {
    val = 'real';
  } else if (val.contains('decimal')) {
    val = 'numeric';
  } else if (val.startsWith('bool')) {
    val = 'bool';
  } else if (val.contains('(')) {
    val = val.substring(0, val.indexOf('('));
  }

  for (var o in DbType.values) {
    if (sqLiteType[o.index].toLowerCase() == val ||
        dartType[o.index].toLowerCase() == val) {
      return o;
    }
  }
  return DbType.unknown;
}
// END ENUMS, CLASSES AND ABSTRACTS
