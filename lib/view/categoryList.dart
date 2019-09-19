import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:sqfentity_sample/model/model.dart';
import 'package:sqfentity_sample/tools/global.dart';
import 'package:sqfentity_sample/tools/helper.dart';
import 'package:sqfentity_sample/view/categoryAdd.dart';
import 'package:flutter/material.dart';
import 'package:sqfentity_sample/view/productList.dart';
import 'package:sqfentity_sample/tools/popup.dart';

import '../tools/SlideMenu.dart';

class CategoryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoryListState();
}

class CategoryListState extends State {
  List<Category> categories;
  // statistics variables
  int statCount;
  double statSumPrice;
  double statAvgPrice;
  double statMinPrice;
  double statMaxPrice;
// end statistics variables
  @override
  Widget build(BuildContext context) {
    void getData() async {
      final categoriesData = await Category()
          .select(getIsDeleted: SearchFilter.showIsDeleted)
          .orderByDesc(['isdeleted']).toList();
      categoriesData.add(Category.withId(0, 'List All',0, true, false));
      setState(() {
        categories = categoriesData;
        //count = categoriesData.length;
      });
    }

    if (categories == null) {
      categories = List<Category>();
      getData();
    }
    void goToDetail(Category category) async {
      SearchFilter.resetSearchFilter();
      final bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
                    body: ProductList(category),

                    //body: categoryListItems(),
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(75, 46, 99, 1.0),
                      elevation: 1,
                      centerTitle: false,
                      title: Text(
                        '${category.name}',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void goToCategoryAdd(Category category) async {
      final bool result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CategoryAdd(category)));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void select(Choice choice, Category category) async {
      BoolResult result;
      switch (choice) {
        case Choice.Delete:
          final confirm = await UITools(context).confirmDialog(
              'Delete \'${category.name}\'?\n\nWARNING!\nAlso all products in this category will be deleted\nNote: You can recover this item after you delete it.',
              '${(category.isDeleted ? 'Hard ' : '')}Delete Category');
          if (confirm) {
            result = await category.delete();
            if (result.success) {
              UITools(context).alertDialog('${category.name} deleted',
                  title: '${(category.isDeleted ? 'Hard ' : '')}Delete Category', callBack: () {
                //Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Recover:
          final confirm = await UITools(context)
              .confirmDialog('Recover \'${category.name}\'?', 'Recover Category');
          if (confirm) {
            result = await category.recover();
            if (result.success) {
              UITools(context).alertDialog('${category.name} recovered',
                  title: 'Recover Category', callBack: () {
                //  Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Update:
          goToCategoryAdd(category);
          break;
        default:
      }
    }

    ListTile makeCategoryListTile(Category category) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: SizedBox(
              width: UITools(context).scaleWidth(60),
              height: UITools(context).scaleHeight(50),
              child: Icon(Icons.folder,
                  color: Colors.yellowAccent,
                  size: UITools(context).scaleHeight(30.0)),
            ),
          ),
          title: Text(
            category.name,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration:
                    category.isDeleted ? TextDecoration.lineThrough : null,
                fontSize: UITools(context).scaleWidth(24)),
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: UITools(context).scaleHeight(30.0)),
          onTap: () {
            goToDetail(category);
          },
        );

    Card makeCategoryCart(Category category) => Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: category.isDeleted
                ? BoxDecoration(color: Color.fromRGBO(111, 14, 33, .9))
                : category.isActive
                    ? BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9))
                    : BoxDecoration(color: Color.fromRGBO(111, 84, 113, .5)),
            child: makeCategoryListTile(category),
          ),
        );

    final makeCategoryList = ListView(
      children: ListTile.divideTiles(
        context: this.context,
        tiles: List.generate(categories.length, (index) {
          if (categories[index].id == 0) {
            return makeCategoryCart(categories[
                index]); // 'List All' item has no delete/info actions
          } else {
            return SlideMenu(
              child: makeCategoryCart(categories[index]),
              menuItems: <Widget>[
                Container(
                  //decoration:  BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9)),
                  child: IconButton(
                      icon: Icon(
                        categories[index].isDeleted
                            ? Icons.delete_forever
                            : Icons.delete_outline,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        select(Choice.Delete, categories[index]);
                      }),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        categories[index].isDeleted
                            ? Icons.restore_from_trash
                            : Icons.edit,
                        color: Colors.tealAccent,
                      ),
                      onPressed: () {
                        select(
                            categories[index].isDeleted
                                ? Choice.Recover
                                : Choice.Update,
                            categories[index]);
                      }),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.show_chart,
                        color: Colors.yellowAccent,
                      ),
                      onPressed: () async {
                        await getStatistics(categories[index]);
                        showPopup(context, _statisticsWindow(categories[index]),
                            'Stats for ${categories[index].name}');
                      }),
                ),
              ],
            );
          } // end if
        }),
      ).toList(),
    );

    final makeBottom = Container(
      height: UITools(context).scaleHeight(70),
      child: BottomAppBar(
        color: Color.fromRGBO(194, 186, 135, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.info,
                color: Colors.white,
                size: 50,
              ),
              Text(
                'on Tap/Click -> go to Sub Items\nSwap Left -> Delete/Edit Item',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
      body: makeCategoryList,
      bottomNavigationBar: makeBottom,
      //body: categoryListItems(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(75, 46, 99, 1.0),
        elevation: 1,
        centerTitle: false,
        title: Text(
          '${categories.length - 1} items..',
          textAlign: TextAlign.left,
        ),
        actions: <Widget>[
          //actionBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Color.fromRGBO(52, 20, 86, 1),
                  value: SearchFilter.showIsDeleted,
                  onChanged: (value) {
                    setState(() {
                      SearchFilter.showIsDeleted = value;
                      getData();
                    });
                  },
                ),
                Text(
                  'Show deleted',
                  style: TextStyle(fontSize: UITools(context).scaleWidth(14)),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(52, 20, 86, 1),
        onPressed: () {
          goToCategoryAdd(Category());
        },
        tooltip: 'add new category',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> getStatistics(Category category) async {
    final _count = await category
        .getProducts(getIsDeleted: SearchFilter.showIsDeleted)
        .toCount();
    final stats = await category.getProducts(
        getIsDeleted: SearchFilter.showIsDeleted,
        columnsToSelect: [
          ProductFields.price.min('minPrice'),
          ProductFields.price.max('maxPrice'),
          ProductFields.price.avg('avgPrice'),
          ProductFields.price.sum('sumPrice')
        ]).toListObject();

    setState(() {

      statCount = _count;
      statMinPrice = stats[0]['minPrice'] as double;
      statMaxPrice = stats[0]['maxPrice'] as double;
      statAvgPrice = stats[0]['avgPrice'] as double;
      statSumPrice = stats[0]['sumPrice'] as double;
    });
  }

  Widget _statisticsWindow(Category category) {
    //BoolResult count = await category.getProducts(getIsDeleted: SearchFilter.showIsDeleted).toCount();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Text(
                    //'Leave the job to SqfEntitiy for CRUD operations. Do easily and faster adding tables, adding columns, defining multiple tables, multiple databases etc. with the help of DbModel object'
                    '${category.name} ${SearchFilter.showIsDeleted ? ' (with deleted Items)':''}', style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            ),
            SizedBox(
              height: 20,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Sub items'),
                Flexible(child: Text('$statCount')),
              ],
            ),
             SizedBox(
              height: 20,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Minimum Price'),
                statMinPrice == null ? Text('0'): Flexible(child: Text('\$ ${priceFormat.format(statMinPrice)}')),
              ],
            ),
             SizedBox(
              height: 20,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Maximum Price'),
                statMaxPrice == null ? Text('0'): Flexible(child: Text('\$ ${priceFormat.format(statMaxPrice)}')),
              ],
            ),
             SizedBox(
              height: 20,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Average Price'),
                statAvgPrice == null ? Text('0'): Flexible(child: Text('\$ ${priceFormat.format(statAvgPrice)}')),
              ],
            ),
             SizedBox(
              height: 20,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Sum Price'),
                statSumPrice == null ? Text('0'): Flexible(child: Text('\$ ${priceFormat.format(statSumPrice)}')),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
