import 'package:flutter/material.dart';
import 'package:points_of_sale/localization/trans.dart';
import 'widgets/text_form_input.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController itemName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          TextFormInput(
            text: trans(context, 'item_name'),
            cController: itemName,
            readOnly: false,
            obscureText: false,
            onTab: () {},
          ),
        ],
      ),
    );
  }
}
