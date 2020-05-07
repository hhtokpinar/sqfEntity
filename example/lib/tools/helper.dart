import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class UITools {
  UITools(BuildContext context) {
    _context = context;
  }

  static int selectedDb =0;
// BEGIN MAIN CONTROLLER DESIGN

  static const mainBgColor = Color.fromRGBO(95, 66, 119, 1.0);
  static const mainAlertColor = Color.fromRGBO(145, 86, 159, 1.0);
  static const mainBgColorLighter = Color.fromRGBO(75, 46, 99, 1.0);
  static const mainItemBgColor = Color.fromRGBO(111, 84, 133, .9);
  static const mainItemDeletedBgColor = Color.fromRGBO(111, 14, 33, .9);
  static const mainTextColor = Colors.white;
  static const mainTextColorAlternative = Color.fromRGBO(171, 144, 193, 1);
  static const mainIconsColor = Colors.white;
  static const double mainFontSize = 24;
  static const double mainIconSize = 30;
  static final DateFormat dateFormatter =
      DateFormat('yyyy-MM-dd', mainDatePickerLocaleType.toString());
  static const mainDatePickerLocaleType = LocaleType.tr;
  static const mainDatePickerTheme = DatePickerTheme(
      backgroundColor: UITools.mainBgColorLighter,
      itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      doneStyle: TextStyle(color: UITools.mainTextColor, fontSize: 16));

  Widget getMainPage(Widget body, String title /*, void refreshList()*/) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: body,
      appBar: AppBar(
          backgroundColor: mainBgColorLighter,
          elevation: 1,
          centerTitle: false,
          title: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: mainTextColorAlternative, fontSize: scaleWidth(14)),
          ),
          actions:
              null /* <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
                child: Icon(Icons.refresh),
                onTap: () {
                  refreshList();
                }),
          )
        ],*/
          ),
    );
  }

  Widget getSubPage(Widget body, List<Widget> actions) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: body,
      appBar: AppBar(
        backgroundColor: mainBgColorLighter,
        elevation: 1,
        centerTitle: false,
        title: Text(''),
        actions: actions,
        automaticallyImplyLeading: false,
      ),
    );
  }

  Widget makeBottomAlert(String text) {
    return Container(
      height: scaleHeight(70),
      child: BottomAppBar(
        color: UITools.mainAlertColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.info,
              color: Colors.white,
              size: 50,
            ),
            Text(
              text,
              style: TextStyle(
                  color: UITools.mainTextColor, fontSize: scaleHeight(14)),
            )
          ],
        ),
      ),
    );
  }

  void goToModelPage(StatefulWidget modelPage, String title) async {
    await Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  backgroundColor: mainBgColor,
                  body: modelPage,
                  appBar: AppBar(
                    backgroundColor: mainBgColorLighter,
                    elevation: 1,
                    centerTitle: false,
                    title: Text(
                      title,
                      textAlign: TextAlign.left,
                    ),
                  ),
                )));
  }

  Card makeCard(StatefulWidget modelPage, String title) => Card(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(color: mainItemBgColor),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white24))),
                child: SizedBox(
                  width: scaleWidth(60),
                  height: scaleHeight(50),
                  child: Icon(Icons.input,
                      color: mainIconsColor, size: scaleHeight(mainIconSize)),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: scaleWidth(mainFontSize)),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: mainTextColor, size: scaleHeight(mainIconSize)),
              onTap: () => goToModelPage(modelPage, title),
            )),
      );

  Future<bool> selectOption(
      Choice choice,
      dynamic data,
      dynamic obj,
      bool useSoftDeleting,
      bool hasSubItems,
      String formListTitleField,
      void Function() getData) async {
    BoolResult result;
    bool updated = false;
    switch (choice) {
      case Choice.Delete:
        final confirm = await confirmDialog(
            'Delete \'${data[formListTitleField]}\'?${hasSubItems ? '\n\nWARNING!\nAlso all children items in this parent item will be deleted\nNote: You can recover this item after you delete it.' : ''}',
            '${(!useSoftDeleting ? '' : data['isDeleted'] == 1 ? 'Hard ' : '')}Delete Item');
        if (confirm) {
          result = await obj.delete() as BoolResult;
          if (result.success) {
            updated = true;
            alertDialog('${data[formListTitleField]} deleted',
                title:
                    '${(!useSoftDeleting ? '' : data['isDeleted'] == 1 ? 'Hard ' : '')}Delete Item',
                callBack: () {
              getData();
            });
          }
        }
        break;
      case Choice.Recover:
        final confirm = await confirmDialog(
            'Recover \'${data[formListTitleField]}\'?', 'Recover Item');
        if (confirm) {
          result = await obj.recover() as BoolResult;
          if (result.success) {
            updated = true;
            alertDialog('${data[formListTitleField]} recovered',
                title: 'Recover Item', callBack: () {
              //  Navigator.pop(context, true);

              getData();
            });
          }
        }
        break;
      default:
    }
    return updated;
  }

// END MAIN CONTROLLER DESIGN

  static AnimationController lastController;
  double get windowWidth => MediaQuery.of(_context).size.width;
  double get windowHeight => MediaQuery.of(_context).size.height;

  BuildContext _context;
  // this resolution is iphone 6/7/8
  static const int _mobileSizeWidth = 375;
  static const int _mobileSizeHeight = 667;

  static String convertTime(DateTime date) {
    final retVal = StringBuffer();
    if (date.hour < 10) 
    {retVal.write('0');}
    retVal.write('${date.hour}:');

    if (date.minute < 10) 
    {retVal.write('0');}
    retVal.write('${date.minute}');
    if (date.second > 0) {
      retVal.write(':');
      if (date.second < 10)
      { retVal.write('0');}
      retVal.write(date.second);
    }
    return retVal.toString();
  }

  static String convertDate(DateTime date) {
    final retVal = StringBuffer('${date.year}-');

    if (date.month < 10)
     {retVal.write('0');}
    retVal.write('${date.month}-');

    if (date.day < 10) 
    {retVal.write('0');}
    retVal.write(date.day);
    return retVal.toString();
  }

  Future<int> showWaitScreen(String message, int second) async {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(scaleWidth(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: scaleWidth(20),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: scaleWidth(20)),
                  ),
                ],
              ),
            ),
          );
        });

    return Future<int>.delayed(Duration(seconds: second), () {
      Navigator.pop(_context); //pop dialog
      return;
    });
  }

  double scaleWidth(double size) {
    final retVal = size * windowWidth / _mobileSizeWidth;
    return retVal;
  }

  double scaleHeight(double size) {
    final retVal = size * windowHeight / _mobileSizeHeight;
    return retVal;
  }

  static Container imageFromNetwork(String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage('no-picture.png'),
        fit: BoxFit.cover,
      )));
    } else {
      return Container(child: Image.network(imgUrl));
    }
  }

  static Container imageFromCache(String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage('no-picture.png'),
        fit: BoxFit.cover,
      )));
    } else {
      return Container(child: Image.network(imgUrl)
          //CachedNetworkImage(
          //   imageUrl: imgUrl,
          //   placeholder: (context, url) => CircularProgressIndicator(),
          //   errorWidget: (context, url, error) => Icon(Icons.error),),
          );
    }
  }

  static Container imageFromCacheProvider(String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage('no-picture.png'),
        fit: BoxFit.cover,
      )));
    } else {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: NetworkImage(imgUrl), // CachedNetworkImageProvider(imgUrl)
        fit: BoxFit.cover,
      )));
    }
  }

  void alertDialog(String message,
      {String title = CONSTANTS.APP_TITLE, VoidCallback callBack}) async {
    return showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (callBack != null) 
                  {callBack();}
                },
              ),
            ],
          );
        });
  }

  Future<bool> confirmDialog(String message,
      [String title = 'SqfEntity Sample']) async {
    return showDialog<bool>(
      context: _context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }
}

class CONSTANTS {
  static const String APP_TITLE = 'SqfEntity Sample App';
}

enum Choice { Delete, Update, Recover }
enum OrderBy { NameAsc, NameDesc, PriceAsc, PriceDesc, None }
final NumberFormat priceFormat = NumberFormat('#,##0.#', 'en_US');
