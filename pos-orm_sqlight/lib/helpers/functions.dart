import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/constants/config.dart';
import 'package:points_of_sale/constants/styles.dart';
import 'package:location/location.dart';
import 'package:points_of_sale/localization/trans.dart';

final Location location = Location();

SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not alowed  !"),
    action: SnackBarAction(label: 'Ok !', onPressed: () {}));
SpinKitRing spinkit =
    SpinKitRing(color: colors.orange, size: 30.0, lineWidth: 3);

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("هل انت متأكد"),
          content: Text("هل تريد الخروج"),
          actionsOverflowButtonSpacing: 50,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("إلفاء"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("حسناً"),
            ),
          ],
        ),
      )) ??
      false;
}

void goToMap(BuildContext context) {
  try {
    Navigator.pushNamedAndRemoveUntil(context, "/Home", (_) => false,
        arguments: <String, dynamic>{
          "home_map_lat": config.lat,
          "home_map_long": config.long
        });
  } catch (err) {
    print("errerr  $err");
  }
}

void showFullText(BuildContext context, String text) {
  showGeneralDialog<dynamic>(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.73),
    transitionDuration: const Duration(milliseconds: 350),
    context: context,
    pageBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin:
              const EdgeInsets.only(bottom: 160, left: 24, right: 24, top: 160),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: Text(text, style: styles.textInShowMore)),
                const SizedBox(height: 15),
                RaisedButton(
                    color: colors.orange,
                    child: Text("حسناً", style: styles.underHeadwhite),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2, Widget child) {
      return SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
        child: child,
      );
    },
  );
}
void ifUpdateTur(BuildContext context, String text) {
  showGeneralDialog<dynamic>(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.73),
    transitionDuration: const Duration(milliseconds: 350),
    context: context,
    pageBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 360,
          margin: const EdgeInsets.only(bottom: 160, left: 24, right: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/images/checkdone.svg'),
                  const SizedBox(height: 15),
                  Flexible(
                    child: Text(trans(context, text),
                        style: styles.underHeadblack),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shadowColor: colors.orange),
                      child: Text(trans(context, "ok"),
                          style: styles.underHeadwhite),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2, Widget child) {
      return SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
        child: child,
      );
    },
  );
}
