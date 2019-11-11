import 'package:flutter/material.dart';
import '../tools/helper.dart';

class SQFViewDetail extends StatefulWidget {
  SQFViewDetail(this.data, this.formListTitleField, this.T,
      this.useSoftDeleting, this.primaryKeyName);
  final dynamic data;
  final dynamic T;
  final String formListTitleField;
  final String primaryKeyName;
  final bool useSoftDeleting;
  @override
  State<StatefulWidget> createState() => SQFViewDetailState(
      data, formListTitleField, T, useSoftDeleting, primaryKeyName);
}

class SQFViewDetailState extends State {
  SQFViewDetailState(this.data, this.formListTitleField, this.T,
      this.useSoftDeleting, this.primaryKeyName);
  dynamic data;
  Map<String, dynamic> objData;
  List<String> objKeys;
  final dynamic T;
  final String formListTitleField;
  final String primaryKeyName;
  final bool useSoftDeleting;
  bool isItemUpdated = false;
  dynamic obj;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    obj = await T.getById(data[primaryKeyName]);
    if (obj == null) {
      Navigator.pop(context, true);
      return;
    }
    setState(() {
      objData = obj.toMap() as Map<String, dynamic>;
      data = objData;
      objKeys = objData.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final makeMainController = ListView(
      children: ListTile.divideTiles(
              context: this.context,
              tiles: objData == null
                  ? []
                  : List.generate(objData.length, (index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              objKeys[index].toString(),
                              style: TextStyle(
                                  color: UITools.mainTextColorAlternative),
                            ),
                            subtitle: Text(
                              objData[objKeys[index]].toString(),
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
      final bool result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => editWidget));
      if (result != null) {
        if (result) {
          getData();
          SessionDetail.updatedItem = true;
        }
      }
    }

    final actions = <Widget>[
      //actionBar
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            color: UITools.mainAlertColor,
            autofocus: false,
            textColor: UITools.mainTextColor,
            clipBehavior: Clip.hardEdge,
            child: Text(
              'Edit',
              style: TextStyle(fontSize: UITools(context).scaleWidth(14)),
            ),
            onPressed: () {
              goToUpdate(data);
            },
          ),
          SizedBox(
            width: 20,
          ),
          FlatButton(
            color: UITools.mainItemDeletedBgColor,
            autofocus: false,
            textColor: UITools.mainTextColor,
            clipBehavior: Clip.hardEdge,
            child: Text(
              '${(!useSoftDeleting ? '' : data['isDeleted'] == true ? 'Hard ' : '')}Delete',
              style: TextStyle(fontSize: UITools(context).scaleWidth(14)),
            ),
            onPressed: () async {
              SessionDetail.updatedItem = await UITools(context).selectOption(
                  Choice.Delete,
                  data,
                  obj,
                  useSoftDeleting,
                  false,
                  formListTitleField,
                  getData);
              if (useSoftDeleting) {
                Navigator.pop(context, true);
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
          useSoftDeleting && data['isDeleted'] == true
              ? FlatButton(
                  color: Colors.blueGrey,
                  autofocus: false,
                  textColor: UITools.mainTextColor,
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
                            formListTitleField,
                            getData);
                  },
                )
              : Text(''),
        ],
      ),
    ];
    return UITools(context).getSubPage(makeMainController, actions);
  }
}

class SessionDetail {
  static bool updatedItem = false;
}
