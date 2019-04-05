# sqfEntity ORM for Flutter & SQFLite

![ORM Preview](/assets/img/SqfEntity_ORM.gif)

SqfEntity is based on SQFlite plugin (https://github.com/tekartik/sqflite) and lets you build and execute SQL commands easily and quickly with the help of fluent methods similar to .Net Entity Framework

Leave the job to SqfEntitiy for CRUD operations. Do easily and faster adding tables, adding columns, defining multiple tables, etc. with the help of SqfEntityDbContext class.

If you have a bundled database, you can use it or EntityBase will create a new database automatically for you.

Open downloaded folder named sqfentity-master in VSCode and Click "Get Packages" button in the alert window that "Some packages are missing or out of date, would you like to get them now?"

## Getting Started

This project is a starting point for a SqfEntity ORM for SqfLite application.
There are 8 files in the project

    1. main.dart                    : Startup file contains sample methods for using sqfEntity
    2. db / SqfEntityBase.dart      : includes Database Provider, helper classes, enums.. etc 
    3. db / SqfEntityDbContext.dart : Create model classes and set it to clipboard text in runtime
    4. db / MyDbModel.dart          : Declare and modify your database model
    5. models / Product.dart        : Sample created model for examples
    6. assets / sample.db           : Sample db if you want to use an exiting db
    7. app.dart                     : Sample App for display created model. (will be updated later.)
    8. LICENSE.txt                  : see this file for License Terms


### dependencies:

    dependencies:
      flutter:
        sdk: flutter
      sqflite: any
      path_provider: any
      intl: ^0.15.7
      http: ^0.12.0+1  


# to Create a new Database Model

    class MyDbModel {
  
    // declare your sqlite database name
    static const String databaseName = "sample.db";
    
    // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing database
    static const String bundledDatabasePath = "assets/sample.db";
    
    // 1. define your tables as shown in the example Method below
    static SqfEntityTable get tableProduct {
    
    // declare properties of EntityTable
    String tableName = "product";
    String primaryKeyName = "id";
    bool useSoftDeleting = true;
    // when useSoftDeleting is true, creates a field named "isDeleted" on the table,
    // and set to "1" this field when item deleted (does not hard delete)

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

### 2. Add the object you defined above to your list of database tables

    static List<SqfEntityTable> get _databaseTables {
    
     var _dbTables = new List<SqfEntityTable>();
     _dbTables.add(tableProduct);
      //_databaseTables.add(tableCategories());
      //_databaseTables.add(tablePerson());
      // ... 
      // YOU CAN ADD AS MANY TABLES (SqfEntityTable) HERE
      return _dbTables;
      
    }

### that's all.. one more step left for create models.dart file.
  
   **ATTENTION:** Defining the tables here provides automatic processing for database configuration only.
   Use the following function to create your model and use it in your project

  To get the your classes/models from the clipboard, just type 
  
    SqfEntityDbContext.createModel(MyDbModel.databaseTables); 
    
  This function sets the Clipboard text that includes your classes (After debugging, press Ctrl+V to paste the model from the Clipboard)
  That's all.. Just press Ctrl+V to paste your model in your .dart file and reference it where you wish to use.


  
### Database initializer async method
When the software/app is started, you must check the database was it initialized.
If needed, initilizeDb method runs that CREATE TABLE / ALTER TABLE ADD COLUMN queries for you.

       initializeDB(VoidCallback isReady(bool result)) {
          ...
       }
    
 If result is **true**, the database is ready to use

## That's Great! now we can use our created new model named "Product"

### See sample usage of sqf below


      To run this statement "SELECT * FROM PRODUCTS"
      Try below: 
      
      Product().Select().toList((productList){
         for(product in productList)
         {
            print(product.toMap());
         } 
       });
       
      To run this statement "SELECT * FROM PRODUCTS WHERE id=5"
      There are two way for this statement 
    
      The First is:
      Product().getById(5, (product) {
            print(product.toMap());
       });
      
      Second one is:
      Product().Select().id.equals(5).toSingle( (product) {
            print(product.toMap());
       });
    
    
 ## SELECT FIELDS, ORDER BY EXAMPLES
    
    EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id 
            -> Product().select().orderBy("name").orderByDesc("price").orderBy("id").toList()

    EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC 
            -> Product().select(columnsToSelect: ["name","price"]).orderByDesc("price").toList()
            
  ## SELECT AND FILTER EXAMPLES:           

    EXAMPLE 2.1: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1 
    ->  Product().select().isActive.equals(true).toList()

    EXAMPLE 2.2: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9) 
            -> Product().select().id.inValues([3,6,9]).toList()

    EXAMPLE 2.3: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%') 
            -> Product().select().price.greaterThan(10000).and.startBlock.description.contains("256").or.description.startsWith("512").endBlock.toSingle((product){ // TO DO })
  
    EXAMPLE 2.4: BRACKETS 2 ex: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB') 
            -> Product().select(columnsToSelect:["name","price"]).price.lessThanOrEquals(10000).and.startBlock.description.contains("128").or.description.endsWith("GB").endBlock.toList();
  
    EXAMPLE 2.5: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11 
            -> Product().select().id.not.equals(11).toList();
            
    EXAMPLE 2.6: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000 
            -> Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();        
 
    EXAMPLE 2.7: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000 
            -> Product().select().price.between(8000,14000).orderBy("price").toList();
   
    EXAMPLE 2.8: 'NOT' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5 
            -> Product().select().id.not.greaterThan(5).toList();
    
 ## WRITE CUSTOM SQL FILTER   
    
    EXAMPLE 2.9: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000 
            -> Product().select().where("id IN (3,6,9) OR price>8000").toList()
    
    EXAMPLE 2.10: Build filter and query from values from the form
     -> Product().select().price.between(minPrice, maxPrice).and.name.contains(nameFilter).and.description.contains(descFilter).toList()

## SELECT WITH DELETED ITEMS (SOFT DELETE WHEN USED)
    
    EXAMPLE 2.11: EXAMPLE 1.13: Select products with deleted items
            -> Product().select(getIsDeleted: true).toList()
    
    EXAMPLE 2.12: Select products only deleted items 
            -> Product().select(getIsDeleted: true).isDeleted.equals(true).toList()
   
## LIMITATION, PAGING

    EXAMPLE 3.1: LIMITATION SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC 
            -> Product().select().orderByDesc("price").top(3).toList()
  
    EXAMPLE 3.2: PAGING: PRODUCTS in 3. page (5 items per page) 
            -> Product().select().page(3,5).toList()
    
    
 ## DISTINCT   
    EXAMPLE 4.1: DISTINCT: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000 
            -> Product().distinct(columnsToSelect:["name").price.greaterThan(3000).toList();
   
## GROUP BY

    EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS
    SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice,ProductFields.price.sum("sumPrice") FROM PRODUCTS GROUP BY name 
    -> Product().select(
        columnsToSelect: [ProductFields.name.toString(), 
                          ProductFields.id.count("Count"),
                          ProductFields.price.min("minPrice"), 
                          ProductFields.price.max("maxPrice"), 
                          ProductFields.price.avg("avgPrice"))
                          .groupBy(ProductFields.name.toString())
                          .toListObject()
       
       
**These were just a few samples. You can download and review dozens of examples written below**      
       

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
   
    I/f: SQFENTITIY: [databaseTables] Model was successfully created. Create models.dart file in your project and press Ctrl+V to paste the model from the Clipboard
    I/f: SQFENTITIY: Table named 'product' was initialized successfuly with create new table'
    I/f: SQFENTITIY: The database is ready for use
    I/f: 
    I/f: 
    I/f: added 15 new products
    I/f: added 5 dummy products
    I/f: 
    I/f: 
    I/f: EXAMPLE 1.1: SELECT ALL ROWS WITHOUT FILTER ex: SELECT * FROM PRODUCTS 
    I/f:  -> Product().select().toList()
    I/f: 20 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 16, name: Product 1, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 17, name: Product 2, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 18, name: Product 3, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 19, name: Product 4, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 20, name: Product 5, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id 
    I/f: -> Product().select().orderBy("name").orderByDesc("price").orderBy("id").toList()
    I/f: 20 matches found:
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 16, name: Product 1, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 17, name: Product 2, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 18, name: Product 3, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 19, name: Product 4, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 20, name: Product 5, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC 
    I/f: -> Product().select(columnsToSelect: ["name","price"]).orderByDesc("price").toList()
    I/f: 20 matches found:
    I/f: {name: Ultrabook 15", price: 14000.0}
    I/f: {name: Ultrabook 13", price: 13000.0}
    I/f: {name: Ultrabook 15", price: 12000.0}
    I/f: {name: Notebook 15", price: 11999.0}
    I/f: {name: Ultrabook 13", price: 11154.0}
    I/f: {name: Notebook 13", price: 11000.0}
    I/f: {name: Ultrabook 15", price: 11000.0}
    I/f: {name: Notebook 15", price: 10499.0}
    I/f: {name: Ultrabook 13", price: 9954.0}
    I/f: {name: Notebook 13", price: 9900.0}
    I/f: {name: Notebook 12", price: 9214.0}
    I/f: {name: Notebook 15", price: 8999.0}
    I/f: {name: Notebook 13", price: 8500.0}
    I/f: {name: Notebook 12", price: 8244.0}
    I/f: {name: Notebook 12", price: 6899.0}
    I/f: {name: Product 1, price: 0.0}
    I/f: {name: Product 2, price: 0.0}
    I/f: {name: Product 3, price: 0.0}
    I/f: {name: Product 4, price: 0.0}
    I/f: {name: Product 5, price: 0.0}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.1: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1 
    I/f: ->  Product().select().isActive.equals(true).toList()
    I/f: 17 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 16, name: Product 1, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 17, name: Product 2, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 18, name: Product 3, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 19, name: Product 4, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 20, name: Product 5, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.2: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9) 
    I/f:  -> Product().select().id.inValues([3,6,9]).toList()
    I/f: 3 matches found:
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.3: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%') 
    I/f:  -> Product().select().price.greaterThan(10000).and.startBlock.description.contains("256").or.description.startsWith("512").endBlock.toSingle((product){ // TO DO })
    I/f: Toplam 1 sonuç listeleniyor:
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.4: BRACKETS 2 ex: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB') 
    I/f:  -> Product().select(columnsToSelect:["name","price"]).price.lessThanOrEquals(10000).and.startBlock.description.contains("128").or.description.endsWith("GB").endBlock.toList();
    I/f: 4 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.5: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11 
    I/f:  -> Product().select().id.not.equals(11).toList();
    I/f: 19 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 16, name: Product 1, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 17, name: Product 2, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 18, name: Product 3, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 19, name: Product 4, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 20, name: Product 5, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.6: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000 
    I/f:  -> Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();
    I/f: 7 matches found:
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.7: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000 
    I/f:  -> Product().select().price.between(8000,14000).orderBy("price").toList();
    I/f: 14 matches found:
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.8: 'NOT' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5 
    I/f:  -> Product().select().id.not.greaterThan(5).toList();
    I/f: 5 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.9: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000 
    I/f:  -> Product().select().where("id IN (3,6,9) OR price>8000").toList()
    I/f: 14 matches found:
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.10: Product().select().price.between(8000, 10000).and.name.contains("13").and.description.contains("SSD").toList()
    I/f: 3 matches found:
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.11: EXAMPLE 1.13: Select products with deleted items
    I/f:  -> Product().select(getIsDeleted: true).toList()
    I/f: 20 matches found:
    I/f: {id: 1, name: Notebook 12", description: 128 GB SSD i7, price: 6899.0, isActive: true, isDeleted: false}
    I/f: {id: 2, name: Notebook 12", description: 256 GB SSD i7, price: 8244.0, isActive: true, isDeleted: false}
    I/f: {id: 3, name: Notebook 12", description: 512 GB SSD i7, price: 9214.0, isActive: true, isDeleted: false}
    I/f: {id: 4, name: Notebook 13", description: 128 GB SSD, price: 8500.0, isActive: true, isDeleted: false}
    I/f: {id: 5, name: Notebook 13", description: 256 GB SSD, price: 9900.0, isActive: true, isDeleted: false}
    I/f: {id: 6, name: Notebook 13", description: 512 GB SSD, price: 11000.0, isActive: false, isDeleted: false}
    I/f: {id: 7, name: Notebook 15", description: 128 GB SSD, price: 8999.0, isActive: false, isDeleted: false}
    I/f: {id: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, isDeleted: false}
    I/f: {id: 9, name: Notebook 15", description: 512 GB SSD, price: 11999.0, isActive: true, isDeleted: false}
    I/f: {id: 10, name: Ultrabook 13", description: 128 GB SSD i5, price: 9954.0, isActive: true, isDeleted: false}
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 16, name: Product 1, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 17, name: Product 2, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 18, name: Product 3, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 19, name: Product 4, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: {id: 20, name: Product 5, description: , price: 0.0, isActive: true, isDeleted: false}
    I/f: 
    I/f: 
    I/f: EXAMPLE 2.12: Select products only deleted items 
    I/f:  -> Product().select(getIsDeleted: true).isDeleted.equals(true).toList()
    I/f: 0 matches found:
    I/f: 
    I/f: 
    I/f: EXAMPLE 3.1: LIMITATION ex: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC 
    I/f:  -> Product().select().orderByDesc("price").top(3).toList()
    I/f: 3 matches found:
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 3.2: SAMPLE PAGING ex: PRODUCTS in 3. page (5 items per page) 
    I/f:  -> Product().select().page(3,5).toList()
    I/f: 5 matches found:
    I/f: {id: 11, name: Ultrabook 13", description: 256 GB SSD i5, price: 11154.0, isActive: true, isDeleted: false}
    I/f: {id: 12, name: Ultrabook 13", description: 512 GB SSD i5, price: 13000.0, isActive: true, isDeleted: false}
    I/f: {id: 13, name: Ultrabook 15", description: 128 GB SSD i7, price: 11000.0, isActive: true, isDeleted: false}
    I/f: {id: 14, name: Ultrabook 15", description: 256 GB SSD i7, price: 12000.0, isActive: true, isDeleted: false}
    I/f: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7, price: 14000.0, isActive: true, isDeleted: false}
    I/f: ---------------------------------------------------------------
    I/f: 
    I/f: 
    I/f: EXAMPLE 4.1: DISTINCT ex: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000 
    I/f:  -> Product().distinct(columnsToSelect:["name").price.greaterThan(3000).toList();
    I/f: 5 matches found:
    I/f: {name: Notebook 12"}
    I/f: {name: Notebook 13"}
    I/f: {name: Notebook 15"}
    I/f: {name: Ultrabook 13"}
    I/f: {name: Ultrabook 15"}
    I/f: 
    I/f: 
    I/f: EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS ex: SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice,ProductFields.price.sum("sumPrice") FROM PRODUCTS GROUP BY name 
    I/f: -> Product().select(columnsToSelect: [ProductFields.name.toString(), ProductFields.id.count("Count"), ProductFields.price.min("minPrice"), ProductFields.price.max("maxPrice"), ProductFields.price.avg("avgPrice")).groupBy(ProductFields.name.toString()).toListObject()
    I/f: 10 matches found:
    I/f: {name: Notebook 12", Count: 3, minPrice: 6899.0, maxPrice: 9214.0, avgPrice: 8119.0, sumPrice: 24357.0}
    I/f: {name: Notebook 13", Count: 3, minPrice: 8500.0, maxPrice: 11000.0, avgPrice: 9800.0, sumPrice: 29400.0}
    I/f: {name: Notebook 15", Count: 3, minPrice: 8999.0, maxPrice: 11999.0, avgPrice: 10499.0, sumPrice: 31497.0}
    I/f: {name: Product 1, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    I/f: {name: Product 2, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    I/f: {name: Product 3, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    I/f: {name: Product 4, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    I/f: {name: Product 5, Count: 1, minPrice: 0.0, maxPrice: 0.0, avgPrice: 0.0, sumPrice: 0.0}
    I/f: {name: Ultrabook 13", Count: 3, minPrice: 9954.0, maxPrice: 13000.0, avgPrice: 11369.333333333334, sumPrice: 34108.0}
    I/f: {name: Ultrabook 15", Count: 3, minPrice: 11000.0, maxPrice: 14000.0, avgPrice: 12333.333333333334, sumPrice: 37000.0}
    I/f: ---------------------------------------------------------------
    I/f: 10 items updated
    I/f: 10 items updated
    I/f: id=15 Product item updated: {id: 15, name: Ultrabook 15", description: 512 GB SSD i7 (updated), price: 14000.0, isActive: true, isDeleted: false}
    I/f: 1 items updated
    I/f: SQFENTITIY: delete Product called (id=17)
    I/f: 3 items updated
    I/f: 1 items updated


   
