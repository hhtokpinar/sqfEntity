import 'package:flutter/material.dart';
import '../model/model.dart';
import 'searchFilters.dart';

class ProductFilterWindow extends StatefulWidget {
  ProductFilterWindow();

  @override
  State<StatefulWidget> createState() => ProductFilterWindowState();
}

class ProductFilterWindowState extends State {
  ProductFilterWindowState();

  List<DropdownMenuItem<int>> _dropdownMenuItems = <DropdownMenuItem<int>>[];
  int? _selectedCategoryId =
      SearchFilterProduct.getValues.selectedCategoryId ?? 0;
  int nameRadioValue = SearchFilterProduct.getValues.nameRadioValue ?? 1;
  bool? isActive = SearchFilterProduct.getValues.isActive ?? false;
  bool? isNotActive = SearchFilterProduct.getValues.isNotActive ?? false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  final TextEditingController txtPriceMin = TextEditingController();
  final TextEditingController txtPriceMax = TextEditingController();

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

    txtName.text = SearchFilterProduct.getValues.txtNameText ?? '';
    txtDescription.text =
        SearchFilterProduct.getValues.descriptionContains ?? '';
    if (SearchFilterProduct.getValues.minPrice != null) {
      txtPriceMin.text = SearchFilterProduct.getValues.minPrice.toString();
    } else {
      txtPriceMin.text = '';
    }
    if (SearchFilterProduct.getValues.maxPrice != null) {
      txtPriceMax.text = SearchFilterProduct.getValues.maxPrice.toString();
    } else {
      txtPriceMax.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenu() async {
      final dropdownMenuItems =
          await Category().select().toDropDownMenuInt('name');
      setState(() {
        _dropdownMenuItems = dropdownMenuItems;
        _selectedCategoryId = SearchFilterProduct.getValues.selectedCategoryId!;
      });
    }

    if (_dropdownMenuItems.isEmpty) {
      buildDropDownMenu();
    }

    void onChangeDropdownItem(int? selectedCategoryId) {
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
                    buildRowCategory(onChangeDropdownItem),
                    buildIsActiveRow(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: applyButton('Clear Filter'),
                          onPressed: () {
                            clearFilter();
                          },
                        ),
                        TextButton(
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
            onChanged: (bool? value) {
              setState(() {
                isActive = value!;
              });
            },
          ),
          Text('Activated'),
          Checkbox(
            value: isNotActive ?? false,
            activeColor: Color.fromRGBO(95, 66, 119, 1),
            onChanged: (bool? value) {
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

  Row buildRowCategory(
      void Function(int? selectedCategoryId) onChangeDropdownItem) {
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

  void _handleRadioValueChange(int? value) {
    setState(() {
      nameRadioValue = value!;

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
    SearchFilterProduct.resetSearchFilter();
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
    SearchFilterProduct.getValues.nameContains = null;
    SearchFilterProduct.getValues.nameStartsWith = null;
    SearchFilterProduct.getValues.nameEndsWith = null;
    if (txtName.text.isNotEmpty) {
      switch (nameRadioValue) {
        case 0:
          SearchFilterProduct.getValues.nameStartsWith = txtName.text;
          break;
        case 1:
          SearchFilterProduct.getValues.nameContains = txtName.text;
          break;
        case 2:
          SearchFilterProduct.getValues.nameEndsWith = txtName.text;
          break;
        default:
      }
    }
    SearchFilterProduct.getValues.nameRadioValue = nameRadioValue;
    SearchFilterProduct.getValues.txtNameText = txtName.text;
    SearchFilterProduct.getValues.descriptionContains =
        txtDescription.text.isNotEmpty ? txtDescription.text : null;
    SearchFilterProduct.getValues.minPrice =
        txtPriceMin.text.isNotEmpty ? double.tryParse(txtPriceMin.text) : null;
    SearchFilterProduct.getValues.maxPrice =
        txtPriceMax.text.isNotEmpty ? double.tryParse(txtPriceMax.text) : null;
    if (SearchFilterProduct.getValues.minPrice == 0) {
      SearchFilterProduct.getValues.minPrice = null;
    }
    if (SearchFilterProduct.getValues.maxPrice == 0) {
      SearchFilterProduct.getValues.maxPrice = null;
    }
    SearchFilterProduct.getValues.selectedCategoryId =
        _selectedCategoryId != 0 ? _selectedCategoryId : null;
    if ((isActive! && isNotActive!) || (!isActive! && !isNotActive!)) {
      isActive = null;
      SearchFilterProduct.getValues.isNotActive = false;
    }

    SearchFilterProduct.getValues.isActive = isActive;
    SearchFilterProduct.getValues.isNotActive = isNotActive;
    Navigator.pop(context, true);
  }
}
