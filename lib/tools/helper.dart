import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class CONSTANTS {
  static const String APP_TITLE = 'SqfEntity Sample App';
}



enum Choice { Delete, Update, Recover }
enum OrderBy { NameAsc, NameDesc,  PriceAsc,PriceDesc, None }
final priceFormat = NumberFormat('#,##0.#', 'en_US');
class UITools {
  UITools(BuildContext context) {
    _context = context;
  }
  static AnimationController lastController;
  double get windowWidth => MediaQuery.of(_context).size.width;
  double get windowHeight => MediaQuery.of(_context).size.height;

  BuildContext _context;
  // this resolution is iphone 6/7/8
  static const int _mobileSizeWidth = 375;
  static const int _mobileSizeHeight = 667;

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

  static Container imageFromCache(String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: AssetImage('no-picture.png'),
        fit: BoxFit.cover,
      )));
    } else {
      return Container(
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
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
        image: CachedNetworkImageProvider(imgUrl),
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
                  if(callBack!=null) callBack();
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
