/*******************************LICENSE********************************

Copyright (C) 2019, HUSEYIN TOKPUNAR http://huseyintokpinar.com/

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


**********************************************************************/
import 'package:flutter/material.dart';
import 'package:sqfentity/db/MyDbModel.dart';
import 'package:sqfentity/db/SqfEntityBase.dart';
import 'package:flutter/services.dart';


class SqfEntityDbContext {
  
  // create Model String and set the Clipboard (After debugging, press Ctrl+V to paste the model from the Clipboard)
  // to call this method use SqfEntityDbModel.createSqfEntityModel
  static String createModel(List<SqfEntityTable> tables) {
    String modelString =
        "import 'package:flutter/material.dart';\nimport 'package:sqfentity/db/sqfEntityBase.dart';";

    for (var table in tables) {
      if (table.modelName == null)
        table.modelName = table.tableName.substring(0, 1).toUpperCase() +
            table.tableName.substring(1).toLowerCase();
      modelString += SqfEntityObjectBuilder(table).toString() + "\n";
      modelString += SqfEntityObjectField(table).toString() + "\n";
      modelString += SqfEntityObjectFilterBuilder(table).toString() + "\n";
      modelString += SqfEntityFieldBuilder(table).toString() + "\n";
      modelString += SqfEntityObjectManagerBuilder(table).toString() + "\n";
    }
    Clipboard.setData(ClipboardData(text: modelString)).then((_) {
      print(
          "SQFENTITIY: ${tables.toString()} Model was successfully created. Create models.dart file in your project and press Ctrl+V to paste the model from the Clipboard");
    });
    return modelString;
  }

  initializeDB(VoidCallback isReady(bool result)) {
    var dbTables = MyDbModel.databaseTables.where((i) => !i.initialized).toList();
    if (dbTables.length == 0)
      isReady(true);
    else {
      //List<String> updateQueryList = new List<String>();
      for (SqfEntityTable table in dbTables) {
        // check exiting table fields in the database
        var tableFields = SqfEntityProvider()
            .execDataTable("PRAGMA table_info(${table.tableName})");
        tableFields.then((data) {
          List<TableField> exitingDBfields = new List<TableField>();
          if (data != null && data.length > 0) {
            String primaryKeyName = data[0]["name"].toString();
            if (table.primaryKeyName != primaryKeyName) {
              throw Exception(
                  "SQFENTITIY: DATABASE INITIALIZE ERROR The primary key name for table named '${table.tableName}' must be '$primaryKeyName'");
            }
            for (int i = 1; i < data.length; i++) {
              exitingDBfields.add(TableField(data[i]["name"].toString(),
                  parseDbType(data[i]["type"].toString())));
            }
            // create SQL Command for new columns
            List<String> alterTableQuery =
                checkTableColumns(table, exitingDBfields);

            if (alterTableQuery.length > 0) {
              print("SQFENTITIY: alterTableQuery => $alterTableQuery");
              table.initialized = true;
              SqfEntityProvider().execSQLList(alterTableQuery, (result) {
                if (result) {
                  print(
                      "SQFENTITIY: Table named '${table.tableName}' was initialized successfuly (Added new columns)");
                  if (checkForIsReadyDatabase(dbTables)) isReady(true);
                }
              });
            } else {
              table.initialized = true;
              print(
                  "SQFENTITIY: Table named '${table.tableName}' was initialized successfuly (No added new columns)");
              if (checkForIsReadyDatabase(dbTables)) isReady(true);
            }
            //initializeDB(dbTables, (callBack) {});
          } else {
            // The table if not exist
            table.initialized = true;
            SqfEntityProvider().execSQL(table.createTableSQL).then((_) {
              print(
                  "SQFENTITIY: Table named '${table.tableName}' was initialized successfuly with create new table'");
              if (checkForIsReadyDatabase(dbTables)) isReady(true);
            });
          }
        });
      }
    }
  }

  bool checkForIsReadyDatabase(List<SqfEntityTable> dbTables) {
    if (dbTables.where((i) => !i.initialized).length == 0) {
      print("SQFENTITIY: The database is ready for use");
      return true;
    } else
      return false;
  }

  List<String> checkTableColumns(
      SqfEntityTable table, List<TableField> exitingDBfields) {
    var alterTableQuery = List<String>();
    for (var newField in table.fields) {
      var eField =
          exitingDBfields.where((x) => x.fieldName == newField.fieldName);
      if (eField.length > 0) {
        if (newField.dbType == DbType.bool) newField.dbType = DbType.numeric;
        if (eField.toList()[0].fieldType != newField.dbType) {
          throw Exception(
              "SQFENTITIY DATABASE INITIALIZE ERROR: The type of column '${newField.fieldName}(${newField.dbType.toString()})' does not match the exiting column '${eField.toList()[0].fieldName}(${eField.toList()[0].fieldType.toString()})'");
        }
      } else {
        alterTableQuery.add(
            "ALTER TABLE ${table.tableName} ADD COLUMN ${newField.toSqLiteFieldString()}");
        if (newField.defaultValue != "") {
          if (newField.dbType == DbType.text)
            newField.defaultValue = "'${newField.defaultValue}'";
          alterTableQuery.add(
              "UPDATE ${table.tableName} set ${newField.fieldName}=${newField.defaultValue}");
        }
      }
    }
    return alterTableQuery;
  }

  
}

class SqfEntityFieldBuilder {
  SqfEntityTable _table;

  SqfEntityFieldBuilder(SqfEntityTable table) {
    _table = table;
  }

  String get _createObjectField => __createObjectField();

  @override
  String toString() {
    String toString = """\n
// region ${_table.modelName}Fields
class ${_table.modelName}Fields {
$_createObjectField
}
// endregion ${_table.modelName}Fields
""";

    return toString;
  }

  __createObjectField() {
    String retVal = """
  static TableField _fId;
  static TableField get id {
    _fId = SqlSyntax.setField(_fId, "id", ${DbType.integer.toString()});
    return _fId;
  }
""";

    for (SqfEntityField field in _table.fields) {
      retVal += """
  static TableField _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)};
  static TableField get ${field.fieldName} {
    _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)} = SqlSyntax.setField(_f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)}, "${field.fieldName}", ${field.dbType.toString()});
    return _f${field.fieldName.substring(0, 1).toUpperCase() + field.fieldName.substring(1)};
  }
""";
    }
    if (_table.useSoftDeleting)
      retVal += """
  static TableField _fIsDeleted;
  static TableField get isDeleted {
    _fIsDeleted = SqlSyntax.setField(_fId, "isDeleted", ${DbType.integer.toString()});
    return _fIsDeleted;
  }
    """;

    return retVal;
  }
}

class SqfEntityObjectBuilder {
  SqfEntityTable _table;

  SqfEntityObjectBuilder(SqfEntityTable table) {
    _table = table;
  }

  String get _createProperties => __createProperties();
  String get _createConstructure => __createConstructure();
  String get _toMapString => __toMapString();
  String get _toFromMapString => __toFromMapString();
  String get _createDefaultValues => __createDefaultValues();
  @override
  String toString() {
    String toString = """\n
/*
These classes was generated by SqfEntity
To use these SqfEntity classes do following: 
- import ${_table.modelName}.dart into where to use
- start typing ${_table.modelName}().select()... (add a few filters with fluent methods)...(add orderBy/orderBydesc if you want)...
- and then just put end of filters / or end of only select()  toSingle(${_table.modelLowerCase}) / or toList(${_table.modelLowerCase}List) 
- you can select one ${_table.modelName} or List<${_table.modelName}> by your filters and orders
- also you can batch update or batch delete by using delete/update methods instead of tosingle/tolist methods
  Enjoy.. Huseyin Tokpunar
*/
// region ${_table.modelName}
class ${_table.modelName} extends SearchCriteria {
  // FIELDS
  $_createProperties// end FIELDS

  static const bool softDeleteActivated=${_table.useSoftDeleting.toString()};
  ${_table.modelName}Manager __mn${_table.modelName};
  ${_table.modelName}FilterBuilder _select;

  ${_table.modelName}Manager get _mn${_table.modelName} {
    if (__mn${_table.modelName} == null) __mn${_table.modelName} = new ${_table.modelName}Manager();
    return __mn${_table.modelName};
  }

  ${_table.modelName}({this.${_table.primaryKeyName}, $_createConstructure}) { setDefaultValues();}
  ${_table.modelName}.withFields($_createConstructure){ setDefaultValues();}
  ${_table.modelName}.withId(this.${_table.primaryKeyName}, $_createConstructure){ setDefaultValues();}

  // methods
  Map<String, dynamic> toMap({bool forQuery=false}) {
    var map = Map<String, dynamic>();
    $_toMapString
    return map;
    }

    ${_table.modelName}.fromMap(Map<String, dynamic> o) {
    $_toFromMapString
    }

    ${_table.modelName}.fromObjectExclude(dynamic o) {
    $_toFromMapString
    }
  
  Future<List<${_table.modelName}>> fromObjectList(Future<List<dynamic>> o) async {
    var ${_table.modelLowerCase}sList = new List<${_table.modelName}>();
    o.then((data) {
      for (int i = 0; i < data.length; i++) {
        ${_table.modelLowerCase}sList.add(${_table.modelName}.fromMap(data[i]));
      }
    });
    return ${_table.modelLowerCase}sList;
  }

  List<${_table.modelName}> fromMapList(List<Map<String, dynamic>> query) {
    List<${_table.modelName}> ${_table.modelLowerCase}s = List<${_table.modelName}>();
    for (Map map in query) {
      ${_table.modelLowerCase}s.add(${_table.modelName}.fromMap(map));
    }
    return ${_table.modelLowerCase}s;
  }

  /// returns ${_table.modelName} by ID if exist, otherwise returns null
  /// <param name="id">Primary Key Value</param>
  /// <returns>returns ${_table.modelName} if exist, otherwise returns null</returns>
  ${_table.modelName} getById([int id, VoidCallback callBack(${_table.modelName} o)]) {
    ${_table.modelName} ${_table.modelLowerCase};
    var ${_table.modelLowerCase}Future = _mn${_table.modelName}.getById(id);
    ${_table.modelLowerCase}Future.then((data) {
      if (data.length > 0)
        ${_table.modelLowerCase} = ${_table.modelName}.fromMap(data[0]);
      else
        ${_table.modelLowerCase} = null;
      callBack(${_table.modelLowerCase});
    });
    return ${_table.modelLowerCase};
  }

  /// <summary>
  /// Saves the object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  /// </summary>
  /// <returns>Returns id</returns>
  Future<int> save() async {
    if (${_table.primaryKeyName} == null || ${_table.primaryKeyName} == 0)
      ${_table.primaryKeyName} = await _mn${_table.modelName}.insert(
          ${_table.modelName}.withFields(${_createConstructure.replaceAll("this.", "")}));
    else
      _mn${_table.modelName}.update(
          ${_table.modelName}.withId(${_table.primaryKeyName}, ${_createConstructure.replaceAll("this.", "")}));
    return ${_table.primaryKeyName};
  }

  /// <summary>
  /// SaveAs ${_table.modelName}. Returns a new Primary Key value of ${_table.modelName}
  /// </summary>
  /// <returns>Returns a new Primary Key value of ${_table.modelName}</returns>
  Future<int> get saveAs async {
    ${_table.primaryKeyName} = await _mn${_table.modelName}.insert(
        ${_table.modelName}.withFields(${_createConstructure.replaceAll("this.", "")}));
    return ${_table.primaryKeyName};
  }

  /// <summary>
  /// Deletes ${_table.modelName}
  /// </summary>
  /// <returns>true=Deleted, false=Can not deleted</returns>
  Future<BoolResult> delete() async {
    print("SQFENTITIY: delete ${_table.modelName} called (${_table.primaryKeyName}=\$${_table.primaryKeyName})");
    if (!softDeleteActivated)
      return _mn${_table.modelName}.delete(QueryParams(whereString: "${_table.primaryKeyName}=\$${_table.primaryKeyName}"));
    else
      return _mn${_table.modelName}
          .updateBatch(QueryParams(whereString: "${_table.primaryKeyName}=\$${_table.primaryKeyName}"), {"isDeleted": 1});
  }
  //private ${_table.modelName}FilterBuilder _Select;
  ${_table.modelName}FilterBuilder select(
      {List<String> columnsToSelect, bool getIsDeleted}) {
    _select = new ${_table.modelName}FilterBuilder(this);
    _select._getIsDeleted = getIsDeleted==true;
    _select.qparams.selectColumns = columnsToSelect;
    return _select;
  }

  ${_table.modelName}FilterBuilder distinct(
      {List<String> columnsToSelect, bool getIsDeleted}) {
    ${_table.modelName}FilterBuilder _distinct = new ${_table.modelName}FilterBuilder(this);
    _distinct._getIsDeleted = getIsDeleted==true;
    _distinct.qparams.selectColumns = columnsToSelect;
    _distinct.qparams.distinct = true;
    return _distinct;
  }

  void setDefaultValues() {
    $_createDefaultValues
  }
  //end methods
}
// endregion ${_table.modelLowerCase}

    """;
    return toString;
  }

  String __createProperties() {
    String _retVal = "int ${_table.primaryKeyName};\n";
    for (SqfEntityField field in _table.fields) {
      _retVal += "  " + field.toPropertiesString() + ";\n";
    }
    if (_table.useSoftDeleting) _retVal += "  bool isDeleted;\n";

    return _retVal;
  }

  String __createConstructure() {
    String _retVal = "";
    for (SqfEntityField field in _table.fields) {
      _retVal += "," + field.toConstructureString();
    }
    if (_table.useSoftDeleting) _retVal += ",this.isDeleted\n";
    return _retVal.substring(1);
  }

  String __toMapString() {
    String _retVal =
        "if (${_table.primaryKeyName} != null) map[\"${_table.primaryKeyName}\"] = ${_table.primaryKeyName};";
    for (SqfEntityField field in _table.fields) {
      _retVal += "    " + field.toMapString();
    }
    if (_table.useSoftDeleting)
      _retVal +=
          "  if (isDeleted != null) map[\"isDeleted\"] = forQuery? (isDeleted ? 1 : 0):isDeleted;\n";
    return _retVal;
  }

  String __toFromMapString() {
    String _retVal =
        "this.${_table.primaryKeyName} = o[\"${_table.primaryKeyName}\"];\n";
    for (SqfEntityField field in _table.fields) {
      _retVal += "    " + field.toFromMapString();
    }
    if (_table.useSoftDeleting)
      _retVal +=
          "  this.isDeleted = o[\"isDeleted\"] != null ? o[\"isDeleted\"] == 1 : null;";
    return _retVal;
  }

  __createDefaultValues() {
    String _retVal = "";
    for (SqfEntityField field in _table.fields) {
      if (field.defaultValue != null) {
        switch (field.dbType) {
          case DbType.text:
            field.defaultValue =
                "\"" + field.defaultValue.replaceAll("\"", "\\\"") + "\"";
            break;
          case DbType.bool:
            field.defaultValue = field.defaultValue == "1" ? "true" : "false";
            break;
          default:
        }
        _retVal +=
            "if(${field.fieldName}==null) ${field.fieldName}=${field.defaultValue};\n";
      }
    }
    if (_table.useSoftDeleting)
      _retVal += "   if(isDeleted==null) isDeleted=false;";
    return _retVal;
  }
}

class SqfEntityObjectManagerBuilder {
  SqfEntityTable _table;

  SqfEntityObjectManagerBuilder(SqfEntityTable table) {
    _table = table;
  }

  @override
  String toString() {
    String toString = """//region ${_table.modelName}Manager
class ${_table.modelName}Manager extends SqfEntityProvider {
  static String _tableName = "${_table.tableName}";
  static String _colId = "${_table.primaryKeyName}";

  ${_table.modelName}Manager():super(tableName: _tableName, colId: _colId);
}
//endregion ${_table.modelName}Manager""";

    return toString;
  }
}

class SqfEntityObjectField {
  SqfEntityTable _table;

  SqfEntityObjectField(SqfEntityTable table) {
    _table = table;
  }
// ${_table.modelName}
//${_table.modelLowerCase} = ${_table.modelName}
  @override
  String toString() {
    String toString = """// region ${_table.modelName}Field
class ${_table.modelName}Field extends SearchCriteria {
  DbParameter param;
  String _waitingNot = "";
  ${_table.modelName}FilterBuilder ${_table.modelLowerCase}FB;
  ${_table.modelName}Field(${_table.modelName}FilterBuilder fb) {
    param = new DbParameter();
    ${_table.modelLowerCase}FB = fb;
  }

  ${_table.modelName}Field get not {
    _waitingNot = " NOT ";
    return this;
  }

  ${_table.modelName}FilterBuilder equals(var pValue) {
    param.expression = "=";
    ${_table.modelLowerCase}FB._addedBlocks = _waitingNot == ""
        ? setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param, SqlSyntax.EQuals,
            ${_table.modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param, SqlSyntax.NotEQuals,
            ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder isNull() {
    ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
        0,
        ${_table.modelLowerCase}FB.parameters,
        param,
        SqlSyntax.IsNULL.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
        ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder contains(dynamic pValue) {
    ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
        "%" + pValue + "%",
        ${_table.modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
        ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder startsWith(dynamic pValue) {
    ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
        pValue + "%",
        ${_table.modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
        ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder endsWith(dynamic pValue) {
    ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
        "%" + pValue,
        ${_table.modelLowerCase}FB.parameters,
        param,
        SqlSyntax.Contains.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
        ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder between(dynamic pFirst, dynamic pLast) {
    if (pFirst != null && pLast != null) {
      ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
          pFirst,
          ${_table.modelLowerCase}FB.parameters,
          param,
          SqlSyntax.Between.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
          ${_table.modelLowerCase}FB._addedBlocks,
          pLast);
    } else if (pFirst != null) {
      if (_waitingNot != "")
        ${_table.modelLowerCase}FB._addedBlocks = setCriteria(pFirst, ${_table.modelLowerCase}FB.parameters,
            param, SqlSyntax.LessThan, ${_table.modelLowerCase}FB._addedBlocks);
      else
        ${_table.modelLowerCase}FB._addedBlocks = setCriteria(pFirst, ${_table.modelLowerCase}FB.parameters,
            param, SqlSyntax.GreaterThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks);
    } else if (pLast != null) {
      if (_waitingNot != "")
        ${_table.modelLowerCase}FB._addedBlocks = setCriteria(pLast, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table.modelLowerCase}FB._addedBlocks);
      else
        ${_table.modelLowerCase}FB._addedBlocks = setCriteria(pLast, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks);
    }
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder greaterThan(dynamic pValue) {
    param.expression = ">";
    ${_table.modelLowerCase}FB._addedBlocks = _waitingNot == ""
        ? setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table.modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder lessThan(dynamic pValue) {
    param.expression = "<";
    ${_table.modelLowerCase}FB._addedBlocks = _waitingNot == ""
        ? setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param, SqlSyntax.LessThan,
            ${_table.modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder greaterThanOrEquals(dynamic pValue) {
    param.expression = ">=";
    ${_table.modelLowerCase}FB._addedBlocks = _waitingNot == ""
        ? setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param, SqlSyntax.LessThan,
            ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder lessThanOrEquals(dynamic pValue) {
    param.expression = "<=";
    ${_table.modelLowerCase}FB._addedBlocks = _waitingNot == ""
        ? setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.LessThanOrEquals, ${_table.modelLowerCase}FB._addedBlocks)
        : setCriteria(pValue, ${_table.modelLowerCase}FB.parameters, param,
            SqlSyntax.GreaterThan, ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }

  ${_table.modelName}FilterBuilder inValues(var pValue) {
    ${_table.modelLowerCase}FB._addedBlocks = setCriteria(
        pValue,
        ${_table.modelLowerCase}FB.parameters,
        param,
        SqlSyntax.IN.replaceAll(SqlSyntax.NOT_KEYWORD, _waitingNot),
        ${_table.modelLowerCase}FB._addedBlocks);
    _waitingNot = "";
    ${_table.modelLowerCase}FB._addedBlocks.needEndBlock[${_table.modelLowerCase}FB._blockIndex] =
        ${_table.modelLowerCase}FB._addedBlocks.retVal;
    return ${_table.modelLowerCase}FB;
  }
}
// endregion ${_table.modelName}Field
""";
    return toString;
  }
}

class SqfEntityObjectFilterBuilder {
  SqfEntityTable _table;

  SqfEntityObjectFilterBuilder(SqfEntityTable table) {
    _table = table;
  }

  String get _createObjectFieldProperty => __createObjectFieldProperty();

  @override
  String toString() {
    String toString = """
    // region ${_table.modelName}FilterBuilder
class ${_table.modelName}FilterBuilder extends SearchCriteria {
  AddedBlocks _addedBlocks;
  int _blockIndex = 0;
  List<DbParameter> parameters;
  List<String> orderByList;
  ${_table.modelName} _obj;
  QueryParams qparams;
  int _pagesize;
  int _page;
  ${_table.modelName}FilterBuilder(${_table.modelName} obj) {
    whereString = "";
    qparams = new QueryParams();
    parameters = List<DbParameter>();
    orderByList = List<String>();
    groupByList = List<String>();
    _addedBlocks = new AddedBlocks(new List<bool>(), new List<bool>());
    _addedBlocks.needEndBlock.add(false);
    _addedBlocks.waitingStartBlock.add(false);
    _pagesize = 0;
    _page = 0;
    _obj = obj;
  }

  ${_table.modelName}FilterBuilder get and {
    if (parameters.length > 0)
      parameters[parameters.length - 1].wOperator = " AND ";
    return this;
  }

  ${_table.modelName}FilterBuilder get or {
    if (parameters.length > 0)
      parameters[parameters.length - 1].wOperator = " OR ";
    return this;
  }

  ${_table.modelName}FilterBuilder get startBlock {
    _addedBlocks.waitingStartBlock.add(true);
    _addedBlocks.needEndBlock.add(false);
    _blockIndex++;
    if (_blockIndex > 1) _addedBlocks.needEndBlock[_blockIndex - 1] = true;
    return this;
  }

  ${_table.modelName}FilterBuilder where(String whereCriteria) {
    if (whereCriteria != null && whereCriteria != "") {
      DbParameter param = new DbParameter();
      _addedBlocks = setCriteria(
          0, parameters, param, "(" + whereCriteria + ")", _addedBlocks);
      _addedBlocks.needEndBlock[_blockIndex] = _addedBlocks.retVal;
    }
    return this;
  }

  ${_table.modelName}FilterBuilder page(int page, int pagesize) {
    if (page > 0) _page = page;
    if (pagesize > 0) _pagesize = pagesize;
    return this;
  }

  ${_table.modelName}FilterBuilder top(int count) {
    if (count > 0) {
      _pagesize = count;
    }
    return this;
  }

  ${_table.modelName}FilterBuilder get endBlock {
    if (_addedBlocks.needEndBlock[_blockIndex]) {
      parameters[parameters.length - 1].whereString += " ) ";
    }
    _addedBlocks.needEndBlock.removeAt(_blockIndex);
    _addedBlocks.waitingStartBlock.removeAt(_blockIndex);
    _blockIndex--;
    return this;
  }

  ${_table.modelName}FilterBuilder orderBy(var argFields) {
    if (argFields != null) {
      if (argFields is String)
        this.orderByList.add(argFields);
      else
        for (String s in argFields) {
          if (s != null && s != "") this.orderByList.add(" \$s ");
        }
    }
    return this;
  }

  ${_table.modelName}FilterBuilder orderByDesc(var argFields) {
    if (argFields != null) {
      if (argFields is String)
        this.orderByList.add("\$argFields desc ");
      else
        for (String s in argFields) {
          if (s != null && s != "") this.orderByList.add(" \$s desc ");
        }
    }
    return this;
  }

  ${_table.modelName}FilterBuilder groupBy(var argFields) {
    if (argFields != null) {
      if (argFields is String)
        this.groupByList.add(" \$argFields ");
      else
        for (String s in argFields) {
          if (s != null && s != "") this.groupByList.add(" \$s ");
        }
    }
    return this;
  }

  ${_table.modelName}Field setField(${_table.modelName}Field field, String colName, DbType dbtype) {
    field = new ${_table.modelName}Field(this);
    field.param = new DbParameter(
        dbType: dbtype,
        columnName: colName,
        wStartBlock: _addedBlocks.waitingStartBlock[_blockIndex]);
    return field;
  }

  $_createObjectFieldProperty

  bool _getIsDeleted;

  void _buildParameters() {
    if (_page > 0 && _pagesize > 0) {
      qparams.limit = _pagesize;
      qparams.offset = (_page - 1) * _pagesize;
    } else {
      qparams.limit = _pagesize;
      qparams.offset = _page;
    }
    for (DbParameter param in parameters) {
      if (param.columnName != null) {
        if (param.value is List) {
          param.value = param.value
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .toString();
          whereString += param.whereString
              .replaceAll("{field}", param.columnName)
              .replaceAll("?", param.value);
          param.value = null;
        } else
          whereString +=
              param.whereString.replaceAll("{field}", param.columnName);
        switch (param.dbType) {
          case DbType.bool:
            if (param.value != null) param.value = param.value ? 1 : 0;
            break;
          default:
        }

        if (param.value != null) whereArguments.add(param.value);
        if (param.value2 != null) whereArguments.add(param.value2);
      } else
        whereString += param.whereString;
    }
    if (${_table.modelName}.softDeleteActivated) {
      if (whereString != "")
        whereString = (!_getIsDeleted ? "ifnull(isDeleted,0)=0 AND" : "") +
            " (\$whereString)";
      else if (!_getIsDeleted) whereString = "ifnull(isDeleted,0)=0";
    }

    if (whereString != "") qparams.whereString = whereString;
    qparams.whereArguments = whereArguments;
    qparams.groupBy = groupByList.join(',');
    qparams.orderBy = orderByList.join(',');
  }


  Future<BoolResult> delete() {
    _buildParameters();
      if(${_table.modelName}.softDeleteActivated)
       return _obj._mn${_table.modelName}.updateBatch(qparams,{"isDeleted":1});
    else
       return _obj._mn${_table.modelName}.delete(qparams);
  }


  Future<BoolResult> update(Map<String, dynamic> values) {
    _buildParameters();
    return _obj._mn${_table.modelName}.updateBatch(qparams, values);
  }

/// This method always returns ${_table.modelName}Obj if exist, otherwise returns null 
  /// <returns>List<${_table.modelName}></returns>
  void toSingle(VoidCallback ${_table.modelLowerCase}(${_table.modelName} o)) {
    _pagesize = 1;
    toList((List<${_table.modelName}> list) {
      if(list.length>0)
      ${_table.modelLowerCase}(list[0]);
      else
      ${_table.modelLowerCase}(null);
    });
  }

  
  /// This method always returns List<${_table.modelName}>. 
  /// <returns>List<${_table.modelName}></returns>
  void toList(VoidCallback ${_table.modelLowerCase}List (List<${_table.modelName}> o)) async {

    _buildParameters();

    var ${_table.modelLowerCase}sFuture = _obj._mn${_table.modelName}.toList(qparams);

    List<${_table.modelName}> ${_table.modelLowerCase}sData = new List<${_table.modelName}>();
    ${_table.modelLowerCase}sFuture.then((data) {
      int count = data.length;
      for (int i = 0; i < count; i++) {
        ${_table.modelLowerCase}sData.add(${_table.modelName}.fromMap(data[i]));
      }
      ${_table.modelLowerCase}List (${_table.modelLowerCase}sData);
      ${_table.modelLowerCase}sData = null;
    });

    
  }

  void toListObject(VoidCallback listObject(List<dynamic> o)) async {
    _buildParameters();

    var objectFuture = _obj._mn${_table.modelName}.toList(qparams);

    List<dynamic> objectsData = new List<dynamic>();
    objectFuture.then((data) {
      int count = data.length;
      for (int i = 0; i < count; i++) {
        objectsData.add(data[i]);
      }
      listObject(objectsData);
      objectsData = null;
    });

    
  }

}
// endregion ${_table.modelName}FilterBuilder
    
    """;

    return toString;
  }

  __createObjectFieldProperty() {
    String retVal = """
    ${_table.modelName}Field _${_table.primaryKeyName};
  ${_table.modelName}Field get ${_table.primaryKeyName} {
    _${_table.primaryKeyName} = setField(_${_table.primaryKeyName}, "${_table.primaryKeyName}", ${DbType.integer.toString()});
    return _${_table.primaryKeyName};
  }
    """;

    for (SqfEntityField field in _table.fields) {
      retVal += """
      ${_table.modelName}Field _${field.fieldName};
  ${_table.modelName}Field get ${field.fieldName} {
    _${field.fieldName} = setField(_${field.fieldName}, "${field.fieldName}", ${field.dbType});
    return _${field.fieldName};
  }
    """;
    }
    if (_table.useSoftDeleting)
      retVal += """
      ${_table.modelName}Field _isDeleted;
  ${_table.modelName}Field get isDeleted {
    _isDeleted = setField(_isDeleted, "isDeleted", DbType.bool);
    return _isDeleted;
  }
    """;

    return retVal;
  }
}

class SqfEntityTable {
  String tableName;
  String primaryKeyName;
  List<SqfEntityField> fields;
  bool useSoftDeleting;
  String modelName;
  bool initialized;
  SqfEntityTable(
      this.tableName, this.primaryKeyName, this.fields, this.useSoftDeleting,
      {this.initialized = false, this.modelName});
  String get modelLowerCase => tableName.toLowerCase();

  String get createTableSQL => _createTableSQL();
  String _createTableSQL() {
    String _createTableSQL =
        "Create table $tableName ($primaryKeyName integer primary key";
    for (SqfEntityField field in fields) {
      _createTableSQL += ", " + field.toSqLiteFieldString();
    }
    if (useSoftDeleting) _createTableSQL += ", isDeleted numeric";
    _createTableSQL += ")";
    return _createTableSQL;
  }
}

class SqfEntityField {
  String fieldName;
  DbType dbType;
  String _dbType;
  String defaultValue;
  SqfEntityField(this.fieldName, this.dbType, {this.defaultValue});
  String toSqLiteFieldString() {
    switch (dbType) {
      case DbType.bool:
        _dbType = "numeric";
        break;
      default:
        _dbType = dbType.toString().replaceAll("DbType.", "");
    }
    return "$fieldName $_dbType";
  }

  String toPropertiesString() {
    return dartType[dbType.index] + " $fieldName";
  }

  String toConstructureString() {
    return "this.$fieldName";
  }

  String toMapString() {
    switch (dbType) {
      case DbType.bool: //forQuery? (bxcol8Bool? 1 : 0):bxcol8Bool;
        return "if ($fieldName != null) map[\"$fieldName\"] = forQuery? ($fieldName ? 1 : 0) : $fieldName;\n";
        break;
      default:
        return "if ($fieldName != null) map[\"$fieldName\"] = $fieldName;\n";
    }
  }

  String toFromMapString() {
    if (dbType == DbType.bool)
      return "this.$fieldName = o[\"$fieldName\"] != null ? o[\"$fieldName\"] == 1 : null;\n";
    else
      return "this.$fieldName = o[\"$fieldName\"];\n";
  }
}
