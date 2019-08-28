import 'package:flutter/material.dart';
import 'package:sqfentity_sample/models/models.dart';

class ProductAdd extends StatefulWidget {
  ProductAdd(this.product);
  final Product product;
  @override
  State<StatefulWidget> createState() => ProductAddState(product);
}

class ProductAddState extends State {
  ProductAddState(this.product);
  Product product;
  List<DropdownMenuItem<int>> _dropdownMenuItems =
      List<DropdownMenuItem<int>>();
  int _selectedCategoryId;
  final _formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();
  final txtDescription = TextEditingController();
  final txtImageUrl = TextEditingController();
  final txtPrice = TextEditingController();
  //List<String> _categories = ['Please choose a location', 'A', 'B', 'C', 'D']; // Option 1
//  String _selectedLocation = 'Please choose a location'; // Option 1
  // Option 2
  @override
  void initState() {
    /*
    _dropdownMenuItems = List<DropdownMenuItem<Category>>();
    _dropdownMenuItems.add(DropdownMenuItem(
      value: Category(),
      child: Text("Select Category"),
    ));
    _selectedCategory = _dropdownMenuItems[0].value;
*/

    txtName.text = product.name;
    txtDescription.text = product.description;
    txtImageUrl.text = product.imageUrl;
    txtPrice.text = product.price.toString();
    super.initState();

    //_selectedCategory = _dropdownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenu() async {
      final dropdownMenuItems =
          await Category().select().toDropDownMenuInt("name");
      setState(() {
        _dropdownMenuItems = dropdownMenuItems;
        _selectedCategoryId = product.categoryId;
      });
    }

    if (_dropdownMenuItems == null || _dropdownMenuItems.isEmpty) {
      buildDropDownMenu();
    }

    void onChangeDropdownItem(int selectedCategoryId) {
      setState(() {
        _selectedCategoryId = selectedCategoryId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (product.id == null || product.id == 0)
            ? Text("Add a new product")
            : Text("Edit (" + product.name + ")"),
      ),
      body: 
      Container(
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
                    buildRowCategory(onChangeDropdownItem),
                    buildRowName(),
                    buildRowDescription(),
                    buildRowPrice(),
                    buildRowImageUrl(),
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

  Row buildRowPrice() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextField(

            controller: txtPrice,
            decoration: InputDecoration(labelText: "Price"),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(95, 66, 119, .5)))),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: product.isActive,
                    activeColor: Color.fromRGBO(95, 66, 119, 1),
                    onChanged: (bool value) {
                      setState(() {
                        product.isActive = value;
                      });
                    },
                  ),
                  Text("Activated")
                ],
              ),
            )),
      ],
    );
  }

  TextField buildRowDescription() {
    return TextField(
      controller: txtDescription,
      decoration: InputDecoration(labelText: "Description"),
    );
  }

  TextField buildRowImageUrl() {
    return TextField(
      controller: txtImageUrl,
      decoration: InputDecoration(labelText: "Image Url"),
    );
  }

  TextFormField buildRowName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter Product Name';
        }
        return null;
      },
      controller: txtName,
      decoration: InputDecoration(labelText: "Name"),
    );
  }

  Row buildRowCategory(void onChangeDropdownItem(int selectedCategoryId)) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text("Category"),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: DropdownButtonFormField(
                 value: _selectedCategoryId,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
                validator: (value) {
                  if(_selectedCategoryId!=null && _selectedCategoryId>0)
                  {return null;}
                  else if (value == null || value == 0) {
                    return 'Please enter Category';
                  }
                  return null;
                },
               
              ),
            )),
      ],
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
        "Save",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    //final product = Product();
    product.name = txtName.text;
    product.description = txtDescription.text;
    product.imageUrl = txtImageUrl.text;
    product.price = double.tryParse(txtPrice.text);
    product.categoryId = _selectedCategoryId;
    final result = await product.save();
    if (result != 0) {
      Navigator.pop(context, true);
    }
  }
}
