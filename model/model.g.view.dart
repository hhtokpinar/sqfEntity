// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart'; // CONTROLLER hasSubItems:true

class CategoryController extends Category {
  static SQFViewList getController = SQFViewList(
    CategoryController(),
    primaryKeyName: 'id',
    useSoftDeleting: false,
    formListTitleField: 'name',
    formListSubTitleField: null,
    hasSubItems: true,
  );
  SQFViewList subList(int id) {
    return SQFViewList(CategoryControllerSub(),
        primaryKeyName: CategoryControllerSub.primaryKeyName,
        useSoftDeleting: CategoryControllerSub.useSoftDeleting,
        formListTitleField: CategoryControllerSub.formListTitleField,
        formListSubTitleField: CategoryControllerSub.formListSubTitleField,
        filterExpression: '${CategoryControllerSub.relationshipFieldName}=$id');
  }

  Future<Widget> gotoEdit(dynamic obj) async {
    return CategoryAdd(obj == null
        ? Category()
        : await Category().getById(obj['id'] as int) ?? Category());
  }
}
// END CONTROLLER

class CategoryAdd extends StatefulWidget {
  CategoryAdd(this._category);
  final dynamic _category;
  @override
  State<StatefulWidget> createState() =>
      CategoryAddState(_category as Category);
}

class CategoryAddState extends State {
  CategoryAddState(this.category);
  Category category;
  final _formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();

  @override
  void initState() {
    txtName.text = category.name == null ? '' : category.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (category.id == null)
            ? Text('Add a new category')
            : Text('Edit category'),
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
                              duration: Duration(seconds: 2),
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

  Widget buildRowName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter Name()';
        }
        return null;
      },
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name'),
    );
  }

  Widget buildRowIsActive() {
    return Row(
      children: <Widget>[
        Text('IsActive?'),
        Checkbox(
          value: category.isActive,
          onChanged: (bool value) {
            setState(() {
              category.isActive = value;
            });
          },
        ),
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    category..name = txtName.text;
    final result = await category.save();
    if (result != 0) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(category.saveResult.toString(),
          title: 'save Category Failed!', callBack: () {
        Navigator.pop(context, true);
      });
    }
  }
}

// CONTROLLER hasSubItems:false
class CategoryControllerSub extends ProductController {
  static String relationshipFieldName = 'categoryId';
  static String primaryKeyName = 'id';
  static bool useSoftDeleting = true;
  static String formListTitleField = 'name';
  static String formListSubTitleField;
}

class ProductController extends Product {
  static SQFViewList getController = SQFViewList(
    ProductController(),
    primaryKeyName: 'id',
    useSoftDeleting: true,
    formListTitleField: 'name',
    formListSubTitleField: null,
    hasSubItems: false,
  );

  Future<Widget> gotoEdit(dynamic obj) async {
    return ProductAdd(obj == null
        ? Product()
        : await Product().getById(obj['id'] as int) ?? Product());
  }
}
// END CONTROLLER

class ProductAdd extends StatefulWidget {
  ProductAdd(this._product);
  final dynamic _product;
  @override
  State<StatefulWidget> createState() => ProductAddState(_product as Product);
}

class ProductAddState extends State {
  ProductAddState(this.product);
  Product product;
  final _formKey = GlobalKey<FormState>();
  final txtName = TextEditingController();
  final txtDescription = TextEditingController();
  final txtPrice = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForCategoryId =
      List<DropdownMenuItem<int>>();
  int _selectedCategoryId;

  final txtRownum = TextEditingController();
  final txtImageUrl = TextEditingController();
  final txtDatetime = TextEditingController();
  final txtTimeForDatetime = TextEditingController();
  final txtDate = TextEditingController();
  final txtTimeForDate = TextEditingController();

  @override
  void initState() {
    txtName.text = product.name == null ? '' : product.name;
    txtDescription.text =
        product.description == null ? '' : product.description;
    txtPrice.text = product.price == null ? '' : product.price.toString();

    txtRownum.text = product.rownum == null ? '' : product.rownum.toString();
    txtImageUrl.text = product.imageUrl == null ? '' : product.imageUrl;
    txtDatetime.text =
        product.datetime == null ? '' : UITools.convertDate(product.datetime);
    txtTimeForDatetime.text =
        product.datetime == null ? '' : UITools.convertTime(product.datetime);

    txtDate.text =
        product.date == null ? '' : UITools.convertDate(product.date);
    txtTimeForDate.text =
        product.date == null ? '' : UITools.convertTime(product.date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForCategoryId() async {
      final dropdownMenuItems =
          await Category().select().toDropDownMenuInt('name');
      setState(() {
        _dropdownMenuItemsForCategoryId = dropdownMenuItems;
        _selectedCategoryId = product.categoryId;
      });
    }

    if (_dropdownMenuItemsForCategoryId == null ||
        _dropdownMenuItemsForCategoryId.isEmpty) {
      buildDropDownMenuForCategoryId();
    }
    void onChangeDropdownItemForCategoryId(int selectedCategoryId) {
      setState(() {
        _selectedCategoryId = selectedCategoryId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (product.id == null)
            ? Text('Add a new product')
            : Text('Edit product'),
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
                    buildRowDescription(),
                    buildRowPrice(),
                    buildRowIsActive(),
                    buildRowCategoryId(onChangeDropdownItemForCategoryId),
                    buildRowRownum(),
                    buildRowImageUrl(),
                    buildRowDatetime(),
                    buildRowDate(),
                    FlatButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
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

  Widget buildRowName() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter Name()';
        }
        return null;
      },
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name'),
    );
  }

  Widget buildRowDescription() {
    return TextFormField(
      controller: txtDescription,
      decoration: InputDecoration(labelText: 'Description'),
    );
  }

  Widget buildRowPrice() {
    return TextFormField(
      validator: (value) {
        if (value.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
        }
        return null;
      },
      controller: txtPrice,
      decoration: InputDecoration(labelText: 'Price'),
    );
  }

  Widget buildRowIsActive() {
    return Row(
      children: <Widget>[
        Text('IsActive?'),
        Checkbox(
          value: product.isActive,
          onChanged: (bool value) {
            setState(() {
              product.isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowCategoryId(
      void onChangeDropdownItemForCategoryId(int selectedCategoryId)) {
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
                items: _dropdownMenuItemsForCategoryId,
                onChanged: onChangeDropdownItemForCategoryId,
                validator: (value) {
                  if ((_selectedCategoryId != null &&
                          _selectedCategoryId > 0) ||
                      true) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter Category';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowRownum() {
    return TextFormField(
      validator: (value) {
        if (value.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }
        return null;
      },
      controller: txtRownum,
      decoration: InputDecoration(labelText: 'Rownum'),
    );
  }

  Widget buildRowImageUrl() {
    return TextFormField(
      controller: txtImageUrl,
      decoration: InputDecoration(labelText: 'ImageUrl'),
    );
  }

  Widget buildRowDatetime() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('2019-01-01'),
              maxTime: DateTime.now().add(Duration(days: 30)),
              onConfirm: (sqfSelectedDate) {
            txtDatetime.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDatetime.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = product.datetime ?? DateTime.now();
              product.datetime = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: product.datetime ?? DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDatetime,
          decoration: InputDecoration(labelText: 'Datetime'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDatetime.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = product.datetime ?? DateTime.now();
                product.datetime = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDatetime.text = UITools.convertDate(product.datetime);
              });
            },
                currentTime: product.datetime ?? DateTime(2019),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDatetime,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowDate() {
    return TextFormField(
      onTap: () => DatePicker.showDatePicker(context,
          showTitleActions: true,
          theme: UITools.mainDatePickerTheme,
          minTime: DateTime.parse('2015-01-01'),
          maxTime: DateTime.now().add(Duration(days: 365)),
          onConfirm: (sqfSelectedDate) {
        txtDate.text = UITools.convertTime(sqfSelectedDate);
        setState(() {
          product.date = sqfSelectedDate;
        });
      },
          currentTime: product.date ?? DateTime.now(),
          locale: UITools.mainDatePickerLocaleType),
      controller: txtDate,
      decoration: InputDecoration(labelText: 'Date'),
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
    product
      ..name = txtName.text
      ..description = txtDescription.text
      ..price = double.tryParse(txtPrice.text)
      ..categoryId = _selectedCategoryId
      ..rownum = int.tryParse(txtRownum.text)
      ..imageUrl = txtImageUrl.text;
    final result = await product.save();
    if (result != 0) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(product.saveResult.toString(),
          title: 'save Product Failed!', callBack: () {
        Navigator.pop(context, true);
      });
    }
  }
}

// CONTROLLER hasSubItems:false

class TodoController extends Todo {
  static SQFViewList getController = SQFViewList(
    TodoController(),
    primaryKeyName: 'id',
    useSoftDeleting: false,
    formListTitleField: 'title',
    formListSubTitleField: null,
    hasSubItems: false,
  );

  Future<Widget> gotoEdit(dynamic obj) async {
    return TodoAdd(obj == null
        ? Todo()
        : await Todo().getById(obj['id'] as int) ?? Todo());
  }
}
// END CONTROLLER

class TodoAdd extends StatefulWidget {
  TodoAdd(this._todos);
  final dynamic _todos;
  @override
  State<StatefulWidget> createState() => TodoAddState(_todos as Todo);
}

class TodoAddState extends State {
  TodoAddState(this.todos);
  Todo todos;
  final _formKey = GlobalKey<FormState>();
  final txtUserId = TextEditingController();
  final txtTitle = TextEditingController();

  @override
  void initState() {
    txtUserId.text = todos.userId == null ? '' : todos.userId.toString();
    txtTitle.text = todos.title == null ? '' : todos.title;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            (todos.id == null) ? Text('Add a new todos') : Text('Edit todos'),
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
                    buildRowUserId(),
                    buildRowTitle(),
                    buildRowCompleted(),
                    FlatButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
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

  Widget buildRowUserId() {
    return TextFormField(
      validator: (value) {
        if (value.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }
        return null;
      },
      controller: txtUserId,
      decoration: InputDecoration(labelText: 'UserId'),
    );
  }

  Widget buildRowTitle() {
    return TextFormField(
      controller: txtTitle,
      decoration: InputDecoration(labelText: 'Title'),
    );
  }

  Widget buildRowCompleted() {
    return Row(
      children: <Widget>[
        Text('Completed?'),
        Checkbox(
          value: todos.completed,
          onChanged: (bool value) {
            setState(() {
              todos.completed = value;
            });
          },
        ),
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    todos
      ..userId = int.tryParse(txtUserId.text)
      ..title = txtTitle.text;
    final result = await todos.save();
    if (result != 0) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(todos.saveResult.toString(),
          title: 'save Todo Failed!', callBack: () {
        Navigator.pop(context, true);
      });
    }
  }
}
