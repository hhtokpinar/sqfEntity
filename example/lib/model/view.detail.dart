import 'package:flutter/material.dart';
import '../tools/helper.dart';

class SQFViewDetail extends StatefulWidget {
  SQFViewDetail(this.data, this.formListTitleField, this.T,
      this.useSoftDeleting, this.primaryKeyName);
  final dynamic data;
  final dynamic T;
  final String? formListTitleField;
  final String? primaryKeyName;
  final bool useSoftDeleting;
  @override
  State<StatefulWidget> createState() => SQFViewDetailState(
      data, formListTitleField, T, useSoftDeleting, primaryKeyName);
}

class SQFViewDetailState extends State {
  SQFViewDetailState(this.data, this.formListTitleField, this.T,
      this.useSoftDeleting, this.primaryKeyName);
  dynamic data;
  Map<String, dynamic>? objData;
  Map<String, String>? objMenu;
  List<String?>? objDataKeys;
  List<String>? objMenuKeys;
  final dynamic T;
  final String? formListTitleField;
  final String? primaryKeyName;
  final bool useSoftDeleting;
  bool isItemUpdated = false;
  dynamic obj;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    obj = await T.getById(data[primaryKeyName], loadParents: true);
    if (obj == null) {
      Navigator.pop(context, true);
      return;
    }
    objData = await obj.toMap(forView: true) as Map<String, dynamic>;
    setState(() {
      data = objData;
      objDataKeys = objData!.keys.toList();
      objMenu = T.subMenu() as Map<String, String>;
      objMenuKeys = objMenu!.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final makeMainController = ListView(
      children: ListTile.divideTiles(
              context: this.context,
              tiles: objData == null
                  ? []
                  : List.generate(objData!.length, (index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              objDataKeys![index] != null
                                  ? objDataKeys![index].toString()
                                  : '',
                              style: TextStyle(
                                  color: UITools.mainTextColorAlternative),
                            ),
                            subtitle: Text(
                              objData![objDataKeys![index]].toString(),
                              style: TextStyle(
                                  color: UITools.mainTextColor,
                                  fontSize: UITools(context).scaleWidth(18)),
                            ),
                          ));
                    }))
          .toList(),
    );

    Future<void> goToUpdate(dynamic data) async {
      final editWidget = await T.gotoEdit(data) as Widget;
      final bool? result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => editWidget));
      if (result != null) {
        if (result) {
          getData();
          SessionDetail.updatedItem = true;
        }
      }
    }

    void getSubList(String controllerName) async {
      final bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    backgroundColor: UITools.mainBgColor,
                    body: T.subList(data[primaryKeyName], controllerName)
                        as Widget,
                    appBar: AppBar(
                      backgroundColor: UITools.mainBgColorLighter,
                      elevation: 1,
                      centerTitle: false,
                      title: Text(
                        '${data[formListTitleField]} items...',
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

    TextButton buildTextButton(
        Color buttonColor, String text, Function onpressed) {
      return TextButton(
        clipBehavior: Clip.hardEdge,
        child: Text(
          text,
          style: TextStyle(fontSize: UITools(context).scaleWidth(14)),
        ),
        onPressed: () async {
          onpressed();
        },
      );
    }

    final actions = <Widget>[
      //actionBar
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildTextButton(
              UITools.mainAlertColor, 'Edit', () => goToUpdate(data)),
          SizedBox(
            width: 20,
          ),
          buildTextButton(
              UITools.mainItemDeletedBgColor,
              '${(!useSoftDeleting ? '' : data['isDeleted'] == true ? 'Hard ' : '')}Delete',
              () async => SessionDetail.updatedItem = await UITools(context)
                  .selectOption(Choice.Delete, data, obj, useSoftDeleting,
                      false, formListTitleField, getData)),
          SizedBox(
            width: 10,
          ),
          useSoftDeleting && data['isDeleted'] == true
              ? TextButton(
                  clipBehavior: Clip.hardEdge,
                  child: Text(
                    'Recover',
                    style: TextStyle(fontSize: UITools(context).scaleWidth(14)),
                  ),
                  onPressed: () async {
                    SessionDetail.updatedItem = await UITools(context)
                        .selectOption(
                            Choice.Recover,
                            data,
                            obj,
                            useSoftDeleting,
                            false,
                            formListTitleField!,
                            getData);
                  },
                )
              : Text(''),
        ],
      ),
      Row(
        children: objMenu == null || objMenu!.isEmpty
            ? <Widget>[Text('')]
            : <Widget>[
                PopupMenuButton<String>(
                    child: Container(
                      height: UITools(context).scaleHeight(30),
                      width: UITools(context).scaleWidth(120),
                      color: UITools.mainBgColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Sub Items',
                              style: TextStyle(
                                  fontSize: UITools(context).scaleWidth(14)),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: UITools(context).scaleWidth(28),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    onSelected: getSubList,
                    itemBuilder: (BuildContext context) =>
                        List.generate(objMenu!.length, (index) {
                          return PopupMenuItem<String>(
                            child:
                                Text(objMenu![objMenuKeys![index]].toString()),
                            value: objMenuKeys![index],
                          );
                        })),
              ],
      ),
      SizedBox(
        width: 10,
      ),
    ];
    return UITools(context).getSubPage(makeMainController, actions);
  }
}

class SessionDetail {
  static bool updatedItem = false;
}
