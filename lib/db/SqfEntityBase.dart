import 'package:flutter/material.dart';
import 'package:sqfentity/db/SqfEntityDbModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SqfEntityProvider {
  static final SqfEntityProvider _sqfEntityProvider =
      SqfEntityProvider._internal();
  static SqfEntityProvider get = _sqfEntityProvider;
  String _tableName = "";
  String _colId = "";
  SqfEntityProvider._internal();
  SqfEntityProvider({String tableName, String colId}) {
    this._tableName = tableName;
    this._colId = colId;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + SqfEntityDbModel.databaseName;

    var dbEtrade = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbEtrade;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "Create table sqfentitytables (id integer primary key, tablename text, version int, properties text)");
  }

  Future<dynamic> getById(int id) async {
    Database db = await this.db;
    var query = "Select * from $_tableName where id=$id";
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
    var result = await db
        .update(_tableName, T.toMap(forQuery:true), where: "$_colId = ?", whereArgs: [T.id]);
    return result;
  }

  Future<int> insert(T) async {
    Database db = await this.db;
    var result = await db.insert(_tableName, T.toMap(forQuery:true));
    return result;
  }
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
  //bool softDeleteActivated;
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

// BEGIN ENUMS AND STRUCTURES

class AddedBlocks {
  bool retVal;
  List<bool> needEndBlock;
  List<bool> waitingStartBlock;
  AddedBlocks([this.needEndBlock, this.waitingStartBlock, this.retVal = false]);
}

class BoolResult {
  String successMessage;
  String errorMessage;
  bool success;
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
    if (sqLiteType[o.index]  == val) return o;
  }
  return null;
}
