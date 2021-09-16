## 2.1.2
Added an optional parameter **ignoreBatch** into save() method that sent true as a default to fix issue [214](https://github.com/hhtokpinar/sqfEntity/issues/214) 
Set ignoreBatch to false if you run more than one save() operation those are between batchStart and batchCommit

Sample:

    await MyDbModel().batchStart();
    for (final obj in products) {
      await obj.save(ignoreBatch: false);
    }
    //    return MyDbModel().batchCommit();
    final result = await MyDbModel().batchCommit();


## 2.1.0+2

New features added: (by [Reni Delonzek](https://github.com/ReniDelonzek))

- Ability to specify default columns for all tables
   Example:

```
    @SqfEntityBuilder(myDbModel)
    const myDbModel = SqfEntityModel(
    modelName: 'AppDatabase',
    databaseName: 'AppDatabase.db',
    databaseTables: [
       table1, 
       table2
    ],
    sequences: [seqIdentity],
    bundledDatabasePath: null,
    defaultColumns: const [
      SqfEntityField('lastUpdate', DbType.datetime),
    ]);
```

All database tables (table1 and table2) will have the lastUpdate column

- Possibility of performing actions before each insert/update
   Example:

```
   @SqfEntityBuilder(myDbModel)
   const myDbModel = SqfEntityModel(
       ...
       preSaveAction: getPreSaveAction,
   );

   Future<TableBase> getPreSaveAction(String tableName, obj) async {
      // Update the lastUpdate column on all records before saving
      obj.lastUpdate = DateTime.now()
      return obj;
   }
```

- Log events on failure of insert/update operation
   Example:

```
   @SqfEntityBuilder(myDbModel)
   const myDbModel = SqfEntityModel(
       ...
       logFunction: getLogFunction,
   );

   getLogFunction(Log log) {
      // Report the error to the server here
   }
```

- Addition of saveOrThrow method, making it possible to handle throws directly
   Example usage with transactions:

```
   Future<bool> saveData() async {
      try {
         /// Start a transaction
         await AppDatabase().execSQL('BEGIN');

         table1.id = await table1.saveOrThrow();

         table2.table1_id = table1.id;
         table2.id = table2.saveOrThrow();

         /// Confirm the data in the db
         return (await AppDatabase().execSQL('COMMIT')).success;
      } catch (error, stackTrace) {

         /// Reverses all successful operations
         await AppDatabase().execSQL('ROLLBACK');

         /// Cancels possible ids assigned to the object during insertions, preventing a new save attempt from accidentally performing an update
         table1?.rollbackId();
         table2?.rollbackId();
         return false;
      }
   }
```

- Make all table classes extend from TableBase

Thanks to [Reni Delonzek](https://github.com/ReniDelonzek) for these contributions.  

## 2.0.0
1. Migrated to null safety, min SDK is 2.12.0.
2. implemented SQLChiper to encrypt DB
3. Added DbType.time
4. Added an option to implement an abstract class (by [Amit Rotner](https://github.com/amitrotner))

## 1.4.0

1. Added Desktop support [issue #59](https://github.com/hhtokpinar/sqfEntity/issues/59)

2. Added support for sending header to the fromWebUrl() method to able using Authentication Credentials or Token [issue #122](https://github.com/hhtokpinar/sqfEntity/issues/122)

3. Added a new method named post() and postUrl() to post json to specified url with headers

4. Added VIEW support

### How to use method post() ?

First  Define the 'Todo' constant as SqfEntityTable and generate your model


    const tableTodo = SqfEntityTable(
    tableName: 'todos',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    defaultJsonUrl:
        'https://jsonplaceholder.typicode.com/todos', // optional: to synchronize your table with json data from webUrl
    fields: [
      SqfEntityField('userId', DbType.integer),
      SqfEntityField('title', DbType.text),
      SqfEntityField('completed', DbType.bool, defaultValue: false),
    ]);


using:

      final todo = Todo()
      ..title='test'
      ..userId=1
      ..completed = true;

      final res = await todo.post(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization' : 'Basic your_api_token_here'
            });

### How to define a VIEW?

You can define views like below:


        const tableV_tracks = SqfEntityTable(
            tableName: 'VTracks',
            objectType: ObjectType.view,
            fields: [
            SqfEntityField('Name', DbType.text),
            SqfEntityField('album', DbType.text),
            SqfEntityField('media', DbType.text),
            SqfEntityField('genres', DbType.text),
            SqfEntityFieldRelationship(
                parentTable: tableTrack,
                deleteRule: DeleteRule.NO_ACTION,
                fieldName: 'TrackId',
                isPrimaryKeyField: false),
            ],
            sqlStatement: '''SELECT
            trackid,
            track.name,
            album.Title AS album,
            mediatype.Name AS media,
            genre.Name AS genres
        FROM
            track
        INNER JOIN album ON Album.AlbumId = track.AlbumId
        INNER JOIN mediatype ON mediatype.MediaTypeId = track.MediaTypeId
        INNER JOIN genre ON genre.GenreId = track.GenreId''',
        );

Get some data from the view:

      final vtracs = await VTrack().select().top(5).toList(); 

Result:

      flutter: 5 matches found
      flutter: {Name: For Those About To Rock (We Salute You), album: For Those About To Rock We Salute You, media: MPEG audio file, genres: Rock, TrackId: 1}
      flutter: {Name: Balls to the Wall, album: Balls to the Wall, media: Protected AAC audio file, genres: Rock, TrackId: 2}
      flutter: {Name: Fast As a Shark, album: Restless and Wild, media: Protected AAC audio file, genres: Rock, TrackId: 3}
      flutter: {Name: Restless and Wild, album: Restless and Wild, media: Protected AAC audio file, genres: Rock, TrackId: 4}
      flutter: {Name: Princess of the Dawn, album: Restless and Wild, media: Protected AAC audio file, genres: Rock, TrackId: 5}


## 1.3.5+7
fixed [issue #121](https://github.com/hhtokpinar/sqfEntity/issues/121) 

## 1.3.5+6
fixed [issue #115](https://github.com/hhtokpinar/sqfEntity/issues/115) 

## 1.3.5+4
Added Support Collating Sequences

How to use?
Set collate parameter when declaring columns like below:


      SqfEntityField('name', DbType.text, collate: Collate.NOCASE)


## 1.3.5+3
Added ability to change columns type


## 1.3.5+2

Added a property named ignoreForFile in SqfEntityModel.
You can specify the names of rules to be ignored which are specified in analysis_options.yaml file.
  
### How to use?

      @SqfEntityBuilder(myDbModel)
         const myDbModel = SqfEntityModel(
         modelName: 'MyDbModel',
         databaseName: 'sampleORM_v1.3.5+1.db',
         databaseTables: [tableProduct, tableCategory, tableTodo],
         ignoreForFile: [ 'avoid_unused_constructor_parameters', 
                                    'always_put_control_body_on_new_line', 
                                    'prefer_final_fields']
         );


## 1.3.5+1
Added multicolumn index support. For more information [click here](https://www.sqlitetutorial.net/sqlite-index/)

### How to use?
set any integer value to **isIndexGroup** parameter with isIndex: true
example:

      SqfEntityField('firtsName', DbType.text, isIndex: true, isIndexGroup: 1),
      SqfEntityField('lastName', DbType.text, isIndex: true, isIndexGroup: 1),


## 1.3.5
   Added SQLite Constraints and Index property to fields

**NOT NULL Constraint** − Ensures that a column cannot have NULL value.
**DEFAULT Constraint** − Provides a default value for a column when none is specified.
**UNIQUE Constraint** − Ensures that all values in a column are different.
**CHECK Constraint** − Ensures that all values in a column satisfies certain conditions.
**INDEXES** - Indexes are used to retrieve data from the database more quickly than otherwise.

## How do I use these features?

use these parameters when declaring SqfEntityField
**isNotNull**: true,
**defaultValue**: 0, // specify a default value according to type of the column 
**isUnique**: true
**checkCondition**: '(this)>0' // you can use **(this)** phrase instead of the column name
**isIndex**: true 

## To test constraints

1. Define a sample table


      const tableProduct = SqfEntityTable(
      tableName: 'product',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
         SqfEntityField('name',DbType.text,
                         isUnique: true, isNotNull: true, isIndex:true),
         SqfEntityField('price', DbType.real, 
                         defaultValue: 1, checkCondition: '(this)>0'),
      ]);


2. Try to insert a row into the product table with these values:


      Product product = Product();
      // We didn't set any values before saving.
      await product.save();
      print('-----TEST: NOT NULL CONSTRAINT (name must not be null)');
      print(product.saveResult);

      product = Product()
      ..name = 'product 1'
      ..categoryId = 1
      ..price=0; // the price must be greater than 0 according to the specified CHECK CONSTRAINT

      await product.save();
      print('-----TEST: CHECK CONSTRAINT (price must be greater than 0)');
      print(product.saveResult);


      product = Product()
      ..name = 'product 1'
      ..categoryId=1
      ..price=1;
      await product.save();
      await product.saveAs(); // We saved the product again without changing the name

      print('-----TEST: UNIQUE CONSTRAINT (name must be UNIQUE)');
      print(product.saveResult);


## Results:

      flutter: -----TEST: NOT NULL CONSTRAINT (name isNotNull)
      flutter: product-> Save failed. Error: "NOT NULL constraint failed: product.name"...

      flutter: -----TEST: CHECK CONSTRAINT (price must be greater than 0)
      flutter: product-> Save failed. Error:  "CHECK constraint failed: product"...

      flutter: -----TEST: UNIQUE CONSTRAINT (name must be UNIQUE)
      flutter: product-> Save failed. Error: "UNIQUE constraint failed: product.name"...


## 1.3.4+4
   fixed repeated variable declaration in tables which have more than one RelationShip to the same table
   
## 1.3.4+3
   fixed bugs in nested Tables and Related tables which have more than one Primary Key
   
## 1.3.2+13
   fixed bugs in MANY_TO_MANY Relationships

## 1.3.2+8
   fixed bugs in nested ONE_TO_ONE Relationships

## 1.3.2+5
   implemented MANY_TO_MANY Relationships

   ### How to use many yo many relationship?

   In Chinook.db there are two tables named Playlist and Track which are related with many to many relation.
   And there is a table called PlaylistTrack which is saved ids of those related records here.
   Now, you can define SqfEntityFieldRelationship column in one of these tables, like this:

   Option 1: Define this SqfEntityFieldRelationship column in Track table model with the relationType is MANY_TO_MANY 

      SqfEntityFieldRelationship(
         parentTable: tablePlaylist,
         deleteRule: DeleteRule.NO_ACTION,
         relationType: RelationType.MANY_TO_MANY,
         manyToManyTableName: 'PlaylistTrack'),
   

   Option 2: OR define this SqfEntityFieldRelationship column in Playlist table model

      SqfEntityFieldRelationship(
         parentTable: tableTrack,
         deleteRule: DeleteRule.NO_ACTION,
         relationType: RelationType.MANY_TO_MANY,
         manyToManyTableName: 'PlaylistTrack'),

Note:   
 **manyToManyTableName** parameter is optional. SqfEntity will name it if you don't set this parameter

After generate the models you can list related records like this:

to list Tracks of a Playlist:

      final playlist = await Playlist().getById(1);
      final tracks = await playlist.getTracks().toList();

to list Playlists of a Track:   

   
      final track = await Track().getById(1);
      final playlists = await track.getPlaylists().toList();

## 1.3.1
   changed saveAll(), upsertAll(), rawInsert() methods according to whether have a primary key or not

## 1.3.0+7
   applied following advice:
   https://github.com/hhtokpinar/sqfEntity/issues/93#issuecomment-596340785

## 1.3.0+6
   applied isPrimaryKeyField propery to both SqfEntityField or SqfEntityFieldRelationship fields 
   fixed some bugs

## 1.3.0
   Added a new feature that allows you to set SqfEntityFieldRelationship items as primary Key
   set the isPrimaryKeyField parameter to true to use this feature
   
   Sample usage:

      const tableProductProperties = SqfEntityTable(
      tableName: 'product_properties',
      // now you do not need to set primaryKeyName If you set RelationshipField as primarykeyfield

      // declare fields
      fields: [
         SqfEntityField('title', DbType.text),
         SqfEntityField('productId', DbType.integer, isPrimaryKeyField: true),
         SqfEntityFieldRelationship(fieldName: 'propertyId', parentTable: tableProperty, isPrimaryKeyField: true),
      ]);

## 1.2.3+19
   Added loadParents parameter into parameters of getById, toSingle, and toList methods to preload parent of items 
   sample using:
   Shop is the top element with no parent and the last element is Todo that has no children, so my simple schema is like this-> Shop > Category > Product > Todo
  
    final todo= Todo().getById(1,loadParents:true);
    
    print( todo.plProduct.plCategory.plShop.name );

    result:
    flutter: shop 1


And showed how to reach to top parent in the following figure
![loadparents](https://user-images.githubusercontent.com/18614561/74828491-416ddf80-5320-11ea-956f-7878245b61d2.gif)


## 1.2.3+18
   Extended preload option. Now preloading loads all nested children (except for parents)

## 1.2.3+17
   added datetimeUtc dbType for SqfEntityFields

## 1.2.3+8
   fixed bugs

## 1.2.3+3
   Added new feature for relationships preload parent or child fields to virtual fields that created automatically starts with 'pl'

  this field will be created for Product table
  
    Category plCategory;

  this field will be created for Category table

    List<Product> plProducts;

Using (from parent to child):
Note: You can send certain field names with preloadField parameter for preloading. For ex: toList(preload:true, preloadFields:['plField1','plField2'... etc]) 

    final category = await Category().select()..(your optional filter)...toSingle(preload:true, preloadFields: ['plProducts']);

    // you can see pre-loaded products of this category
    category.plProducts[0].name
    
    
or Using (from child to parent):
    
    final products = await Product().select().toList(preload:true);

    // you see pre-loaded categories of all products
    products[0].plCategory.name


## 1.2.1+16
   Added SqfEntityFieldVirtual field type for virtual property. It will be declared in the model that only generates fields in the model class and not in the database table. They are used to store lists of preloaded rows from other tables.

   Example:

   When creating model:

    const tablePerson = SqfEntityTable(
        tableName: 'person',
        primaryKeyName: 'id',
        primaryKeyType: PrimaryKeyType.integer_auto_incremental,
        fields: [
            SqfEntityField('firstName', DbType.text),
            SqfEntityField('lastName', DbType.text),
            SqfEntityFieldVirtual('fullName', DbType.text),
        ],
        customCode: '''
            init()
            { 
            fullName = '\$firstName \$lastName';
            }'''
        );


  When using:

    final personList = await Person().select().toList();
    
    for (final person in personList) {
        person.init();
        print('fullName: ${person.virtualName}');
    }
     

Also removed method called 'fromObjectList'

## 1.2.1+13
   fixed Relationships supports text data type

## 1.2.1+12
   Fixed some Dart Analysis hints

## 1.2.1+11
   Applied range validator to forms (You can use minValue and maxValue property for integer, real and numeric field dbTypes)

## 1.2.1+9
   Added One-to-One Relationships type for relationships.
   
   as an example:
   to expand the product table with the properties table with one-to-one relationships

    const tableProductProperties = SqfEntityTable(
    tableName: 'property',
    primaryKeyName: 'propertyId',
    //useSoftDeleting: true,
    //primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
        SqfEntityField('weight', DbType.real),
        SqfEntityField('stockQty', DbType.numeric),
        SqfEntityFieldRelationship(
        //fieldName: 'productId',
            parentTable: tableProduct, relationType: RelationType.ONE_TO_ONE)
    ],
    );

   after generate the code, you will see ".property" in product item properties like below:
   Note: In one-to-many relations There will be ".getProperty().toList()"

    final product = await Product().getById(8);

    product.property
        ..stockQty = 8
        ..weight = 320;
    await product.save();
    
    print(product.toMapWithChilds());
    
   and here is DEBUG RESULT

     flutter: { productId: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 8, datetime: 2019-11-21 06:22:34.512, isDeleted: false, property: {stockQty: 4, weight: 320} } 

## 1.2.1+4
1- added equalsOrNull keyword for queries
    Example:

    // this query lists only isActive=false 
    final productList = await Product().select().isActive.not.equals(true).toList();
    
    // but this query lists isActive=false and isActive is null both
    final productList = await Product().select().isActive.not.equalsOrNull(true).toList();

       
    
2- you can define customCode property of your SqfEntityTable constant for ex:

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
        return '\$firstName \$lastName';
        }
    ''');

## 1.2.0+13
   modified isSaved property and to be removed when not needed
   
## 1.2.0+12
   bugs fixed
     getById(id) -> id is null then return null instead exception
     and fixed .isNull() throws the exception

## 1.2.0+11
   Converting the first character of fieldName to lowercase has been cancelled. 
   Users should specify the field name as they wants

## 1.2.0+9
   Added Form Generation Feature, and minValue, maxValue propery for datetime fields and fixed some bugs.
   Example:

    @SqfEntityBuilderForm(tableCategory, formListTitleField: 'name', hasSubItems: true)
    const tableCategory = SqfEntityTable(
        tableName: 'category',
        primaryKeyName: 'id',
        primaryKeyType: PrimaryKeyType.integer_auto_incremental,
        useSoftDeleting: true,
        // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
        modelName:
            null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
        // declare fields
        fields: [
        SqfEntityField('name', DbType.text),
        SqfEntityField('isActive', DbType.bool, defaultValue: true),
        SqfEntityField('date1', DbType.datetime, defaultValue: 'DateTime.now()', minValue: '2019-01-01', maxValue: '2023-01-01'),
        SqfEntityField('date2', DbType.datetime,  minValue: '2020-01-01', maxValue: '2022-01-01')
        ]);



## 1.1.1+3
   fixed the build error after defining multiple referance (RelationShip) to the same table 
 
## 1.1.1+1
   added saveResult property
   Note: You must re-generate your models after updating the package

  Example:

    final product = Product(
        name: 'Notebook 12"',
        description: '128 GB SSD i7',
        price: 6899,
        categoryId: 1);
    await product.save();
    
    print(product.saveResult.success); // bool (true/false)
    print(product.saveResult.toString()); // String (message)

## 1.1.0+5
   bugfix SequenceManager error on multi database
## 1.1.0+4
   added unknown (text) dbType for unrecognized columns

## 1.1.0+3

   added Date (Small Date) dbType 
    
        SqfEntityField('birthDate', DbType.date),


## 1.1.0+2
   added DateTime dbType 
    
        SqfEntityField('birthDate', DbType.datetime),


## 1.1.0+1
   modified sqlite dbType mapping

## 1.1.0
   merged package with sqfentity_base
   
## 1.0.3+5
   removed analyzer from dependencies
   
## 1.0.3+4
   added FormBuilder 

## 1.0.3+3
   removed FormBuilder  

## 1.0.3+2
   added analyzer 0.38.2

## 1.0.3+1
   sqfentity_base exported to sqfentity_base 1.0.1 package

## 1.0.2+4
   Blob type mapped as Uint8List instead String

## 1.0.2
   Added function to generate model from existing database

## 1.0.1
   sqfentity_base moved into this package

## 1.0.0+7
   some required changes applied

## 1.0.0+6
   * Initial publish 
   This package required for sqfentity_gen ORM for Flutter code generator
   Includes SqfEntity base classes and Annotation Classes