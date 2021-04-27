import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:points_of_sale/constants/colors.dart';

class TextFormInput extends StatelessWidget {
  const TextFormInput(
      {Key key,
      this.text,
      this.cController,
      this.prefixIcon,
      this.kt,
      this.postfixIcon,
      this.obscureText,
      this.suffixicon,
      this.readOnly,
      this.onTab,
      this.focusNode,
      this.nextfocusNode,
      this.onFieldSubmitted,
      this.validator})
      : super(key: key);
  final String text;
  final TextEditingController cController;
  final IconData prefixIcon;
  final TextInputType kt;
  final IconData postfixIcon;
  final bool obscureText;
  final Widget suffixicon;
  final bool readOnly;
  final void Function() onTab;
  final FocusNode focusNode;
  final FocusNode nextfocusNode;
  final Function onFieldSubmitted;
  final String Function(String error) validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextFormField(
        readOnly: readOnly ?? false,
        keyboardType: kt,
        onTap: () => onTab(),
        controller: cController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: colors.ggrey)),
            filled: true,
            fillColor: Colors.white70,
            hintText: text,
            hintStyle: TextStyle(
              color: colors.ggrey,
              fontSize: 15,
            ),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.grey,
            )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixicon),
        focusNode: focusNode,
        onFieldSubmitted: (String v) {
          onFieldSubmitted();
        },
        validator: (String error) {
          return validator(error);
        },
      ),
    );
  }
}
