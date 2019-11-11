import 'package:flutter/material.dart';
import '../sample_advanced_form/productList.dart';
import '../tools/helper.dart';
import 'model.dart';

class MainController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainControllerState();
}

class MainControllerState extends State {
  Map<String, dynamic> controllers = Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    //

    void refreshList() {
      setState(() {
        /// Load controller cards from generated models
        controllers = MyDbModel().getControllers();

        /// We added this card sample includes how to filter by form values and order, listing deleted items and recovery..
        controllers['Advanced Form'] = ProductList();
        //controllers['Datetime Picker'] = MyPickerApp();

      });
    }

    //if (controllers.isEmpty) {
      /// Load controllers from generated models
      refreshList();
    //}

    //}
    final makeMainController = ListView(
      children: ListTile.divideTiles(
          context: this.context,
          tiles: List.generate(controllers.length, (index) {
            final String controllerName =
                controllers.keys.toList()[index].toString();
            return UITools(context).makeCard(
                controllers[controllerName] as StatefulWidget, controllerName);
          })).toList(),
    );

    return UITools(context).getMainPage(makeMainController,
        'Listing generated (${controllers.length - 1}) models\nand Advanced Form');
  }
}
