import 'package:flutter/material.dart';
import 'package:sqfentity_sample/model/model.dart';

class CategoryAdd extends StatefulWidget {
  CategoryAdd(this.category);
  final Category category;
  @override
  State<StatefulWidget> createState() => CategoryAddState(category);
}

class CategoryAddState extends State {
  CategoryAddState(this.category);
  Category category;
  final _formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();
  //List<String> _categories = ['Please choose a location', 'A', 'B', 'C', 'D']; // Option 1
//  String _selectedLocation = 'Please choose a location'; // Option 1
  // Option 2
  @override
  void initState() {
    txtName.text = category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: (category.id == null || category.id == 0)
            ? Text('Add a new category')
            : Text('Edit (${category.name})'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildRowName(),
                    buildRowIsActive(),
                    FlatButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 10),
                              content: Text('Processing Data')));
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Row buildRowIsActive() {
    return Row(
      children: <Widget>[
  Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(95, 66, 119, .5)))),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: category.isActive,
                    activeColor: Color.fromRGBO(95, 66, 119, 1),
                    onChanged: (bool value) {
                      setState(() {
                        category.isActive = value;
                      });
                    },
                  ),
                  Text('Activated')
                ],
              ),
            )
      ],
    );
  }

  TextFormField buildRowName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter Category Name';
        }
        return null;
      },
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name'),
    );
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    //final category = Category();
    category.name = txtName.text;
    final result = await category.save();
    if (result != 0) {
      Navigator.pop(context, true);
    }
  }
}
