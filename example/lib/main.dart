import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'app.dart';
import 'model/chinook.dart';
import 'model/model.dart';

/*

------------------------------------   GETTING STARTED  ------------------------------------------

This project is a starting point for a SqfEntity ORM for database application.
Some files in the project:

    1. main.dart (this file)          : Startup file contains sample methods for using sqfEntity
    2. model / model.dart             : Declare and modify your database model (CAN BE MODIFIED)
    3. model / model.g.dart           : Sample generated model for examples (DO NOT MODIFY BY HAND)
    4. model / model.g.view.dart      : Sample generated form views for examples (DO NOT MODIFY BY HAND)
    5. model / controller.dart        : main controller that provides access to created form views from
                                        the application main page (CAN BE MODIFIED)
    6. model / view.list.dart         : The Sample for List View that your saved table items (CAN BE MODIFIED)
    7. model / view.detail.dart       : The Sample for Detail View that your saved table items (CAN BE MODIFIED)
    8. sample_advanced_form / *.dart  : Sample Widget showing how to filter toList() at runtime
    9. assets / chinook.sqlite        : Sample db if you want to use an exiting database or create 
                                        model from database
    10. app.dart                      : Sample App for display created model. 
                                        (Updating frequently. Please click 'Watch' to follow updates at: 
                                        https://github.com/hhtokpinar/sqfEntity)

*/

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ATTENTION! when the software/app is started, database will initialized.
  // If the database is not initialized, something went wrong. Check DEBUG CONSOLE for alerts

  await runSamples();
  runApp(MyApp());
}

Future<bool> runSamples() async {
  // add some products
  await addSomeProducts();

  // Print all categories
  printCategories(false);

  // SELECT AND ORDER PRODUCTS BY FIELDS
  await samples1();

  // FILTERS: SOME FILTERS ON PRODUCTS
  await samples2();

  // LIMITATIONS: PAGING, TOP X ROW
  await samples3();

  // DISTINCT, GROUP BY with SQL AGGREGATE FUNCTIONS,
  await samples4();

  // UPDATE BATCH, UPDATE OBJECT
  await samples5();

  // DELETE BATCH, DELETE OBJECT, RECOVERY
  await samples6();

  // ORM (Object Relational Mapping) SAMPLE
  await samples7();

  // fill List from the web (JSON)
  await samples8();

  // run custom sql query on database
  await samples9();

  // SEQUENCE samples
  await samples10();

  // toJson samples
  await samples11();

  // get data from view sample
  await samples12();

  // create model from existing database sample
  await createModelFromDatabaseSample();

  return true;
}

Future<void> printListDynamic(SqfEntityProvider model, String pSql) async {
  final list = await model.execDataTable(pSql);
  printList(list);
}

void printList(List<dynamic> list, {bool isMap = false, String? title}) {
  print('PRINTLIST--------------$title---------------lenght: ${list.length}');
  for (final o in list) {
    if (isMap) {
      print(o.toMap());
    } else {
      print(o.toString());
    }
  }
}

Future<void> printCategories(bool getIsDeleted) async {
  final categoryList =
      await Category().select(getIsDeleted: getIsDeleted).toList();
  print('LISTING CATEGORIES -> Category().select().toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${categoryList.length} matches found:');
  for (int i = 0; i < categoryList.length; i++) {
    print(categoryList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

class BundledDbModel extends SqfEntityModelProvider {}

Future<String> createModelFromDatabaseSample() async {
/* STEP 1

  // Copy your database in /assets folder (in this sample we copied chinook.sqlite database)
  // and define your asset database in pubspec.yaml as below

flutter:
  assets:
    - assets/chinook.sqlite

*/

// STEP 2
// Run this script with this parameters.
// databaseName: Specify a name for your database to use for the database connection
// bundledDatabasePath: File path of your copied database
  final bundledDbModel = await convertDatabaseToModelBase(BundledDbModel()
    ..databaseName = 'chinook.db'
    ..bundledDatabasePath = 'assets/chinook.sqlite');

// STEP 3
// Run this function to convert the model to annotation
  final String modelConstString =
      SqfEntityConverter(bundledDbModel).createConstDatabase();

// That's all. Set clipboard to paste codes
  await Clipboard.setData(ClipboardData(text: modelConstString));

  /*
      Model were created succesfuly and set to the Clipboard. 

      STEP 1:
      Open model.dart file in lib/model folder and paste (Ctrl+V) models after following line
      part 'model.g.view.dart';

      STEP 2:
      Go Terminal Window and run command below
      flutter pub run build_runner build --delete-conflicting-outputs
      Your Entity models will be created in lib/model/model.g.dart

 */
  print('''Your ${bundledDbModel.databaseName} 
      were created succesfuly and set to the Clipboard. 

      STEP 1:
      Open model.dart file in lib/model folder and paste models after following line
      part 'model.g.dart';

      STEP 2:
      Go Terminal Window and run command below
      flutter pub run build_runner build --delete-conflicting-outputs
      Your Entity models will be created in lib/model/model.g.dart''');

  return modelConstString;
}

Future<String> createSqfEntityModelString([bool setClipboard = true]) async {
  // To get the class from the clipboard, run it separately for each object
  // Create Entity Model String of model from file at '/lib/model/model.dart'
  /// and set the Clipboard (After debugging, press Ctrl+V to paste the model from the Clipboard into `model.g.dart`)

  final model = SqfEntityModelConverter(chinookdb).toModelBase();
  final strModel = StringBuffer()
    ..writeln('part of \'model.dart\';')
    ..writeln(SqfEntityConverter(model).createModelDatabase())
    ..writeln(SqfEntityConverter(model).createEntites());

  if (setClipboard) {
    await Clipboard.setData(ClipboardData(text: strModel.toString()));
  }

  return strModel.toString();

  // also you can get Model String from TextField in App (on the Emulator only!)
  /* also you can generate model.g.dart as following:
  --> Go Terminal Window and run command below
    flutter pub run build_runner build --delete-conflicting-outputs
  Note: After running the command Please check lib/model/model.g.dart 
  */
  // Notice: Keyboard shortcuts are not working on the emulator.
  // To copy for your model, click on the cursor in the TextField than open tooltip menu in the emulator.
  // When the menu opens, you can click 'SELECT ALL' and then click 'COPY'.
}

Future<void> printProducts() async {
  final productList = await Product().select().toList();
  print(
      'EXAMPLE 1.1: SELECT ALL ROWS WITHOUT FILTER ex: SELECT * FROM PRODUCTS \n -> Product().select().toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> samples1() async {
// EXAMPLE 1.1: SELECT * FROM PRODUCTS
  await printProducts();
// EXAMPLE 1.2: ORDER BY FIELDS -> ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id

  var productList = await Product()
      .select()
      .orderBy('name')
      .orderByDesc('price')
      .orderBy('id')
      .toList();
  print(
      'EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id \n-> Product().select().orderBy(\'name\').orderByDesc(\'price\').orderBy(\'id\').toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.3: SELECT SPECIFIC FIELDS -> ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC
  print(
      'EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC \n-> Product().select(columnsToSelect: [\'name\',\'price\']).orderByDesc(\'price\').toList()');

  productList = await Product()
      .select(columnsToSelect: ['name', 'price'])
      .orderByDesc('price')
      .toList();

  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------');
}

Future<void> samples2() async {
// EXAMPLE 1.4: SELECT * FROM PRODUCTS WHERE isActive=1
  var productList = await Product().select().isActive.equals(true).toList();
  print(
      'EXAMPLE 1.4: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1 \n->  Product().select().isActive.equals(true).toList()');

  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.5: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9)
  productList = await Product().select().id.inValues([3, 6, 9]).toList();
  print(
      'EXAMPLE 1.5: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9) \n -> Product().select().id.inValues([3,6,9]).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// Brackets in query, Contains, Endswith, Startswith SAMPLES
// EXAMPLE 1.6: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%')
  final singleProduct = await Product()
      .select()
      .price
      .greaterThan(10000)
      .and
      .startBlock
      .description
      .contains('256')
      .or
      .description
      .startsWith('512')
      .endBlock
      .toSingle();
  print(
      'EXAMPLE 1.6: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE \'%256%\' OR description LIKE \'512%\') \n -> Product().select().price.greaterThan(10000).and.startBlock.description.contains(\'256\').or.description.startsWith(\'512").endBlock.toSingle((product){ // TO DO })');
  print('Toplam ${(singleProduct != null ? '1' : '0')} sonuç listeleniyor:');
  if (singleProduct != null) {
    print(singleProduct.toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.7: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB')
  productList = await Product()
      .select()
      .price
      .lessThanOrEquals(10000)
      .and
      .startBlock
      .description
      .contains('128')
      .or
      .description
      .endsWith('GB')
      .or
      .description
      .startsWith('128')
      .endBlock
      .toList();
  print(
      'EXAMPLE 1.7: BRACKETS 2 ex: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE \'%128%\' OR description LIKE \'%GB\') \n -> Product().select(columnsToSelect:[\'name\',\'price\']).price.lessThanOrEquals(10000).and.startBlock.description.contains(\'128\').or.description.endsWith(\'GB\').endBlock.toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.8: NOT EQUALS
  productList = await Product().select().id.not.equals(11).toList();
  print(
      'EXAMPLE 1.8: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11 \n -> Product().select().id.not.equals(11).toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.9: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS
  productList = await Product()
      .select()
      .price
      .greaterThanOrEquals(10000)
      .and
      .price
      .lessThanOrEquals(13000)
      .toList();
  print(
      'EXAMPLE 1.9: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000 \n -> Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.10: BETWEEN KEYWORD
  productList = await Product()
      .select()
      .price
      .between(8000, 14000)
      .orderBy('price')
      .toList();
  print(
      'EXAMPLE 1.10: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000 \n -> Product().select().price.between(8000,14000).orderBy(\'price\').toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.11: 'NOT' KEYWORD
  productList = await Product().select().id.not.greaterThan(5).toList();
  print(
      'EXAMPLE 1.11: \'NOT\' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5 \n -> Product().select().id.not.greaterThan(5).toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 1.12: WRITING CUSTOM FILTER IN WHERE CLAUSE
  productList = await Product()
      .select()
      .where('id IN (3,6,9) OR price>?', parameterValue: 8000)
      .toList();
  print(
      'EXAMPLE 1.12: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000 \n -> Product().select().where(\'id IN (3,6,9) OR price>8000\').toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 1.13: Build filter and query from values from the form
  // assume that the values come from the form by defining several variables:
  int minPrice;
  int maxPrice;
  String nameContains;
  String descriptionContains;

  // setting values
  minPrice =
      8000; // if minPrice is null then -> The between method runs LessThanOrEquals Method
  maxPrice =
      10000; // if maxPrice is null then -> The between method runs GreaterThanOrEquals Method
  nameContains =
      '13'; // if all of the values any method's is null then -> this method will be extracted
  descriptionContains = 'SSD';

  productList = await Product()
      .select()
      .price
      .between(minPrice, maxPrice)
      .and
      .name
      .contains(nameContains)
      .and
      .description
      .contains(descriptionContains)
      .toList();
  print(
      'EXAMPLE 1.13: Product().select().price.between($minPrice, $maxPrice).and.name.contains(\'$nameContains\').and.description.contains(\'$descriptionContains\').toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (var prod in productList) {
    print(prod.toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 1.14: Select products with deleted items (only softdelete was activated on Model)
  productList = await Product().select(getIsDeleted: true).toList();
  print(
      'EXAMPLE 1.14: EXAMPLE 1.13: Select products with deleted items\n -> Product().select(getIsDeleted: true).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');

  for (var prod in productList) {
    print(prod.toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 1.15: Select products only deleted items (only softdelete was activated on Model)
  productList = await Product()
      .select(getIsDeleted: true)
      .isDeleted
      .equals(true)
      .toList();
  print(
      'EXAMPLE 1.15: Select products only deleted items \n -> Product().select(getIsDeleted: true).isDeleted.equals(true).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (var prod in productList) {
    print(prod.toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 1.16: Select products between datetimes
  productList = await Product()
      .select()
      //.datetime.between(DateTime(2020,1,1,14), DateTime(2020,1,5,15))
      .where(
          'datetime BETWEEN \'${DateTime(2020, 1, 1, 14)}\' AND \'${DateTime(2020, 1, 1, 14).millisecondsSinceEpoch}\'')
      .toList();
  print(
      'EXAMPLE 1.16: Select products between datetimes \n -> Product().select().datetime.between(DateTime(2020,1,1,14), DateTime(2020,1,5,15)).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (var prod in productList) {
    print(prod.toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> samples3() async {
// EXAMPLE 3.1: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC
  var productList =
      await Product().select().orderByDesc('price').top(3).toList();
  print(
      'EXAMPLE 3.1: LIMITATION ex: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC \n -> Product().select().orderByDesc(\'price\').top(3).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 3.2: SAMPLE PAGING -> PRODUCTS in 3. page (5 items per page)
  productList = await Product().select().page(3, 5).toList();
  print(
      'EXAMPLE 3.2: SAMPLE PAGING ex: PRODUCTS in 3. page (5 items per page) \n -> Product().select().page(3,5).toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> samples4() async {
// EXAMPLE 4.1: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000
  final productList = await Product()
      .distinct(columnsToSelect: ['name'])
      .price
      .greaterThan(3000)
      .toList();
  print(
      'EXAMPLE 4.1: DISTINCT ex: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000 \n -> Product().distinct(columnsToSelect:[\'name\').price.greaterThan(3000).toList();');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${productList.length} matches found:');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');

  // EXAMPLE 4.2: GROUP BY with SCALAR OR AGGREGATE FUNCTIONS ex: SELECT COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice FROM PRODUCTS GROUP BY name
  // /* count(),avg(),max(),min() when empty returns columnname as default, count('aliasname') is returns alias columnname */

  final objectList = await Product()
      .select(columnsToSelect: [
        ProductFields.name.toString(),
        ProductFields.id.count('Count'),
        ProductFields.price.min('minPrice'),
        ProductFields.price.max('maxPrice'),
        ProductFields.price.avg('avgPrice'),
        ProductFields.price.sum('sumPrice'),
      ])
      .groupBy(ProductFields.name
          .toString() /*also you can use this .groupBy('name')*/)
      .toListObject();
  print(
      'EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS ex: SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice,ProductFields.price.sum(\'sumPrice\') FROM PRODUCTS GROUP BY name \n-> Product().select(columnsToSelect: [ProductFields.name.toString(), ProductFields.id.count(\'Count\'), ProductFields.price.min(\'minPrice\'), ProductFields.price.max(\'maxPrice\'), ProductFields.price.avg(\'avgPrice\')).groupBy(ProductFields.name.toString()).toListObject()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${objectList.length} matches found:');
  for (int i = 0; i < objectList.length; i++) {
    print(objectList[i].toString());
  }
  print('---------------------------------------------------------------');
}

Future<void> samples5() async {
// EXAMPLE 5.1: Update multiple records with query
  var result =
      await Product().select().id.greaterThan(10).update({'isActive': 0});
  print(
      'EXAMPLE 5.1: Update multiple records with query \n -> Product().select().id.greaterThan(10).update({\'isActive\': 0});');
  print(result.toString());
  print('---------------------------------------------------------------\n\n');

// UPDATE imageUrl field by CategoryId
  await Product().select().categoryId.equals(1).update({
    'imageUrl':
        'https://raw.githubusercontent.com/hhtokpinar/sqfEntity/master/example/assets/notebook.png'
  });
  await Product().select().categoryId.equals(2).update({
    'imageUrl':
        'https://raw.githubusercontent.com/hhtokpinar/sqfEntity/master/example/assets/ultrabook.png'
  });

// EXAMPLE 5.2: Update multiple records with query
  result =
      await Product().select().id.lessThanOrEquals(10).update({'isActive': 1});
  print(
      'EXAMPLE 5.2: uUpdate multiple records with query \n -> Product().select().id.lessThanOrEquals(10).update({\'isActive\': 1});');
  print(result.toString());
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 5.3: select product by id and update
  final product2 = await Product().getById(15);
// TO DO
// update product object if exist
  if (product2 != null) {
    product2.description = '512GB SSD i7 (updated)';
    await product2.save();
    print(
        'EXAMPLE 5.3: id=15 Product item updated: ${product2.toMap().toString()}');
  } else {
    print('EXAMPLE 5.3: id=15 => product not found');
  }
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 5.4: update some filtered products with saveAll method -> Product().saveAll(productList){});
  var productList = await Product().select().price.lessThan(1000).toList();
  double i = 0;
  for (var product in productList) {
    i = i + 10;
    product.price = i;
  }
  final results = await Product.saveAll(productList);
  productList = await Product().select().toList();
  print(
      'EXAMPLE 5.4: update some filtered products with saveAll method \n -> Product().saveAll(productList){});');

  print(' List<BoolResult> result of saveAll method is following:');

  for (var result in results) {
    print(result.toString());
  }
  print('---------------------------------------------------------------');

  print(
      'EXAMPLE 5.4: listing saved products (set price=i) with saveAll method;');
  for (int i = 0; i < productList.length; i++) {
    print(productList[i].toMap());
  }
  print('---------------------------------------------------------------');
}

Future<void> samples6() async {
  // EXAMPLE 6.1 : Delete all products.
  // Uncomment following section for delete all products
  /*
  Product().select().delete().then((result) {
    if (result.success)
      print('${result.successMessage}');
    else
      print('${result.errorMessage}');
  });
*/

// EXAMPLE 6.2: get product with query id and delete
  var result = await Product().select().id.equals(16).delete();
  print(
      'EXAMPLE 6.2: delete product by query filder \n -> Product().select().id.equals(16).delete();');
  print(result.toString());
  print('---------------------------------------------------------------\n\n');

// EXAMPLE 6.3: Get product by id and then delete
  final product = await Product().getById(17);
// TO DO
// delete product object if exist
  if (product != null) {
    result = await product.delete();
    print(
        'EXAMPLE 6.3: delete product if exist \n -> if (product != null) Product.delete();');
    if (result.success) {
      print('${result.successMessage}');
    } else {
      print('${result.errorMessage}');
    }
    print(
        '---------------------------------------------------------------\n\n');
  } else {
    print('id=15 => product not found');
    print(
        '---------------------------------------------------------------\n\n');
  }

// EXAMPLE 6.4: Delete many products by filter
  result = await Product().select().id.greaterThan(17).delete();
  print(
      'EXAMPLE 6.4: Delete many products by filter \n -> Product().select().id.greaterThan(17).delete()');
  if (result.success) {
    print('${result.successMessage}');
  } else {
    print('${result.errorMessage}');
  }
  print('---------------------------------------------------------------\n\n');

/*/ EXAMPLE 6.5: Get product by id and then recover
  Product().getById(17, (product) {
// TO DO
// delete product object if exist
    if (product != null) {
      product.delete().then((result) {
        print(
            'EXAMPLE 6.5: recover product if exist \n -> if (product != null) Product.recover();');
        if (result.success)
          print('${result.successMessage}');
        else
          print('${result.errorMessage}');
        print(
            '---------------------------------------------------------------\n\n');
      });
    } else {
      print('id=15 => product not found');
      print(
          '---------------------------------------------------------------\n\n');
    }
    return;
  });
*/
// EXAMPLE 6.6: Recover many products by filter
  result = await Product().select().id.greaterThan(17).recover();
  print(
      'EXAMPLE 6.6: Recover many products by filter \n -> Product().select().id.greaterThan(17).recover()');
  if (result.success) {
    print('${result.successMessage}');
  } else {
    print('${result.errorMessage}');
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> samples7() async {
  // EXAMPLE 7.1: goto Category Object from Product \n-> Product.category((_category) {});
  final product = await Product().getById(3);
  if (product != null) {
    final category = await product.getCategory();
    print(
        'EXAMPLE 7.1: goto Category Object from Product \n-> Product.getCategory(); ');

    print(
        'The category of \'${product.name}\' is: ${category == null ? 'null' : category.toMap()}');
  }
  // EXAMPLE 7.2: list Products of Categories \n-> Product.category((_category) {});
  final categoryList = await Category().select().toList();
  for (var category in categoryList) {
    final productList = await category.getProducts()!.toList();
    print(
        'EXAMPLE 7.2.${category.id}: Products of \'${category.name}\' listing \n-> category.getProducts((productList) {}); ');
    // PRINT RESULTS TO DEBUG CONSOLE
    print('${productList.length} matches found:');
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print('---------------------------------------------------------------');
    return;
  }
  return;
}

Future<void> samples8() async {
  List<Todo>? todosList = await Todo.fromWeb();
  if (todosList != null) {
    await Todo().upsertAll(todosList);

    todosList = await Todo().select().top(10).toList();
    print(
        'EXAMPLE 8.1: Fill List from web (JSON data) and upsertAll \n -> Todo.fromWeb((todosList) {}');
    print('${todosList.length.toString()} matches found\n');
    for (var todo in todosList) {
      print(todo.toMap());
    }
    print(
        '---------------------------------------------------------------\n\n');
  }
  todosList = await Todo.fromWebUrl(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'));
  if (todosList != null) {
    final results = await Todo().upsertAll(todosList);
    print(
        'EXAMPLE 8.2: upsertAll result \n -> final results = await Todo().upsertAll(todosList);');

    // print upsert Results
    for (var res in results.commitResult!) {
      res = res; // dummy line for analysis_options (unused_local_variable)
      //print(res.toString()); // uncomment this line for print save results
    }
  }
  todosList = await Todo().select().top(10).toList();
  print(
      'EXAMPLE 8.2: Fill List from web with Url (JSON data) and upsertAll \n -> Todo.fromWebUrl(\'https://jsonplaceholder.typicode.com/todos\', (todosList) {}');
  print('${todosList.length.toString()} matches found\n');
  for (var todo in todosList) {
    print(todo.toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> samples9() async {
  // EX.9.1 Execute custom SQL command on database
  final sql_91 = 'UPDATE product set isActive=1 where isActive=1';
  final result_91 = await MyDbModel().execSQL(sql_91);
  print(
      'EX.9.1 Execute custom SQL command on database\n -> final sql=\'$sql_91\';\n -> MyDbModel().execSQL(sql)  \n -> print result = ${result_91.toString()}');

  // EX.9.2 Execute custom SQL command List on database
  final sqlList = <String>[]
    ..add('UPDATE product set isActive=1 where isActive=1')
    ..add('UPDATE product set isActive=0 where isActive=0');

  final result_92 = await MyDbModel().execSQLList(sqlList);
  print(
      'EX.9.2 Execute custom SQL command List on database\n -> final sqlList=List<String>();\n -> MyDbModel().execSQLList(sqlList);  \n -> print result = ${result_92.toString()}');

// EX.9.3 Execute custom SQL Query and get datatable -> returns List<Map<String,dynamic>>
  final sql_93 = 'SELECT name, price FROM product order by price desc LIMIT 5';
  final result_93 = await MyDbModel().execDataTable(sql_93);
  print(
      'EX.9.3 Execute custom SQL Query and get datatable -> returns List<Map<String,dynamic>> \n -> MyDbModel().execDataTable(\'$sql_93\');\n -> print result:');
  for (var item in result_93) {
    print(item.toString());
  }

  /// EX.9.4 Execute custom SQL Query and get first col of first row
  final sql_94 = 'SELECT name FROM product order by price desc';
  final result_94 = await MyDbModel().execScalar(sql_94);
  print(
      'EX.9.4 Execute custom SQL Query and get first col of first row -> returns dynamic \n -> MyDbModel().execScalar(\'$sql_94\');\n -> print result:');
  print(result_94.toString());
}

Future<void> samples10() async {
  print('EXAMPLE 10 SqfEntity Sequence SAMPLES-----------');

  final int currentVal = await IdentitySequence().currentVal();
  final int nextVal = await IdentitySequence().nextVal();
  final int nextVal2 = await IdentitySequence().nextVal();
  final int currentVal2 = await IdentitySequence().currentVal();

  print('Sample Code:\n');
  print('''
  final currentVal= await IdentitySequence().currentVal();
  result: currentVal = $currentVal
  final nextVal = await IdentitySequence().nextVal();
  result: nextVal = $nextVal
  final int nextVal2 = await IdentitySequence().nextVal();
  result: nextVal2 = $nextVal2
  final int currentVal2 = await IdentitySequence().currentVal();
  result: currentVal2 = $currentVal2
  ''');
}

/// toJson samples
Future<void> samples11() async {
  // EXAMPLE 11.1 single object to Json
  final product = await Product().select().toSingle();
  final jsonString = product!.toJson();

  print(
      'EXAMPLE 11.1 single object to Json\n product jsonString is: $jsonString');

  //EXAMPLE 11.2 object list with nested objects to Json
  final jsonStringWithChilds =
      await Category().select().toJsonWithChilds(); // all categories selected
  print(
      'EXAMPLE 11.2 object list with nested objects to Json\n categories jsonStringWithChilds is: $jsonStringWithChilds');
}

Future<void> samples12() async {
  print('EXAMPLE 12 SqfEntity VIEW SAMPLES-----------');
  print(
      'EXAMPLE 12.1 Get some data from Vtracks -> final vtracs = await VTrack().select().top(5).toList();');
  final vtracs = await VTrack().select().top(5).toList();
  printList(vtracs, isMap: true, title: '${vtracs.length} matches found');
}

/// add new categories if not any Category
Future<void> addSomeProducts() async {
  await addCategories();
  // add new products if not any Product..
  final product = await Product().select().toSingle();
  if (product == null) {
    await addProducts();
  } else {
    print(
        'There is already products in the database.. addProduct will not run');
  }
  return;
}

Future<void> addCategories() async {
  final category = await Category().select().toSingle();
  if (category == null) {
    await Category(name: 'Notebooks', isActive: true).save();
    await Category(name: 'Ultrabooks', isActive: true).save();
  } else {
    print(
        'There is already categories in the database.. addCategories will not run');
  }
}

Future<bool> addProducts() async {
  final productList = await Product().select(getIsDeleted: true).toList();
  if (productList.length < 15) {
    // some dummy rows for select (id:1- to 15)
    await Product(
      name: 'Notebook 12"',
      description: '128 GB SSD i7',
      price: 6899,
      categoryId: 1,
      date: DateTime(2020, 01, 01),
      datetime: DateTime(2020, 01, 01, 12),
    ).save();

    await Product(
            name: 'Notebook 12"',
            description: '256 GB SSD i7',
            price: 8244,
            categoryId: 1,
            date: DateTime(2020, 01, 02),
            datetime: DateTime(2020, 01, 02, 13))
        .save();
    await Product(
            name: 'Notebook 12"',
            description: '512 GB SSD i7',
            price: 9214,
            categoryId: 1,
            date: DateTime(2020, 01, 03),
            datetime: DateTime(2020, 01, 03, 14))
        .save();

    await Product(
            name: 'Notebook 13"',
            description: '128 GB SSD',
            price: 8500,
            categoryId: 1,
            date: DateTime(2020, 01, 04),
            datetime: DateTime(2020, 01, 04, 15))
        .save();
    await Product(
            name: 'Notebook 13"',
            description: '256 GB SSD',
            price: 9900,
            categoryId: 1,
            date: DateTime(2020, 01, 05),
            datetime: DateTime(2020, 01, 05, 16))
        .save();
    await Product(
            name: 'Notebook 13"',
            description: '512 GB SSD',
            price: 11000,
            categoryId: 1,
            date: DateTime(2020, 01, 06),
            datetime: DateTime(2020, 01, 06, 17))
        .save();

    await Product(
            name: 'Notebook 15"',
            description: '128 GB SSD',
            price: 8999,
            categoryId: 1,
            date: DateTime(2020, 01, 07),
            datetime: DateTime(2020, 01, 07, 18))
        .save();
    await Product(
            name: 'Notebook 15"',
            description: '256 GB SSD',
            price: 10499,
            categoryId: 1,
            date: DateTime(2020, 01, 08),
            datetime: DateTime(2020, 01, 08, 19))
        .save();
    await Product(
            name: 'Notebook 15"',
            description: '512 GB SSD',
            price: 11999,
            categoryId: 1,
            date: DateTime(2020, 01, 09),
            datetime: DateTime(2020, 01, 09, 20))
        .save();

    await Product(
            name: 'Ultrabook 13"',
            description: '128 GB SSD i5',
            price: 9954,
            categoryId: 2)
        .save();
    await Product(
            name: 'Ultrabook 13"',
            description: '256 GB SSD i5',
            price: 11154,
            categoryId: 2)
        .save();
    await Product(
            name: 'Ultrabook 13"',
            description: '512 GB SSD i5',
            price: 13000,
            categoryId: 2)
        .save();

    await Product(
            name: 'Ultrabook 15"',
            description: '128 GB SSD i7',
            price: 11000,
            categoryId: 2)
        .save();
    await Product(
            name: 'Ultrabook 15"',
            description: '256 GB SSD i7',
            price: 12000,
            categoryId: 2)
        .save();
    await Product(
            name: 'Ultrabook 15"',
            description: '512 GB SSD i7',
            price: 14000,
            categoryId: 2)
        .save();
    print('added 15 new products');

    // add a few dummy products for delete (id:from 16 to 20)
    await Product(name: 'Product 1').save();
    await Product(name: 'Product 2').save();
    await Product(name: 'Product 3').save();
    await Product(name: 'Product 4').save();
    await Product(name: 'Product 5').save();
    print('added 5 dummy products');
  }
  return true;
}
