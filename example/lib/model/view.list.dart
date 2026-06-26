import 'package:flutter/material.dart';
import '../tools/helper.dart';
import '../tools/slidemenu.dart';
import 'view.detail.dart';

//import 'package:sqfentity_sample/view/Update.dart';

class SQFViewList extends StatefulWidget {
  SQFViewList(
    this.T, {
    this.useSoftDeleting,
    //this.formListTitleField,
    //this.formListSubTitleField,
    this.filterExpression,
    this.primaryKeyName,
    this.filterParameter,
  });
  final dynamic T;
  final bool? useSoftDeleting;
  final String? filterExpression;
  final dynamic filterParameter;
  final String? primaryKeyName;
  @override
  State<StatefulWidget> createState() => SQFViewListState(
      T,
      useSoftDeleting ?? false,
      filterExpression,
      primaryKeyName,
      filterParameter);
}

class SQFViewListState extends State {
  SQFViewListState(this.T, this.useSoftDeleting, this.filterExpression,
      this.primaryKeyName, this.filterParameter);
  dynamic T;
  final bool useSoftDeleting;

  String? formListTitleField;
  String? formListSubTitleField;
  final String? filterExpression;
  final dynamic filterParameter;
  final String? primaryKeyName;
  List<dynamic> datalist = <dynamic>[];
  bool showIsDeleted = false;
  @override
  Widget build(BuildContext context) {
    void getData() async {
      formListTitleField = T.formListTitleField as String;
      formListSubTitleField = T.formListSubTitleField as String;
      final selectCols = <String>[]
        ..add(primaryKeyName!)
        ..add(formListTitleField!);
      if (formListSubTitleField != null && formListSubTitleField!.isNotEmpty) {
        selectCols.add(formListSubTitleField!);
      }
      if (useSoftDeleting) {
        selectCols.add('isDeleted');
      }

      final datalistData = await T
          .select(columnsToSelect: selectCols, getIsDeleted: showIsDeleted)
          .where(filterExpression, parameterValue: filterParameter)
          .toMapList();
      setState(() {
        datalist = datalistData as List;
      });
    }

    if (datalist.isEmpty || SessionDetail.updatedItem) {
      getData();
      SessionDetail.updatedItem = false;
    }

    void goToDetail(dynamic data) async {
      final bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    backgroundColor: UITools.mainBgColor,
                    body: SQFViewDetail(data, formListTitleField!, T,
                        useSoftDeleting, primaryKeyName),
                    //body: SQFViewListItems(),
                    appBar: AppBar(
                      backgroundColor: UITools.mainBgColorLighter,
                      elevation: 1,
                      centerTitle: false,
                      title: Text(
                        '${data[formListTitleField]} details..',
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

    Future<void> goToUpdate(dynamic data) async {
      final editWidget = await T.gotoEdit(data) as Widget;
      final bool? result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => editWidget));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    ListTile makeSQFViewListTile(dynamic data) => ListTile(
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
              child: Icon(Icons.description,
                  color: UITools.mainIconsColor,
                  size: UITools(context).scaleHeight(30.0)),
            ),
          ),
          title: Text(
            data[formListTitleField].toString(),
            style: TextStyle(
                color: UITools.mainTextColor,
                fontWeight: FontWeight.bold,
                decoration: !useSoftDeleting
                    ? null
                    : data['isDeleted'] == 1
                        ? TextDecoration.lineThrough
                        : null,
                fontSize: UITools(context).scaleWidth(24)),
          ),
          subtitle:
              formListSubTitleField != null && formListSubTitleField!.isNotEmpty
                  ? Text(data[formListSubTitleField].toString(),
                      style: TextStyle(
                        color: UITools.mainTextColorAlternative,
                        fontSize: UITools(context).scaleWidth(14),
                        fontWeight: FontWeight.bold,
                      ))
                  : null,
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: UITools(context).scaleHeight(30.0)),
          onTap: () => goToDetail(data),
        );

    Card makeItemCard(dynamic data) => Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: !useSoftDeleting
                ? BoxDecoration(color: UITools.mainItemBgColor)
                : data['isDeleted'] == 1
                    ? BoxDecoration(color: UITools.mainItemDeletedBgColor)
                    : BoxDecoration(color: UITools.mainItemBgColor),
            child: makeSQFViewListTile(data),
          ),
        );

    final makeSQFViewList = ListView(
      children: ListTile.divideTiles(
        context: this.context,
        tiles: List.generate(datalist.length, (index) {
          return SlideMenu(
            child: makeItemCard(datalist[index]),
            menuItems: <Widget>[
              Container(
                //decoration:  BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9)),
                child: IconButton(
                    icon: Icon(
                      !useSoftDeleting
                          ? Icons.delete_outline
                          : datalist[index]['isDeleted'] == 1
                              ? Icons.delete_forever
                              : Icons.delete_outline,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () async {
                      final obj =
                          await T.getById(datalist[index][primaryKeyName]);
                      UITools(context).selectOption(
                          Choice.Delete,
                          datalist[index],
                          obj,
                          useSoftDeleting,
                          false,
                          formListTitleField!,
                          getData);
                    }),
              ),
              Container(
                child: IconButton(
                    icon: Icon(
                      !useSoftDeleting
                          ? Icons.edit
                          : datalist[index]['isDeleted'] == 1
                              ? Icons.restore_from_trash
                              : Icons.edit,
                      color: Colors.tealAccent,
                    ),
                    onPressed: () async {
                      final obj =
                          await T.getById(datalist[index][primaryKeyName]);
                      final choice = !useSoftDeleting
                          ? Choice.Update
                          : datalist[index]['isDeleted'] == 1
                              ? Choice.Recover
                              : Choice.Update;
                      if (choice == Choice.Update) {
                        await goToUpdate(datalist[index]);
                      } else {
                        UITools(context).selectOption(
                            choice,
                            datalist[index],
                            obj,
                            useSoftDeleting,
                            false,
                            formListTitleField!,
                            getData);
                      }
                    }),
              ),
            ],
          );
        }),
      ).toList(),
    );

    return Scaffold(
      backgroundColor: UITools.mainBgColor,
      body: makeSQFViewList,
      bottomNavigationBar: UITools(context).makeBottomAlert(
          'on Tap -> Go to child items or detail\nSwap Left -> Delete/Edit product)'),
      appBar: AppBar(
        backgroundColor: UITools.mainBgColorLighter,
        elevation: 1,
        centerTitle: false,
        title: Text(
          '${datalist.length} items..',
          textAlign: TextAlign.left,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          //actionBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.refresh),
                  onTap: () {
                    getData();
                  },
                ),
                Checkbox(
                  activeColor: Color.fromRGBO(52, 20, 86, 1),
                  value: showIsDeleted,
                  onChanged: (value) {
                    setState(() {
                      showIsDeleted = value!;
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
        backgroundColor: UITools.mainAlertColor,
        onPressed: () {
          goToUpdate(null);
        },
        tooltip: 'add new item',
        child: Icon(
          Icons.add,
          color: UITools.mainIconsColor,
        ),
      ),
    );
  }
}
