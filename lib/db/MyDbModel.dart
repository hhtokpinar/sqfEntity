import 'package:sqfentity/db/SqfEntityBase.dart';

// STEP 1: define your tables as shown in the example Method below.
/// create getter methods for your own tables like tableCategory, tablePerson.. etc and add them to the databaseTables property similar to the example below

// declare sample table tableCategory
SqfEntityTable tableCategory() {
  // declare properties of EntityTable

  String tableName = "category";
  String primaryKeyName = "id";
  bool useSoftDeleting = true;
  // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

  // declare EntityTable with table fields
  SqfEntityTable table = new SqfEntityTable(
      tableName,
      primaryKeyName,
      [
        SqfEntityField("name", DbType.text),
        SqfEntityField("isActive", DbType.bool, defaultValue: "true")
      ],
      useSoftDeleting);
  return table;
}

// declare sample table tableProduct
SqfEntityTable tableProduct() {
  // declare properties of EntityTable

  String tableName = "product";
  String primaryKeyName = "id";
  bool useSoftDeleting = true;
  // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

  // declare EntityTable with table fields
  SqfEntityTable table = new SqfEntityTable(
      tableName,
      primaryKeyName,
      [
        SqfEntityFieldRelationship(tableCategory(), defaultValue: "0"),
        SqfEntityField("name", DbType.text),
        SqfEntityField("description", DbType.text),
        SqfEntityField("price", DbType.real, defaultValue: "0"),
        SqfEntityField("isActive", DbType.bool, defaultValue: "true"),
      ],
      useSoftDeleting);
  return table;
}

// STEP 2: Create your Database Model to be implemented SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
class MyDbModel extends SqfEntityModel {
  MyDbModel() {
    databaseName = "sampleORM.db";
    databaseTables = [
      tableProduct(),
      tableCategory()
    ]; // put defined tables into the list. ex: [tableProduct(),tableCategories(),tablePerson()]
    bundledDatabasePath =
       null; // "assets/sample.db"; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  }
 
}
