# sqfEntity ORM for Flutter

![Sqf Entity ORM Preview](/assets/img/SqfEntity_ORM.gif) 

SqfEntity is based on SQFlite plugin and lets you build and execute SQL commands easily and quickly with the help of fluent methods similar to .Net Entity Framework

Leave the job to SqfEntitiy for CRUD operations. Do easily and faster adding tables, adding columns, defining multiple tables, soft deleting, recovery, syncronize data from the web and more with the help of SqfEntityTable class.

If you have a bundled database, you can use it or EntityBase will create a new database automatically for you.

Open downloaded folder named sqfentity-master in VSCode and Click "Get Packages" button in the alert window that "Some packages are missing or out of date, would you like to get them now?"

## Getting Started

This project is a starting point for a SqfEntity ORM for database application.
There are 7 files in the project

    1. main.dart                    : Startup file contains sample methods for using sqfEntity
    2. models / MyDbModel.dart      : Declare and modify your database model
    3. models / models.dart         : Sample created model for examples
    4. assets / sample.db           : Sample db if you want to use an exiting db
    5. app.dart                     : Sample App for display created model. (will be updated later.)
    6. LICENSE.txt                  : see this file for License Terms


### dependencies:

    dependencies:
      sqfentity: any


# Create a new Database Model

First, create your dbmodel.dart file to define your model and import sqfentity.dart 

    import 'package:sqfentity/sqfentity.dart';

**STEP 1:** define your tables as shown in the example Classes below.
 For example, we have created 3 tables for category,product and todo that extended from "SqfEntityTable" as follows:


*Table 1: Category*

    class TableCategory extends SqfEntityTable {
    TableCategory() {
    // declare properties of EntityTable
    tableName = "category";
    modelName = null; // If the modelName (class name) is null then EntityBase uses TableName instead of modelName
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
    static SqfEntityTable _instance;
      static SqfEntityTable get getInstance {
        if (_instance == null) {
          _instance = TableCategory();
        }
        return _instance;
      }
    }

If **useSoftDeleting** is true then, The builder engine creates a field named "isDeleted" on the table.
When item was deleted then this field value is changed to "1"  (does not hard delete)
in this case it is possible to recover a deleted item using the recover() method.
If the **modelName** (class name) is null then EntityBase uses TableName instead of modelName

*Table 2: Product*

    class TableProduct extends SqfEntityTable {
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
    static SqfEntityTable _instance;
    static SqfEntityTable get getInstance {
    if (_instance == null) {
      _instance = TableProduct();
    }
    return _instance;
    }}

If this table (Product) is the child of a parent table (Category), you must declare the SqfEntityFieldRelationship column into fields for Object Relational Mapping.
You can choose one of the following for DeleteRule: **CASCADE, NO ACTION, SET NULL, SET DEFAULT VALUE**
For more information about the rules [Click here](https://www.mssqltips.com/sqlservertip/2365/sql-server-foreign-key-update-and-delete-rules/)

*Table 3: Todo*

This table is for creating a synchronization with json data from the web url

    class TableTodo extends SqfEntityTable {
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
    static SqfEntityTable __instance;
    static SqfEntityTable get getInstance {
    if (__instance == null) {
      __instance = TableTodo();
    }
    return __instance;
    }}


### 2. Add your table objects you defined above to your dbModel

**STEP 2**: Create your Database Model to be extended from SqfEntityModel
*Note:* SqfEntity provides support for the use of **multiple databases**.
So you can create many Database Models and use them in your application.

    class MyDbModel extends SqfEntityModel {
    MyDbModel() {
    databaseName = "sampleORM.db";
    databaseTables = [
      TableProduct.getInstance,
      TableCategory.getInstance,
      TableTodo.getInstance,
    ]; // put defined tables into the list. ex: [TableProduct.getInstance, TableCategory.getInstance]
    bundledDatabasePath =
        null; // "assets/sample.db"; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
    }}


That's all.. one more step left for create models.dart file.

### Attach existing SQLite database with bundledDatabasePath parameter
  *bundledDatabasePath* is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
  
   **ATTENTION:** Defining the tables here provides automatic processing for database configuration only.
   Use the following function to create your model and use it in your project

  To get the your classes (models) from the clipboard, just type 
  
    MyDbModel.createModel(); 
    
  This function sets the Clipboard text that includes your classes (After debugging, press Ctrl+V to paste the model from the Clipboard)
  That's all.. You can paste your model in your .dart file by pressing Ctrl+V for PC or Command+V for Mac and reference it where you wish to use.

  
### Database initializer async method
When the software/app is started, you must check the database was it initialized.
If needed, initilizeDb method runs that CREATE TABLE / ALTER TABLE ADD COLUMN queries for you.

    final bool isInitialized = await MyDbModel().initializeDB();
      if (isInitialized == true)
      {
        runSamples();
        // TO DO
        // ex: runApp(MyApp());
      } 
      else {
       // If the database is not initialized, something went wrong. Check DEBUG CONSOLE for alerts
       // TO DO
      }
    }
    
 If result is **true**, the database is ready to use

## That's Great! now we can use our created new models

Let's add some record to the "Category" table

*Note: save() method returns the primary id of the added record*

    final notebookCategoryId = await Category(name: "Notebooks", isActive: true).save();
    
    // or another way to define a category is Category.withField
    final ultrabookCategoryId = await Category.withFields("Ultrabooks", true, false).save();


## Let's add some record to the "Product" table

You can add record as follow:

    final product = Product();
    product.name = "Notebook 12\"";
    product.description = "128 GB SSD i7";
    product.price = 6899;
    product.categoryId = notebookCategoryId;
    await product.save();
    
You can also add records quickly as follows:

    await Product.withFields( "Notebook 12\"", "128 GB SSD i7", 6899, true, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 12\"", "256 GB SSD i7", 8244, true, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 12\"", "512 GB SSD i7", 9214, true, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 13\"", "128 GB SSD", 8500, true, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 13\"", "256 GB SSD", 9900, true, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 13\"", "512 GB SSD", 11000, null, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 15\"", "128 GB SSD", 8999, null, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 15\"", "256 GB SSD", 10499, null, notebookCategoryId, 0, false).save();
    await Product.withFields( "Notebook 15\"", "512 GB SSD", 11999, true, notebookCategoryId, 0, false).save();

    await Product.withFields( "Ultrabook 13\"", "128 GB SSD i5", 9954, true, ultrabookCategoryId, 0, false).save();
    await Product.withFields( "Ultrabook 13\"", "256 GB SSD i5", 11154, true, ultrabookCategoryId, 0, false).save();
    await Product.withFields( "Ultrabook 13\"", "512 GB SSD i5", 13000, true, ultrabookCategoryId, 0, false).save();
    await Product.withFields( "Ultrabook 15\"", "128 GB SSD i7", 11000, true, ultrabookCategoryId, 0, false).save();
    await Product.withFields( "Ultrabook 15\"", "256 GB SSD i7", 12000, true, ultrabookCategoryId, 0, false).save();
    await Product.withFields( "Ultrabook 15\"", "512 GB SSD i7", 14000, true, ultrabookCategoryId, 0, false).save();

### See sample usage of sqf below


To run this statement "SELECT * FROM PRODUCTS"
Try below: 
      
    final productList = await Product().select().toList();
    
    for (int i = 0; i < productList.length; i++) {
        print(productList[i].toMap());
    }

       
To run this statement "SELECT * FROM PRODUCTS WHERE id=5"
There are two way for this statement 
    
The First is:

       var product = await Product().getById(5);
      
Second one is:

     var product = await Product().select().id.equals(5).toSingle();
    
    
 ## SELECT FIELDS, ORDER BY EXAMPLES
    
    EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id 
            -> await Product().select().orderBy("name").orderByDesc("price").orderBy("id").toList()

    EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC 
            -> await Product().select(columnsToSelect: ["name","price"]).orderByDesc("price").toList()
            
  ## SELECT AND FILTER EXAMPLES:           

    EXAMPLE 2.1: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1 
    ->  await Product().select().isActive.equals(true).toList()

    EXAMPLE 2.2: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9) 
    -> await Product().select().id.inValues([3,6,9]).toList()

    EXAMPLE 2.3: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%') 
    -> await  Product().select()
      .price
      .greaterThan(10000)
      .and.startBlock.description.contains("256").or.description.startsWith("512").endBlock
      .toSingle();
  
    EXAMPLE 2.4: BRACKETS 2: SELECT name,price FROM PRODUCTS WHERE price<=10000 AND (description LIKE '%128%' OR description LIKE '%GB') 
    ->  await Product().select(columnsToSelect:["name","price"])
       .price.lessThanOrEquals(10000)
       .and.startBlock.description.contains("128").or.description.endsWith("GB").endBlock
       .toList();
  
    EXAMPLE 2.5: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11 
    -> await Product().select().id.not.equals(11).toList();
            
    EXAMPLE 2.6: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000 
    -> await Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();        
 
    EXAMPLE 2.7: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000 
    -> await Product().select().price.between(8000,14000).orderBy("price").toList();
   
    EXAMPLE 2.8: 'NOT' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5 
    -> await Product().select().id.not.greaterThan(5).toList();
    
 ## WRITE CUSTOM SQL FILTER   
    
    EXAMPLE 2.9: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000 
    -> await Product().select().where("id IN (3,6,9) OR price>8000").toList()
    
    EXAMPLE 2.10: Build filter and query from values from the form
    -> await Product().select()
       .price.between(minPrice, maxPrice)
       .and.name.contains(nameFilter)
       .and.description.contains(descFilter)
       .toList()

## SELECT WITH DELETED ITEMS (SOFT DELETE WHEN USED)
    
    EXAMPLE 2.11: EXAMPLE 1.13: Select products with deleted items
    -> await Product().select(getIsDeleted: true).toList()
    
    EXAMPLE 2.12: Select products only deleted items 
    -> await Product().select(getIsDeleted: true).isDeleted.equals(true).toList()
   
## LIMITATION, PAGING

    EXAMPLE 3.1: LIMITATION SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC 
    -> await Product().select().orderByDesc("price").top(3).toList()
  
    EXAMPLE 3.2: PAGING: PRODUCTS in 3. page (5 items per page) 
    -> await Product().select().page(3,5).toList()
    
    
 ## DISTINCT   
    EXAMPLE 4.1: DISTINCT: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000 
    -> await Product().distinct(columnsToSelect:["name"]).price.greaterThan(3000).toList();
   
## GROUP BY

    EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS
    SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS
    avgPrice, SUM(price) AS sumPrice FROM PRODUCTS GROUP BY name 
    -> await Product()
        .select(columnsToSelect: [
        ProductFields.name.toString(),
        ProductFields.id.count("Count"),
        ProductFields.price.min("minPrice"),
        ProductFields.price.max("maxPrice"),
        ProductFields.price.avg("avgPrice"),
        ProductFields.price.sum("sumPrice"),
      ])
      .groupBy(ProductFields.name.toString() /*also you can use this .groupBy("name")*/)
      .toListObject();
       
       
## RELATIONSHIPS

    EXAMPLE 7.1: goto Category from Product 
    
    final product = await Product().getById(1);
    final category = await product.getCategory();
    print(category.toMap());
    
    Results:
    {id: 1, name: Notebooks, isActive: true, isDeleted: false}
    
    
    EXAMPLE 7.2: Products of 'Notebooks Category' listing 
    
    final category = await Category().getById(1);
    final productList = await category.getProducts();
   
    for(var product in productList) {
       print(product.toMap());
       }
    
    Results: Products of 'Notebooks' listing 9 matches found:
    {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 1, isDeleted: false}
    {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    ....
    
    

**These were just a few samples. You can download and review dozens of examples written below**      
       
## save() Method for insert or update (for both)

    await Product(name:"test product").save(); // inserts a new record if id is null or equals to zero
    await Product(id:1, name:"test product").save(); // updates record
    
## saveAll() Method for insert or update List (for both)

    var productList= List<Product>();
    // TO DO.. add products to list
    
    // Save All products in the List
     final results = await Product().saveAll(productList);
     
    print(" List<BoolResult> result of saveAll method is following:");
    for (var result in results) {
       print(result.toString());
    }
  
## upsertAll() Method for insert or update List (for both)
Note: upsertAll() method is faster then saveAll() method. upsertAll() should be used when you are sure that the primary key is greater than zero

    var productList= List<Product>();
    // TO DO.. add products to list with ID (ID>0) (primary key must be greater then 0)
    
    // Upsert All products in the List
    final results = await Product().upsertAll(productList);
    for (var result in results) {
        print(result.toString());  
    }
  

## UPDATE multiple records with query
EXAMPLE 5.1: UPDATE PRODUCT SET isActive=0 WHERE ID>=10 

    final result = await Product().select().id.greaterThan(10).update({"isActive": 0});
    print(result.toString());



## DELETE multiple records with query
EXAMPLE 6.4: DELETE PRODUCT WHERE ID>17 

    final result = await Product().select().id.greaterThan(17).delete();
    print(result.toString());
      
## Syncronize data from the web
EXAMPLE 8.2: Fill List from web with Url (JSON data) and saveAll
Todo.fromWebUrl("URL",(todosList){}) method gets json data from the web and loads into the todosList
and then Todo().saveAll(todosList) method saves all data in your local database

     todosList = await Todo.fromWebUrl("https://jsonplaceholder.typicode.com/todos");
      final results = await Todo().upsertAll(todosList);

      // print upsert Results
      for (var res in results) {
        print(res.toString()); 
      }

      todosList = await Todo().select().top(10).toList();
      print(todosList.length.toString() + " matches found\n");
      for (var todo in todosList) {
        print(todo.toMap());
      }


### See the following examples in main.dart for sample model use

      // SELECT AND ORDER PRODUCTS BY FIELDS
      samples1();

      // FILTERS: SOME FILTERS ON PRODUCTS
      samples2();

      // LIMITATIONS: PAGING, TOP X ROW
      samples3();

      // DISTINCT, GROUP BY with SQL AGGREGATE FUNCTIONS,
      samples4();

      // UPDATE BATCH, UPDATE OBJECT
      samples5();

      // DELETE BATCH, DELETE OBJECT
      samples6();

### main.dart includes a lot of samples that you need

### Running the main.dart should show the following result at DEBUG CONSOLE:

    flutter >>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntityTable of 'category' initialized successfuly
    flutter >>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntityTable of 'product' initialized successfuly
    flutter >>>>>>>>>>>>>>>>>>>>>>>>>>>> SqfEntityTable of 'todos' initialized successfuly
    D/EGL_emulation( 6184): eglMakeCurrent: 0xe6ed49a0: ver 3 0 (tinfo 0xcf020470)
    flutter SQFENTITIY: [databaseTables] Model was created successfully. Create models.dart file in your project and press Ctrl+V to paste the model from the Clipboard
    flutter sampleORMx01.db created successfully
    flutter SQFENTITIY: Table named 'product' was initialized successfuly with create new table
    flutter SQFENTITIY: alterTableIndexesQuery => [CREATE INDEX IF NOT EXISTS IDXCategorycategoryId ON product (categoryId ASC)]
    flutter SQFENTITIY: Table named 'category' was initialized successfuly with create new table
    flutter SQFENTITIY: Table named 'todos' was initialized successfuly with create new table
    flutter SQFENTITIY: The database is ready for use
    flutter
    flutter
    flutter added 15 new products
    flutter added 5 dummy products
    flutter
    flutter
    flutter LISTING CATEGORIES -> Category().select().toList()
    flutter 2 matches found:
    flutter {id: 1, name: Notebooks, isActive: true, isDeleted: false}
    flutter {id: 2, name: Ultrabooks, isActive: true, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.1: SELECT ALL ROWS WITHOUT FILTER ex: SELECT * FROM PRODUCTS
    flutter  -> Product().select().toList()
    flutter 20 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id
    flutter -> Product().select().orderBy("name").orderByDesc("price").orderBy("id").toList()
    flutter 20 matches found:
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC
    flutter -> Product().select(columnsToSelect: ["name","price"]).orderByDesc("price").toList()
    flutter
    flutter
    flutter 20 matches found:
    flutter {name: Ultrabook 15", price: 14000.0}
    flutter {name: Ultrabook 13", price: 13000.0}
    flutter {name: Ultrabook 15", price: 12000.0}
    flutter {name: Notebook 15", price: 11999.0}
    flutter {name: Ultrabook 13", price: 11154.0}
    flutter {name: Notebook 13", price: 11000.0}
    flutter {name: Ultrabook 15", price: 11000.0}
    flutter {name: Notebook 15", price: 10499.0}
    flutter {name: Ultrabook 13", price: 9954.0}
    flutter {name: Notebook 13", price: 9900.0}
    flutter {name: Notebook 12", price: 9214.0}
    flutter {name: Notebook 15", price: 8999.0}
    flutter {name: Notebook 13", price: 8500.0}
    flutter {name: Notebook 12", price: 8244.0}
    flutter {name: Notebook 12", price: 6899.0}
    flutter {name: Product 1, price: 0.0}
    flutter {name: Product 2, price: 0.0}
    flutter {name: Product 3, price: 0.0}
    flutter {name: Product 4, price: 0.0}
    flutter {name: Product 5, price: 0.0}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter EXAMPLE 1.4: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1
    flutter ->  Product().select().isActive.equals(true).toList()
    flutter 17 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.5: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9)
    flutter  -> Product().select().id.inValues([3,6,9]).toList()
    flutter 3 matches found:
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.6: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%')
    flutter  -> Product().select().price.greaterThan(10000).and.startBlock.description.contains("256").or.description.startsWith("512").endBlock.toSingle((product){ // TO DO })
    flutter Toplam 1 sonuç listeleniyor:
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.7: BRACKETS 2 ex: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB')
    flutter  -> Product().select(columnsToSelect:["name","price"]).price.lessThanOrEquals(10000).and.startBlock.description.contains("128").or.description.endsWith("GB").endBlock.toList();
    flutter 4 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.8: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11
    flutter  -> Product().select().id.not.equals(11).toList();
    flutter 19 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.9: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000
    flutter  -> Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();
    flutter 7 matches found:
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.10: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000
    flutter  -> Product().select().price.between(8000,14000).orderBy("price").toList();
    flutter 14 matches found:
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.11: 'NOT' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5
    flutter  -> Product().select().id.not.greaterThan(5).toList();
    flutter 5 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.12: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000
    flutter  -> Product().select().where("id IN (3,6,9) OR price>8000").toList()
    flutter 14 matches found:
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.13: Product().select().price.between(8000, 10000).and.name.contains("13").and.description.contains("SSD").toList()
    flutter 3 matches found:
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.14: EXAMPLE 1.13: Select products with deleted items
    flutter  -> Product().select(getIsDeleted: true).toList()
    flutter 20 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 0, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: true, categoryId: 0, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 1.15: Select products only deleted items
    flutter  -> Product().select(getIsDeleted: true).isDeleted.equals(true).toList()
    flutter 0 matches found:
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 3.1: LIMITATION ex: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC
    flutter  -> Product().select().orderByDesc("price").top(3).toList()
    flutter 3 matches found:
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 3.2: SAMPLE PAGING ex: PRODUCTS in 3. page (5 items per page)
    flutter  -> Product().select().page(3,5).toList()
    flutter 5 matches found:
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 4.1: DISTINCT ex: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000
    flutter  -> Product().distinct(columnsToSelect:["name").price.greaterThan(3000).toList();
    flutter 5 matches found:
    flutter {name: Notebook 12"}
    flutter {name: Notebook 13"}
    flutter {name: Notebook 15"}
    flutter {name: Ultrabook 13"}
    flutter {name: Ultrabook 15"}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS ex: SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice,ProductFields.price.sum("sumPrice") FROM PRODUCTS GROUP BY name
    flutter -> Product().select(columnsToSelect: [ProductFields.name.toString(), ProductFields.id.count("Count"), ProductFields.price.min("minPrice"), ProductFields.price.max("maxPrice"), ProductFields.price.avg("avgPrice")).groupBy(ProductFields.name.toString()).toListObject()
    flutter 10 matches found:
    flutter {name: Notebook 12", Count: 3, minPrice: 6899.0, maxPrice: 9214.0, avgPrice: 8119.0, sumPrice: 24357.0}
    flutter {name: Notebook 13", Count: 3, minPrice: 8500.0, maxPrice: 11000.0, avgPrice: 9800.0, sumPrice: 29400.0}
    flutter {name: Notebook 15", Count: 3, minPrice: 8999.0, maxPrice: 11999.0, avgPrice: 10499.0, sumPrice: 31497.0}
    flutter {name: Product 1, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    flutter {name: Product 2, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    flutter {name: Product 3, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    flutter {name: Product 4, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    flutter {name: Product 5, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    flutter {name: Ultrabook 13", Count: 3, minPrice: 9954.0, maxPrice: 13000.0, avgPrice: 11369.333333333334, sumPrice: 34108.0}
    flutter {name: Ultrabook 15", Count: 3, minPrice: 11000.0, maxPrice: 14000.0, avgPrice: 12333.333333333334, sumPrice: 37000.0}
    flutter ---------------------------------------------------------------
    flutter EXAMPLE 5.1: Update multiple records with query
    flutter  -> Product().select().id.greaterThan(10).update({"isActive": 0});
    flutter 10 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 5.2: uUpdate multiple records with query
    flutter  -> Product().select().id.lessThanOrEquals(10).update({"isActive": 1});
    flutter 10 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 5.3: id=15 Product item updated: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7 (updated), price: 14000.0, isActive: true, categoryId: 2, rownum: 0, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter
    flutter EXAMPLE 5.4: update some filtered products with saveAll method
    flutter  -> Product().saveAll(productList){});
    flutter  List<BoolResult> result of saveAll method is following:
    flutter id=1 upserted successfuly
    flutter id=2 upserted successfuly
    flutter id=3 upserted successfuly
    flutter id=4 upserted successfuly
    flutter id=5 upserted successfuly
    flutter id=6 upserted successfuly
    flutter id=7 upserted successfuly
    flutter id=8 upserted successfuly
    flutter id=9 upserted successfuly
    flutter id=10 upserted successfuly
    flutter id=11 upserted successfuly
    flutter id=12 upserted successfuly
    flutter id=13 upserted successfuly
    flutter id=14 upserted successfuly
    flutter id=15 upserted successfuly
    flutter id=16 upserted successfuly
    flutter id=17 upserted successfuly
    flutter id=18 upserted successfuly
    flutter id=19 upserted successfuly
    flutter id=20 upserted successfuly
    flutter ---------------------------------------------------------------
    flutter EXAMPLE 5.4: listing saved products (set rownum=i) with saveAll method;
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 1, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 2, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 3, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 4, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 5, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: true, categoryId: 1, rownum: 6, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: true, categoryId: 1, rownum: 7, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: true, categoryId: 1, rownum: 8, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 9, isDeleted: false}
    flutter {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, categoryId: 2, rownum: 10, isDeleted: false}
    flutter {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: false, categoryId: 2, rownum: 11, isDeleted: false}
    flutter {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: false, categoryId: 2, rownum: 12, isDeleted: false}
    flutter {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: false, categoryId: 2, rownum: 13, isDeleted: false}
    flutter {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: false, categoryId: 2, rownum: 14, isDeleted: false}
    flutter {id: 15, name: Ultrabook 15", description: 512 GB SSD i7 (updated), price: 14000.0, isActive: true, categoryId: 2, rownum: 15, isDeleted: false}
    flutter {id: 16, name: Product 1, description: , price: 0.0, isActive: false, categoryId: 0, rownum: 16, isDeleted: false}
    flutter {id: 17, name: Product 2, description: , price: 0.0, isActive: false, categoryId: 0, rownum: 17, isDeleted: false}
    flutter {id: 18, name: Product 3, description: , price: 0.0, isActive: false, categoryId: 0, rownum: 18, isDeleted: false}
    flutter {id: 19, name: Product 4, description: , price: 0.0, isActive: false, categoryId: 0, rownum: 19, isDeleted: false}
    flutter {id: 20, name: Product 5, description: , price: 0.0, isActive: false, categoryId: 0, rownum: 20, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter EXAMPLE 6.2: delete product by query filder
    flutter  -> Product().select().id.equals(16).delete();
    flutter 1 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter SQFENTITIY: delete Product invoked (id=17)
    flutter EXAMPLE 6.3: delete product if exist
    flutter  -> if (product != null) Product.delete();
    flutter 1 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 6.4: Delete many products by filter
    flutter  -> Product().select().id.greaterThan(17).delete()
    flutter 3 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter SQFENTITIY: recover Product batch invoked
    flutter EXAMPLE 6.6: Recover many products by filter
    flutter  -> Product().select().id.greaterThan(17).recover()
    flutter 3 items updated
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 7.1: goto Category Object from Product
    flutter -> Product.getCategory();
    flutter The category of 'Notebook 12"' is: {id: 1, name: Notebooks, isActive: true, isDeleted: false}
    flutter
    flutter
    flutter EXAMPLE 7.2.1: Products of 'Notebooks' listing
    flutter -> category.getProducts((productList) {});
    flutter 9 matches found:
    flutter {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, categoryId: 1, rownum: 1, isDeleted: false}
    flutter {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, categoryId: 1, rownum: 2, isDeleted: false}
    flutter {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, categoryId: 1, rownum: 3, isDeleted: false}
    flutter {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, categoryId: 1, rownum: 4, isDeleted: false}
    flutter {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, categoryId: 1, rownum: 5, isDeleted: false}
    flutter {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: true, categoryId: 1, rownum: 6, isDeleted: false}
    flutter {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: true, categoryId: 1, rownum: 7, isDeleted: false}
    flutter {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: true, categoryId: 1, rownum: 8, isDeleted: false}
    flutter {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, categoryId: 1, rownum: 9, isDeleted: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter
    flutter EXAMPLE 8.1: Fill List from web (JSON data) and upsertAll
    flutter  -> Todo.fromWeb((todosList) {}
    flutter 10 matches found
    flutter {id: 1, userId: 1, title: delectus aut autem, completed: false}
    flutter {id: 2, userId: 1, title: quis ut nam facilis et officia qui, completed: false}
    flutter {id: 3, userId: 1, title: fugiat veniam minus, completed: false}
    flutter {id: 4, userId: 1, title: et porro tempora, completed: false}
    flutter {id: 5, userId: 1, title: laboriosam mollitia et enim quasi adipisci quia provident illum, completed: false}
    flutter {id: 6, userId: 1, title: qui ullam ratione quibusdam voluptatem quia omnis, completed: false}
    flutter {id: 7, userId: 1, title: illo expedita consequatur quia in, completed: false}
    flutter {id: 8, userId: 1, title: quo adipisci enim quam ut ab, completed: false}
    flutter {id: 9, userId: 1, title: molestiae perspiciatis ipsa, completed: false}
    flutter {id: 10, userId: 1, title: illo est ratione doloremque quia maiores aut, completed: false}
    flutter ---------------------------------------------------------------
    flutter
    flutter EXAMPLE 8.2: upsertAll result
    flutter  -> final results = await Todo().upsertAll(todosList);
    flutter
    flutter
    flutter EXAMPLE 8.2: Fill List from web with Url (JSON data) and upsertAll
    flutter  -> Todo.fromWebUrl("https://jsonplaceholder.typicode.com/todos", (todosList) {}
    flutter 10 matches found
    flutter {id: 1, userId: 1, title: delectus aut autem, completed: false}
    flutter {id: 2, userId: 1, title: quis ut nam facilis et officia qui, completed: false}
    flutter {id: 3, userId: 1, title: fugiat veniam minus, completed: false}
    flutter {id: 4, userId: 1, title: et porro tempora, completed: false}
    flutter {id: 5, userId: 1, title: laboriosam mollitia et enim quasi adipisci quia provident illum, completed: false}
    flutter {id: 6, userId: 1, title: qui ullam ratione quibusdam voluptatem quia omnis, completed: false}
    flutter {id: 7, userId: 1, title: illo expedita consequatur quia in, completed: false}
    flutter {id: 8, userId: 1, title: quo adipisci enim quam ut ab, completed: false}
    flutter {id: 9, userId: 1, title: molestiae perspiciatis ipsa, completed: false}
    flutter {id: 10, userId: 1, title: illo est ratione doloremque quia maiores aut, completed: false}
    flutter ---------------------------------------------------------------
    flutter
