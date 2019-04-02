import 'package:sqfentity/db/SqfEntityBase.dart';
import 'package:sqfentity/db/SqfEntityDbContext.dart';


class MyDbModel {

  // STEPS CREATE FOR YOUR DB CONTEXT

  // 1. declare your sqlite database name
  static const String databaseName = "sample.db";

  // 2. define your tables as shown in the example Method below.
  /// create getter methods for your own tables like tableCategory, tablePerson.. etc and add them to the databaseTables property similar to the example below
  static SqfEntityTable get tableProduct {
    // declare properties of EntityTable

    String tableName = "product";
    String primaryKeyName = "id";
    bool useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named "isDeleted" on the table, and set to "1" this field when item deleted (does not hard delete)

    // declare EntityFields List for EntityTable
    List<SqfEntityField> fields = new List<SqfEntityField>();

    // Please add your table fields instead of following dummy fields..
    fields.add(SqfEntityField("name", DbType.text));
    fields.add(SqfEntityField("description", DbType.text));
    fields.add(SqfEntityField("price", DbType.real, defaultValue: "0"));
    fields.add(SqfEntityField("isActive", DbType.bool, defaultValue: "true"));

    // declare EntityTable
    SqfEntityTable table =
        new SqfEntityTable(tableName, primaryKeyName, fields, useSoftDeleting);
    return table;
  }

  // 3. Add the object you defined above to your list of database tables.
  static List<SqfEntityTable> get databaseTables {
    var _dbTables = new List<SqfEntityTable>();
    _dbTables.add(tableProduct);
    //_databaseTables.add(table2());
    // ...
    // ADD YOUR DECLARETED SqfEntityTable HERE
    return _dbTables;
  }

  // that's all.. one more step left for create models.dart file.
  // ATTENTION: Defining the table here provides automatic processing for database configuration only.
  // you may call the SqfEntityDbContext.createModel(MyDbModel.databaseTables) function to create your model and use it in your project



}