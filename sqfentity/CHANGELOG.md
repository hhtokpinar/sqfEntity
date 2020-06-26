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


## 1.3.5+3
Added Support Collating Sequences

How to use?
Set collate parameter when declaring columns like below:


      SqfEntityField('name', DbType.text, collate: Collate.NOCASE)

## 1.3.5+2
added ability to change columns type

## 1.3.5+1
fixed some bugs

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

## 1.3.4+1
   unimplemented sqlchipher due to unexpected errors in Android SDK

   You can fix sqfentity version to 1.3.3+2 to use sqlchipher like below:

      dependencies:
      sqfentity: 1.3.3+2
   

## 1.3.3+6
   implemented sqlchipher to open crypted database

   You can set password parameter of your db model like below

      @SqfEntityBuilder(myDbModel)
      const myDbModel = SqfEntityModel(
         databaseName: 'sample.db',
         password: 'testpassword',
         databaseTables: [ 
            tableProduct, tableCategory, tableTodo,
         ],
      );



## 1.3.2
   implemented MANY_TO_MANY Relationships

   ### How to use many to many relationship?

   In Chinook.db there are two tables named Playlist and Track which are related with many to many relation.
   And there is a table called PlaylistTrack which is saved ids of those related records here.
   Now, you can define SqfEntityFieldRelationship column in one of these tables, like this:

   Option 1: define this (virtual) column in Track model

      SqfEntityFieldRelationship(
         parentTable: tablePlaylist,
         deleteRule: DeleteRule.NO_ACTION,
         relationType: RelationType.MANY_TO_MANY,
         manyToManyTableName: 'PlaylistTrack'),
   

   Option 2: define this (virtual) column in Playlist model

      SqfEntityFieldRelationship(
         parentTable: tableTrack,
         deleteRule: DeleteRule.NO_ACTION,
         relationType: RelationType.MANY_TO_MANY,
         manyToManyTableName: 'PlaylistTrack'),

Note:   
 **manyToManyTableName** parameter is optional. It's the name of the table in which interrelated records will be saved.  SqfEntity will name it if you don't set this parameter

After generate the models you can list related records like this:

to list Tracks from a Playlist:

      final playlist = await Playlist().getById(1);
      final tracks = await playlist.getTracks().toList();

to list Playlists from a Track:   
   
      final track = await Track().getById(1);
      final playlists = await track.getPlaylists().toList();


## 1.3.1
   changed saveAll(), upsertAll(), rawInsert() methods according to whether have a primary key or not

## 1.3.0+4
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

## 1.2.3+13
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


   Added **SqfEntityFieldVirtual** field type for virtual property. It will be declared in the model that only generates fields in the model class and not in the database table. They are used to store lists of preloaded rows from other tables.

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

## 1.2.2+13
   Fixed some Dart Analysis hints
   
## 1.2.2+11
   Added writeDatabase() method

    Future<void> writeDatabaseSample() async {
        // declare your database as ByteData
        final ByteData data = await rootBundle.load('assets/chinook.sqlite');
        // write your new data on existing database
        await Chinookdb().writeDatabase(data);
        
    }


## 1.2.2+10
   Added One-to-One Relationship type for relationships.
   
   as an example:
   to expand the product table with the properties table with one-to-one relationship

    const tableProductProperties = SqfEntityTable(
    tableName: 'property',
    primaryKeyName: 'propertyId',
    //useSoftDeleting: true,
    //primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
        SqfEntityField('weight', DbType.real),
        SqfEntityField('stockQty', DbType.numeric),
        SqfEntityFieldRelationship(
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
    
   As you can see above, the product is a parent table and the property is its subtable that related to one-to-one.
   
   And here is DEBUG RESULT:

     flutter: { productId: 8, name: Notebook 15", description: 256 GB SSD, price: 10499.0, isActive: false, categoryId: 1, rownum: 8, datetime: 2019-11-21 06:22:34.512, isDeleted: false, property: {stockQty: 4, weight: 320} } 


## 1.2.2+9
   
   added batchStart(),batchRollback() and batchCommit() methods into db model class

   Example

    // start batch
    MyDbModel().batchStart();

    // add some products
    await Product(name: 'Notebook 12"',  description: '128 GB SSD i7',  price: 6899,  categoryId: 1).save();
    await Product(name: 'Notebook 12"',  description: '256 GB SSD i7',  price: 8244,  categoryId: 1).save();
    await Product(name: 'Notebook 12"',  description: '512 GB SSD i7',  price: 9214,  categoryId: 1).save();

    try
    {
        final List<dynamic> result = await MyDbModel().batchCommit();
        // The result contains primary keys as list of inserted records
    } catch(e)
    {
        MyDbModel().batchRollback();
    }


## 1.2.2+8
   Converting the first character of fieldName to lowercase has been cancelled. 
   Users should specify the field name as they wants
   
## 1.2.2+7
   Added keepFieldNamesAsOriginal property in @SqfEntityBuilder annotation
   Default is false and Complies with rule that "Name non-constant identifiers using lowerCamelCase.dart(non_constant_identifier_names)"
   Example:

    @SqfEntityBuilder(myDbModel, formControllers: [tableProduct, tableCategory], keepFieldNamesAsOriginal:true) 

## 1.2.2+6
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


## 1.2.1
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

DEBUG CONSOLE output:

    I/flutter: true
    I/flutter: id=15 saved successfuly

    
## 1.2.0+13
   bug fix: fixed error in convertDatabaseToModelBase()
## 1.2.0+8
added getDatabasePath() method
example: 

        final String dbPath = await MyDbModel().getDatabasePath();



## 1.2.0+6
When the application was initialize initializeDB() method is performed automatically in this version. You no longer need to call this method before start application

## 1.2.0+4
   bug fix

## 1.2.0+2

   added DateTime dbType 
    
        SqfEntityField('birthDate', DbType.datetime),

   added Date (Small Date) dbType 
    
        SqfEntityField('birthDate', DbType.date),


## 1.2.0+1
   modified dependencies (merged sqfentity_base with sqfentity_gen)

## 1.1.1+2
   modified dependencies (removed sqfentity_gen, added sqfentity_base, downgrade path version to 1.6.2)
## 1.1.1
   Added function to generate model from existing database

## 1.1.0+4
   bug fix

## 1.1.0+2
   implemented source_gen for model generate

## 1.0.5
   fixed some bugs

## 1.0.4+1
   added toJsonWithChilds() method

## 1.0.3
   added toMapWithChilds() method
   
## 1.0.2
   added toJson() method

    final product = await Product().select().toSingle();
    final jsonString = await product.toJson();
 
    print("EXAMPLE 11.1 single object to Json\n product jsonString is: $jsonString");

    final jsonStringWithChilds =  await Category().select().toJson(); // all categories selected
    print("EXAMPLE 11.2 object list with nested objects to Json\n categories jsonString is: $jsonStringWithChilds");

## 1.0.1+3
   added fromJson() method

## 1.0.0+1
   Example of linking a column to a sequence

   This is sample sequence in model

    class SequenceIdentity extends SqfEntitySequence {
    SequenceIdentity() {
        sequenceName = "identity";
        maxValue = 10;     /* optional. default is max int (9.223.372.036.854.775.807) */
        cycle = true;      /* optional. default is false; */
        //minValue = 0;    /* optional. default is 0 */
        //incrementBy = 1; /* optional. default is 1 */
        // startWith = 0;  /* optional. default is 0 */
        super.init();
    }
    static SequenceIdentity _instance;
    static SequenceIdentity get getInstance {
        if (_instance == null) {
        _instance = SequenceIdentity();
        }
        return _instance;
    }
    }

   How to linking a column to a sequence?

    SqfEntityField("rownum", DbType.integer, sequencedBy: SequenceIdentity()

## 0.2.7+1
   added some features and methods:
   - SEQUENCE Generator
   - dbModel.execScalar()

## 0.2.6
   added String Primary Key Type
   WARNING: change the 
    
    primaryKeyType = PrimaryKeyType.integer_auto_incremental;

instead of

    primaryKeyisIdentity = true

## 0.2.5+1
   Fixed some bugs
## 0.2.4+1
   New useful methods added
   dbModel.execSQL(sql), dbModel.execSQLList(sql) and dbModel.execDataTable(sql)
   see example at https://github.com/hhtokpinar/sqfEntity/blob/master/README.md#run-sql-raw-query-on-database-or-get-datatable

## 0.2.3
   WARNING! toCount() return type (BoolResult) changed to (int)

## 0.2.2
   startsWith(), endsWith() and contains() methods modified

## 0.2.1
   optional parameter added to delete() method
   delete([bool hardDelete=false])

## 0.2.0
   toListString() method added
   this method Returns List<String> for selected first column
   Sample usage: await Product.select(columnsToSelect: ["columnName"]).toListString()

## 0.1.0+22
dependencies modified

## 0.1.0+21
.fromWebUrl method modified

## 0.1.0+20
dependencies modified

## 0.1.0+18
recover() and delete() methods updated

## 0.1.0+13
create_model.dart modified

## 0.1.0+12
README.md and example/main.dart modified

## 0.1.0+11
README.md and example/main.dart modified

## 0.1.0+10
README.md and example/main.dart modified

## 0.1.0+9
README.md and example/main.dart modified

## 0.1.0+8
README.md and example/main.dart modified

## 0.1.0+7
README.md and example/main.dart modified

## 0.1.0+6
README.md modified

## 0.1.0+5
README.md modified

## 0.0.5+5
README.md modified

## 0.0.5+4
README.md modified

## 0.0.5+3
README.md modified

## 0.0.5+2
README.md modified

## 0.0.5+1

* toList(), toSingle(), getById(), initializeDb(), fromWeb().. etc methods are replaced with async method

## 0.0.4+1
README.md modified

## 0.0.3+1
README.md modified

## 0.0.2+1
README.md modified

## 0.0.1

* Initial experimentation

