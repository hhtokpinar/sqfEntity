import 'package:sqfentity/db/SqfEntityBase.dart';

// STEP 1: define your tables as shown in the example Classes below.
// Define the "TableCategory" sample table as extended from "SqfEntityTable".
class TableCategory extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableCategory();
    return _instance;
  }

  TableCategory() {
    // declare properties of EntityTable
    tableName = "category";
    modelName =
        null; // If the modelName (class name) is null then EntityBase uses TableName instead of modelName
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;

    // declare fields
    fields = [
      SqfEntityField("name", DbType.text),
      SqfEntityField("isActive", DbType.bool, defaultValue: "true")
    ];

    super.init();
  }
}

// Define the "TableProduct"  sample table as extended from "SqfEntityTable".
class TableProduct extends SqfEntityTable {
  static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) _instance = TableProduct();
    return _instance;
  }

  TableProduct() {
    // declare properties of EntityTable
    tableName = "product";
    primaryKeyName = "id";
    primaryKeyisIdentity = true;
    useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityField("name", DbType.text),
      SqfEntityField("description", DbType.text),
      SqfEntityField("price", DbType.real, defaultValue: "0"),
      SqfEntityField("isActive", DbType.bool, defaultValue: "true"),
      SqfEntityFieldRelationship(TableCategory.getInstance, DeleteRule.CASCADE,
          defaultValue: "0"), // Relationship column for CategoryId of Product
      SqfEntityField("rownum", DbType.integer, defaultValue: "0"),
    ];
    super.init();
  }
}

class TableTodo extends SqfEntityTable {
  static SqfEntityTable __instance;
  static SqfEntityTable get getInstance {
    if (__instance == null) __instance = TableTodo();
    return __instance;
  }

  TableTodo() {
    // declare properties of EntityTable
    tableName = "todos";
    modelName =
        null; // when the modelName (class name) is null then EntityBase uses TableName instead of modelName
    primaryKeyName = "id";
    useSoftDeleting =
        false; // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)
    primaryKeyisIdentity = false;
    defaultJsonUrl =
        "https://jsonplaceholder.typicode.com/todos"; // optional: to synchronize your table with json data from webUrl

    // declare fields
    fields = [
      SqfEntityField("userId", DbType.integer),
      SqfEntityField("title", DbType.text),
      SqfEntityField("completed", DbType.bool, defaultValue: "false")
    ];

    super.init();
  }
}

// STEP 2: Create your Database Model to be extended from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
class MyDbModel extends SqfEntityModel {
  MyDbModel() {
    databaseName = "sampleORM.db";
    databaseTables = [
      TableProduct.getInstance,
      TableCategory.getInstance,
      TableTodo.getInstance
    ]; // put defined tables into the list. ex: [TableProduct.getInstance, TableCategory.getInstance]
    bundledDatabasePath = 
        null; // "assets/sample.db"; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  }
}
