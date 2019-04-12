/****************************   LICENSE   *****************************

Copyright (C) 2019, HUSEYIN TOKPUNAR http://huseyintokpinar.com/

Download & Update Latest Version: https://github.com/hhtokpinar/sqfEntity

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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:synchronized/synchronized.dart';

// BEGIN DATABASE PROVIDER
class SqfEntityProvider {
  static final SqfEntityProvider _sqfEntityProvider =
      SqfEntityProvider._internal();
  static SqfEntityProvider get = _sqfEntityProvider;
  String _databaseName;
  String _bundledDatabasePath;
  String _tableName = "";
  String _colId = "";
  SqfEntityProvider._internal();
  SqfEntityProvider(dynamic dbModel, {String tableName, String colId}) {
    this._tableName = tableName;
    this._colId = colId;
    this._databaseName = dbModel.databaseName;
    this._bundledDatabasePath = dbModel.bundledDatabasePath;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, _databaseName);
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset if MyDbModel.bundledDatabasePath is not empty
            if (_bundledDatabasePath != null && _bundledDatabasePath != "") {
              ByteData data = await rootBundle.load(_bundledDatabasePath);
              List<int> bytes = data.buffer
                  .asUint8List(data.offsetInBytes, data.lengthInBytes);
              await new File(path).writeAsBytes(bytes).then((_) {
                print("$_databaseName successfully copied from asset");
              });
            }
          }
          _db = await openDatabase(path, version: 1, onCreate: _createDb);
        }
      });
    }
    return _db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "Create table sqfentitytables (id integer primary key, tablename text, version int, properties text)");
    print("$_databaseName successfully created");
  }

  Future<dynamic> getById(int id) async {
    Database db = await this.db;
    var query = "Select * from $_tableName where $_colId=$id";
    var result = await db.rawQuery(query);
    return result;
  }

  Future<void> execSQL(String pSql) async {
    Database db = await this.db;
    var result = await db.execute(pSql);
    return result;
  }

  Future<void> execSQLList(
      List<String> pSql, VoidCallback callBack(bool c)) async {
    Database db = await this.db;
    var result = await db.transaction((txn) {
      for (String sql in pSql) {
        txn.execute(sql).then((_) {
          pSql.remove(sql);
          if (pSql.length == 0) callBack(true);
        });
      }
    });
    return result;
  }

  Future<List> execDataTable(String pSql) async {
    Database db = await this.db;
    var result = await db.rawQuery(pSql);
    return result;
  }

  Future<List> toList(QueryParams params) async {
    Database db = await this.db;
    var result = await db.query(_tableName,
        columns: params.selectColumns,
        where: params.whereString,
        whereArgs: params.whereArguments,
        orderBy: params.orderBy == "" ? null : params.orderBy,
        groupBy: params.groupBy == "" ? null : params.groupBy,
        limit: params.limit == 0 ? null : params.limit,
        offset: params.offset == 0 ? null : params.offset,
        distinct: params.distinct);
    print("\r\n");
    print("\r\n");

    // You can uncomment following print command for print when called db query with parameters automatically
    /*
    print("********** SqfEntityProvider.toList(QueryParams=> columns:" +
        (params.selectColumns != null ? params.selectColumns.toString() : "*") +
        ", whereString: " +
        (params.whereString != null ? params.whereString : "null") +
        ", whereArgs:" +
        (params.whereArguments != null
            ? params.whereArguments.toString()
            : "null") +
        ", orderBy:" +
        (params.orderBy != "" ? params.orderBy : "null") +
        ", groupBy:" +
        (params.groupBy != "" ? params.groupBy : "null") +
        ")");
        */
    return result;
  }

  Future<BoolResult> delete(QueryParams params) async {
    var result = new BoolResult();
    Database db = await this.db;
    try {
      var deletedItems = await db.delete(_tableName,
          where: params.whereString, whereArgs: params.whereArguments);
      result.successMessage = "$deletedItems items deleted";
      result.success = true;
    } catch (e) {
      result.errorMessage = e.toString();
    }
    return result;
  }

  Future<BoolResult> updateBatch(
      QueryParams params, Map<String, dynamic> values) async {
    var result = new BoolResult();
    Database db = await this.db;
    try {
      var updatedItems = await db.update(_tableName, values,
          where: params.whereString, whereArgs: params.whereArguments);
      result.successMessage = "$updatedItems items updated";
      result.success = true;
    } catch (e) {
      result.errorMessage = e.toString();
    }
    return result;
  }

  Future<int> update(T) async {
    Database db = await this.db;
    var o = T.toMap(forQuery: true);
    var result = await db
        .update(_tableName, o, where: "$_colId = ?", whereArgs: [o[_colId]]);
    return result;
  }

  Future<int> insert(T) async {
    Database db = await this.db;
    var result = await db.insert(_tableName, T.toMap(forQuery: true));
    return result;
  }

  Future<int> rawInsert(String pSql, List<dynamic> params) async {
    Database db = await this.db;
    var result = await db.rawInsert(pSql, params);
    return result;
  }

  Future<List<BoolResult>> rawInsertAll(
      String pSql, List<dynamic> params) async {
    var results = List<BoolResult>();
    Database db = await this.db;
    for (var t in params) {
      var result = BoolResult();
      try {
        int res = await db.rawInsert(pSql, t.toArgs());
        result.success = true;
        result.successMessage = "$_colId: $res upserted successfuly";
      } catch (e) {
        result.successMessage = null;
        result.errorMessage = e.toString();
      }

      results.add(result);
    }

    return results;
  }

  Future<List<BoolResult>> saveAll(String pSql, List T) async {
    var results = List<BoolResult>();
    Database db = await this.db;
    for (var t in T) {
      var result = BoolResult();
      try {
        var o = t.toMap(forQuery: true);
        if (o[_colId] != null && o[_colId] != 0) {
          var uresult = await db.rawInsert(pSql, t.toArgs());
          if (uresult > 0)
            result.successMessage =
                "id=" + o[_colId].toString() + " upserted successfuly";
        } else {
          var iresult = await db.insert(_tableName, o);
          if (iresult > 0)
            result.successMessage =
                "id=" + iresult.toString() + " inserted  successfuly";
        }
        result.success = true;
      } catch (e) {
        result.successMessage = null;
        result.errorMessage = e.toString();
      }
      results.add(result);
    }
    return results;
  }
}
// END DATABASE PROVIDER

// BEGIN MODEL BUILDER
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
  static TableField _f${toCamelCase(_table.primaryKeyName)};
  static TableField get ${_table.primaryKeyName.toLowerCase()} {
    _f${toCamelCase(_table.primaryKeyName)} = SqlSyntax.setField(_f${toCamelCase(_table.primaryKeyName)}, "${_table.primaryKeyName.toLowerCase()}", ${DbType.integer.toString()});
    return _f${toCamelCase(_table.primaryKeyName)};
  }
""";

    for (SqfEntityFieldType field in _table.fields) {
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
    _fIsDeleted = SqlSyntax.setField(_fIsDeleted, "isDeleted", ${DbType.integer.toString()});
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
  String get _createObjectRelations => __createObjectRelations();
  String get _createObjectCollections => __createObjectCollections();
  String get _createConstructure => __createConstructure();
  String get _createConstructureArgs => __createConstructureArgs();
  String get _toMapString => __toMapString();
  String get _toFromMapString => __toFromMapString();
  String get _fromWebUrl => __fromWebUrl();
  String get _deleteMethodSingle => __deleteMethodSingle();
  String get _recoveryMethodSingle => __recoveryMethodSingle();
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
        $_createProperties      // end FIELDS
        $_createObjectRelations
        $_createObjectCollections
        static const bool _softDeleteActivated=${_table.useSoftDeleting.toString()};
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
      
        List<dynamic> toArgs() {
          return[${_table.primaryKeyName},${_createConstructure.replaceAll("this.", "")}];   
        }  
    
        $_fromWebUrl  
        static fromWebUrl(String url, VoidCallback  ${_table.modelLowerCase}List (List<${_table.modelName}> o)) async {
        var objList = List<${_table.modelName}>();
        http.get(url).then((response) {
          Iterable list = json.decode(response.body);
          try {
            objList = list.map((${_table.modelLowerCase}) => ${_table.modelName}.fromMap(${_table.modelLowerCase})).toList();
            ${_table.modelLowerCase}List(objList);
          } catch (e) {
            print("SQFENTITY ERROR ${_table.modelName}.fromWeb: ErrorMessage:" + e.toString());
          }
        });
       }
    
        static Future<List<${_table.modelName}>> fromObjectList(Future<List<dynamic>> o) async {
          var ${_table.modelLowerCase}sList = new List<${_table.modelName}>();
          o.then((data) {
            for (int i = 0; i < data.length; i++) {
              ${_table.modelLowerCase}sList.add(${_table.modelName}.fromMap(data[i]));
            }
          });
          return ${_table.modelLowerCase}sList;
        }
      
        static List<${_table.modelName}> fromMapList(List<Map<String, dynamic>> query) {
          List<${_table.modelName}> ${_table.modelLowerCase}s = List<${_table.modelName}>();
          for (Map map in query) {
            ${_table.modelLowerCase}s.add(${_table.modelName}.fromMap(map));
          }
          return ${_table.modelLowerCase}s;
        }
      
        /// returns ${_table.modelName} by ID if exist, otherwise returns null
        /// <param name="${_table.primaryKeyName}">Primary Key Value</param>
        /// <returns>returns ${_table.modelName} if exist, otherwise returns null</returns>
        getById(int ${_table.primaryKeyName.toLowerCase()}, VoidCallback ${_table.modelLowerCase}(${_table.modelName} o)) {
          ${_table.modelName} ${_table.modelLowerCase}Obj;
          var ${_table.modelLowerCase}Future = _mn${_table.modelName}.getById(${_table.primaryKeyName.toLowerCase()});
          ${_table.modelLowerCase}Future.then((data) {
            if (data.length > 0)
              ${_table.modelLowerCase}Obj = ${_table.modelName}.fromMap(data[0]);
            else
              ${_table.modelLowerCase}Obj = null;
            ${_table.modelLowerCase}(${_table.modelLowerCase}Obj);
          });
        }
      
        /// <summary>
        /// Saves the object. If the ${_table.primaryKeyName} field is null, saves as a new record and returns new ${_table.primaryKeyName}, if ${_table.primaryKeyName} is not null then updates record
        /// </summary>
        /// <returns>Returns ${_table.primaryKeyName}</returns>
        Future<int> save() async {
          if (${_table.primaryKeyName} == null || ${_table.primaryKeyName} == 0)
            ${_table.primaryKeyName} = await _mn${_table.modelName}.insert(
                ${_table.modelName}.withFields(${_createConstructure.replaceAll("this.", "")}));
          else
            ${_table.primaryKeyName}= await _upsert();
          return ${_table.primaryKeyName};
        }
    
        /// <summary>
        /// saveAll method saves the sent List<${_table.modelName}> as a batch in one transaction 
        /// </summary>
        /// <returns> Returns a <List<BoolResult>> </returns>
        Future<List<BoolResult>> saveAll(List<${_table.modelName}> ${toPluralName(_table.modelLowerCase)}) async {
          var results = _mn${_table.modelName}.saveAll("INSERT OR REPLACE INTO ${_table.tableName} (${_table.primaryKeyName}, ${_createConstructure.replaceAll("this.", "")})  VALUES (?,$_createConstructureArgs)",${toPluralName(_table.modelLowerCase)});
          return results;
        }
    
        /// <summary>
        /// Updates if the record exists, otherwise adds a new row
        /// </summary>
        /// <returns>Returns ${_table.primaryKeyName}</returns>
        Future<int> _upsert() async {
          ${_table.primaryKeyName} = await _mn${_table.modelName}.rawInsert(
              "INSERT OR REPLACE INTO ${_table.tableName} (${_table.primaryKeyName}, ${_createConstructure.replaceAll("this.", "")})  VALUES (?,$_createConstructureArgs)", [${_table.primaryKeyName},${_createConstructure.replaceAll("this.", "")}]);
          return ${_table.primaryKeyName};
        }
    
        
        /// <summary>
        /// inserts or replaces the sent List<Todo> as a batch in one transaction.
        /// upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero
        /// </summary>
        /// <returns> Returns a <List<BoolResult>> </returns>
        Future<List<BoolResult>> upsertAll(List<${_table.modelName}> ${toPluralName(_table.modelLowerCase)}) async {
          var results = await _mn${_table.modelName}.rawInsertAll(
              "INSERT OR REPLACE INTO ${_table.tableName} (${_table.primaryKeyName}, ${_createConstructure.replaceAll("this.", "")})  VALUES (?,$_createConstructureArgs)", ${toPluralName(_table.modelLowerCase)});
          return results;
        }
    
    
        /// <summary>
        /// saveAs ${_table.modelName}. Returns a new Primary Key value of ${_table.modelName}
        /// </summary>
        /// <returns>Returns a new Primary Key value of ${_table.modelName}</returns>
        Future<int> saveAs() async {
          ${_table.primaryKeyName} = await _mn${_table.modelName}.insert(
              ${_table.modelName}.withFields(${_createConstructure.replaceAll("this.", "")}));
          return ${_table.primaryKeyName};
        }
      
    
        /// <summary>
        /// Deletes ${_table.modelName}
        /// </summary>
        /// <returns>BoolResult res.success=Deleted, not res.success=Can not deleted</returns>
        Future<BoolResult> delete() async {
          print("SQFENTITIY: delete ${_table.modelName} invoked (${_table.primaryKeyName}=\$${_table.primaryKeyName})");
          $_deleteMethodSingle
        }
          $_recoveryMethodSingle
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
    for (SqfEntityFieldType field in _table.fields) {
      _retVal += "      " + field.toPropertiesString() + ";\n";
    }
    if (_table.useSoftDeleting) _retVal += "      bool isDeleted;\n";

    return _retVal;
  }

  String __createConstructure() {
    String _retVal = "";
    for (SqfEntityFieldType field in _table.fields) {
      _retVal += "," + field.toConstructureString();
    }
    if (_table.useSoftDeleting) _retVal += ",this.isDeleted";
    return _retVal.substring(1);
  }

  String __createConstructureArgs() {
    String _retVal = "";
    for (int i = 0; i < _table.fields.length; i++) {
      _retVal += ",?";
    }
    if (_table.useSoftDeleting) _retVal += ",?";
    return _retVal.substring(1);
  }

  String __toMapString() {
    String _retVal =
        "if (${_table.primaryKeyName} != null) map[\"${_table.primaryKeyName}\"] = ${_table.primaryKeyName};";
    for (SqfEntityFieldType field in _table.fields) {
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
    for (SqfEntityFieldType field in _table.fields) {
      _retVal += "    " + field.toFromMapString();
    }
    if (_table.useSoftDeleting)
      _retVal +=
          "  this.isDeleted = o[\"isDeleted\"] != null ? o[\"isDeleted\"] == 1 : null;";
    return _retVal;
  }

  __createDefaultValues() {
    String _retVal = "";
    for (SqfEntityFieldType field in _table.fields) {
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

  __createObjectRelations() {
    String retVal = "";

    for (SqfEntityFieldType field in _table.fields) {
      if (field is SqfEntityFieldRelationship) {
        retVal += """
     get${field.relationshipName}(VoidCallback ${field.relationshipName.toLowerCase()}(${field.table.modelName} o)) {
        ${field.relationshipName}().getById(${field.fieldName}, (obj) {
          ${field.relationshipName.toLowerCase()}(obj);
        });
      }
    """;
      }
    }
    if (retVal != "")
      retVal = "\n// RELATIONSHIPS\n$retVal// END RELATIONSHIPS\n";
    return retVal;
  }

  __createObjectCollections() {
    String retVal = "";
    for (var tableCollecion in _table.collections) {
      retVal += """
       get${toPluralName(tableCollecion.childTable.modelName)}(VoidCallback ${tableCollecion.childTable.modelLowerCase}List(List<${tableCollecion.childTable.modelName}> o)) {
        ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).toList((objList) {
          ${tableCollecion.childTable.modelLowerCase}List(objList);
        });
      }
    """;
    }
    if (retVal != "") retVal = "\n// COLLECTIONS\n$retVal// END COLLECTIONS\n";
    return retVal;
  }

  __fromWebUrl() {
    if (_table.defaultJsonUrl != null && _table.defaultJsonUrl != "")
      return """
     static fromWeb(VoidCallback ${_table.modelLowerCase}List(List<${_table.modelName}> o)) async {
         fromWebUrl("https://jsonplaceholder.typicode.com/todos", (objList){
          ${_table.modelLowerCase}List (objList);
         });
      }
          """;
    else
      return "";
  }

  String __deleteMethodSingle() {
    String retVal = "";
    String varResult = "var result= BoolResult();";

    for (var tableCollecion in _table.collections) {
      switch (tableCollecion.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          retVal += """
  result = await ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).update({"${tableCollecion.childTableField.fieldName}": null});
  if (!result.success) return result;
  else""";
          break;
        case DeleteRule.NO_ACTION:
          retVal += """
  result = await ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).toCount((_){});
  if (result.success) return BoolResult(success: false,errorMessage: "SQFENTITY ERROR: The DELETE statement conflicted with the REFERENCE RELATIONSHIP '${tableCollecion.childTable.modelName}.${tableCollecion.childTableField.fieldName}'");
  else""";

          break;
        case DeleteRule.CASCADE:
          retVal += """
  result = await ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).delete();
  if (!result.success) return result;
        else
         """;
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          retVal += """
  result = await ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).update({"${tableCollecion.childTableField.fieldName}": ${tableCollecion.childTableField.defaultValue}});
  if (!result.success) return result;
  else""";
          break;
        default:
      }
    }
    if (retVal != "") retVal = varResult + retVal;
    retVal += """
  if (!_softDeleteActivated)
  return _mn${_table.modelName}.delete(QueryParams(whereString: "${_table.primaryKeyName}=\$${_table.primaryKeyName}"));
  else
  return _mn${_table.modelName}.updateBatch(QueryParams(whereString: "${_table.primaryKeyName}=\$${_table.primaryKeyName}"), {"isDeleted": 1});""";

    return retVal;
  }

  String __recoveryMethodSingle() {
    if (!_table.useSoftDeleting) return "";
    String retVal = "";
    String varResult = "var result= BoolResult();";

    for (var tableCollecion in _table.collections) {
      switch (tableCollecion.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        case DeleteRule.CASCADE:
          if (tableCollecion.childTable.useSoftDeleting)
            retVal += """
  result = await ${tableCollecion.childTable.modelName}().select(getIsDeleted: true).isDeleted.equals(true).and.${tableCollecion.childTableField.fieldName}.equals(${tableCollecion.childTableField.table.primaryKeyName}).update({"isDeleted": 0});
  if (!result.success) return result;
  else""";
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          //IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        default:
      }
    }
    if (retVal != "") retVal = varResult + retVal;
    retVal += """
  return _mn${_table.modelName}.updateBatch(QueryParams(whereString: "${_table.primaryKeyName}=\$${_table.primaryKeyName}"), {"isDeleted": 0});""";

    return """
  /// <summary>
  /// Recover Product
  /// </summary>
  /// <returns>BoolResult res.success=Recovered, not res.success=Can not recovered</returns>
  Future<BoolResult> recover() async {
  print("SQFENTITIY: recover ${_table.modelName} invoked (${_table.primaryKeyName}=\$${_table.primaryKeyName})");""" +
        retVal +
        """
  }""";
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

  ${_table.modelName}Manager():super(${_table.dbModel}(),tableName: _tableName, colId: _colId);
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
  String get _recoveryMethodList => __recoveryMethodList();
  String get _deleteMethodList => __deleteMethodList();
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
       if (${_table.modelName}._softDeleteActivated) {
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
   
     
    /// <summary>
    /// Deletes List<${_table.modelName}> batch by query 
    /// </summary>
    /// <returns>BoolResult res.success=Deleted, not res.success=Can not deleted</returns>
    Future<BoolResult> delete() async {
      _buildParameters();
      $_deleteMethodList
        if(${_table.modelName}._softDeleteActivated)
          r = await _obj._mn${_table.modelName}.updateBatch(qparams,{"isDeleted":1});
      else
          r = await _obj._mn${_table.modelName}.delete(qparams);
      return r;    
    }
     $_recoveryMethodList
    
     Future<BoolResult> update(Map<String, dynamic> values) {
       _buildParameters();
       return _obj._mn${_table.modelName}.updateBatch(qparams, values);
     }
   
     /// This method always returns ${_table.modelName}Obj if exist, otherwise returns null 
     /// <returns>List<${_table.modelName}></returns>
     void toSingle(VoidCallback ${_table.modelLowerCase}(${_table.modelName} o)) {
       _pagesize = 1;
       _buildParameters();
       var objFuture = _obj._mn${_table.modelName}.toList(qparams);
       objFuture.then((data) {
         if (data.length > 0)
           ${_table.modelLowerCase}(${_table.modelName}.fromMap(data[0]));
         else
           ${_table.modelLowerCase}(null);
       });
     }
     
   
      /// This method always returns int.
      /// <returns>int</returns>
      Future<BoolResult> toCount(VoidCallback ${_table.modelLowerCase}Count (int c)) async {
       _buildParameters();
       qparams.selectColumns = ["COUNT(1) AS CNT"];   
       var ${toPluralLowerName(_table.modelLowerCase)}Future = await _obj._mn${_table.modelName}.toList(qparams);
         int count = ${toPluralLowerName(_table.modelLowerCase)}Future[0]["CNT"];
         ${_table.modelLowerCase}Count (count);
         return BoolResult(success:count>0, successMessage: count>0? "toCount(): \$count items found":"", errorMessage: count>0?"": "toCount(): no items found");
     }
      
     /// This method always returns List<${_table.modelName}>. 
     /// <returns>List<${_table.modelName}></returns>
     void toList(VoidCallback ${_table.modelLowerCase}List (List<${_table.modelName}> o)) async {
   
       _buildParameters();
   
       var ${toPluralLowerName(_table.modelLowerCase)}Future = _obj._mn${_table.modelName}.toList(qparams);
   
       List<${_table.modelName}> ${toPluralLowerName(_table.modelLowerCase)}Data = new List<${_table.modelName}>();
       ${toPluralLowerName(_table.modelLowerCase)}Future.then((data) {
         int count = data.length;
         for (int i = 0; i < count; i++) {
           ${toPluralLowerName(_table.modelLowerCase)}Data.add(${_table.modelName}.fromMap(data[i]));
         }
         ${_table.modelLowerCase}List (${toPluralName(_table.modelLowerCase)}Data);
         ${toPluralLowerName(_table.modelLowerCase)}Data = null;
       });
     }
  
     /// This method always returns Primary Key List<int>. 
     /// <returns>List<int></returns>
     Future<List<int>> toListPrimaryKey(VoidCallback ${_table.primaryKeyName}List (List<int> o),
           [bool buildParameters=true]) async {
       if(buildParameters) _buildParameters();
       List<int> ${_table.primaryKeyName}Data = new List<int>();
       qparams.selectColumns= ["${_table.primaryKeyName}"];
       var ${_table.primaryKeyName}Future = await _obj._mn${_table.modelName}.toList(qparams);
   

         int count = ${_table.primaryKeyName}Future.length;
         for (int i = 0; i < count; i++) {
           ${_table.primaryKeyName}Data.add(${_table.primaryKeyName}Future[i]["${_table.primaryKeyName}"]);
         }
         ${_table.primaryKeyName}List (${_table.primaryKeyName}Data);
         return ${_table.primaryKeyName}Data;

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

    for (SqfEntityFieldType field in _table.fields) {
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

  String __recoveryMethodList() {
    if (!_table.useSoftDeleting) return "";
    String retVal = "";

    for (var tableCollecion in _table.collections) {
      switch (tableCollecion.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        case DeleteRule.CASCADE:
          if (tableCollecion.childTable.useSoftDeleting)
            retVal += """
      toListPrimaryKey((idList){
      ${tableCollecion.childTable.modelName}().select(getIsDeleted: true).isDeleted.equals(true).and.${tableCollecion.childTableField.fieldName}.inValues(idList).update({"isDeleted": 0});
    }, false);
    """;
          break;
        case DeleteRule.SET_DEFAULT_VALUE:
          //IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        default:
      }
    }

    retVal += """
            return _obj._mn${_table.modelName}.updateBatch(qparams,{"isDeleted":0});
      """;

    return """
  Future<BoolResult> recover() async {
  _getIsDeleted = true;
  _buildParameters();
  print("SQFENTITIY: recover ${_table.modelName} batch invoked");""" +
        retVal +
        """
  }""";
  }

  __deleteMethodList() {
    String retVal = "var r= BoolResult();";

    for (var tableCollecion in _table.collections) {
      switch (tableCollecion.childTableField.deleteRule) {
        case DeleteRule.SET_NULL:
          // IN THIS CASE YOU CAN NOT RECOVER CHILD ROWS
          break;
        case DeleteRule.NO_ACTION:
          retVal += """
    var idList = await toListPrimaryKey((_) {}, false);
    r = await ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.inValues(idList).toCount((_) {});
    if (r.success) {
    return BoolResult(
    success: false,
    errorMessage: 
          "SQFENTITY ERROR: The DELETE statement conflicted with the REFERENCE RELATIONSHIP '${tableCollecion.childTable.modelName}.${tableCollecion.childTableField.fieldName}'");
    } else
                      """;

          break;
        case DeleteRule.CASCADE:
          if (tableCollecion.childTable.useSoftDeleting)
            retVal += """
    toListPrimaryKey((idList){
    ${tableCollecion.childTable.modelName}().select().${tableCollecion.childTableField.fieldName}.inValues(idList).delete();
    }, false);
           """;
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

// END MODEL BUILDER

// BEGIN ENUMS, CLASSES AND ABSTRACTS
class TableCollection {
  SqfEntityTable childTable;
  SqfEntityFieldRelationship childTableField;
  TableCollection(this.childTable, this.childTableField);
}

class TableField {
  String fieldName;
  DbType fieldType;

  TableField([String fName, DbType fType]) {
    fieldName = fName;
    fieldType = fType;
  }

  //start SQL Aggregate Functions
  String max([String alias]) {
    return "MAX($fieldName) AS " + (alias ?? fieldName).toString();
  }

  String min([String alias]) {
    return "MIN($fieldName) AS " + (alias ?? fieldName).toString();
  }

  String sum([String alias]) {
    return "SUM($fieldName) AS " + (alias ?? fieldName).toString();
  }

  String avg([String alias]) {
    return "AVG($fieldName) AS " + (alias ?? fieldName).toString();
  }

  String count([String alias]) {
    return "COUNT($fieldName) AS " + (alias ?? fieldName).toString();
  }

  //end  SQL Aggregate Functions

  // start SQL Scalar Functions

  String lTrim([String alias]) {
    return "LTRIM($fieldName) AS " +
        ((alias ?? fieldName).toString()).toString();
  }

  String trim([String alias]) {
    return "RTRIM(LTRIM($fieldName)) AS " +
        ((alias ?? fieldName).toString()).toString();
  }

  String rTrim([String alias]) {
    return "RTRIM($fieldName) AS " + (alias ?? fieldName).toString();
  }

  String len([String alias]) {
    return "LEN($fieldName) AS " + (alias ?? fieldName).toString();
  }

  // end SQL Scalar Functions

  String isNull(String val, [String alias]) {
    return "ifnull($fieldName,'$val') AS " + (alias ?? fieldName).toString();
  }

  String toString([String alias]) {
    return "$fieldName" + (alias != null ? " AS $alias" : "");
  }
}

class SqlSyntax {
  static TableField setField(TableField field, String fName, [DbType fType]) {
    if (field == null) {
      field = new TableField();
      field.fieldName = fName;
      if (fType != null) field.fieldType = fType;
    }
    return field;
  }

  static const NOT_KEYWORD = "{isNot}";
// SQLITE keywords
// "add","all","alter","and","as","autoincrement","between","case","check","collate","commit","constraint","create","default","deferrable","delete","distinct","drop","else","escape","except","exists","foreign","from","group","having","if","in","index","insert","intersect","into","is","isnull","join","limit","not","notnull","null","on","or","order","primary","references","select","set","table","then","to","transaction","union","unique","update","using","values","when","where"
  static const String EQuals = " {field}=? ";
  static const String IsNULL = " {field} IS $NOT_KEYWORD NULL "; // *
  static const String NotEQuals = " {field}<>? ";
  static const String Contains = " {field} $NOT_KEYWORD LIKE ? "; // *
  static const String Between = " {field} $NOT_KEYWORD BETWEEN ? AND ? "; // *
  static const String GreaterThan = " {field}>? ";
  static const String LessThan = " {field}<? ";
  static const String GreaterOrEqualsThan = " {field}>=? ";
  static const String LessOrEqualsThan = " {field}<=? ";
  static const String GreaterThanOrEquals = " {field}>=? ";
  static const String LessThanOrEquals = " {field}<=? ";
  static const String IN = " {field} $NOT_KEYWORD IN (?) "; // *
}

class QueryParams {
  List<String> selectColumns;
  String whereString;
  List<dynamic> whereArguments;
  String orderBy;
  int limit;
  int offset;
  String groupBy;
  String having;
  bool distinct;
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
}

abstract class SearchCriteria {
  BoolResult result;
  List<String> groupByList = new List<String>();
  List<dynamic> whereArguments = new List<dynamic>();
  String whereString = "";

  AddedBlocks setCriteria(dynamic pValue, List<DbParameter> parameters,
      DbParameter param, String sqlSyntax, AddedBlocks addedBlocks,
      [dynamic pValue2]) {
    bool sp = addedBlocks.needEndBlock[addedBlocks.needEndBlock.length - 1];
    if (pValue != null) {
      param.whereString += parameters.length > 0
          ? parameters[parameters.length - 1].wOperator
          : "";

      for (int i = 1; i < addedBlocks.waitingStartBlock.length; i++) {
        if (addedBlocks.waitingStartBlock[i]) {
          param.whereString += " ( ";
          addedBlocks.waitingStartBlock[i] = false;
          sp = true;
        }
      }

      param.value = pValue;
      if (pValue2 != null) param.value2 = pValue2;
      param.whereString += sqlSyntax;
      parameters.add(param);
    }
    addedBlocks.retVal = sp;

    return addedBlocks;
  }
}

class AddedBlocks {
  bool retVal;
  List<bool> needEndBlock;
  List<bool> waitingStartBlock;
  AddedBlocks([this.needEndBlock, this.waitingStartBlock, this.retVal = false]);
}

class BoolResult {
  String successMessage;
  String errorMessage;
  bool success = false;
  BoolResult({this.success, this.successMessage, this.errorMessage});
  @override
  String toString() {
    if (success)
      return successMessage != null && successMessage != ""
          ? successMessage
          : "Result: OK! Successful";
    else
      return errorMessage != null && errorMessage != ""
          ? errorMessage
          : "Result: ERROR!";
  }
}

class DbParameter {
  String columnName;
  DbType dbType;
  var value;
  var value2;
  String whereString;
  bool wStartBlock;
  String wOperator;
  String expression;
  DbParameter(
      {this.columnName,
      this.dbType,
      this.expression = "",
      this.value,
      this.value2,
      this.whereString = "",
      this.wOperator = "",
      this.wStartBlock = false});
}

class SqfEntityTable {
  String tableName;
  String primaryKeyName;
  List<SqfEntityFieldType> fields;
  List<TableCollection> collections;
  bool useSoftDeleting = false;
  bool primaryKeyisIdentity = true;
  String modelName;
  String dbModel;
  String defaultJsonUrl;
  bool initialized;

  SqfEntityTable init() {
    if (modelName == null) {
      modelName = toSingularName(tableName);
      modelName = modelName.substring(0, 1).toUpperCase() +
          modelName.substring(1).toLowerCase();
    }
    dbModel = dbModel
        .toString()
        .replaceAll("Instance of", "")
        .replaceAll("'", "")
        .trim();
    initialized = false;
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntityTable of '$tableName' initialized successfuly");
    return this;
  }

  String get modelLowerCase => modelName.toLowerCase();

  String get createTableSQL => _createTableSQL();
  String _createTableSQL() {
    String _createTableSQL = "Create table $tableName ($primaryKeyName " +
        (primaryKeyisIdentity ? "integer primary key" : "int UNIQUE");
    for (SqfEntityFieldType field in fields) {
      _createTableSQL += ", " + field.toSqLiteFieldString();
    }
    if (useSoftDeleting) _createTableSQL += ", isDeleted numeric";
    _createTableSQL += ")";

    return _createTableSQL;
  }
}

String toCamelCase(String fieldName) => fieldName.length == 1
    ? fieldName.toUpperCase()
    : fieldName.substring(0, 1).toUpperCase() +
        fieldName.substring(1).toLowerCase();

String toPluralName(String s) => s.endsWith("y")
    ? s.substring(0, s.length - 1) + "ies"
    : (s.endsWith("s")) ? s + "es" : s + "s";

String toPluralLowerName(String s) => s.endsWith("y")
    ? s.substring(0, s.length - 1).toLowerCase() + "ies"
    : (s.endsWith("s")) ? s.toLowerCase() + "es" : s.toLowerCase() + "s";

String toSingularName(String s) => s.endsWith("ies")
    ? s.substring(0, s.length - 3) + "y"
    : s.endsWith("ses")
        ? s.substring(0, s.length - 3) + "s"
        : s.endsWith("s") ? s.substring(0, s.length - 1) : s;

String toSingularLowerName(String s) => s.endsWith("ies")
    ? s.substring(0, s.length - 3).toLowerCase() + "y"
    : s.endsWith("ses")
        ? s.substring(0, s.length - 3).toLowerCase() + "s"
        : s.endsWith("s")
            ? s.substring(0, s.length - 1).toLowerCase()
            : s.toLowerCase();

abstract class SqfEntityFieldType {
  final String fieldName;
  DbType dbType;
  String _dbType;
  String defaultValue;
  SqfEntityTable table;

  SqfEntityFieldType(this.fieldName, this.dbType,
      {this.defaultValue, this.table});

  String toSqLiteFieldString();

  String toPropertiesString();

  String toConstructureString();

  String toMapString();

  String toFromMapString();
}

class SqfEntityField implements SqfEntityFieldType {
  String fieldName;
  DbType dbType;
  String _dbType;
  String defaultValue;
  SqfEntityTable table;

  SqfEntityField(this.fieldName, this.dbType, {this.defaultValue, this.table});

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

class SqfEntityFieldRelationship implements SqfEntityFieldType {
  String fieldName;
  String relationshipName;
  @override
  DbType dbType = DbType.integer;
  String _dbType;
  String defaultValue;
  SqfEntityTable table;
  DeleteRule deleteRule = DeleteRule.NO_ACTION;
  SqfEntityFieldRelationship(this.table, this.deleteRule,
      {this.fieldName, this.defaultValue}) {
    if (fieldName == null)
      fieldName = table.tableName +
          table.primaryKeyName.substring(0, 1).toUpperCase() +
          table.primaryKeyName.substring(1);
    relationshipName = table.modelName;
  }
  String toSqLiteFieldString() {
    _dbType = "integer";
    return "$fieldName $_dbType";
  }

  String toPropertiesString() {
    return "int $fieldName";
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

abstract class SqfEntityModel {
  // STEPS FOR CREATE YOUR DB CONTEXT

  // 1. declare your sqlite database name
  String databaseName;

  // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing database
  String bundledDatabasePath;

  // 2. Add the object you defined above to your list of database tables.
  List<SqfEntityTable> databaseTables;

  // that's all.. one more step left for create models.dart file.
  // ATTENTION: Defining the table here provides automatic processing for database configuration only.
  // you may call the SqfEntityDbContext.createModel(MyDbModel.databaseTables) function to create your model and use it in your project

  initializeDB(VoidCallback isReady(bool result)) {
    var dbTables = databaseTables.where((i) => !i.initialized).toList();
    if (dbTables.length == 0)
      isReady(true);
    else {
      //List<String> updateQueryList = new List<String>();
      for (SqfEntityTable table in dbTables) {
        // check exiting table fields in the database
        var tableFields = SqfEntityProvider(this)
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
            List<String> alterTableColsQuery =
                checkTableColumns(table, exitingDBfields);

            if (alterTableColsQuery.length > 0) {
              print("SQFENTITIY: alterTableQuery => $alterTableColsQuery");

              SqfEntityProvider(this).execSQLList(alterTableColsQuery,
                  (result) {
                if (result) {
                  table.initialized = true;
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
          } else {
            // The table if not exist
            SqfEntityProvider(this).execSQL(table.createTableSQL).then((_) {
              List<String> alterTableIndexesQuery = checkTableIndexes(table);
              table.initialized = true;
              print(
                  "SQFENTITIY: Table named '${table.tableName}' was initialized successfuly with create new table");
              if (checkForIsReadyDatabase(dbTables)) isReady(true);
              if (alterTableIndexesQuery.length > 0) {
                print(
                    "SQFENTITIY: alterTableIndexesQuery => $alterTableIndexesQuery");
                SqfEntityProvider(this)
                    .execSQLList(alterTableIndexesQuery, (result) {});
              }
            });
          }
        });
      }
    }
  }

  // create Model String and set the Clipboard (After debugging, press Ctrl+V to paste the model from the Clipboard)
  // to call this method use SqfEntityDbModel.createSqfEntityModel
  String createModel() {
    String modelString =
        "import 'dart:convert';\nimport 'package:http/http.dart' as http;\nimport 'package:flutter/material.dart';\nimport 'package:sqfentity/db/sqfEntityBase.dart';";

    for (var table in databaseTables) {
      table.dbModel = this
          .toString()
          .replaceAll("Instance of", "")
          .replaceAll("'", "")
          .trim();
      table.collections = getCollections(table);
      modelString += SqfEntityObjectBuilder(table).toString() + "\n";
      modelString += SqfEntityObjectField(table).toString() + "\n";
      modelString += SqfEntityObjectFilterBuilder(table).toString() + "\n";
      modelString += SqfEntityFieldBuilder(table).toString() + "\n";
      modelString += SqfEntityObjectManagerBuilder(table).toString() + "\n";
    }
    Clipboard.setData(ClipboardData(text: modelString)).then((_) {
      print(
          "SQFENTITIY: [databaseTables] Model was successfully created. Create models.dart file in your project and press Ctrl+V to paste the model from the Clipboard");
    });
    return modelString;
  }

  List<TableCollection> getCollections(SqfEntityTable table) {
    var collectionList = List<TableCollection>();
    for (var _table in databaseTables) {
      for (var field in _table.fields) {
        if (field is SqfEntityFieldRelationship) {
          if (field.table.tableName == table.tableName)
            collectionList.add(TableCollection(_table, field));
        }
      }
    }
    return collectionList;
  }
}

bool checkForIsReadyDatabase(List<SqfEntityTable> dbTables) {
  if (dbTables.where((i) => !i.initialized).length == 0) {
    print("SQFENTITIY: The database is ready for use");
    return true;
  } else
    return false;
}

List<String> checkTableIndexes(SqfEntityTable table) {
  var alterTableQuery = List<String>();
  for (SqfEntityFieldType field in table.fields) {
    if (field is SqfEntityFieldRelationship) {
      alterTableQuery.add(
          "CREATE INDEX IF NOT EXISTS IDX${field.relationshipName + field.fieldName} ON ${table.tableName} (${field.fieldName} ASC)");
    }
  }
  return alterTableQuery;
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
      if (newField is SqfEntityFieldRelationship) {
        alterTableQuery.add(
            "CREATE INDEX [IF NOT EXISTS] IDX${newField.relationshipName + newField.fieldName} ON ${table.tableName} (${newField.fieldName} [ASC])");
      }
    }
  }
  return alterTableQuery;
}

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

"add","all","alter","and","as","autoincrement",
"between","case","check","collate","commit","constraint","create",
"default","deferrable","delete","distinct","drop",
"else","escape","except","exists",
"foreign","from","group","having",
"if","in","index","insert","intersect","into","is","isnull",
"join","limit","not","notnull","null","on","or","order",
"primary","references","select","set",
"table","then","to","transaction",
"union","unique","update","using",
"values","when","where"

*/

// List<String> dartType: each element of the list corresponds to the DbType enum index
const List<String> dartType = [
  "int",
  "String",
  "String",
  "double",
  "int",
  "bool"
];
const List<String> sqLiteType = [
  "integer",
  "text",
  "blob",
  "real",
  "numeric",
  "numeric"
];
enum DeleteRule { CASCADE, SET_DEFAULT_VALUE, SET_NULL, NO_ACTION }
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
  bool
  // bool is not a supported SQLite type. Builder converts this type to numeric values (false=0, true=1)
}

DbType parseDbType(String val) {
  for (var o in DbType.values) {
    if (sqLiteType[o.index] == val) return o;
  }
  return null;
}
// END ENUMS, CLASSES AND ABSTRACTS
