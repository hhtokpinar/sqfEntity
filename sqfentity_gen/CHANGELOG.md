## 1.3.2+9
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