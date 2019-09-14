import 'package:flutter/material.dart';
import 'package:sqfentity_sample/model/model.dart';
import 'package:sqfentity_sample/tools/global.dart';

class ProductFilterWindow extends StatefulWidget {
  ProductFilterWindow(this.showCategoryRow);
  final bool showCategoryRow;
  @override
  State<StatefulWidget> createState() =>
      ProductFilterWindowState(showCategoryRow);
}

class ProductFilterWindowState extends State {
  ProductFilterWindowState(this.showCategoryRow);
  final bool showCategoryRow;
  List<DropdownMenuItem<int>> _dropdownMenuItems =
      List<DropdownMenuItem<int>>();
  int _selectedCategoryId = SearchFilter.getValues.selectedCategoryId ?? 0;
  int nameRadioValue = SearchFilter.getValues.nameRadioValue ?? 1;
  bool isActive = SearchFilter.getValues.isActive ?? false;
  bool isNotActive = SearchFilter.getValues.isNotActive ?? false;
  final _formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();
  final txtDescription = TextEditingController();
  final txtImageUrl = TextEditingController();
  final txtPriceMin = TextEditingController();
  final txtPriceMax = TextEditingController();

  String nameTitle = 'Contains';

  //List<String> _categories = ['Please choose a location', 'A', 'B', 'C', 'D']; // Option 1
//  String _selectedLocation = 'Please choose a location'; // Option 1
  // Option 2
  @override
  void initState() {
    /*
    _dropdownMenuItems = List<DropdownMenuItem<Category>>();
    _dropdownMenuItems.add(DropdownMenuItem(
      value: Category(),
      child: Text('Select Category'),
    ));
    _selectedCategory = _dropdownMenuItems[0].value;
*/

    txtName.text = SearchFilter.getValues.txtNameText;
    txtDescription.text = SearchFilter.getValues.descriptionContains;
    if (SearchFilter.getValues.minPrice != null) {
      txtPriceMin.text = SearchFilter.getValues.minPrice.toString();
    } else
      txtPriceMin.text = '';
    if (SearchFilter.getValues.maxPrice != null) {
      txtPriceMax.text = SearchFilter.getValues.maxPrice.toString();
    } else
      txtPriceMax.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenu() async {
      final dropdownMenuItems =
          await Category().select().toDropDownMenuInt('name');
      setState(() {
        _dropdownMenuItems = dropdownMenuItems;
        _selectedCategoryId = SearchFilter.getValues.selectedCategoryId;
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
        appBar: AppBar(title: Text('Filter Products')),
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
                    buildRowNameOptions(),
                    buildRowName(),
                    buildRowDescription(),
                    buildRowPrice(),
                    showCategoryRow
                        ? buildRowCategory(onChangeDropdownItem)
                        : SizedBox(
                            height: 1,
                          ),
                    buildIsActiveRow(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          child: applyButton('Clear Filter'),
                          onPressed: () {
                            clearFilter();
                          },
                        ),
                        FlatButton(
                          child: applyButton('Apply'),
                          onPressed: () {
                            applyFilter();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))));
  }

  Row buildRowPrice() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextField(
            controller: txtPriceMin,
            decoration: InputDecoration(labelText: 'Minimum Price'),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: txtPriceMax,
            decoration: InputDecoration(labelText: 'Maximum Price'),
          ),
        )
      ],
    );
  }

  TextField buildRowDescription() {
    return TextField(
      controller: txtDescription,
      decoration: InputDecoration(labelText: 'Description Contains'),
    );
  }

  TextField buildRowImageUrl() {
    return TextField(
      controller: txtImageUrl,
      decoration: InputDecoration(labelText: 'Image Url'),
    );
  }

  Row buildRowNameOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Divider(
          height: 5.0,
          color: Colors.black,
        ),
        Text(
          'Name:',
        ),
        Radio(
          value: 0,
          groupValue: nameRadioValue,
          onChanged: _handleRadioValueChange,
        ),
        Text(
          'Starts',
        ),
        Radio(
          value: 1,
          groupValue: nameRadioValue,
          onChanged: _handleRadioValueChange,
        ),
        Text(
          'Contains',
        ),
        Radio(
          value: 2,
          groupValue: nameRadioValue,
          onChanged: _handleRadioValueChange,
        ),
        Text(
          'Ends',
        ),
      ],
    );
  }

  TextFormField buildRowName() {
    return TextFormField(
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name $nameTitle'),
    );
  }

  Container buildIsActiveRow() {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(95, 66, 119, .5)))),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isActive ?? false,
            activeColor: Color.fromRGBO(95, 66, 119, 1),
            onChanged: (bool value) {
              setState(() {
                isActive = value;
              });
            },
          ),
          Text('Activated'),
          Checkbox(
            value: isNotActive ?? false,
            activeColor: Color.fromRGBO(95, 66, 119, 1),
            onChanged: (bool value) {
              setState(() {
                isNotActive = value;
              });
            },
          ),
          Text('Not Activated')
        ],
      ),
    );
  }

  Row buildRowCategory(void onChangeDropdownItem(int selectedCategoryId)) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Category'),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedCategoryId,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
            )),
      ],
    );
  }

  Container applyButton(String text) {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      nameRadioValue = value;

      switch (nameRadioValue) {
        case 0:
          nameTitle = 'Starts With';
          break;
        case 1:
          nameTitle = 'Contains';
          break;
        case 2:
          nameTitle = 'Ends With';
          break;
      }
    });
  }

  void clearFilter() {
    SearchFilter.resetSearchFilter();
    setState(() {
      nameRadioValue = 1;
      _selectedCategoryId = null;
      isActive = false;
      isNotActive = false;
    });
    txtName.text = '';
    txtDescription.text = '';
    txtPriceMin.text = '';
    txtPriceMax.text = '';
  }

  void applyFilter() async {
    SearchFilter.getValues.nameContains = null;
    SearchFilter.getValues.nameStartsWith = null;
    SearchFilter.getValues.nameEndsWith = null;
    if (txtName.text.isNotEmpty) {
      switch (nameRadioValue) {
        case 0:
          SearchFilter.getValues.nameStartsWith = txtName.text;
          break;
        case 1:
          SearchFilter.getValues.nameContains = txtName.text;
          break;
        case 2:
          SearchFilter.getValues.nameEndsWith = txtName.text;
          break;
        default:
      }
    }
    SearchFilter.getValues.nameRadioValue = nameRadioValue;
    SearchFilter.getValues.txtNameText = txtName.text;
    SearchFilter.getValues.descriptionContains =
        txtDescription.text.isNotEmpty ? txtDescription.text : null;
    SearchFilter.getValues.minPrice =
        txtPriceMin.text.isNotEmpty ? double.tryParse(txtPriceMin.text) : null;
    SearchFilter.getValues.maxPrice =
        txtPriceMax.text.isNotEmpty ? double.tryParse(txtPriceMax.text) : null;
    if (SearchFilter.getValues.minPrice == 0) {
      SearchFilter.getValues.minPrice = null;
    }
    if (SearchFilter.getValues.maxPrice == 0) {
      SearchFilter.getValues.maxPrice = null;
    }
    SearchFilter.getValues.selectedCategoryId =
        _selectedCategoryId != 0 ? _selectedCategoryId : null;
    if ((isActive && isNotActive) || (!isActive && !isNotActive)) {
      isActive = null;
      SearchFilter.getValues.isNotActive = false;
    }

    SearchFilter.getValues.isActive = isActive;
    SearchFilter.getValues.isNotActive = isNotActive;
    Navigator.pop(context, true);
  }
}
