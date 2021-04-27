import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/helpers/service_locator.dart';
import 'package:points_of_sale/providers/transactionController.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key key, this.searches}) : super(key: key);
  final List<String> searches;
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController itemName = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  SimpleAutoCompleteTextField textField;
  List<String> suggestions;
  @override
  void initState() {
    super.initState();
    suggestions = widget.searches;
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(
          alignLabelWithHint: true,
          helperText: "حدد موقع البحث",
          fillColor: colors.blue,
          hoverColor: colors.blue,
          focusColor: colors.blue),
      controller: getIt<TransactionController>().addressController,
      submitOnSuggestionTap: true,
      suggestions: suggestions,
      textChanged: (text) {
        // setState(() {
        //   addressController.text = text;
        // });
      },
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        getIt<TransactionController>().addressController.text = text;
        if (text != "") {
          setState(() {
            suggestions.add(text);
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [],
      ),
    );
  }
}
