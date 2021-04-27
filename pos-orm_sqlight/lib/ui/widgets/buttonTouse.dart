import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:points_of_sale/constants/colors.dart';

class ButtonToUse extends StatelessWidget {
  const ButtonToUse(this.buttonstring,
      {this.fontWait, this.fontColors, this.onPressed, this.width});
  final String buttonstring;
  final FontWeight fontWait;
  final Color fontColors;
  final Function onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.padded,
            elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) => 0),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => colors.trans)),
        child: Container(
          width: width,
          alignment: Alignment.center,
          child: Text(
            buttonstring,
            style: TextStyle(
              color: fontColors,
              fontSize: 15,
              fontWeight: fontWait,
            ),
          ),
        ),
        onPressed: () => onPressed());
  }
}
