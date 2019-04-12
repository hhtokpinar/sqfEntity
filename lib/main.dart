import 'package:flutter/material.dart';
import 'package:sqfentity/app.dart';
import 'package:sqfentity/db/MyDbModel.dart';
import 'package:sqfentity/models/models.dart';

void main(List<String> args) {
  // 1- creates a simple  Model named product and sets the clipboard for paste into your models.dart file
  createSqfEntityModelString();

  // 2- run Entity Model samples
  // ATTENTION! when the software/app is started, you must check the database was it initialized.
  // If needed, initilizeDb method runs CREATE / ALTER TABLE query for you.

  MyDbModel().initializeDB((result) {
    if (result == true)
    //The database is ready for use
    {
      runSamples();
      // TO DO
      // ex: runApp(MyApp());
      //
    }
  });
}

void runSamples() {
  // add some products
  addSomeProducts((isReady) {
    if (isReady) {
      // Print all categories
      printCategories(false);

      // DELETE BATCH, DELETE OBJECT, RECOVERY
      samples6();

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

      // ORM (Object Relational Mapping) SAMPLE
      samples7();

      // fill List from the web (JSON)
      samples8();
    }
  });
}

void printCategories(bool getIsDeleted) {
  Category().select(getIsDeleted: getIsDeleted).toList((categoryList) {
    print("LISTING CATEGORIES -> Category().select().toList()");
    print("${categoryList.length} matches found:");
    for (int i = 0; i < categoryList.length; i++) {
      print(categoryList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });
}

void createSqfEntityModelString() {
  // To get the class from the clipboard, run it separately for each object
  // create Model String and set the Clipboard (After debugging, press Ctrl+V to paste the model from the Clipboard)
  String sqfEntityModelString =
      MyDbModel().createModel(); //SqfEntityDbContext.createModel(MyDbModel());

  // also you can get Model String from TextField in App (on the Emulator only!)
  // Notice: Keyboard shortcuts are not working on the emulator.
  // To copy for your model, click on the cursor in the TextField than open tooltip menu in the emulator.
  // When the menu opens, you can click "SELECT ALL" and then click "COPY".
  runApp(MyApp(sqfEntityModelString));
}

void printProducts() {
  Product().select().toList((productList) {
    print(
        "EXAMPLE 1.1: SELECT ALL ROWS WITHOUT FILTER ex: SELECT * FROM PRODUCTS \n -> Product().select().toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });
}

void samples1() {
// EXAMPLE 1.1: SELECT * FROM PRODUCTS
  printProducts();
// EXAMPLE 1.2: ORDER BY FIELDS -> ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id
  Product()
      .select()
      .orderBy("name")
      .orderByDesc("price")
      .orderBy("id")
      .toList((productList) {
    print(
        "EXAMPLE 1.2: ORDER BY FIELDS ex: SELECT * FROM PRODUCTS ORDER BY name, price DESC, id \n-> Product().select().orderBy(\"name\").orderByDesc(\"price\").orderBy(\"id\").toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.3: SELECT SPECIFIC FIELDS -> ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC
  Product()
      .select(columnsToSelect: ["name", "price"])
      .orderByDesc("price")
      .toList((productList) {
        print(
            "EXAMPLE 1.3: SELECT SPECIFIC FIELDS ex: SELECT name,price FROM PRODUCTS ORDER BY price DESC \n-> Product().select(columnsToSelect: [\"name\",\"price\"]).orderByDesc(\"price\").toList()");
        print("${productList.length} matches found:");
        for (int i = 0; i < productList.length; i++) {
          print(productList[i].toMap());
        }
        print(
            "---------------------------------------------------------------");
      });
}

void samples2() {
// EXAMPLE 1.4: SELECT * FROM PRODUCTS WHERE isActive=1
  Product().select().isActive.equals(true).toList((productList) {
    print(
        "EXAMPLE 1.4: EQUALS ex: SELECT * FROM PRODUCTS WHERE isActive=1 \n->  Product().select().isActive.equals(true).toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.5: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9)
  Product().select().id.inValues([3, 6, 9]).toList((productList) {
    print(
        "EXAMPLE 1.5: WHERE field IN (VALUES) ex: SELECT * FROM PRODUCTS WHERE ID IN (3,6,9) \n -> Product().select().id.inValues([3,6,9]).toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// Brackets in query, Contains, Endswith, Startswith SAMPLES
// EXAMPLE 1.6: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%')
  Product()
      .select()
      .price
      .greaterThan(10000)
      .and
      .startBlock
      .description
      .contains("256")
      .or
      .description
      .startsWith("512")
      .endBlock
      .toSingle((product) {
    print(
        "EXAMPLE 1.6: BRACKETS ex: SELECT TOP 1 * FROM PRODUCTS WHERE price>10000 AND (description LIKE '%256%' OR description LIKE '512%') \n -> Product().select().price.greaterThan(10000).and.startBlock.description.contains(\"256\").or.description.startsWith(\"512\").endBlock.toSingle((product){ // TO DO })");
    print("Toplam " + (product != null ? "1" : "0") + " sonuç listeleniyor:");
    if (product != null) print(product.toMap());
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.7: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB')
  Product()
      .select()
      .price
      .lessThanOrEquals(10000)
      .and
      .startBlock
      .description
      .contains("128")
      .or
      .description
      .endsWith("GB")
      .or
      .description
      .startsWith("128")
      .endBlock
      .toList((productList) {
    print(
        "EXAMPLE 1.7: BRACKETS 2 ex: SELECT name,price FROM PRODUCTS WHERE price <=10000 AND (description LIKE '%128%' OR description LIKE '%GB') \n -> Product().select(columnsToSelect:[\"name\",\"price\"]).price.lessThanOrEquals(10000).and.startBlock.description.contains(\"128\").or.description.endsWith(\"GB\").endBlock.toList();");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.8: NOT EQUALS
  Product().select().id.not.equals(11).toList((productList) {
    print(
        "EXAMPLE 1.8: NOT EQUALS ex: SELECT * FROM PRODUCTS WHERE ID <> 11 \n -> Product().select().id.not.equals(11).toList();");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.9: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS
  Product()
      .select()
      .price
      .greaterThanOrEquals(10000)
      .and
      .price
      .lessThanOrEquals(13000)
      .toList((productList) {
    print(
        "EXAMPLE 1.9: GREATERTHEN OR EQUALS, LESSTHAN OR EQUALS ex: SELECT * FROM PRODUCTS WHERE price>=10000 AND price<=13000 \n -> Product().select().price.greaterThanOrEquals(10000).and.price.lessThanOrEquals(13000).toList();");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.10: BETWEEN KEYWORD
  Product()
      .select()
      .price
      .between(8000, 14000)
      .orderBy("price")
      .toList((productList) {
    print(
        "EXAMPLE 1.10: BETWEEN ex: SELECT * FROM PRODUCTS WHERE price BETWEEN 8000 AND 14000 \n -> Product().select().price.between(8000,14000).orderBy(\"price\").toList();");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.11: 'NOT' KEYWORD
  Product().select().id.not.greaterThan(5).toList((productList) {
    print(
        "EXAMPLE 1.11: 'NOT' KEYWORD ex: SELECT * FROM PRODUCTS WHERE NOT id>5 \n -> Product().select().id.not.greaterThan(5).toList();");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 1.12: WRITING CUSTOM FILTER IN WHERE CLAUSE
  Product().select().where("id IN (3,6,9) OR price>8000").toList((productList) {
    print(
        "EXAMPLE 1.12: WRITING CUSTOM FILTER IN WHERE CLAUSE ex: SELECT * FROM PRODUCTS WHERE id IN (3,6,9) OR price>8000 \n -> Product().select().where(\"id IN (3,6,9) OR price>8000\").toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

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
      "13"; // if all of the values any method's is null then -> this method will be extracted
  descriptionContains = "SSD";

  Product()
      .select()
      .price
      .between(minPrice, maxPrice)
      .and
      .name
      .contains(nameContains)
      .and
      .description
      .contains(descriptionContains)
      .toList((productList) {
    print(
        "EXAMPLE 1.13: Product().select().price.between($minPrice, $maxPrice).and.name.contains(\"$nameContains\").and.description.contains(\"$descriptionContains\").toList()");
    print("${productList.length} matches found:");
    for (var prod in productList) {
      print(prod.toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

  // EXAMPLE 1.14: Select products with deleted items (only softdelete was activated on Model)
  Product().select(getIsDeleted: true).toList((productList) {
    print(
        "EXAMPLE 1.14: EXAMPLE 1.13: Select products with deleted items\n -> Product().select(getIsDeleted: true).toList()");
    print("${productList.length} matches found:");

    for (var prod in productList) {
      print(prod.toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

  // EXAMPLE 1.15: Select products only deleted items (only softdelete was activated on Model)
  Product()
      .select(getIsDeleted: true)
      .isDeleted
      .equals(true)
      .toList((productList) {
    print(
        "EXAMPLE 1.15: Select products only deleted items \n -> Product().select(getIsDeleted: true).isDeleted.equals(true).toList()");
    print("${productList.length} matches found:");
    for (var prod in productList) {
      print(prod.toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });
}

void samples3() {
// EXAMPLE 3.1: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC
  Product().select().orderByDesc("price").top(3).toList((productList) {
    print(
        "EXAMPLE 3.1: LIMITATION ex: SELECT TOP 3 * FROM PRODUCTS ORDER BY price DESC \n -> Product().select().orderByDesc(\"price\").top(3).toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });

  // EXAMPLE 3.2: SAMPLE PAGING -> PRODUCTS in 3. page (5 items per page)
  Product().select().page(3, 5).toList((productList) {
    print(
        "EXAMPLE 3.2: SAMPLE PAGING ex: PRODUCTS in 3. page (5 items per page) \n -> Product().select().page(3,5).toList()");
    print("${productList.length} matches found:");
    for (int i = 0; i < productList.length; i++) {
      print(productList[i].toMap());
    }
    print(
        "---------------------------------------------------------------\n\n");
  });
}

void samples4() {
// EXAMPLE 4.1: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000
  Product()
      .distinct(columnsToSelect: ["name"])
      .price
      .greaterThan(3000)
      .toList((productList) {
        print(
            "EXAMPLE 4.1: DISTINCT ex: SELECT DISTINCT name FROM PRODUCTS WHERE price > 3000 \n -> Product().distinct(columnsToSelect:[\"name\").price.greaterThan(3000).toList();");
        print("${productList.length} matches found:");
        for (int i = 0; i < productList.length; i++) {
          print(productList[i].toMap());
        }
        print(
            "---------------------------------------------------------------\n\n");
      });

  // EXAMPLE 4.2: GROUP BY with SCALAR OR AGGREGATE FUNCTIONS ex: SELECT COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice FROM PRODUCTS GROUP BY name
  // /* count(),avg(),max(),min() when empty returns columnname as default, count("aliasname") is returns alias columnname */

  Product()
      .select(columnsToSelect: [
        ProductFields.name.toString(),
        ProductFields.id.count("Count"),
        ProductFields.price.min("minPrice"),
        ProductFields.price.max("maxPrice"),
        ProductFields.price.avg("avgPrice"),
        ProductFields.price.sum("sumPrice"),
      ])
      .groupBy(ProductFields.name
          .toString() /*also you can use this .groupBy("name")*/)
      .toListObject((objectList) {
        print(
            "EXAMPLE 4.2: GROUP BY WITH SCALAR OR AGGREGATE FUNCTIONS ex: SELECT name, COUNT(id) AS Count, MIN(price) AS minPrice, MAX(price) AS maxPrice, AVG(price) AS avgPrice,ProductFields.price.sum(\"sumPrice\") FROM PRODUCTS GROUP BY name \n-> Product().select(columnsToSelect: [ProductFields.name.toString(), ProductFields.id.count(\"Count\"), ProductFields.price.min(\"minPrice\"), ProductFields.price.max(\"maxPrice\"), ProductFields.price.avg(\"avgPrice\")).groupBy(ProductFields.name.toString()).toListObject()");
        print("${objectList.length} matches found:");
        for (int i = 0; i < objectList.length; i++) {
          print(objectList[i].toString());
        }
        print(
            "---------------------------------------------------------------");
      });
}

void samples5() {
// EXAMPLE 5.1: Update multiple records with query
  Product().select().id.greaterThan(10).update({"isActive": 0}).then((result) {
    print(
        "EXAMPLE 5.1: Update multiple records with query \n -> Product().select().id.greaterThan(10).update({\"isActive\": 0});");
    print(result.toString());
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 5.2: Update multiple records with query
  Product()
      .select()
      .id
      .lessThanOrEquals(10)
      .update({"isActive": 1}).then((result) {
    print(
        "EXAMPLE 5.2: uUpdate multiple records with query \n -> Product().select().id.lessThanOrEquals(10).update({\"isActive\": 1});");
    print(result.toString());
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 5.3: select product by id and update
  Product().getById(15, (product2) {
// TO DO
// update product object if exist
    if (product2 != null) {
      product2.isActive = true;
      product2.description += " (updated)";
      product2.save().then((result) {
        print("EXAMPLE 5.3: id=$result Product item updated: " +
            product2.toMap().toString());
      });
    } else
      print("EXAMPLE 5.3: id=15 => product not found");
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 5.4: update some filtered products with saveAll method -> Product().saveAll(productList){});
  Product().select().toList((productList) {
    int i = 0;
    for (var product in productList) {
      i++;
      product.rownum = i;
    }
    Product().saveAll(productList).then((results) {
      Product().select().toList((productList) {
        print(
            "EXAMPLE 5.4: update some filtered products with saveAll method \n -> Product().saveAll(productList){});");

        print(" List<BoolResult> result of saveAll method is following:");
        for (var result in results) print(result.toString());
        print(
            "---------------------------------------------------------------");
        print(
            "EXAMPLE 5.4: listing saved products (set rownum=i) with saveAll method;");
        for (int i = 0; i < productList.length; i++) {
          print(productList[i].toMap());
        }
        print(
            "---------------------------------------------------------------");
      });
    });
  });
}

void samples6() {
  // EXAMPLE 6.1 : Delete all products.
  // Uncomment following section for delete all products
  /*
  Product().select().delete().then((result) {
    if (result.success)
      print("${result.successMessage}");
    else
      print("${result.errorMessage}");
  });
*/

// EXAMPLE 6.2: get product with query id and delete
  Product().select().id.equals(16).delete().then((result) {
    print(
        "EXAMPLE 6.2: delete product by query filder \n -> Product().select().id.equals(16).delete();");
    print(result.toString());
    print(
        "---------------------------------------------------------------\n\n");
  });

// EXAMPLE 6.3: Get product by id and then delete
  Product().getById(17, (product) {
// TO DO
// delete product object if exist
    if (product != null) {
      product.delete().then((result) {
        print(
            "EXAMPLE 6.3: delete product if exist \n -> if (product != null) Product.delete();");
        if (result.success)
          print("${result.successMessage}");
        else
          print("${result.errorMessage}");
        print(
            "---------------------------------------------------------------\n\n");
      });
    } else {
      print("id=15 => product not found");
      print(
          "---------------------------------------------------------------\n\n");
    }
  });

// EXAMPLE 6.4: Delete many products by filter
  Product().select().id.greaterThan(17).delete().then((result) {
    print(
        "EXAMPLE 6.4: Delete many products by filter \n -> Product().select().id.greaterThan(17).delete()");
    if (result.success) {
      print("${result.successMessage}");
    } else
      print("${result.errorMessage}");
    print(
        "---------------------------------------------------------------\n\n");
  });
}

void samples7() {
  // EXAMPLE 7.1: goto Category Object from Product \n-> Product.category((_category) {});
  Product().getById(3, (product) {
    product.getCategory((category) {
      print(
          "EXAMPLE 7.1: goto Category Object from Product \n-> Product.getCategory((_category) {}); ");

      print("The category of '${product.name}' is: " +
          category.toMap().toString());
    });
  });

  // EXAMPLE 7.2: list Products of Categories \n-> Product.category((_category) {});
  Category().select().toList((categoryList) {
    for (var category in categoryList)
      category.getProducts((productList) {
        print(
            "EXAMPLE 7.2.${category.id}: Products of '${category.name}' listing \n-> category.getProducts((productList) {}); ");
        print("${productList.length} matches found:");
        for (int i = 0; i < productList.length; i++) {
          print(productList[i].toMap());
        }
        print(
            "---------------------------------------------------------------");
      });
  });
}

void samples8() {
  Todo.fromWeb((todosList) {
    Todo().upsertAll(todosList).then((results) {
      //for (var res in results) print(res.toString()); // print upsert Results
      Todo().select().top(10).toList((todoList) {
        print(
            "EXAMPLE 8.1: Fill List from web (JSON data) and upsertAll \n -> Todo.fromWeb((todosList) {}");
        print(todoList.length.toString() + " matches found\n");
        for (var todo in todoList) {
          print(todo.toMap());
        }
        print(
            "---------------------------------------------------------------\n\n");
      });
    });
  });

  Todo.fromWebUrl("https://jsonplaceholder.typicode.com/todos", (todosList) {
    Todo().upsertAll(todosList).then((results) {
      //for (var res in results) print(res.toString()); // print upsert Results
      Todo().select().top(10).toList((todoList) {
        print(
            "EXAMPLE 8.2: Fill List from web with Url (JSON data) and upsertAll \n -> Todo.fromWebUrl(\"https://jsonplaceholder.typicode.com/todos\", (todosList) {}");
        print(todoList.length.toString() + " matches found\n");
        for (var todo in todoList) {
          print(todo.toMap());
        }
        print(
            "---------------------------------------------------------------\n\n");
      });
    });
  });
}

void addSomeProducts(VoidCallback isReady(bool ready)) {
  // add new products if not any Product..
  Category().select().toSingle((category) {
    if (category == null) {
      addCategories((ready) {
        addProducts((ready) {
          if (ready) isReady(true);
        });
      });
    } else {
      print("There is already rows in the database.. addProduct will not run");
      isReady(true);
    }
  });
}

void addCategories(VoidCallback isReady(bool ready)) {
  Category(name: "Notebooks", isActive: true).save();
  Category.withFields("Ultrabooks", true, false).save().then((_) {
    isReady(true);
  });
}

void addProducts(VoidCallback isReady(bool ready)) {
  Product().select().toList((productList) {
    if (productList.length < 15) {
      // some dummy rows for select (id:1- to 15)
      Product.withFields(
              "Notebook 12\"", "128 GB SSD i7", 6899, true, 1, 0, false)
          .save();
      Product.withFields(
              "Notebook 12\"", "256 GB SSD i7", 8244, true, 1, 0, false)
          .save();
      Product.withFields(
              "Notebook 12\"", "512 GB SSD i7", 9214, true, 1, 0, false)
          .save();

      Product.withFields("Notebook 13\"", "128 GB SSD", 8500, true, 1, 0, false)
          .save();
      Product.withFields("Notebook 13\"", "256 GB SSD", 9900, true, 1, 0, false)
          .save();
      Product.withFields(
              "Notebook 13\"", "512 GB SSD", 11000, null, 1, 0, false)
          .save();

      Product.withFields("Notebook 15\"", "128 GB SSD", 8999, null, 1, 0, false)
          .save();
      Product.withFields(
              "Notebook 15\"", "256 GB SSD", 10499, null, 1, 0, false)
          .save();
      Product.withFields(
              "Notebook 15\"", "512 GB SSD", 11999, true, 1, 0, false)
          .save();

      Product.withFields(
              "Ultrabook 13\"", "128 GB SSD i5", 9954, true, 2, 0, false)
          .save();
      Product.withFields(
              "Ultrabook 13\"", "256 GB SSD i5", 11154, true, 2, 0, false)
          .save();
      Product.withFields(
              "Ultrabook 13\"", "512 GB SSD i5", 13000, true, 2, 0, false)
          .save();

      Product.withFields(
              "Ultrabook 15\"", "128 GB SSD i7", 11000, true, 2, 0, false)
          .save();
      Product.withFields(
              "Ultrabook 15\"", "256 GB SSD i7", 12000, true, 2, 0, false)
          .save();
      Product.withFields(
              "Ultrabook 15\"", "512 GB SSD i7", 14000, true, 2, 0, false)
          .save()
          .then((_) {
        print("added 15 new products");

        // add a few dummy products for delete (id:16 to 20)
        Product.withFields("Product 1", "", 0, true, 0, 0, false).save();
        Product.withFields("Product 2", "", 0, true, 0, 0, false).save();
        Product.withFields("Product 3", "", 0, true, 0, 0, false).save();
        Product.withFields("Product 4", "", 0, true, 0, 0, false).save();
        Product.withFields("Product 5", "", 0, true, 0, 0, false)
            .save()
            .then((_) {
          print("added 5 dummy products");
          isReady(true);
        });
      });
    } else {
      isReady(true);
    }
  });
}
