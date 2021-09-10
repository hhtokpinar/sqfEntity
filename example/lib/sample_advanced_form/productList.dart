import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../model/model.dart';
import '../tools/helper.dart';
import '../tools/slideMenu.dart';
import 'productDetail.dart';
import 'productFilterWindow.dart';
import 'searchFilters.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductListState();
}

class ProductListState extends State {
  ProductListState();

  List<Product>? products;
  OrderBy orderRadioValue = OrderBy.None;
  String? orderBy;
  @override
  void initState() {
    SearchFilterProduct.showIsDeleted = false;
    super.initState();
    return;
  }

  //int count = 0;
  @override
  Widget build(BuildContext context) {
    void getData() async {
      // Set category id parameter
      final int? selectedCategoryId =
          SearchFilterProduct.getValues.selectedCategoryId;

      /*

     final productsData = await Product()
                          .select(getIsDeleted: showIsDeleted)
                          .categoryId.equals(selectedCategoryId)
                          .and
                          .startBlock
                            .name.startsWith(SearchFilterProduct.getValues.nameStartsWith)
                            .or.name.contains(SearchFilterProduct.getValues.nameContains)
                            .or.name.endsWith(SearchFilterProduct.getValues.nameEndsWith)
                          .endBlock
                          .and.description.contains(SearchFilterProduct.getValues.descriptionContains)
                          .and.price.between(SearchFilterProduct.getValues.minPrice, SearchFilterProduct.getValues.maxPrice)
                          .and.isActive.equals(SearchFilterProduct.getValues.isActive)
                          .orderBy(orderBy)
                          .toList();


     */
      final productsData = await Product()
          .select(getIsDeleted: SearchFilterProduct.showIsDeleted)
          .categoryId
          .equals(selectedCategoryId)
          .and
          .startBlock
          .name
          .startsWith(SearchFilterProduct.getValues.nameStartsWith)
          .or
          .name
          .contains(SearchFilterProduct.getValues.nameContains)
          .or
          .name
          .endsWith(SearchFilterProduct.getValues.nameEndsWith)
          .endBlock
          .and
          .description
          .contains(SearchFilterProduct.getValues.descriptionContains)
          .and
          .price
          .between(SearchFilterProduct.getValues.minPrice,
              SearchFilterProduct.getValues.maxPrice)
          .and
          .isActive
          .equals(SearchFilterProduct.getValues.isActive)
          .orderBy(orderBy)
          .toList();
      setState(() {
        products = productsData;
        //   count = productsData.length;
      });
    }

    if (products == null) {
      products = <Product>[];
      getData();
    }
    void goToDetail(Product product) async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductDetail(product)));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void goToProductAdd(Product product) async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductAdd(product)));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void select(Choice choice, Product product) async {
      BoolResult result;
      switch (choice) {
        case Choice.Delete:
          final confirm = await UITools(context).confirmDialog(
              'Delete \'${product.name}\'?',
              '${(product.isDeleted! ? 'Hard ' : '')}Delete Product');
          if (confirm!) {
            result = await product.delete();
            if (result.success) {
              UITools(context).alertDialog('${product.name} deleted',
                  title: '${(product.isDeleted! ? 'Hard ' : '')}Delete Product',
                  callBack: () {
                //Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Recover:
          final confirm = await UITools(context)
              .confirmDialog('Recover \'${product.name}\'?', 'Recover Product');
          if (confirm!) {
            result = await product.recover();
            if (result.success) {
              UITools(context).alertDialog('${product.name} recovered',
                  title: 'Recover Product', callBack: () {
                //  Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Update:
          goToProductAdd(product);
          break;
        default:
      }
    }

    void selectOrderBy(OrderBy value) {
      String? _orderBy;
      switch (value) {
        case OrderBy.NameAsc:
          _orderBy = 'name';
          break;
        case OrderBy.NameDesc:
          _orderBy = 'name desc';
          break;
        case OrderBy.PriceAsc:
          _orderBy = 'price';
          break;
        case OrderBy.PriceDesc:
          _orderBy = 'price desc';
          break;
        case OrderBy.None:
          _orderBy = null;
          break;
        default:
      }
      setState(() {
        orderBy = _orderBy;
        orderRadioValue = value;
        getData();
      });
    }

    ListTile makeProductListTile(Product product) => ListTile(
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
              child: UITools.imageFromNetwork(product.imageUrl!),
            ),
          ),
          title: Text(
            product.name ?? '',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration:
                    product.isDeleted! ? TextDecoration.lineThrough : null,
                fontSize: UITools(context).scaleWidth(24)),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(product.description ?? '',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, .5),
                            decoration: product.isDeleted!
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: UITools(context).scaleWidth(18))),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                      '\$ ${product.price != null ? priceFormat.format(product.price) : '-'}',
                      style: TextStyle(
                          color: Color.fromRGBO(195, 255, 155, .8),
                          fontSize: UITools(context).scaleWidth(14)))
                ],
              )
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: UITools(context).scaleHeight(30.0)),
          onTap: () {
            goToDetail(product);
          },
        );

    void goToProductFilter() async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductFilterWindow()));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    Card makeProductCart(Product product) => Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: product.isDeleted!
                ? BoxDecoration(color: Color.fromRGBO(111, 14, 33, .9))
                : product.isActive!
                    ? BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9))
                    : BoxDecoration(color: Color.fromRGBO(111, 84, 113, .5)),
            child: makeProductListTile(product),
          ),
        );

    final makeProductList = ListView(
      children: ListTile.divideTiles(
        context: this.context,
        tiles: List.generate(products!.length, (index) {
          if (products![index].id == 0) {
            return makeProductCart(
                products![index]); // 'List All' item has no delete/info actions
          } else {
            return SlideMenu(
              child: makeProductCart(products![index]),
              menuItems: <Widget>[
                Container(
                  //decoration:  BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9)),
                  child: IconButton(
                      icon: Icon(
                        products![index].isDeleted!
                            ? Icons.delete_forever
                            : Icons.delete_outline,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        select(Choice.Delete, products![index]);
                      }),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        products![index].isDeleted!
                            ? Icons.restore_from_trash
                            : Icons.edit,
                        color: Colors.tealAccent,
                      ),
                      onPressed: () {
                        select(
                            products![index].isDeleted!
                                ? Choice.Recover
                                : Choice.Update,
                            products![index]);
                      }),
                ),
              ],
            );
          } // end if
        }),
      ).toList(),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
      body: makeProductList,
      bottomNavigationBar: UITools(context).makeBottomAlert(
          'on Tap -> Go to detail\nSwap Left -> Delete/Edit product)'),
      //body: productListItems(),

      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            goToProductFilter();
          },
        ),
        title: Text(
          '(${products!.length} items)',
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
                  value: SearchFilterProduct.showIsDeleted,
                  onChanged: (value) {
                    setState(() {
                      SearchFilterProduct.showIsDeleted = value!;
                      getData();
                    });
                  },
                ),
                Text(
                  'Show\ndeleted',
                  style: TextStyle(
                      fontSize: UITools(context).scaleWidth(14),
                      color: Color.fromRGBO(192, 160, 226, 1)),
                ),
                PopupMenuButton<OrderBy>(
                  tooltip: 'order by',
                  elevation: 8,
                  icon: Icon(
                    Icons.text_rotate_vertical,
                    size: 30,
                  ),
                  onSelected: selectOrderBy,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<OrderBy>>[
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.NameAsc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('name Ascending'),
                        ],
                      ),
                      value: OrderBy.NameAsc,
                    ),
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.NameDesc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('name Descending'),
                        ],
                      ),
                      value: OrderBy.NameDesc,
                    ),
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.PriceAsc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('price Ascending'),
                        ],
                      ),
                      value: OrderBy.PriceAsc,
                    ),
                    PopupMenuItem<OrderBy>(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.PriceDesc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('price Descending'),
                        ],
                      ),
                      value: OrderBy.PriceDesc,
                    ),
                    PopupMenuItem<OrderBy>(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.None,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('none'),
                        ],
                      ),
                      value: OrderBy.None,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(52, 20, 86, 1),
        onPressed: () {
          goToProductAdd(Product());
        },
        tooltip: 'add new product',
        child: Icon(Icons.add),
      ),
    );
  }
}
