import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../model/model.dart';

import '../tools/helper.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail(this.product);
  final Product product;
  @override
  State<StatefulWidget> createState() => ProductDetailState(product);
}

class ProductDetailState extends State {
  ProductDetailState(this.product);
  Product product;
  @override
  Widget build(BuildContext context) {
    final productPrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(195, 166, 219, .9)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        product.isActive!
            ? '\$ ${product.price != null ? priceFormat.format(product.price) : '-'}'
            : 'NOT ON SALE',
        style: TextStyle(
            fontSize: UITools(context).scaleWidth(20.0), color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: UITools(context).scaleHeight(10.0)),
        Text(
          product.name!,
          style: TextStyle(
              color: Colors.white, fontSize: UITools(context).scaleWidth(24.0)),
        ),
        Container(
          width: UITools(context).scaleWidth(180.0),
          child: Divider(color: Colors.white30),
        ),
        Text(
          product.description!,
          style: TextStyle(
              color: Color.fromRGBO(195, 166, 219, 1),
              fontSize: UITools(context).scaleHeight(20.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: UITools(context).scaleHeight(90),
            ),
            productPrice
          ],
          textDirection: prefix0.TextDirection.rtl,
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('windows-wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(95, 66, 119, .9)),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    width: UITools(context).scaleWidth(200),
                    child: UITools.imageFromNetwork(product.imageUrl!),
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[topContentText],
                ),
              )
            ],
          ),
        ),
      ],
    );

    final bottomContentText = Column(
      children: <Widget>[
        Text(
          '14" Full HD multitouch screen',
          style: TextStyle(fontSize: UITools(context).scaleHeight(20.0)),
        ),
        SizedBox(height: 10.0),
        Text(
          'The 1920 x 1080 resolution boasts impressive color and clarity. IPS technology for wide viewing angles. Energy-efficient WLED backlight.',
          style: TextStyle(fontSize: UITools(context).scaleHeight(16.0)),
        )
      ],
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[bottomContentText],
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
      title: Text('Back to List'),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: select,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
            product.isDeleted!
                ? PopupMenuItem<Choice>(
                    child: Text('Recover product'),
                    value: Choice.Recover,
                  )
                : PopupMenuItem<Choice>(
                    child: Text('Edit product'),
                    value: Choice.Update,
                  ),
            PopupMenuItem<Choice>(
              child: product.isDeleted!
                  ? Text('Hard delete product')
                  : Text('Delete product'),
              value: Choice.Delete,
            ),
          ],
        )
      ],
    );
    return Scaffold(
      appBar: topAppBar,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  void select(Choice choice) async {
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
              Navigator.pop(context, true);
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
              Navigator.pop(context, true);
            });
          }
        }
        break;
      case Choice.Update:
        gotoDetail(product);
        break;
      default:
    }
  }

  void gotoDetail(Product product) async {
    final bool? result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductAdd(product)));
    if (result != null) {
      Navigator.pop(context, true);
    }
  }
}
