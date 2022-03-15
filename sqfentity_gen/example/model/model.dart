import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

// STEP 1: define your tables as shown in the example Classes below.

// Define the 'tableCategory' constant as SqfEntityTable for the category table
const tableCategory = SqfEntityTable(
    tableName: 'category',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('name', DbType.text, isNotNull: true),
      SqfEntityField('isActive', DbType.bool, defaultValue: true),
    ],
    formListSubTitleField: '');

// Define the 'tableProduct' constant as SqfEntityTable for the product table
const tableProduct = SqfEntityTable(
    tableName: 'product',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    fields: [
      SqfEntityField(
        'name',
        DbType.text,
        isNotNull: true,
      ),
      SqfEntityField('description', DbType.text),
      SqfEntityField('price', DbType.real, defaultValue: 0),
      SqfEntityField('isActive', DbType.bool, defaultValue: true),

      /// Relationship column for CategoryId of Product
      SqfEntityFieldRelationship(
          parentTable: tableCategory,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 1,
          formDropDownTextField:
              'name' // displayText of dropdownList for category. 'name' => a text field from the category table
          ),
      SqfEntityField('rownum', DbType.integer,
          sequencedBy:
              seqIdentity /*Example of linking a column to a sequence */),
      SqfEntityField('imageUrl', DbType.text),
      SqfEntityField('datetime', DbType.datetime,
          defaultValue: 'DateTime.now()',
          minValue: '2019-01-01',
          maxValue: 'DateTime.now().add(Duration(days: 30))'),
      SqfEntityField('date', DbType.date,
          minValue: '2015-01-01',
          maxValue: 'DateTime.now().add(Duration(days: 365))')
    ]);

// Define the 'Todo' constant as SqfEntityTable.
const tableTodo = SqfEntityTable(
    tableName: 'todos',
    primaryKeyName: 'id',
    useSoftDeleting:
        false, // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    primaryKeyType: PrimaryKeyType.integer_unique,
    defaultJsonUrl:
        'https://jsonplaceholder.typicode.com/todos', // optional: to synchronize your table with json data from webUrl

    // declare fields
    fields: [
      SqfEntityField('userId', DbType.integer),
      SqfEntityField('title', DbType.text),
      SqfEntityField('completed', DbType.bool, defaultValue: false),
    ]);

// Define the 'identity' constant as SqfEntitySequence.
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  //maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  //modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  //cycle : false,    /* optional. default is false; */
  //minValue = 0;     /* optional. default is 0 */
  //incrementBy = 1;  /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

// STEP 2: Create your Database Model constant instanced from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases.
// So you can create many Database Models and use them in the application.
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel',
    databaseName: 'sampleORM_v2.1.0+3.db',
    password:
        null, // You can set a password if you want to use crypted database (For more information: https://github.com/sqlcipher/sqlcipher)
    // put defined tables into the tables list.
    databaseTables: [tableProduct, tableCategory, tableTodo],
    // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [tableProduct, tableCategory, tableTodo],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    dbVersion: 2,
    bundledDatabasePath: null, //         'assets/sample.db'
    // This value is optional. When bundledDatabasePath is empty then
    // EntityBase creats a new database when initializing the database
    defaultColumns: [
      SqfEntityField('dateCreated', DbType.datetime,
          defaultValue: 'DateTime.now()'),
    ]);

/* STEP 3: That's All.. 
--> Go Terminal Window and run command below
    flutter pub run build_runner build --delete-conflicting-outputs
  Note: After running the command Please check lib/model/model.g.dart and lib/model/model.g.view.dart (If formTables parameter is defined in the model)
  Enjoy.. Huseyin TOKPINAR
*/

//  To use these SqfEntity classes do following:
//  - import model.dart into where to use
//  - start typing ex:Product.select()... (add a few filters with fluent methods)...(add orderBy/orderBydesc if you want)...
//  - and then just put end of filters / or end of only select()  toSingle() / or toList()
//  - you can select one or return List<yourObject> by your filters and orders
//  - also you can batch update or batch delete by using delete/update methods instead of tosingle/tolist methods
//    Enjoy.. Huseyin Tokpunar

// BEGIN TABLES
// Product TABLE
class TableProduct extends SqfEntityTableBase {
  TableProduct() {
    // declare properties of EntityTable
    tableName = 'product';
    primaryKeyName = 'id';
    primaryKeyType = PrimaryKeyType.integer_auto_incremental;
    useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityFieldBase('name', DbType.text, isNotNull: true),
      SqfEntityFieldBase('description', DbType.text),
      SqfEntityFieldBase('price', DbType.real, defaultValue: 0),
      SqfEntityFieldBase('isActive', DbType.bool, defaultValue: true),
      SqfEntityFieldRelationshipBase(
          TableCategory.getInstance, DeleteRule.CASCADE,
          relationType: RelationType.ONE_TO_MANY,
          fieldName: 'categoryId',
          defaultValue: 1),
      SqfEntityFieldBase('rownum', DbType.integer),
      SqfEntityFieldBase('imageUrl', DbType.text),
      SqfEntityFieldBase('datetime', DbType.datetime,
          defaultValue: DateTime.now(),
          isNotNull: true,
          minValue: DateTime.parse('2019-01-01'),
          maxValue: DateTime.now().add(Duration(days: 30))),
      SqfEntityFieldBase('date', DbType.date,
          minValue: DateTime.parse('2015-01-01'),
          maxValue: DateTime.now().add(Duration(days: 365))),
      SqfEntityFieldBase('dateCreated', DbType.datetime,
          defaultValue: DateTime.now(), minValue: DateTime.parse('1900-01-01')),
    ];
    super.init();
  }
  static SqfEntityTableBase? _instance;
  static SqfEntityTableBase get getInstance {
    return _instance = _instance ?? TableProduct();
  }
}

// Category TABLE
class TableCategory extends SqfEntityTableBase {
  TableCategory() {
    // declare properties of EntityTable
    tableName = 'category';
    primaryKeyName = 'id';
    primaryKeyType = PrimaryKeyType.integer_auto_incremental;
    useSoftDeleting = false;
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityFieldBase('name', DbType.text, isNotNull: true),
      SqfEntityFieldBase('isActive', DbType.bool, defaultValue: true),
      SqfEntityFieldBase('dateCreated', DbType.datetime,
          defaultValue: DateTime.now(), minValue: DateTime.parse('1900-01-01')),
    ];
    super.init();
  }
  static SqfEntityTableBase? _instance;
  static SqfEntityTableBase get getInstance {
    return _instance = _instance ?? TableCategory();
  }
}

// Todo TABLE
class TableTodo extends SqfEntityTableBase {
  TableTodo() {
    // declare properties of EntityTable
    tableName = 'todos';
    primaryKeyName = 'id';
    primaryKeyType = PrimaryKeyType.integer_unique;
    useSoftDeleting = false;
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityFieldBase('userId', DbType.integer, isIndex: true),
      SqfEntityFieldBase('title', DbType.text),
      SqfEntityFieldBase('completed', DbType.bool, defaultValue: false),
      SqfEntityFieldBase('dateCreated', DbType.datetime,
          defaultValue: DateTime.now(), minValue: DateTime.parse('1900-01-01')),
    ];
    super.init();
  }
  static SqfEntityTableBase? _instance;
  static SqfEntityTableBase get getInstance {
    return _instance = _instance ?? TableTodo();
  }
}
// END TABLES

// BEGIN SEQUENCES
// identity SEQUENCE
class SequenceIdentitySequence extends SqfEntitySequenceBase {
  SequenceIdentitySequence() {
    sequenceName = 'identity';
    maxValue =
        9007199254740991; /* optional. default is max int (9.223.372.036.854.775.807) */
    cycle = false; /* optional. default is false; */
    minValue = 0; /* optional. default is 0 */
    incrementBy = 1; /* optional. default is 1 */
    startWith = 0; /* optional. default is 0 */
    super.init();
  }
  static SequenceIdentitySequence? _instance;
  static SequenceIdentitySequence get getInstance {
    return _instance = _instance ?? SequenceIdentitySequence();
  }
}
// END SEQUENCES

// BEGIN DATABASE MODEL
class MyDbModel extends SqfEntityModelProvider {
  MyDbModel() {
    databaseName = myDbModel.databaseName;
    password = myDbModel.password;
    dbVersion = myDbModel.dbVersion;
    preSaveAction = myDbModel.preSaveAction;
    logFunction = myDbModel.logFunction;
    databaseTables = [
      TableProduct.getInstance,
      TableCategory.getInstance,
      TableTodo.getInstance,
    ];

    sequences = [
      SequenceIdentitySequence.getInstance,
    ];

    bundledDatabasePath = myDbModel
        .bundledDatabasePath; //'assets/sample.db'; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  }
}
// END DATABASE MODEL

// BEGIN ENTITIES
// region Product
class Product extends TableBase {
  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.isActive,
      this.categoryId,
      this.rownum,
      this.imageUrl,
      this.datetime,
      this.date,
      this.dateCreated,
      this.isDeleted}) {
    _setDefaultValues();
    softDeleteActivated = true;
  }
  Product.withFields(
      this.name,
      this.description,
      this.price,
      this.isActive,
      this.categoryId,
      this.rownum,
      this.imageUrl,
      this.datetime,
      this.date,
      this.dateCreated,
      this.isDeleted) {
    _setDefaultValues();
  }
  Product.withId(
      this.id,
      this.name,
      this.description,
      this.price,
      this.isActive,
      this.categoryId,
      this.rownum,
      this.imageUrl,
      this.datetime,
      this.date,
      this.dateCreated,
      this.isDeleted) {
    _setDefaultValues();
  }
  // fromMap v2.0
  Product.fromMap(Map<String, dynamic> o, {bool setDefaultValues = true}) {
    if (setDefaultValues) {
      _setDefaultValues();
    }
    id = int.tryParse(o['id'].toString());
    if (o['name'] != null) {
      name = o['name'].toString();
    }
    if (o['description'] != null) {
      description = o['description'].toString();
    }
    if (o['price'] != null) {
      price = double.tryParse(o['price'].toString());
    }
    if (o['isActive'] != null) {
      isActive =
          o['isActive'].toString() == '1' || o['isActive'].toString() == 'true';
    }
    categoryId = int.tryParse(o['categoryId'].toString());

    if (o['rownum'] != null) {
      rownum = int.tryParse(o['rownum'].toString());
    }
    if (o['imageUrl'] != null) {
      imageUrl = o['imageUrl'].toString();
    }
    if (o['datetime'] != null) {
      datetime = int.tryParse(o['datetime'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(o['datetime'].toString())!)
          : DateTime.tryParse(o['datetime'].toString());
    }
    if (o['date'] != null) {
      date = int.tryParse(o['date'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(o['date'].toString())!)
          : DateTime.tryParse(o['date'].toString());
    }
    if (o['dateCreated'] != null) {
      dateCreated = int.tryParse(o['dateCreated'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(o['dateCreated'].toString())!)
          : DateTime.tryParse(o['dateCreated'].toString());
    }
    isDeleted = o['isDeleted'] != null
        ? o['isDeleted'] == 1 || o['isDeleted'] == true
        : null;

    // RELATIONSHIPS FromMAP
    plCategory = o['category'] != null
        ? Category.fromMap(o['category'] as Map<String, dynamic>)
        : null;
    // END RELATIONSHIPS FromMAP
  }
  // FIELDS (Product)
  int? id;
  String? name;
  String? description;
  double? price;
  bool? isActive;
  int? categoryId;
  int? rownum;
  String? imageUrl;
  DateTime? datetime;
  DateTime? date;
  DateTime? dateCreated;
  bool? isDeleted;
  // end FIELDS (Product)

// RELATIONSHIPS (Product)
  /// to load parent of items to this field, use preload parameter ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
  /// You can also specify this object into certain preload fields!. Ex: toList(preload:true, preloadFields:['plCategory', 'plField2'..]) or so on..
  Category? plCategory;

  /// get Category By CategoryId
  Future<Category?> getCategory(
      {bool loadParents = false, List<String>? loadedFields}) async {
    final _obj = await Category().getById(categoryId,
        loadParents: loadParents, loadedFields: loadedFields);
    return _obj;
  }
  // END RELATIONSHIPS (Product)

  static const bool _softDeleteActivated = true;
  ProductManager? __mnProduct;

  ProductManager get _mnProduct {
    return __mnProduct = __mnProduct ?? ProductManager();
  }

  // METHODS
  @override
  Map<String, dynamic> toMap(
      {bool forQuery = false, bool forJson = false, bool forView = false}) {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    if (isActive != null) {
      map['isActive'] = forQuery ? (isActive! ? 1 : 0) : isActive;
    } else {
      map['isActive'] = null;
    }
    if (categoryId != null) {
      map['categoryId'] = forView
          ? plCategory == null
              ? categoryId
              : plCategory!.name
          : categoryId;
    } else {
      map['categoryId'] = null;
    }
    map['rownum'] = rownum;
    map['imageUrl'] = imageUrl;
    if (datetime != null) {
      map['datetime'] = forJson
          ? datetime!.toString()
          : forQuery
              ? datetime!.millisecondsSinceEpoch
              : datetime;
    } else {
      map['datetime'] = null;
    }
    if (date != null) {
      map['date'] = forJson
          ? '$date!.year-$date!.month-$date!.day'
          : forQuery
              ? DateTime(date!.year, date!.month, date!.day)
                  .millisecondsSinceEpoch
              : date;
    } else {
      map['date'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }
    if (isDeleted != null) {
      map['isDeleted'] = forQuery ? (isDeleted! ? 1 : 0) : isDeleted;
    }

    return map;
  }

  @override
  Future<Map<String, dynamic>> toMapWithChildren(
      [bool forQuery = false,
      bool forJson = false,
      bool forView = false]) async {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    if (isActive != null) {
      map['isActive'] = forQuery ? (isActive! ? 1 : 0) : isActive;
    } else {
      map['isActive'] = null;
    }
    if (categoryId != null) {
      map['categoryId'] = forView
          ? plCategory == null
              ? categoryId
              : plCategory!.name
          : categoryId;
    } else {
      map['categoryId'] = null;
    }
    map['rownum'] = rownum;
    map['imageUrl'] = imageUrl;
    if (datetime != null) {
      map['datetime'] = forJson
          ? datetime!.toString()
          : forQuery
              ? datetime!.millisecondsSinceEpoch
              : datetime;
    } else {
      map['datetime'] = null;
    }
    if (date != null) {
      map['date'] = forJson
          ? '$date!.year-$date!.month-$date!.day'
          : forQuery
              ? DateTime(date!.year, date!.month, date!.day)
                  .millisecondsSinceEpoch
              : date;
    } else {
      map['date'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }
    if (isDeleted != null) {
      map['isDeleted'] = forQuery ? (isDeleted! ? 1 : 0) : isDeleted;
    }

    return map;
  }

  /// This method returns Json String [Product]
  @override
  String toJson() {
    return json.encode(toMap(forJson: true));
  }

  /// This method returns Json String [Product]
  @override
  Future<String> toJsonWithChilds() async {
    return json.encode(await toMapWithChildren(false, true));
  }

  @override
  List<dynamic> toArgs() {
    return [
      name,
      description,
      price,
      isActive,
      categoryId,
      rownum,
      imageUrl,
      datetime != null ? datetime!.millisecondsSinceEpoch : null,
      date != null ? date!.millisecondsSinceEpoch : null,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null,
      isDeleted
    ];
  }

  @override
  List<dynamic> toArgsWithIds() {
    return [
      id,
      name,
      description,
      price,
      isActive,
      categoryId,
      rownum,
      imageUrl,
      datetime != null ? datetime!.millisecondsSinceEpoch : null,
      date != null ? date!.millisecondsSinceEpoch : null,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null,
      isDeleted
    ];
  }

  static Future<List<Product>?> fromWebUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      return await fromJson(response.body);
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Product.fromWebUrl: ErrorMessage: ${e.toString()}');
      return null;
    }
  }

  Future<http.Response> postUrl(Uri uri, {Map<String, String>? headers}) {
    return http.post(uri, headers: headers, body: toJson());
  }

  static Future<List<Product>> fromJson(String jsonBody) async {
    final Iterable list = await json.decode(jsonBody) as Iterable;
    var objList = <Product>[];
    try {
      objList = list
          .map((product) => Product.fromMap(product as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Product.fromJson: ErrorMessage: ${e.toString()}');
    }
    return objList;
  }

  static Future<List<Product>> fromMapList(List<dynamic> data,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields,
      bool setDefaultValues = true}) async {
    final List<Product> objList = <Product>[];
    loadedFields = loadedFields ?? [];
    for (final map in data) {
      final obj = Product.fromMap(map as Map<String, dynamic>,
          setDefaultValues: setDefaultValues);
      // final List<String> _loadedFields = List<String>.from(loadedFields);

      // RELATIONSHIPS PRELOAD
      if (preload || loadParents) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plCategory') && */ (preloadFields ==
                null ||
            loadParents ||
            preloadFields.contains('plCategory'))) {
          /*_loadedfields!.add('category.plCategory');*/ obj.plCategory = obj
                  .plCategory ??
              await obj.getCategory(
                  loadParents: loadParents /*, loadedFields: _loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD

      objList.add(obj);
    }
    return objList;
  }

  /// returns Product by ID if exist, otherwise returns null
  ///
  /// Primary Keys: int? id
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: getById(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: getById(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>returns [Product] if exist, otherwise returns null
  Future<Product?> getById(int? id,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    if (id == null) {
      return null;
    }
    Product? obj;
    final data = await _mnProduct.getById([id]);
    if (data.length != 0) {
      obj = Product.fromMap(data[0] as Map<String, dynamic>);
      // final List<String> _loadedFields = loadedFields ?? [];

      // RELATIONSHIPS PRELOAD
      if (preload || loadParents) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plCategory') && */ (preloadFields ==
                null ||
            loadParents ||
            preloadFields.contains('plCategory'))) {
          /*_loadedfields!.add('category.plCategory');*/ obj.plCategory = obj
                  .plCategory ??
              await obj.getCategory(
                  loadParents: loadParents /*, loadedFields: _loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD

    } else {
      obj = null;
    }
    return obj;
  }

  /// Saves the (Product) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  /// <returns>Returns id
  @override
  Future<int?> save({bool ignoreBatch = true}) async {
    if (id == null || id == 0) {
      rownum = await IdentitySequence().nextVal();

      id = await _mnProduct.insert(this, ignoreBatch);
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnProduct.update(this);
    }

    return id;
  }

  /// Saves the (Product) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  ///
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  ///
  /// <returns>Returns id
  @override
  Future<int?> saveOrThrow({bool ignoreBatch = true}) async {
    if (id == null || id == 0) {
      rownum = await IdentitySequence().nextVal();

      id = await _mnProduct.insertOrThrow(this, ignoreBatch);

      isInsert = true;
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnProduct.updateOrThrow(this);
    }

    return id;
  }

  /// saveAs Product. Returns a new Primary Key value of Product

  /// <returns>Returns a new Primary Key value of Product
  @override
  Future<int?> saveAs({bool ignoreBatch = true}) async {
    id = null;

    return save(ignoreBatch: ignoreBatch);
  }

  @override
  void rollbackPk() {
    if (isInsert == true) {
      id = null;
    }
  }

  /// saveAll method saves the sent List<Product> as a bulk in one transaction
  ///
  /// Returns a <List<BoolResult>>
  static Future<List<dynamic>> saveAll(List<Product> products) async {
    List<dynamic>? result = [];
    // If there is no open transaction, start one
    final isStartedBatch = await MyDbModel().batchStart();
    for (final obj in products) {
      await obj.save(ignoreBatch: false);
    }
    if (!isStartedBatch) {
      result = await MyDbModel().batchCommit();
      for (int i = 0; i < products.length; i++) {
        if (products[i].id == null) {
          products[i].id = result![i] as int;
        }
      }
    }
    return result!;
  }

  /// Updates if the record exists, otherwise adds a new row

  /// <returns>Returns id
  @override
  Future<int?> upsert({bool ignoreBatch = true}) async {
    try {
      final result = await _mnProduct.rawInsert(
          'INSERT OR REPLACE INTO product (id, name, description, price, isActive, categoryId, rownum, imageUrl, datetime, date, dateCreated,isDeleted)  VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
          [
            id,
            name,
            description,
            price,
            isActive,
            categoryId,
            rownum,
            imageUrl,
            datetime != null ? datetime!.millisecondsSinceEpoch : null,
            date != null ? date!.millisecondsSinceEpoch : null,
            dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null,
            isDeleted
          ],
          ignoreBatch);
      if (result! > 0) {
        saveResult = BoolResult(
            success: true,
            successMessage: 'Product id=$id updated successfully');
      } else {
        saveResult = BoolResult(
            success: false, errorMessage: 'Product id=$id did not update');
      }
      return id;
    } catch (e) {
      saveResult = BoolResult(
          success: false,
          errorMessage: 'Product Save failed. Error: ${e.toString()}');
      return null;
    }
  }

  /// inserts or replaces the sent List<<Product>> as a bulk in one transaction.
  ///
  /// upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero
  ///
  /// Returns a BoolCommitResult
  @override
  Future<BoolCommitResult> upsertAll(List<Product> products) async {
    final results = await _mnProduct.rawInsertAll(
        'INSERT OR REPLACE INTO product (id, name, description, price, isActive, categoryId, rownum, imageUrl, datetime, date, dateCreated,isDeleted)  VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        products);
    return results;
  }

  /// Deletes Product

  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    debugPrint('SQFENTITIY: delete Product invoked (id=$id)');
    if (!_softDeleteActivated || hardDelete || isDeleted!) {
      return _mnProduct
          .delete(QueryParams(whereString: 'id=?', whereArguments: [id]));
    } else {
      return _mnProduct.updateBatch(
          QueryParams(whereString: 'id=?', whereArguments: [id]),
          {'isDeleted': 1});
    }
  }

  /// Recover Product

  /// <returns>BoolResult res.success=Recovered, not res.success=Can not recovered
  @override
  Future<BoolResult> recover([bool recoverChilds = true]) async {
    debugPrint('SQFENTITIY: recover Product invoked (id=$id)');
    {
      return _mnProduct.updateBatch(
          QueryParams(whereString: 'id=?', whereArguments: [id]),
          {'isDeleted': 0});
    }
  }

  @override
  ProductFilterBuilder select(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return ProductFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect;
  }

  @override
  ProductFilterBuilder distinct(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return ProductFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect
      ..qparams.distinct = true;
  }

  void _setDefaultValues() {
    price = price ?? 0;
    isActive = isActive ?? true;
    categoryId = categoryId ?? 1;
    datetime = datetime ?? DateTime.now();
    dateCreated = dateCreated ?? DateTime.now();
    isDeleted = isDeleted ?? false;
  }
  // END METHODS
  // BEGIN CUSTOM CODE
  /*
      you can define customCode property of your SqfEntityTable constant. For example:
      const tablePerson = SqfEntityTable(
      tableName: 'person',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
        SqfEntityField('firstName', DbType.text),
        SqfEntityField('lastName', DbType.text),
      ],
      customCode: '''
       String fullName()
       { 
         return '$firstName $lastName';
       }
      ''');
     */
  // END CUSTOM CODE
}
// endregion product

// region ProductField
class ProductField extends FilterBase {
  ProductField(ProductFilterBuilder productFB) : super(productFB);
  //DbParameter param = DbParameter();
  //String _waitingNot = '';
  //ProductFilterBuilder productFB;

  @override
  ProductFilterBuilder equals(dynamic pValue) {
    return super.equals(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder equalsOrNull(dynamic pValue) {
    return super.equalsOrNull(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder isNull() {
    return super.isNull() as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder contains(dynamic pValue) {
    return super.contains(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder startsWith(dynamic pValue) {
    return super.startsWith(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder endsWith(dynamic pValue) {
    return super.endsWith(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder between(dynamic pFirst, dynamic pLast) {
    return super.between(pFirst, pLast) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder greaterThan(dynamic pValue) {
    return super.greaterThan(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder lessThan(dynamic pValue) {
    return super.lessThan(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder greaterThanOrEquals(dynamic pValue) {
    return super.greaterThanOrEquals(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder lessThanOrEquals(dynamic pValue) {
    return super.lessThanOrEquals(pValue) as ProductFilterBuilder;
  }

  @override
  ProductFilterBuilder inValues(dynamic pValue) {
    return super.inValues(pValue) as ProductFilterBuilder;
  }

  @override
  ProductField get not {
    return super.not as ProductField;
  }
}
// endregion ProductField

// region ProductFilterBuilder
class ProductFilterBuilder extends ConjunctionBase {
  ProductFilterBuilder(Product obj, bool? getIsDeleted)
      : super(obj, getIsDeleted) {
    // whereString = '';
    // groupByList = <String>[];
    // _addedBlocks.needEndBlock!.add(false);
    // _addedBlocks.waitingStartBlock!.add(false);
    // _obj = obj;
    _mnProduct = obj._mnProduct;
    _softDeleteActivated = obj.softDeleteActivated;
  }
  // AddedBlocks _addedBlocks= AddedBlocks(<bool>[], <bool>[]);
  // int _blockIndex = 0;
  // List<DbParameter> parameters= <DbParameter>[];
  // List<String> orderByList= <String>[];
  // Product? _obj;
  // QueryParams qparams= QueryParams();
  // int _pagesize=0;
  // int _page=0;

  bool _softDeleteActivated = false;
  ProductManager? _mnProduct;

  /// put the sql keyword 'AND'
  @override
  ProductFilterBuilder get and {
    super.and;
    return this;
  }

  /// put the sql keyword 'OR'
  @override
  ProductFilterBuilder get or {
    super.or;
    return this;
  }

  /// open parentheses
  @override
  ProductFilterBuilder get startBlock {
    super.startBlock;
    return this;
  }

  /// String whereCriteria, write raw query without 'where' keyword. Like this: 'field1 like 'test%' and field2 = 3'
  @override
  ProductFilterBuilder where(String? whereCriteria, {dynamic parameterValue}) {
    super.where(whereCriteria, parameterValue: parameterValue);
    return this;
  }

  /// page = page number,
  ///
  /// pagesize = row(s) per page
  @override
  ProductFilterBuilder page(int page, int pagesize) {
    super.page(page, pagesize);
    return this;
  }

  /// int count = LIMIT
  @override
  ProductFilterBuilder top(int count) {
    super.top(count);
    return this;
  }

  /// close parentheses
  @override
  ProductFilterBuilder get endBlock {
    super.endBlock;
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  ProductFilterBuilder orderBy(dynamic argFields) {
    super.orderBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  ProductFilterBuilder orderByDesc(dynamic argFields) {
    super.orderByDesc(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  ProductFilterBuilder groupBy(dynamic argFields) {
    super.groupBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  ProductFilterBuilder having(dynamic argFields) {
    super.having(argFields);
    return this;
  }

  ProductField _setField(ProductField? field, String colName, DbType dbtype) {
    return ProductField(this)
      ..param = DbParameter(
          dbType: dbtype, columnName: colName, wStartBlock: openedBlock);
  }

  ProductField? _id;
  ProductField get id {
    return _id = _setField(_id, 'id', DbType.integer);
  }

  ProductField? _name;
  ProductField get name {
    return _name = _setField(_name, 'name', DbType.text);
  }

  ProductField? _description;
  ProductField get description {
    return _description = _setField(_description, 'description', DbType.text);
  }

  ProductField? _price;
  ProductField get price {
    return _price = _setField(_price, 'price', DbType.real);
  }

  ProductField? _isActive;
  ProductField get isActive {
    return _isActive = _setField(_isActive, 'isActive', DbType.bool);
  }

  ProductField? _categoryId;
  ProductField get categoryId {
    return _categoryId = _setField(_categoryId, 'categoryId', DbType.integer);
  }

  ProductField? _rownum;
  ProductField get rownum {
    return _rownum = _setField(_rownum, 'rownum', DbType.integer);
  }

  ProductField? _imageUrl;
  ProductField get imageUrl {
    return _imageUrl = _setField(_imageUrl, 'imageUrl', DbType.text);
  }

  ProductField? _datetime;
  ProductField get datetime {
    return _datetime = _setField(_datetime, 'datetime', DbType.datetime);
  }

  ProductField? _date;
  ProductField get date {
    return _date = _setField(_date, 'date', DbType.date);
  }

  ProductField? _dateCreated;
  ProductField get dateCreated {
    return _dateCreated =
        _setField(_dateCreated, 'dateCreated', DbType.datetime);
  }

  ProductField? _isDeleted;
  ProductField get isDeleted {
    return _isDeleted = _setField(_isDeleted, 'isDeleted', DbType.bool);
  }

  /// Deletes List<Product> bulk by query
  ///
  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    buildParameters();
    var r = BoolResult(success: false);

    if (_softDeleteActivated && !hardDelete) {
      r = await _mnProduct!.updateBatch(qparams, {'isDeleted': 1});
    } else {
      r = await _mnProduct!.delete(qparams);
    }
    return r;
  }

  /// Recover List<Product> bulk by query
  @override
  Future<BoolResult> recover() async {
    buildParameters(getIsDeleted: true);
    debugPrint('SQFENTITIY: recover Product bulk invoked');
    return _mnProduct!.updateBatch(qparams, {'isDeleted': 0});
  }

  /// using:
  ///
  /// update({'fieldName': Value})
  ///
  /// fieldName must be String. Value is dynamic, it can be any of the (int, bool, String.. )
  @override
  Future<BoolResult> update(Map<String, dynamic> values) {
    buildParameters();
    if (qparams.limit! > 0 || qparams.offset! > 0) {
      qparams.whereString =
          'id IN (SELECT id from product ${qparams.whereString!.isNotEmpty ? 'WHERE ${qparams.whereString}' : ''}${qparams.limit! > 0 ? ' LIMIT ${qparams.limit}' : ''}${qparams.offset! > 0 ? ' OFFSET ${qparams.offset}' : ''})';
    }
    return _mnProduct!.updateBatch(qparams, values);
  }

  /// This method always returns [Product] Obj if exist, otherwise returns null
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Product?
  @override
  Future<Product?> toSingle(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    buildParameters(pSize: 1);
    final objFuture = _mnProduct!.toList(qparams);
    final data = await objFuture;
    Product? obj;
    if (data.isNotEmpty) {
      obj = Product.fromMap(data[0] as Map<String, dynamic>);
      // final List<String> _loadedFields = loadedFields ?? [];

      // RELATIONSHIPS PRELOAD
      if (preload || loadParents) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plCategory') && */ (preloadFields ==
                null ||
            loadParents ||
            preloadFields.contains('plCategory'))) {
          /*_loadedfields!.add('category.plCategory');*/ obj.plCategory = obj
                  .plCategory ??
              await obj.getCategory(
                  loadParents: loadParents /*, loadedFields: _loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD

    } else {
      obj = null;
    }
    return obj;
  }

  /// This method always returns [Product]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Product?
  @override
  Future<Product> toSingleOrDefault(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    return await toSingle(
            preload: preload,
            preloadFields: preloadFields,
            loadParents: loadParents,
            loadedFields: loadedFields) ??
        Product();
  }

  /// This method returns int. [Product]
  ///
  /// <returns>int
  @override
  Future<int> toCount([VoidCallback Function(int c)? productCount]) async {
    buildParameters();
    qparams.selectColumns = ['COUNT(1) AS CNT'];
    final productsFuture = await _mnProduct!.toList(qparams);
    final int count = productsFuture[0]['CNT'] as int;
    if (productCount != null) {
      productCount(count);
    }
    return count;
  }

  /// This method returns List<Product> [Product]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toList(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toList(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>List<Product>
  @override
  Future<List<Product>> toList(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    final data = await toMapList();
    final List<Product> productsData = await Product.fromMapList(data,
        preload: preload,
        preloadFields: preloadFields,
        loadParents: loadParents,
        loadedFields: loadedFields,
        setDefaultValues: qparams.selectColumns == null);
    return productsData;
  }

  /// This method returns Json String [Product]
  @override
  Future<String> toJson() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(o.toMap(forJson: true));
    }
    return json.encode(list);
  }

  /// This method returns Json String. [Product]
  @override
  Future<String> toJsonWithChilds() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(await o.toMapWithChildren(false, true));
    }
    return json.encode(list);
  }

  /// This method returns List<dynamic>. [Product]
  ///
  /// <returns>List<dynamic>
  @override
  Future<List<dynamic>> toMapList() async {
    buildParameters();
    return await _mnProduct!.toList(qparams);
  }

  /// Returns List<DropdownMenuItem<Product>>
  Future<List<DropdownMenuItem<Product>>> toDropDownMenu(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<Product>> o)?
          dropDownMenu]) async {
    buildParameters();
    final productsFuture = _mnProduct!.toList(qparams);

    final data = await productsFuture;
    final int count = data.length;
    final List<DropdownMenuItem<Product>> items = []..add(DropdownMenuItem(
        value: Product(),
        child: Text('Select Product'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: Product.fromMap(data[i] as Map<String, dynamic>),
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// Returns List<DropdownMenuItem<int>>
  Future<List<DropdownMenuItem<int>>> toDropDownMenuInt(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<int>> o)?
          dropDownMenu]) async {
    buildParameters();
    qparams.selectColumns = ['id', displayTextColumn];
    final productsFuture = _mnProduct!.toList(qparams);

    final data = await productsFuture;
    final int count = data.length;
    final List<DropdownMenuItem<int>> items = []..add(DropdownMenuItem(
        value: 0,
        child: Text('Select Product'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: data[i]['id'] as int,
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// This method returns Primary Key List SQL and Parameters retVal = Map<String,dynamic>. [Product]
  ///
  /// retVal['sql'] = SQL statement string, retVal['args'] = whereArguments List<dynamic>;
  ///
  /// <returns>List<String>
  @override
  Map<String, dynamic> toListPrimaryKeySQL([bool buildParams = true]) {
    final Map<String, dynamic> _retVal = <String, dynamic>{};
    if (buildParams) {
      buildParameters();
    }
    _retVal['sql'] = 'SELECT `id` FROM product WHERE ${qparams.whereString}';
    _retVal['args'] = qparams.whereArguments;
    return _retVal;
  }

  /// This method returns Primary Key List<int>.
  /// <returns>List<int>
  @override
  Future<List<int>> toListPrimaryKey([bool buildParams = true]) async {
    if (buildParams) {
      buildParameters();
    }
    final List<int> idData = <int>[];
    qparams.selectColumns = ['id'];
    final idFuture = await _mnProduct!.toList(qparams);

    final int count = idFuture.length;
    for (int i = 0; i < count; i++) {
      idData.add(idFuture[i]['id'] as int);
    }
    return idData;
  }

  /// Returns List<dynamic> for selected columns. Use this method for 'groupBy' with min,max,avg..  [Product]
  ///
  /// Sample usage: (see EXAMPLE 4.2 at https://github.com/hhtokpinar/sqfEntity#group-by)
  @override
  Future<List<dynamic>> toListObject() async {
    buildParameters();

    final objectFuture = _mnProduct!.toList(qparams);

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
  /// Sample usage: await Product.select(columnsToSelect: ['columnName']).toListString()
  @override
  Future<List<String>> toListString(
      [VoidCallback Function(List<String> o)? listString]) async {
    buildParameters();

    final objectFuture = _mnProduct!.toList(qparams);

    final List<String> objectsData = <String>[];
    final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i][qparams.selectColumns![0]].toString());
    }
    if (listString != null) {
      listString(objectsData);
    }
    return objectsData;
  }
}
// endregion ProductFilterBuilder

// region ProductFields
class ProductFields {
  static TableField? _fId;
  static TableField get id {
    return _fId = _fId ?? SqlSyntax.setField(_fId, 'id', DbType.integer);
  }

  static TableField? _fName;
  static TableField get name {
    return _fName = _fName ?? SqlSyntax.setField(_fName, 'name', DbType.text);
  }

  static TableField? _fDescription;
  static TableField get description {
    return _fDescription = _fDescription ??
        SqlSyntax.setField(_fDescription, 'description', DbType.text);
  }

  static TableField? _fPrice;
  static TableField get price {
    return _fPrice =
        _fPrice ?? SqlSyntax.setField(_fPrice, 'price', DbType.real);
  }

  static TableField? _fIsActive;
  static TableField get isActive {
    return _fIsActive =
        _fIsActive ?? SqlSyntax.setField(_fIsActive, 'isActive', DbType.bool);
  }

  static TableField? _fCategoryId;
  static TableField get categoryId {
    return _fCategoryId = _fCategoryId ??
        SqlSyntax.setField(_fCategoryId, 'categoryId', DbType.integer);
  }

  static TableField? _fRownum;
  static TableField get rownum {
    return _fRownum =
        _fRownum ?? SqlSyntax.setField(_fRownum, 'rownum', DbType.integer);
  }

  static TableField? _fImageUrl;
  static TableField get imageUrl {
    return _fImageUrl =
        _fImageUrl ?? SqlSyntax.setField(_fImageUrl, 'imageUrl', DbType.text);
  }

  static TableField? _fDatetime;
  static TableField get datetime {
    return _fDatetime = _fDatetime ??
        SqlSyntax.setField(_fDatetime, 'datetime', DbType.datetime);
  }

  static TableField? _fDate;
  static TableField get date {
    return _fDate = _fDate ?? SqlSyntax.setField(_fDate, 'date', DbType.date);
  }

  static TableField? _fDateCreated;
  static TableField get dateCreated {
    return _fDateCreated = _fDateCreated ??
        SqlSyntax.setField(_fDateCreated, 'dateCreated', DbType.datetime);
  }

  static TableField? _fIsDeleted;
  static TableField get isDeleted {
    return _fIsDeleted = _fIsDeleted ??
        SqlSyntax.setField(_fIsDeleted, 'isDeleted', DbType.integer);
  }
}
// endregion ProductFields

//region ProductManager
class ProductManager extends SqfEntityProvider {
  ProductManager()
      : super(MyDbModel(),
            tableName: _tableName,
            primaryKeyList: _primaryKeyList,
            whereStr: _whereStr);
  static const String _tableName = 'product';
  static const List<String> _primaryKeyList = ['id'];
  static const String _whereStr = 'id=?';
}

//endregion ProductManager
// region Category
class Category extends TableBase {
  Category({this.id, this.name, this.isActive, this.dateCreated}) {
    _setDefaultValues();
    softDeleteActivated = false;
  }
  Category.withFields(this.name, this.isActive, this.dateCreated) {
    _setDefaultValues();
  }
  Category.withId(this.id, this.name, this.isActive, this.dateCreated) {
    _setDefaultValues();
  }
  // fromMap v2.0
  Category.fromMap(Map<String, dynamic> o, {bool setDefaultValues = true}) {
    if (setDefaultValues) {
      _setDefaultValues();
    }
    id = int.tryParse(o['id'].toString());
    if (o['name'] != null) {
      name = o['name'].toString();
    }
    if (o['isActive'] != null) {
      isActive =
          o['isActive'].toString() == '1' || o['isActive'].toString() == 'true';
    }
    if (o['dateCreated'] != null) {
      dateCreated = int.tryParse(o['dateCreated'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(o['dateCreated'].toString())!)
          : DateTime.tryParse(o['dateCreated'].toString());
    }
  }
  // FIELDS (Category)
  int? id;
  String? name;
  bool? isActive;
  DateTime? dateCreated;
  // end FIELDS (Category)

// COLLECTIONS & VIRTUALS (Category)
  /// to load children of items to this field, use preload parameter. Ex: toList(preload:true) or toSingle(preload:true) or getById(preload:true)
  /// You can also specify this object into certain preload fields!. Ex: toList(preload:true, preloadFields:['plProducts', 'plField2'..]) or so on..
  List<Product>? plProducts;

  /// get Product(s) filtered by id=categoryId
  ProductFilterBuilder? getProducts(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    if (id == null) {
      return null;
    }
    return Product()
        .select(columnsToSelect: columnsToSelect, getIsDeleted: getIsDeleted)
        .categoryId
        .equals(id)
        .and;
  }

// END COLLECTIONS & VIRTUALS (Category)

  static const bool _softDeleteActivated = false;
  CategoryManager? __mnCategory;

  CategoryManager get _mnCategory {
    return __mnCategory = __mnCategory ?? CategoryManager();
  }

  // METHODS
  @override
  Map<String, dynamic> toMap(
      {bool forQuery = false, bool forJson = false, bool forView = false}) {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (isActive != null) {
      map['isActive'] = forQuery ? (isActive! ? 1 : 0) : isActive;
    } else {
      map['isActive'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }

    return map;
  }

  @override
  Future<Map<String, dynamic>> toMapWithChildren(
      [bool forQuery = false,
      bool forJson = false,
      bool forView = false]) async {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (isActive != null) {
      map['isActive'] = forQuery ? (isActive! ? 1 : 0) : isActive;
    } else {
      map['isActive'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }

// COLLECTIONS (Category)
    if (!forQuery) {
      map['Products'] = await getProducts()!.toMapList();
    }
// END COLLECTIONS (Category)

    return map;
  }

  /// This method returns Json String [Category]
  @override
  String toJson() {
    return json.encode(toMap(forJson: true));
  }

  /// This method returns Json String [Category]
  @override
  Future<String> toJsonWithChilds() async {
    return json.encode(await toMapWithChildren(false, true));
  }

  @override
  List<dynamic> toArgs() {
    return [
      name,
      isActive,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
    ];
  }

  @override
  List<dynamic> toArgsWithIds() {
    return [
      id,
      name,
      isActive,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
    ];
  }

  static Future<List<Category>?> fromWebUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      return await fromJson(response.body);
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Category.fromWebUrl: ErrorMessage: ${e.toString()}');
      return null;
    }
  }

  Future<http.Response> postUrl(Uri uri, {Map<String, String>? headers}) {
    return http.post(uri, headers: headers, body: toJson());
  }

  static Future<List<Category>> fromJson(String jsonBody) async {
    final Iterable list = await json.decode(jsonBody) as Iterable;
    var objList = <Category>[];
    try {
      objList = list
          .map((category) => Category.fromMap(category as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Category.fromJson: ErrorMessage: ${e.toString()}');
    }
    return objList;
  }

  static Future<List<Category>> fromMapList(List<dynamic> data,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields,
      bool setDefaultValues = true}) async {
    final List<Category> objList = <Category>[];
    loadedFields = loadedFields ?? [];
    for (final map in data) {
      final obj = Category.fromMap(map as Map<String, dynamic>,
          setDefaultValues: setDefaultValues);
      // final List<String> _loadedFields = List<String>.from(loadedFields);

      // RELATIONSHIPS PRELOAD CHILD
      if (preload) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plProducts') && */ (preloadFields ==
                null ||
            preloadFields.contains('plProducts'))) {
          /*_loadedfields!.add('category.plProducts'); */ obj.plProducts =
              obj.plProducts ??
                  await obj.getProducts()!.toList(
                      preload: preload,
                      preloadFields: preloadFields,
                      loadParents: false /*, loadedFields:_loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD CHILD

      objList.add(obj);
    }
    return objList;
  }

  /// returns Category by ID if exist, otherwise returns null
  ///
  /// Primary Keys: int? id
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: getById(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: getById(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>returns [Category] if exist, otherwise returns null
  Future<Category?> getById(int? id,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    if (id == null) {
      return null;
    }
    Category? obj;
    final data = await _mnCategory.getById([id]);
    if (data.length != 0) {
      obj = Category.fromMap(data[0] as Map<String, dynamic>);
      // final List<String> _loadedFields = loadedFields ?? [];

      // RELATIONSHIPS PRELOAD CHILD
      if (preload) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plProducts') && */ (preloadFields ==
                null ||
            preloadFields.contains('plProducts'))) {
          /*_loadedfields!.add('category.plProducts'); */ obj.plProducts =
              obj.plProducts ??
                  await obj.getProducts()!.toList(
                      preload: preload,
                      preloadFields: preloadFields,
                      loadParents: false /*, loadedFields:_loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD CHILD

    } else {
      obj = null;
    }
    return obj;
  }

  /// Saves the (Category) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  /// <returns>Returns id
  @override
  Future<int?> save({bool ignoreBatch = true}) async {
    if (id == null || id == 0) {
      id = await _mnCategory.insert(this, ignoreBatch);
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnCategory.update(this);
    }

    return id;
  }

  /// Saves the (Category) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  ///
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  ///
  /// <returns>Returns id
  @override
  Future<int?> saveOrThrow({bool ignoreBatch = true}) async {
    if (id == null || id == 0) {
      id = await _mnCategory.insertOrThrow(this, ignoreBatch);

      isInsert = true;
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnCategory.updateOrThrow(this);
    }

    return id;
  }

  /// saveAs Category. Returns a new Primary Key value of Category

  /// <returns>Returns a new Primary Key value of Category
  @override
  Future<int?> saveAs({bool ignoreBatch = true}) async {
    id = null;

    return save(ignoreBatch: ignoreBatch);
  }

  @override
  void rollbackPk() {
    if (isInsert == true) {
      id = null;
    }
  }

  /// saveAll method saves the sent List<Category> as a bulk in one transaction
  ///
  /// Returns a <List<BoolResult>>
  static Future<List<dynamic>> saveAll(List<Category> categories) async {
    List<dynamic>? result = [];
    // If there is no open transaction, start one
    final isStartedBatch = await MyDbModel().batchStart();
    for (final obj in categories) {
      await obj.save(ignoreBatch: false);
    }
    if (!isStartedBatch) {
      result = await MyDbModel().batchCommit();
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].id == null) {
          categories[i].id = result![i] as int;
        }
      }
    }
    return result!;
  }

  /// Updates if the record exists, otherwise adds a new row

  /// <returns>Returns id
  @override
  Future<int?> upsert({bool ignoreBatch = true}) async {
    try {
      final result = await _mnCategory.rawInsert(
          'INSERT OR REPLACE INTO category (id, name, isActive, dateCreated)  VALUES (?,?,?,?)',
          [
            id,
            name,
            isActive,
            dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
          ],
          ignoreBatch);
      if (result! > 0) {
        saveResult = BoolResult(
            success: true,
            successMessage: 'Category id=$id updated successfully');
      } else {
        saveResult = BoolResult(
            success: false, errorMessage: 'Category id=$id did not update');
      }
      return id;
    } catch (e) {
      saveResult = BoolResult(
          success: false,
          errorMessage: 'Category Save failed. Error: ${e.toString()}');
      return null;
    }
  }

  /// inserts or replaces the sent List<<Category>> as a bulk in one transaction.
  ///
  /// upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero
  ///
  /// Returns a BoolCommitResult
  @override
  Future<BoolCommitResult> upsertAll(List<Category> categories) async {
    final results = await _mnCategory.rawInsertAll(
        'INSERT OR REPLACE INTO category (id, name, isActive, dateCreated)  VALUES (?,?,?,?)',
        categories);
    return results;
  }

  /// Deletes Category

  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    debugPrint('SQFENTITIY: delete Category invoked (id=$id)');
    var result = BoolResult(success: false);
    {
      result =
          await Product().select().categoryId.equals(id).and.delete(hardDelete);
    }
    if (!result.success) {
      return result;
    }
    if (!_softDeleteActivated || hardDelete) {
      return _mnCategory
          .delete(QueryParams(whereString: 'id=?', whereArguments: [id]));
    } else {
      return _mnCategory.updateBatch(
          QueryParams(whereString: 'id=?', whereArguments: [id]),
          {'isDeleted': 1});
    }
  }

  @override
  Future<BoolResult> recover([bool recoverChilds = true]) {
    // not implemented because:
    final msg =
        'set useSoftDeleting:true in the table definition of [Category] to use this feature';
    throw UnimplementedError(msg);
  }

  @override
  CategoryFilterBuilder select(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return CategoryFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect;
  }

  @override
  CategoryFilterBuilder distinct(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return CategoryFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect
      ..qparams.distinct = true;
  }

  void _setDefaultValues() {
    isActive = isActive ?? true;
    dateCreated = dateCreated ?? DateTime.now();
  }
  // END METHODS
  // BEGIN CUSTOM CODE
  /*
      you can define customCode property of your SqfEntityTable constant. For example:
      const tablePerson = SqfEntityTable(
      tableName: 'person',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
        SqfEntityField('firstName', DbType.text),
        SqfEntityField('lastName', DbType.text),
      ],
      customCode: '''
       String fullName()
       { 
         return '$firstName $lastName';
       }
      ''');
     */
  // END CUSTOM CODE
}
// endregion category

// region CategoryField
class CategoryField extends FilterBase {
  CategoryField(CategoryFilterBuilder categoryFB) : super(categoryFB);
  //DbParameter param = DbParameter();
  //String _waitingNot = '';
  //CategoryFilterBuilder categoryFB;

  @override
  CategoryFilterBuilder equals(dynamic pValue) {
    return super.equals(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder equalsOrNull(dynamic pValue) {
    return super.equalsOrNull(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder isNull() {
    return super.isNull() as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder contains(dynamic pValue) {
    return super.contains(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder startsWith(dynamic pValue) {
    return super.startsWith(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder endsWith(dynamic pValue) {
    return super.endsWith(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder between(dynamic pFirst, dynamic pLast) {
    return super.between(pFirst, pLast) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder greaterThan(dynamic pValue) {
    return super.greaterThan(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder lessThan(dynamic pValue) {
    return super.lessThan(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder greaterThanOrEquals(dynamic pValue) {
    return super.greaterThanOrEquals(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder lessThanOrEquals(dynamic pValue) {
    return super.lessThanOrEquals(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryFilterBuilder inValues(dynamic pValue) {
    return super.inValues(pValue) as CategoryFilterBuilder;
  }

  @override
  CategoryField get not {
    return super.not as CategoryField;
  }
}
// endregion CategoryField

// region CategoryFilterBuilder
class CategoryFilterBuilder extends ConjunctionBase {
  CategoryFilterBuilder(Category obj, bool? getIsDeleted)
      : super(obj, getIsDeleted) {
    // whereString = '';
    // groupByList = <String>[];
    // _addedBlocks.needEndBlock!.add(false);
    // _addedBlocks.waitingStartBlock!.add(false);
    // _obj = obj;
    _mnCategory = obj._mnCategory;
    _softDeleteActivated = obj.softDeleteActivated;
  }
  // AddedBlocks _addedBlocks= AddedBlocks(<bool>[], <bool>[]);
  // int _blockIndex = 0;
  // List<DbParameter> parameters= <DbParameter>[];
  // List<String> orderByList= <String>[];
  // Category? _obj;
  // QueryParams qparams= QueryParams();
  // int _pagesize=0;
  // int _page=0;

  bool _softDeleteActivated = false;
  CategoryManager? _mnCategory;

  /// put the sql keyword 'AND'
  @override
  CategoryFilterBuilder get and {
    super.and;
    return this;
  }

  /// put the sql keyword 'OR'
  @override
  CategoryFilterBuilder get or {
    super.or;
    return this;
  }

  /// open parentheses
  @override
  CategoryFilterBuilder get startBlock {
    super.startBlock;
    return this;
  }

  /// String whereCriteria, write raw query without 'where' keyword. Like this: 'field1 like 'test%' and field2 = 3'
  @override
  CategoryFilterBuilder where(String? whereCriteria, {dynamic parameterValue}) {
    super.where(whereCriteria, parameterValue: parameterValue);
    return this;
  }

  /// page = page number,
  ///
  /// pagesize = row(s) per page
  @override
  CategoryFilterBuilder page(int page, int pagesize) {
    super.page(page, pagesize);
    return this;
  }

  /// int count = LIMIT
  @override
  CategoryFilterBuilder top(int count) {
    super.top(count);
    return this;
  }

  /// close parentheses
  @override
  CategoryFilterBuilder get endBlock {
    super.endBlock;
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  CategoryFilterBuilder orderBy(dynamic argFields) {
    super.orderBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  CategoryFilterBuilder orderByDesc(dynamic argFields) {
    super.orderByDesc(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  CategoryFilterBuilder groupBy(dynamic argFields) {
    super.groupBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  CategoryFilterBuilder having(dynamic argFields) {
    super.having(argFields);
    return this;
  }

  CategoryField _setField(CategoryField? field, String colName, DbType dbtype) {
    return CategoryField(this)
      ..param = DbParameter(
          dbType: dbtype, columnName: colName, wStartBlock: openedBlock);
  }

  CategoryField? _id;
  CategoryField get id {
    return _id = _setField(_id, 'id', DbType.integer);
  }

  CategoryField? _name;
  CategoryField get name {
    return _name = _setField(_name, 'name', DbType.text);
  }

  CategoryField? _isActive;
  CategoryField get isActive {
    return _isActive = _setField(_isActive, 'isActive', DbType.bool);
  }

  CategoryField? _dateCreated;
  CategoryField get dateCreated {
    return _dateCreated =
        _setField(_dateCreated, 'dateCreated', DbType.datetime);
  }

  /// Deletes List<Category> bulk by query
  ///
  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    buildParameters();
    var r = BoolResult(success: false);
    // Delete sub records where in (Product) according to DeleteRule.CASCADE
    final idListProductBYcategoryId = toListPrimaryKeySQL(false);
    final resProductBYcategoryId = await Product()
        .select()
        .where('categoryId IN (${idListProductBYcategoryId['sql']})',
            parameterValue: idListProductBYcategoryId['args'])
        .delete(hardDelete);
    if (!resProductBYcategoryId.success) {
      return resProductBYcategoryId;
    }

    if (_softDeleteActivated && !hardDelete) {
      r = await _mnCategory!.updateBatch(qparams, {'isDeleted': 1});
    } else {
      r = await _mnCategory!.delete(qparams);
    }
    return r;
  }

  /// using:
  ///
  /// update({'fieldName': Value})
  ///
  /// fieldName must be String. Value is dynamic, it can be any of the (int, bool, String.. )
  @override
  Future<BoolResult> update(Map<String, dynamic> values) {
    buildParameters();
    if (qparams.limit! > 0 || qparams.offset! > 0) {
      qparams.whereString =
          'id IN (SELECT id from category ${qparams.whereString!.isNotEmpty ? 'WHERE ${qparams.whereString}' : ''}${qparams.limit! > 0 ? ' LIMIT ${qparams.limit}' : ''}${qparams.offset! > 0 ? ' OFFSET ${qparams.offset}' : ''})';
    }
    return _mnCategory!.updateBatch(qparams, values);
  }

  /// This method always returns [Category] Obj if exist, otherwise returns null
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Category?
  @override
  Future<Category?> toSingle(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    buildParameters(pSize: 1);
    final objFuture = _mnCategory!.toList(qparams);
    final data = await objFuture;
    Category? obj;
    if (data.isNotEmpty) {
      obj = Category.fromMap(data[0] as Map<String, dynamic>);
      // final List<String> _loadedFields = loadedFields ?? [];

      // RELATIONSHIPS PRELOAD CHILD
      if (preload) {
        loadedFields = loadedFields ?? [];
        if (/*!_loadedfields!.contains('category.plProducts') && */ (preloadFields ==
                null ||
            preloadFields.contains('plProducts'))) {
          /*_loadedfields!.add('category.plProducts'); */ obj.plProducts =
              obj.plProducts ??
                  await obj.getProducts()!.toList(
                      preload: preload,
                      preloadFields: preloadFields,
                      loadParents: false /*, loadedFields:_loadedFields*/);
        }
      } // END RELATIONSHIPS PRELOAD CHILD

    } else {
      obj = null;
    }
    return obj;
  }

  /// This method always returns [Category]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Category?
  @override
  Future<Category> toSingleOrDefault(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    return await toSingle(
            preload: preload,
            preloadFields: preloadFields,
            loadParents: loadParents,
            loadedFields: loadedFields) ??
        Category();
  }

  /// This method returns int. [Category]
  ///
  /// <returns>int
  @override
  Future<int> toCount([VoidCallback Function(int c)? categoryCount]) async {
    buildParameters();
    qparams.selectColumns = ['COUNT(1) AS CNT'];
    final categoriesFuture = await _mnCategory!.toList(qparams);
    final int count = categoriesFuture[0]['CNT'] as int;
    if (categoryCount != null) {
      categoryCount(count);
    }
    return count;
  }

  /// This method returns List<Category> [Category]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toList(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toList(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>List<Category>
  @override
  Future<List<Category>> toList(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    final data = await toMapList();
    final List<Category> categoriesData = await Category.fromMapList(data,
        preload: preload,
        preloadFields: preloadFields,
        loadParents: loadParents,
        loadedFields: loadedFields,
        setDefaultValues: qparams.selectColumns == null);
    return categoriesData;
  }

  /// This method returns Json String [Category]
  @override
  Future<String> toJson() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(o.toMap(forJson: true));
    }
    return json.encode(list);
  }

  /// This method returns Json String. [Category]
  @override
  Future<String> toJsonWithChilds() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(await o.toMapWithChildren(false, true));
    }
    return json.encode(list);
  }

  /// This method returns List<dynamic>. [Category]
  ///
  /// <returns>List<dynamic>
  @override
  Future<List<dynamic>> toMapList() async {
    buildParameters();
    return await _mnCategory!.toList(qparams);
  }

  /// Returns List<DropdownMenuItem<Category>>
  Future<List<DropdownMenuItem<Category>>> toDropDownMenu(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<Category>> o)?
          dropDownMenu]) async {
    buildParameters();
    final categoriesFuture = _mnCategory!.toList(qparams);

    final data = await categoriesFuture;
    final int count = data.length;
    final List<DropdownMenuItem<Category>> items = []..add(DropdownMenuItem(
        value: Category(),
        child: Text('Select Category'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: Category.fromMap(data[i] as Map<String, dynamic>),
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// Returns List<DropdownMenuItem<int>>
  Future<List<DropdownMenuItem<int>>> toDropDownMenuInt(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<int>> o)?
          dropDownMenu]) async {
    buildParameters();
    qparams.selectColumns = ['id', displayTextColumn];
    final categoriesFuture = _mnCategory!.toList(qparams);

    final data = await categoriesFuture;
    final int count = data.length;
    final List<DropdownMenuItem<int>> items = []..add(DropdownMenuItem(
        value: 0,
        child: Text('Select Category'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: data[i]['id'] as int,
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// This method returns Primary Key List SQL and Parameters retVal = Map<String,dynamic>. [Category]
  ///
  /// retVal['sql'] = SQL statement string, retVal['args'] = whereArguments List<dynamic>;
  ///
  /// <returns>List<String>
  @override
  Map<String, dynamic> toListPrimaryKeySQL([bool buildParams = true]) {
    final Map<String, dynamic> _retVal = <String, dynamic>{};
    if (buildParams) {
      buildParameters();
    }
    _retVal['sql'] = 'SELECT `id` FROM category WHERE ${qparams.whereString}';
    _retVal['args'] = qparams.whereArguments;
    return _retVal;
  }

  /// This method returns Primary Key List<int>.
  /// <returns>List<int>
  @override
  Future<List<int>> toListPrimaryKey([bool buildParams = true]) async {
    if (buildParams) {
      buildParameters();
    }
    final List<int> idData = <int>[];
    qparams.selectColumns = ['id'];
    final idFuture = await _mnCategory!.toList(qparams);

    final int count = idFuture.length;
    for (int i = 0; i < count; i++) {
      idData.add(idFuture[i]['id'] as int);
    }
    return idData;
  }

  /// Returns List<dynamic> for selected columns. Use this method for 'groupBy' with min,max,avg..  [Category]
  ///
  /// Sample usage: (see EXAMPLE 4.2 at https://github.com/hhtokpinar/sqfEntity#group-by)
  @override
  Future<List<dynamic>> toListObject() async {
    buildParameters();

    final objectFuture = _mnCategory!.toList(qparams);

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
  /// Sample usage: await Category.select(columnsToSelect: ['columnName']).toListString()
  @override
  Future<List<String>> toListString(
      [VoidCallback Function(List<String> o)? listString]) async {
    buildParameters();

    final objectFuture = _mnCategory!.toList(qparams);

    final List<String> objectsData = <String>[];
    final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i][qparams.selectColumns![0]].toString());
    }
    if (listString != null) {
      listString(objectsData);
    }
    return objectsData;
  }
}
// endregion CategoryFilterBuilder

// region CategoryFields
class CategoryFields {
  static TableField? _fId;
  static TableField get id {
    return _fId = _fId ?? SqlSyntax.setField(_fId, 'id', DbType.integer);
  }

  static TableField? _fName;
  static TableField get name {
    return _fName = _fName ?? SqlSyntax.setField(_fName, 'name', DbType.text);
  }

  static TableField? _fIsActive;
  static TableField get isActive {
    return _fIsActive =
        _fIsActive ?? SqlSyntax.setField(_fIsActive, 'isActive', DbType.bool);
  }

  static TableField? _fDateCreated;
  static TableField get dateCreated {
    return _fDateCreated = _fDateCreated ??
        SqlSyntax.setField(_fDateCreated, 'dateCreated', DbType.datetime);
  }
}
// endregion CategoryFields

//region CategoryManager
class CategoryManager extends SqfEntityProvider {
  CategoryManager()
      : super(MyDbModel(),
            tableName: _tableName,
            primaryKeyList: _primaryKeyList,
            whereStr: _whereStr);
  static const String _tableName = 'category';
  static const List<String> _primaryKeyList = ['id'];
  static const String _whereStr = 'id=?';
}

//endregion CategoryManager
// region Todo
class Todo extends TableBase {
  Todo({this.id, this.userId, this.title, this.completed, this.dateCreated}) {
    _setDefaultValues();
    softDeleteActivated = false;
  }
  Todo.withFields(
      this.id, this.userId, this.title, this.completed, this.dateCreated) {
    _setDefaultValues();
  }
  Todo.withId(
      this.id, this.userId, this.title, this.completed, this.dateCreated) {
    _setDefaultValues();
  }
  // fromMap v2.0
  Todo.fromMap(Map<String, dynamic> o, {bool setDefaultValues = true}) {
    if (setDefaultValues) {
      _setDefaultValues();
    }
    id = int.tryParse(o['id'].toString());
    if (o['userId'] != null) {
      userId = int.tryParse(o['userId'].toString());
    }
    if (o['title'] != null) {
      title = o['title'].toString();
    }
    if (o['completed'] != null) {
      completed = o['completed'].toString() == '1' ||
          o['completed'].toString() == 'true';
    }
    if (o['dateCreated'] != null) {
      dateCreated = int.tryParse(o['dateCreated'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(o['dateCreated'].toString())!)
          : DateTime.tryParse(o['dateCreated'].toString());
    }

    isSaved = true;
  }
  // FIELDS (Todo)
  int? id;
  int? userId;
  String? title;
  bool? completed;
  DateTime? dateCreated;
  bool? isSaved;
  // end FIELDS (Todo)

  static const bool _softDeleteActivated = false;
  TodoManager? __mnTodo;

  TodoManager get _mnTodo {
    return __mnTodo = __mnTodo ?? TodoManager();
  }

  // METHODS
  @override
  Map<String, dynamic> toMap(
      {bool forQuery = false, bool forJson = false, bool forView = false}) {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['title'] = title;
    if (completed != null) {
      map['completed'] = forQuery ? (completed! ? 1 : 0) : completed;
    } else {
      map['completed'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }

    return map;
  }

  @override
  Future<Map<String, dynamic>> toMapWithChildren(
      [bool forQuery = false,
      bool forJson = false,
      bool forView = false]) async {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['title'] = title;
    if (completed != null) {
      map['completed'] = forQuery ? (completed! ? 1 : 0) : completed;
    } else {
      map['completed'] = null;
    }
    if (dateCreated != null) {
      map['dateCreated'] = forJson
          ? dateCreated!.toString()
          : forQuery
              ? dateCreated!.millisecondsSinceEpoch
              : dateCreated;
    } else {
      map['dateCreated'] = null;
    }

    return map;
  }

  /// This method returns Json String [Todo]
  @override
  String toJson() {
    return json.encode(toMap(forJson: true));
  }

  /// This method returns Json String [Todo]
  @override
  Future<String> toJsonWithChilds() async {
    return json.encode(await toMapWithChildren(false, true));
  }

  @override
  List<dynamic> toArgs() {
    return [
      id,
      userId,
      title,
      completed,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
    ];
  }

  @override
  List<dynamic> toArgsWithIds() {
    return [
      id,
      userId,
      title,
      completed,
      dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
    ];
  }

  static Future<List<Todo>?> fromWeb({Map<String, String>? headers}) async {
    final objList = await fromWebUrl(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: headers);
    return objList;
  }

  Future<http.Response> post({Map<String, String>? headers}) async {
    final res = await postUrl(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: headers);
    return res;
  }

  static Future<List<Todo>?> fromWebUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      return await fromJson(response.body);
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Todo.fromWebUrl: ErrorMessage: ${e.toString()}');
      return null;
    }
  }

  Future<http.Response> postUrl(Uri uri, {Map<String, String>? headers}) {
    return http.post(uri, headers: headers, body: toJson());
  }

  static Future<List<Todo>> fromJson(String jsonBody) async {
    final Iterable list = await json.decode(jsonBody) as Iterable;
    var objList = <Todo>[];
    try {
      objList = list
          .map((todo) => Todo.fromMap(todo as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR Todo.fromJson: ErrorMessage: ${e.toString()}');
    }
    return objList;
  }

  static Future<List<Todo>> fromMapList(List<dynamic> data,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields,
      bool setDefaultValues = true}) async {
    final List<Todo> objList = <Todo>[];
    loadedFields = loadedFields ?? [];
    for (final map in data) {
      final obj = Todo.fromMap(map as Map<String, dynamic>,
          setDefaultValues: setDefaultValues);

      objList.add(obj);
    }
    return objList;
  }

  /// returns Todo by ID if exist, otherwise returns null
  ///
  /// Primary Keys: int? id
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: getById(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: getById(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>returns [Todo] if exist, otherwise returns null
  Future<Todo?> getById(int? id,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    if (id == null) {
      return null;
    }
    Todo? obj;
    final data = await _mnTodo.getById([id]);
    if (data.length != 0) {
      obj = Todo.fromMap(data[0] as Map<String, dynamic>);
    } else {
      obj = null;
    }
    return obj;
  }

  /// Saves the (Todo) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  /// <returns>Returns id
  @override
  Future<int?> save({bool ignoreBatch = true}) async {
    if (id == null || id == 0 || !isSaved!) {
      await _mnTodo.insert(this, ignoreBatch);
      if (saveResult!.success) {
        isSaved = true;
      }
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnTodo.update(this);
    }

    return id;
  }

  /// Saves the (Todo) object. If the id field is null, saves as a new record and returns new id, if id is not null then updates record
  ///
  /// ignoreBatch = true as a default. Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit
  ///
  /// <returns>Returns id
  @override
  Future<int?> saveOrThrow({bool ignoreBatch = true}) async {
    if (id == null || id == 0 || !isSaved!) {
      await _mnTodo.insertOrThrow(this, ignoreBatch);
      if (saveResult != null && saveResult!.success) {
        isSaved = true;
      }
      isInsert = true;
    } else {
      // id= await _upsert(); // removed in sqfentity_gen 1.3.0+6
      await _mnTodo.updateOrThrow(this);
    }

    return id;
  }

  @override
  void rollbackPk() {
    if (isInsert == true) {
      id = null;
    }
  }

  /// saveAll method saves the sent List<Todo> as a bulk in one transaction
  ///
  /// Returns a <List<BoolResult>>
  static Future<List<dynamic>> saveAll(List<Todo> todos) async {
    List<dynamic>? result = [];
    // If there is no open transaction, start one
    final isStartedBatch = await MyDbModel().batchStart();
    for (final obj in todos) {
      await obj.save(ignoreBatch: false);
    }
    if (!isStartedBatch) {
      result = await MyDbModel().batchCommit();
    }
    return result!;
  }

  /// Updates if the record exists, otherwise adds a new row

  /// <returns>Returns id
  @override
  Future<int?> upsert({bool ignoreBatch = true}) async {
    try {
      final result = await _mnTodo.rawInsert(
          'INSERT OR REPLACE INTO todos (id, userId, title, completed, dateCreated)  VALUES (?,?,?,?,?)',
          [
            id,
            userId,
            title,
            completed,
            dateCreated != null ? dateCreated!.millisecondsSinceEpoch : null
          ],
          ignoreBatch);
      if (result! > 0) {
        saveResult = BoolResult(
            success: true, successMessage: 'Todo id=$id updated successfully');
      } else {
        saveResult = BoolResult(
            success: false, errorMessage: 'Todo id=$id did not update');
      }
      return id;
    } catch (e) {
      saveResult = BoolResult(
          success: false,
          errorMessage: 'Todo Save failed. Error: ${e.toString()}');
      return null;
    }
  }

  /// inserts or replaces the sent List<<Todo>> as a bulk in one transaction.
  ///
  /// upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero
  ///
  /// Returns a BoolCommitResult
  @override
  Future<BoolCommitResult> upsertAll(List<Todo> todos) async {
    final results = await _mnTodo.rawInsertAll(
        'INSERT OR REPLACE INTO todos (id, userId, title, completed, dateCreated)  VALUES (?,?,?,?,?)',
        todos);
    return results;
  }

  /// Deletes Todo

  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    debugPrint('SQFENTITIY: delete Todo invoked (id=$id)');
    if (!_softDeleteActivated || hardDelete) {
      return _mnTodo
          .delete(QueryParams(whereString: 'id=?', whereArguments: [id]));
    } else {
      return _mnTodo.updateBatch(
          QueryParams(whereString: 'id=?', whereArguments: [id]),
          {'isDeleted': 1});
    }
  }

  @override
  Future<BoolResult> recover([bool recoverChilds = true]) {
    // not implemented because:
    final msg =
        'set useSoftDeleting:true in the table definition of [Todo] to use this feature';
    throw UnimplementedError(msg);
  }

  @override
  TodoFilterBuilder select(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return TodoFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect;
  }

  @override
  TodoFilterBuilder distinct(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return TodoFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect
      ..qparams.distinct = true;
  }

  void _setDefaultValues() {
    isSaved = false;
    completed = completed ?? false;
    dateCreated = dateCreated ?? DateTime.now();
  }
  // END METHODS
  // BEGIN CUSTOM CODE
  /*
      you can define customCode property of your SqfEntityTable constant. For example:
      const tablePerson = SqfEntityTable(
      tableName: 'person',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
        SqfEntityField('firstName', DbType.text),
        SqfEntityField('lastName', DbType.text),
      ],
      customCode: '''
       String fullName()
       { 
         return '$firstName $lastName';
       }
      ''');
     */
  // END CUSTOM CODE
}
// endregion todo

// region TodoField
class TodoField extends FilterBase {
  TodoField(TodoFilterBuilder todoFB) : super(todoFB);
  //DbParameter param = DbParameter();
  //String _waitingNot = '';
  //TodoFilterBuilder todoFB;

  @override
  TodoFilterBuilder equals(dynamic pValue) {
    return super.equals(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder equalsOrNull(dynamic pValue) {
    return super.equalsOrNull(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder isNull() {
    return super.isNull() as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder contains(dynamic pValue) {
    return super.contains(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder startsWith(dynamic pValue) {
    return super.startsWith(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder endsWith(dynamic pValue) {
    return super.endsWith(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder between(dynamic pFirst, dynamic pLast) {
    return super.between(pFirst, pLast) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder greaterThan(dynamic pValue) {
    return super.greaterThan(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder lessThan(dynamic pValue) {
    return super.lessThan(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder greaterThanOrEquals(dynamic pValue) {
    return super.greaterThanOrEquals(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder lessThanOrEquals(dynamic pValue) {
    return super.lessThanOrEquals(pValue) as TodoFilterBuilder;
  }

  @override
  TodoFilterBuilder inValues(dynamic pValue) {
    return super.inValues(pValue) as TodoFilterBuilder;
  }

  @override
  TodoField get not {
    return super.not as TodoField;
  }
}
// endregion TodoField

// region TodoFilterBuilder
class TodoFilterBuilder extends ConjunctionBase {
  TodoFilterBuilder(Todo obj, bool? getIsDeleted) : super(obj, getIsDeleted) {
    // whereString = '';
    // groupByList = <String>[];
    // _addedBlocks.needEndBlock!.add(false);
    // _addedBlocks.waitingStartBlock!.add(false);
    // _obj = obj;
    _mnTodo = obj._mnTodo;
    _softDeleteActivated = obj.softDeleteActivated;
  }
  // AddedBlocks _addedBlocks= AddedBlocks(<bool>[], <bool>[]);
  // int _blockIndex = 0;
  // List<DbParameter> parameters= <DbParameter>[];
  // List<String> orderByList= <String>[];
  // Todo? _obj;
  // QueryParams qparams= QueryParams();
  // int _pagesize=0;
  // int _page=0;

  bool _softDeleteActivated = false;
  TodoManager? _mnTodo;

  /// put the sql keyword 'AND'
  @override
  TodoFilterBuilder get and {
    super.and;
    return this;
  }

  /// put the sql keyword 'OR'
  @override
  TodoFilterBuilder get or {
    super.or;
    return this;
  }

  /// open parentheses
  @override
  TodoFilterBuilder get startBlock {
    super.startBlock;
    return this;
  }

  /// String whereCriteria, write raw query without 'where' keyword. Like this: 'field1 like 'test%' and field2 = 3'
  @override
  TodoFilterBuilder where(String? whereCriteria, {dynamic parameterValue}) {
    super.where(whereCriteria, parameterValue: parameterValue);
    return this;
  }

  /// page = page number,
  ///
  /// pagesize = row(s) per page
  @override
  TodoFilterBuilder page(int page, int pagesize) {
    super.page(page, pagesize);
    return this;
  }

  /// int count = LIMIT
  @override
  TodoFilterBuilder top(int count) {
    super.top(count);
    return this;
  }

  /// close parentheses
  @override
  TodoFilterBuilder get endBlock {
    super.endBlock;
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  TodoFilterBuilder orderBy(dynamic argFields) {
    super.orderBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  TodoFilterBuilder orderByDesc(dynamic argFields) {
    super.orderByDesc(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='field1, field2'
  ///
  /// Example 2: argFields = ['field1', 'field2']
  @override
  TodoFilterBuilder groupBy(dynamic argFields) {
    super.groupBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  ///
  /// Example 1: argFields='name, date'
  ///
  /// Example 2: argFields = ['name', 'date']
  @override
  TodoFilterBuilder having(dynamic argFields) {
    super.having(argFields);
    return this;
  }

  TodoField _setField(TodoField? field, String colName, DbType dbtype) {
    return TodoField(this)
      ..param = DbParameter(
          dbType: dbtype, columnName: colName, wStartBlock: openedBlock);
  }

  TodoField? _id;
  TodoField get id {
    return _id = _setField(_id, 'id', DbType.integer);
  }

  TodoField? _userId;
  TodoField get userId {
    return _userId = _setField(_userId, 'userId', DbType.integer);
  }

  TodoField? _title;
  TodoField get title {
    return _title = _setField(_title, 'title', DbType.text);
  }

  TodoField? _completed;
  TodoField get completed {
    return _completed = _setField(_completed, 'completed', DbType.bool);
  }

  TodoField? _dateCreated;
  TodoField get dateCreated {
    return _dateCreated =
        _setField(_dateCreated, 'dateCreated', DbType.datetime);
  }

  /// Deletes List<Todo> bulk by query
  ///
  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    buildParameters();
    var r = BoolResult(success: false);

    if (_softDeleteActivated && !hardDelete) {
      r = await _mnTodo!.updateBatch(qparams, {'isDeleted': 1});
    } else {
      r = await _mnTodo!.delete(qparams);
    }
    return r;
  }

  /// using:
  ///
  /// update({'fieldName': Value})
  ///
  /// fieldName must be String. Value is dynamic, it can be any of the (int, bool, String.. )
  @override
  Future<BoolResult> update(Map<String, dynamic> values) {
    buildParameters();
    if (qparams.limit! > 0 || qparams.offset! > 0) {
      qparams.whereString =
          'id IN (SELECT id from todos ${qparams.whereString!.isNotEmpty ? 'WHERE ${qparams.whereString}' : ''}${qparams.limit! > 0 ? ' LIMIT ${qparams.limit}' : ''}${qparams.offset! > 0 ? ' OFFSET ${qparams.offset}' : ''})';
    }
    return _mnTodo!.updateBatch(qparams, values);
  }

  /// This method always returns [Todo] Obj if exist, otherwise returns null
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Todo?
  @override
  Future<Todo?> toSingle(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    buildParameters(pSize: 1);
    final objFuture = _mnTodo!.toList(qparams);
    final data = await objFuture;
    Todo? obj;
    if (data.isNotEmpty) {
      obj = Todo.fromMap(data[0] as Map<String, dynamic>);
    } else {
      obj = null;
    }
    return obj;
  }

  /// This method always returns [Todo]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toSingle(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns> Todo?
  @override
  Future<Todo> toSingleOrDefault(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    return await toSingle(
            preload: preload,
            preloadFields: preloadFields,
            loadParents: loadParents,
            loadedFields: loadedFields) ??
        Todo();
  }

  /// This method returns int. [Todo]
  ///
  /// <returns>int
  @override
  Future<int> toCount([VoidCallback Function(int c)? todoCount]) async {
    buildParameters();
    qparams.selectColumns = ['COUNT(1) AS CNT'];
    final todosFuture = await _mnTodo!.toList(qparams);
    final int count = todosFuture[0]['CNT'] as int;
    if (todoCount != null) {
      todoCount(count);
    }
    return count;
  }

  /// This method returns List<Todo> [Todo]
  ///
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  ///
  /// ex: toList(preload:true) -> Loads all related objects
  ///
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  ///
  /// ex: toList(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  ///
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  ///
  /// <returns>List<Todo>
  @override
  Future<List<Todo>> toList(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    final data = await toMapList();
    final List<Todo> todosData = await Todo.fromMapList(data,
        preload: preload,
        preloadFields: preloadFields,
        loadParents: loadParents,
        loadedFields: loadedFields,
        setDefaultValues: qparams.selectColumns == null);
    return todosData;
  }

  /// This method returns Json String [Todo]
  @override
  Future<String> toJson() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(o.toMap(forJson: true));
    }
    return json.encode(list);
  }

  /// This method returns Json String. [Todo]
  @override
  Future<String> toJsonWithChilds() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(await o.toMapWithChildren(false, true));
    }
    return json.encode(list);
  }

  /// This method returns List<dynamic>. [Todo]
  ///
  /// <returns>List<dynamic>
  @override
  Future<List<dynamic>> toMapList() async {
    buildParameters();
    return await _mnTodo!.toList(qparams);
  }

  /// Returns List<DropdownMenuItem<Todo>>
  Future<List<DropdownMenuItem<Todo>>> toDropDownMenu(String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<Todo>> o)?
          dropDownMenu]) async {
    buildParameters();
    final todosFuture = _mnTodo!.toList(qparams);

    final data = await todosFuture;
    final int count = data.length;
    final List<DropdownMenuItem<Todo>> items = []..add(DropdownMenuItem(
        value: Todo(),
        child: Text('Select Todo'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: Todo.fromMap(data[i] as Map<String, dynamic>),
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// Returns List<DropdownMenuItem<int>>
  Future<List<DropdownMenuItem<int>>> toDropDownMenuInt(
      String displayTextColumn,
      [VoidCallback Function(List<DropdownMenuItem<int>> o)?
          dropDownMenu]) async {
    buildParameters();
    qparams.selectColumns = ['id', displayTextColumn];
    final todosFuture = _mnTodo!.toList(qparams);

    final data = await todosFuture;
    final int count = data.length;
    final List<DropdownMenuItem<int>> items = []..add(DropdownMenuItem(
        value: 0,
        child: Text('Select Todo'),
      ));
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: data[i]['id'] as int,
          child: Text(data[i][displayTextColumn].toString()),
        ),
      );
    }
    if (dropDownMenu != null) {
      dropDownMenu(items);
    }
    return items;
  }

  /// This method returns Primary Key List SQL and Parameters retVal = Map<String,dynamic>. [Todo]
  ///
  /// retVal['sql'] = SQL statement string, retVal['args'] = whereArguments List<dynamic>;
  ///
  /// <returns>List<String>
  @override
  Map<String, dynamic> toListPrimaryKeySQL([bool buildParams = true]) {
    final Map<String, dynamic> _retVal = <String, dynamic>{};
    if (buildParams) {
      buildParameters();
    }
    _retVal['sql'] = 'SELECT `id` FROM todos WHERE ${qparams.whereString}';
    _retVal['args'] = qparams.whereArguments;
    return _retVal;
  }

  /// This method returns Primary Key List<int>.
  /// <returns>List<int>
  @override
  Future<List<int>> toListPrimaryKey([bool buildParams = true]) async {
    if (buildParams) {
      buildParameters();
    }
    final List<int> idData = <int>[];
    qparams.selectColumns = ['id'];
    final idFuture = await _mnTodo!.toList(qparams);

    final int count = idFuture.length;
    for (int i = 0; i < count; i++) {
      idData.add(idFuture[i]['id'] as int);
    }
    return idData;
  }

  /// Returns List<dynamic> for selected columns. Use this method for 'groupBy' with min,max,avg..  [Todo]
  ///
  /// Sample usage: (see EXAMPLE 4.2 at https://github.com/hhtokpinar/sqfEntity#group-by)
  @override
  Future<List<dynamic>> toListObject() async {
    buildParameters();

    final objectFuture = _mnTodo!.toList(qparams);

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
  /// Sample usage: await Todo.select(columnsToSelect: ['columnName']).toListString()
  @override
  Future<List<String>> toListString(
      [VoidCallback Function(List<String> o)? listString]) async {
    buildParameters();

    final objectFuture = _mnTodo!.toList(qparams);

    final List<String> objectsData = <String>[];
    final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i][qparams.selectColumns![0]].toString());
    }
    if (listString != null) {
      listString(objectsData);
    }
    return objectsData;
  }
}
// endregion TodoFilterBuilder

// region TodoFields
class TodoFields {
  static TableField? _fId;
  static TableField get id {
    return _fId = _fId ?? SqlSyntax.setField(_fId, 'id', DbType.integer);
  }

  static TableField? _fUserId;
  static TableField get userId {
    return _fUserId =
        _fUserId ?? SqlSyntax.setField(_fUserId, 'userId', DbType.integer);
  }

  static TableField? _fTitle;
  static TableField get title {
    return _fTitle =
        _fTitle ?? SqlSyntax.setField(_fTitle, 'title', DbType.text);
  }

  static TableField? _fCompleted;
  static TableField get completed {
    return _fCompleted = _fCompleted ??
        SqlSyntax.setField(_fCompleted, 'completed', DbType.bool);
  }

  static TableField? _fDateCreated;
  static TableField get dateCreated {
    return _fDateCreated = _fDateCreated ??
        SqlSyntax.setField(_fDateCreated, 'dateCreated', DbType.datetime);
  }
}
// endregion TodoFields

//region TodoManager
class TodoManager extends SqfEntityProvider {
  TodoManager()
      : super(MyDbModel(),
            tableName: _tableName,
            primaryKeyList: _primaryKeyList,
            whereStr: _whereStr);
  static const String _tableName = 'todos';
  static const List<String> _primaryKeyList = ['id'];
  static const String _whereStr = 'id=?';
}

//endregion TodoManager
/// Region SEQUENCE IdentitySequence
class IdentitySequence {
  /// Assigns a new value when it is triggered and returns the new value
  /// returns Future<int>
  Future<int> nextVal([VoidCallback Function(int o)? nextval]) async {
    final val = await MyDbModelSequenceManager()
        .sequence(SequenceIdentitySequence.getInstance, true);
    if (nextval != null) {
      nextval(val);
    }
    return val;
  }

  /// Get the current value
  /// returns Future<int>
  Future<int> currentVal([VoidCallback Function(int o)? currentval]) async {
    final val = await MyDbModelSequenceManager()
        .sequence(SequenceIdentitySequence.getInstance, false);
    if (currentval != null) {
      currentval(val);
    }
    return val;
  }

  /// Reset sequence to start value
  /// returns start value
  Future<int> reset([VoidCallback Function(int o)? currentval]) async {
    final val = await MyDbModelSequenceManager()
        .sequence(SequenceIdentitySequence.getInstance, false, reset: true);
    if (currentval != null) {
      currentval(val);
    }
    return val;
  }
}

/// End Region SEQUENCE IdentitySequence

class MyDbModelSequenceManager extends SqfEntityProvider {
  MyDbModelSequenceManager() : super(MyDbModel());
}
// END OF ENTITIES
