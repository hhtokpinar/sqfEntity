import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/constants/styles.dart';
import 'package:points_of_sale/localization/trans.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SettingBottom extends StatelessWidget {
  final TextEditingController reasonforDeleteController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(trans(context, "user_account")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(onPrimary: colors.trans),
            // splashColor: Colors.transparent,
            // highlightElevation: 0,
            // highlightColor: Colors.transparent,
            // elevation: 0,

            onPressed: () {
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                dialogType: DialogType.WARNING,
                body: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: <Widget>[
                      Text(trans(context, 'We wish to see you soon'),
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                      TextFormField(
                        controller: reasonforDeleteController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: colors.ggrey,
                          )),
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: trans(context,
                              'Help us to get better please write some feedback'),
                          hintStyle:
                              TextStyle(color: colors.ggrey, fontSize: 15),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  onPrimary: colors.red),
                              // splashColor: Colors.transparent,
                              // highlightElevation: 0,
                              // highlightColor: Colors.transparent,
                              // elevation: 0,

                              child: Text(trans(context, 'am sure'),
                                  style: styles.mywhitestyle),
                              onPressed: () {
                           //delete account
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (_) => false);
                              }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shadowColor: colors.yellow,
                              ),
                              child: Text(trans(context, 'cancel'),
                                  style: styles.mywhitestyle),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      )
                    ],
                  ),
                ),
                desc: trans(context,
                    'Help us to get better please write some feedback'),
              ).show();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  "assets/images/delete.png",
                  height: 20,
                  width: 20,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Text(trans(context, "cancel_account"), style: styles.redstyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
