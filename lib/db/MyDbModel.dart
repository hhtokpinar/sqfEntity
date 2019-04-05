import 'package:sqfentity/db/SqfEntityBase.dart';

// STEP 1: define your tables as shown in the example Method below.
/// create getter methods for your own tables like tableCategory, tablePerson.. etc and add them to the databaseTables property similar to the example below

// Define the "TableCategory" sample table as extended from "SqfEntityTable".
class TableCategory extends SqfEntityTable {
  TableCategory() {
    // declare properties of EntityTable
    tableName = "category";
    modelName =
        null; // when the modelName (class name) is null then EntityBase uses TableName as modelName
    primaryKeyName = "id";
    useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityField("name", DbType.text),
      SqfEntityField("isActive", DbType.bool, defaultValue: "true")
    ];

    init();
  }
  
}

// Define the "TableProduct"  sample table as extended from "SqfEntityTable".
class TableProduct extends SqfEntityTable {
  TableProduct() {
// declare properties of EntityTable
    tableName = "product";
    primaryKeyName = "id";
    useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityField("name", DbType.text),
      SqfEntityField("description", DbType.text),
      SqfEntityField("price", DbType.real, defaultValue: "0"),
      SqfEntityField("isActive", DbType.bool, defaultValue: "true"),
      SqfEntityFieldRelationship(MyRepository.tableCategory,
          defaultValue: "0"), // Relationship column for CategoryId of Product
    ];

    init();
  }

  
}

// STEP 2: Create Repository to provide access to models with Singleton pattern

class MyRepository {
  static SqfEntityTable _tableProduct;
  static SqfEntityTable _tableCategory;
  static SqfEntityTable get tableProduct {
    if (_tableProduct == null) {
      _tableProduct = new TableProduct();
    }
    return _tableProduct;
  }

  static SqfEntityTable get tableCategory {
    if (_tableCategory == null) {
      _tableCategory = new TableCategory();
    }
    return _tableCategory;
  }
}



// STEP 3: Create your Database Model to be implemented SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
class MyDbModel extends SqfEntityModel {
  MyDbModel() {
    databaseName = "sampleORM38.db";
    databaseTables = [
      MyRepository.tableProduct,
      MyRepository.tableCategory
    ]; // put defined tables into the list. ex: [tableProduct(),tableCategories(),tablePerson()]
    bundledDatabasePath =
        null; // "assets/sample.db"; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  }
}

