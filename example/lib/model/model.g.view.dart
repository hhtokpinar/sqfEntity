// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart';

//ignore: must_be_immutable
class ProductAdd extends StatefulWidget {
  ProductAdd([this._product]) {
    _product ??= Product();
  }
  dynamic _product;
  @override
  State<StatefulWidget> createState() => ProductAddState(_product as Product);
}

class ProductAddState extends State {
  ProductAddState(this.product);
  Product product;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForCategoryId =
      <DropdownMenuItem<int>>[];
  int? _selectedCategoryId;

  final TextEditingController txtRownum = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  final TextEditingController txtDatetime = TextEditingController();
  final TextEditingController txtTimeForDatetime = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtName.text = product.name == null ? '' : product.name.toString();
    txtDescription.text =
        product.description == null ? '' : product.description.toString();
    txtPrice.text = product.price == null ? '' : product.price.toString();

    txtRownum.text = product.rownum == null ? '' : product.rownum.toString();
    txtImageUrl.text =
        product.imageUrl == null ? '' : product.imageUrl.toString();
    txtDatetime.text = product.datetime == null
        ? ''
        : defaultDateTimeFormat.format(product.datetime!);
    txtTimeForDatetime.text = product.datetime == null
        ? ''
        : defaultTimeFormat.format(product.datetime!);

    txtDate.text =
        product.date == null ? '' : defaultDateFormat.format(product.date!);
    txtDateCreated.text = product.dateCreated == null
        ? ''
        : defaultDateTimeFormat.format(product.dateCreated!);
    txtTimeForDateCreated.text = product.dateCreated == null
        ? ''
        : defaultTimeFormat.format(product.dateCreated!);

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

    if (_dropdownMenuItemsForCategoryId.isEmpty) {
      buildDropDownMenuForCategoryId();
    }
    void onChangeDropdownItemForCategoryId(int? selectedCategoryId) {
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
                    buildRowImageUrl(),
                    buildRowDatetime(),
                    buildRowDate(),
                    buildRowDateCreated(),
                    saveButton()
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
        if (value == null || value.isEmpty) {
          return 'Please enter Name';
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
        if (value!.isNotEmpty && double.tryParse(value) == null) {
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
          value: product.isActive ?? false,
          onChanged: (bool? value) {
            setState(() {
              product.isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowCategoryId(
      void Function(int? selectedCategoryId)
          onChangeDropdownItemForCategoryId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Category'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedCategoryId,
                items: _dropdownMenuItemsForCategoryId,
                onChanged: onChangeDropdownItemForCategoryId,
                validator: (value) {
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
        if (value!.isNotEmpty && int.tryParse(value) == null) {
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
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('2019-01-01'),
              maxTime: DateTime.now().add(Duration(days: 30)),
              onConfirm: (sqfSelectedDate) {
            txtDatetime.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDatetime.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDatetime.text) ??
                  product.datetime ??
                  DateTime.now();
              product.datetime = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDatetime.text) ??
                  product.datetime ??
                  DateTime.now()),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Datetime';
            }
            return null;
          },
          controller: txtDatetime,
          decoration: InputDecoration(labelText: 'Datetime'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDatetime.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDatetime.text) ??
                    product.datetime ??
                    DateTime.now();
                product.datetime = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDatetime.text = UITools.convertDate(product.datetime!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDatetime.text}') ??
                    product.datetime ??
                    DateTime.now()),
            controller: txtTimeForDatetime,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Widget buildRowDate() {
    return TextFormField(
      onTap: () => UITools.showDateTimePicker(context,
          minTime: DateTime.parse('2015-01-01'),
          maxTime: DateTime.now().add(Duration(days: 365)),
          onConfirm: (sqfSelectedDate) {
        txtDate.text = UITools.convertDate(sqfSelectedDate);
        setState(() {
          product.date = sqfSelectedDate;
        });
      },
          currentTime: DateTime.tryParse(txtDate.text) ??
              product.date ??
              DateTime.now()),
      controller: txtDate,
      decoration: InputDecoration(labelText: 'Date'),
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  product.dateCreated ??
                  DateTime.now();
              product.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  product.dateCreated ??
                  DateTime.now()),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    product.dateCreated ??
                    DateTime.now();
                product.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text = UITools.convertDate(product.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    product.dateCreated ??
                    DateTime.now()),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          save();
        }
      },
      child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void save() async {
    var _datetime = tryParseDateTime(txtDatetime.text);
    final _datetimeTime = tryParseDateTime(txtTimeForDatetime.text);
    if (_datetime != null && _datetimeTime != null) {
      _datetime = _datetime.add(Duration(
          hours: _datetimeTime.hour,
          minutes: _datetimeTime.minute,
          seconds: _datetimeTime.second));
    }
    final _date = tryParseDateTime(txtDate.text);
    var _dateCreated = tryParseDateTime(txtDateCreated.text);
    final _dateCreatedTime = tryParseDateTime(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    product
      ..name = txtName.text
      ..description = txtDescription.text
      ..price = double.tryParse(txtPrice.text)
      ..categoryId = _selectedCategoryId
      ..rownum = int.tryParse(txtRownum.text)
      ..imageUrl = txtImageUrl.text
      ..datetime = _datetime
      ..date = _date
      ..dateCreated = _dateCreated;
    await product.save();
    if (product.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(product.saveResult.toString(),
          title: 'saving Failed!', callBack: () {});
    }
  }
}

//ignore: must_be_immutable
class CategoryAdd extends StatefulWidget {
  CategoryAdd([this._category]) {
    _category ??= Category();
  }
  dynamic _category;
  @override
  State<StatefulWidget> createState() =>
      CategoryAddState(_category as Category);
}

class CategoryAddState extends State {
  CategoryAddState(this.category);
  Category category;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtName.text = category.name == null ? '' : category.name.toString();

    txtDateCreated.text = category.dateCreated == null
        ? ''
        : defaultDateTimeFormat.format(category.dateCreated!);
    txtTimeForDateCreated.text = category.dateCreated == null
        ? ''
        : defaultTimeFormat.format(category.dateCreated!);

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
                    buildRowDateCreated(),
                    saveButton()
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
        if (value == null || value.isEmpty) {
          return 'Please enter Name';
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
          value: category.isActive ?? false,
          onChanged: (bool? value) {
            setState(() {
              category.isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  category.dateCreated ??
                  DateTime.now();
              category.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  category.dateCreated ??
                  DateTime.now()),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    category.dateCreated ??
                    DateTime.now();
                category.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(category.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    category.dateCreated ??
                    DateTime.now()),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          save();
        }
      },
      child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void save() async {
    var _dateCreated = tryParseDateTime(txtDateCreated.text);
    final _dateCreatedTime = tryParseDateTime(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    category
      ..name = txtName.text
      ..dateCreated = _dateCreated;
    await category.save();
    if (category.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(category.saveResult.toString(),
          title: 'saving Failed!', callBack: () {});
    }
  }
}

//ignore: must_be_immutable
class TodoAdd extends StatefulWidget {
  TodoAdd([this._todo]) {
    _todo ??= Todo();
  }
  dynamic _todo;
  @override
  State<StatefulWidget> createState() => TodoAddState(_todo as Todo);
}

class TodoAddState extends State {
  TodoAddState(this.todo);
  Todo todo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtUserId = TextEditingController();
  final TextEditingController txtTitle = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtUserId.text = todo.userId == null ? '' : todo.userId.toString();
    txtTitle.text = todo.title == null ? '' : todo.title.toString();

    txtDateCreated.text = todo.dateCreated == null
        ? ''
        : defaultDateTimeFormat.format(todo.dateCreated!);
    txtTimeForDateCreated.text = todo.dateCreated == null
        ? ''
        : defaultTimeFormat.format(todo.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (todo.id == null) ? Text('Add a new todo') : Text('Edit todo'),
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
                    buildRowId(),
                    buildRowUserId(),
                    buildRowTitle(),
                    buildRowCompleted(),
                    buildRowDateCreated(),
                    saveButton()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtId,
      decoration: InputDecoration(labelText: 'Id'),
    );
  }

  Widget buildRowUserId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
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
          value: todo.completed ?? false,
          onChanged: (bool? value) {
            setState(() {
              todo.completed = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  todo.dateCreated ??
                  DateTime.now();
              todo.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  todo.dateCreated ??
                  DateTime.now()),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    todo.dateCreated ??
                    DateTime.now();
                todo.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text = UITools.convertDate(todo.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    todo.dateCreated ??
                    DateTime.now()),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          save();
        }
      },
      child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void save() async {
    var _dateCreated = tryParseDateTime(txtDateCreated.text);
    final _dateCreatedTime = tryParseDateTime(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    todo
      ..id = int.tryParse(txtId.text)
      ..userId = int.tryParse(txtUserId.text)
      ..title = txtTitle.text
      ..dateCreated = _dateCreated;
    await todo.save();
    if (todo.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(todo.saveResult.toString(),
          title: 'saving Failed!', callBack: () {});
    }
  }
}
