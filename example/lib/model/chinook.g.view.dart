// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'chinook.dart';

class AlbumAdd extends StatefulWidget {
  AlbumAdd(this._album);
  final dynamic _album;
  @override
  State<StatefulWidget> createState() => AlbumAddState(_album as Album);
}

class AlbumAddState extends State {
  AlbumAddState(this.album);
  Album album;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtTitle = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForArtistId =
      <DropdownMenuItem<int>>[];
  int? _selectedArtistId;

  @override
  void initState() {
    txtTitle.text = album.Title == null ? '' : album.Title.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForArtistId() async {
      final dropdownMenuItems =
          await Artist().select().toDropDownMenuInt('Name');
      setState(() {
        _dropdownMenuItemsForArtistId = dropdownMenuItems;
        _selectedArtistId = album.ArtistId;
      });
    }

    if (_dropdownMenuItemsForArtistId.isEmpty) {
      buildDropDownMenuForArtistId();
    }
    void onChangeDropdownItemForArtistId(int? selectedArtistId) {
      setState(() {
        _selectedArtistId = selectedArtistId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (album.AlbumId == null)
            ? Text('Add a new album')
            : Text('Edit album'),
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
                    buildRowTitle(),
                    buildRowArtistId(onChangeDropdownItemForArtistId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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

  Widget buildRowTitle() {
    return TextFormField(
      controller: txtTitle,
      decoration: InputDecoration(labelText: 'Title'),
    );
  }

  Widget buildRowArtistId(
      void Function(int? selectedArtistId) onChangeDropdownItemForArtistId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Artist'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedArtistId,
                items: _dropdownMenuItemsForArtistId,
                onChanged: onChangeDropdownItemForArtistId,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    album
      ..Title = txtTitle.text
      ..ArtistId = _selectedArtistId;
    await album.save();
    if (album.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(album.saveResult.toString(),
          title: 'save Album Failed!', callBack: () {});
    }
  }
}

class ArtistAdd extends StatefulWidget {
  ArtistAdd(this._artist);
  final dynamic _artist;
  @override
  State<StatefulWidget> createState() => ArtistAddState(_artist as Artist);
}

class ArtistAddState extends State {
  ArtistAddState(this.artist);
  Artist artist;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();

  @override
  void initState() {
    txtName.text = artist.Name == null ? '' : artist.Name.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (artist.ArtistId == null)
            ? Text('Add a new artist')
            : Text('Edit artist'),
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
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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
    artist..Name = txtName.text;
    await artist.save();
    if (artist.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(artist.saveResult.toString(),
          title: 'save Artist Failed!', callBack: () {});
    }
  }
}

class CustomerAdd extends StatefulWidget {
  CustomerAdd(this._customer);
  final dynamic _customer;
  @override
  State<StatefulWidget> createState() =>
      CustomerAddState(_customer as Customer);
}

class CustomerAddState extends State {
  CustomerAddState(this.customer);
  Customer customer;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtLastName = TextEditingController();
  final TextEditingController txtCompany = TextEditingController();
  final TextEditingController txtAddress = TextEditingController();
  final TextEditingController txtCity = TextEditingController();
  final TextEditingController txtState = TextEditingController();
  final TextEditingController txtCountry = TextEditingController();
  final TextEditingController txtPostalCode = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtFax = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForSupportRepId =
      <DropdownMenuItem<int>>[];
  int? _selectedSupportRepId;

  @override
  void initState() {
    txtFirstName.text =
        customer.FirstName == null ? '' : customer.FirstName.toString();
    txtLastName.text =
        customer.LastName == null ? '' : customer.LastName.toString();
    txtCompany.text =
        customer.Company == null ? '' : customer.Company.toString();
    txtAddress.text =
        customer.Address == null ? '' : customer.Address.toString();
    txtCity.text = customer.City == null ? '' : customer.City.toString();
    txtState.text = customer.State == null ? '' : customer.State.toString();
    txtCountry.text =
        customer.Country == null ? '' : customer.Country.toString();
    txtPostalCode.text =
        customer.PostalCode == null ? '' : customer.PostalCode.toString();
    txtPhone.text = customer.Phone == null ? '' : customer.Phone.toString();
    txtFax.text = customer.Fax == null ? '' : customer.Fax.toString();
    txtEmail.text = customer.Email == null ? '' : customer.Email.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForSupportRepId() async {
      final dropdownMenuItems =
          await Employee().select().toDropDownMenuInt('LastName');
      setState(() {
        _dropdownMenuItemsForSupportRepId = dropdownMenuItems;
        _selectedSupportRepId = customer.SupportRepId;
      });
    }

    if (_dropdownMenuItemsForSupportRepId.isEmpty) {
      buildDropDownMenuForSupportRepId();
    }
    void onChangeDropdownItemForSupportRepId(int? selectedSupportRepId) {
      setState(() {
        _selectedSupportRepId = selectedSupportRepId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (customer.CustomerId == null)
            ? Text('Add a new customer')
            : Text('Edit customer'),
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
                    buildRowFirstName(),
                    buildRowLastName(),
                    buildRowCompany(),
                    buildRowAddress(),
                    buildRowCity(),
                    buildRowState(),
                    buildRowCountry(),
                    buildRowPostalCode(),
                    buildRowPhone(),
                    buildRowFax(),
                    buildRowEmail(),
                    buildRowSupportRepId(onChangeDropdownItemForSupportRepId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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

  Widget buildRowFirstName() {
    return TextFormField(
      controller: txtFirstName,
      decoration: InputDecoration(labelText: 'FirstName'),
    );
  }

  Widget buildRowLastName() {
    return TextFormField(
      controller: txtLastName,
      decoration: InputDecoration(labelText: 'LastName'),
    );
  }

  Widget buildRowCompany() {
    return TextFormField(
      controller: txtCompany,
      decoration: InputDecoration(labelText: 'Company'),
    );
  }

  Widget buildRowAddress() {
    return TextFormField(
      controller: txtAddress,
      decoration: InputDecoration(labelText: 'Address'),
    );
  }

  Widget buildRowCity() {
    return TextFormField(
      controller: txtCity,
      decoration: InputDecoration(labelText: 'City'),
    );
  }

  Widget buildRowState() {
    return TextFormField(
      controller: txtState,
      decoration: InputDecoration(labelText: 'State'),
    );
  }

  Widget buildRowCountry() {
    return TextFormField(
      controller: txtCountry,
      decoration: InputDecoration(labelText: 'Country'),
    );
  }

  Widget buildRowPostalCode() {
    return TextFormField(
      controller: txtPostalCode,
      decoration: InputDecoration(labelText: 'PostalCode'),
    );
  }

  Widget buildRowPhone() {
    return TextFormField(
      controller: txtPhone,
      decoration: InputDecoration(labelText: 'Phone'),
    );
  }

  Widget buildRowFax() {
    return TextFormField(
      controller: txtFax,
      decoration: InputDecoration(labelText: 'Fax'),
    );
  }

  Widget buildRowEmail() {
    return TextFormField(
      controller: txtEmail,
      decoration: InputDecoration(labelText: 'Email'),
    );
  }

  Widget buildRowSupportRepId(
      void Function(int? selectedSupportRepId)
          onChangeDropdownItemForSupportRepId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Employee'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedSupportRepId,
                items: _dropdownMenuItemsForSupportRepId,
                onChanged: onChangeDropdownItemForSupportRepId,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    customer
      ..FirstName = txtFirstName.text
      ..LastName = txtLastName.text
      ..Company = txtCompany.text
      ..Address = txtAddress.text
      ..City = txtCity.text
      ..State = txtState.text
      ..Country = txtCountry.text
      ..PostalCode = txtPostalCode.text
      ..Phone = txtPhone.text
      ..Fax = txtFax.text
      ..Email = txtEmail.text
      ..SupportRepId = _selectedSupportRepId;
    await customer.save();
    if (customer.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(customer.saveResult.toString(),
          title: 'save Customer Failed!', callBack: () {});
    }
  }
}

class EmployeeAdd extends StatefulWidget {
  EmployeeAdd(this._employee);
  final dynamic _employee;
  @override
  State<StatefulWidget> createState() =>
      EmployeeAddState(_employee as Employee);
}

class EmployeeAddState extends State {
  EmployeeAddState(this.employee);
  Employee employee;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtLastName = TextEditingController();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtBirthDate = TextEditingController();
  final TextEditingController txtTimeForBirthDate = TextEditingController();
  final TextEditingController txtHireDate = TextEditingController();
  final TextEditingController txtTimeForHireDate = TextEditingController();
  final TextEditingController txtAddress = TextEditingController();
  final TextEditingController txtCity = TextEditingController();
  final TextEditingController txtState = TextEditingController();
  final TextEditingController txtCountry = TextEditingController();
  final TextEditingController txtPostalCode = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtFax = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForReportsTo =
      <DropdownMenuItem<int>>[];
  int? _selectedReportsTo;

  @override
  void initState() {
    txtLastName.text =
        employee.LastName == null ? '' : employee.LastName.toString();
    txtFirstName.text =
        employee.FirstName == null ? '' : employee.FirstName.toString();
    txtTitle.text = employee.Title == null ? '' : employee.Title.toString();
    txtBirthDate.text = employee.BirthDate == null
        ? ''
        : UITools.convertDate(employee.BirthDate!);
    txtTimeForBirthDate.text = employee.BirthDate == null
        ? ''
        : UITools.convertTime(employee.BirthDate!);

    txtHireDate.text = employee.HireDate == null
        ? ''
        : UITools.convertDate(employee.HireDate!);
    txtTimeForHireDate.text = employee.HireDate == null
        ? ''
        : UITools.convertTime(employee.HireDate!);

    txtAddress.text =
        employee.Address == null ? '' : employee.Address.toString();
    txtCity.text = employee.City == null ? '' : employee.City.toString();
    txtState.text = employee.State == null ? '' : employee.State.toString();
    txtCountry.text =
        employee.Country == null ? '' : employee.Country.toString();
    txtPostalCode.text =
        employee.PostalCode == null ? '' : employee.PostalCode.toString();
    txtPhone.text = employee.Phone == null ? '' : employee.Phone.toString();
    txtFax.text = employee.Fax == null ? '' : employee.Fax.toString();
    txtEmail.text = employee.Email == null ? '' : employee.Email.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForReportsTo() async {
      final dropdownMenuItems =
          await Employee().select().toDropDownMenuInt('LastName');
      setState(() {
        _dropdownMenuItemsForReportsTo = dropdownMenuItems;
        _selectedReportsTo = employee.ReportsTo;
      });
    }

    if (_dropdownMenuItemsForReportsTo.isEmpty) {
      buildDropDownMenuForReportsTo();
    }
    void onChangeDropdownItemForReportsTo(int? selectedReportsTo) {
      setState(() {
        _selectedReportsTo = selectedReportsTo;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (employee.EmployeeId == null)
            ? Text('Add a new employee')
            : Text('Edit employee'),
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
                    buildRowLastName(),
                    buildRowFirstName(),
                    buildRowTitle(),
                    buildRowBirthDate(),
                    buildRowHireDate(),
                    buildRowAddress(),
                    buildRowCity(),
                    buildRowState(),
                    buildRowCountry(),
                    buildRowPostalCode(),
                    buildRowPhone(),
                    buildRowFax(),
                    buildRowEmail(),
                    buildRowReportsTo(onChangeDropdownItemForReportsTo),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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

  Widget buildRowLastName() {
    return TextFormField(
      controller: txtLastName,
      decoration: InputDecoration(labelText: 'LastName'),
    );
  }

  Widget buildRowFirstName() {
    return TextFormField(
      controller: txtFirstName,
      decoration: InputDecoration(labelText: 'FirstName'),
    );
  }

  Widget buildRowTitle() {
    return TextFormField(
      controller: txtTitle,
      decoration: InputDecoration(labelText: 'Title'),
    );
  }

  Widget buildRowBirthDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtBirthDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForBirthDate.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtBirthDate.text) ??
                  employee.BirthDate ??
                  DateTime.now();
              employee.BirthDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtBirthDate.text) ??
                  employee.BirthDate ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtBirthDate,
          decoration: InputDecoration(labelText: 'BirthDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForBirthDate.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtBirthDate.text) ??
                    employee.BirthDate ??
                    DateTime.now();
                employee.BirthDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtBirthDate.text = UITools.convertDate(employee.BirthDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForBirthDate.text}') ??
                    employee.BirthDate ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForBirthDate,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowHireDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtHireDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForHireDate.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtHireDate.text) ??
                  employee.HireDate ??
                  DateTime.now();
              employee.HireDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtHireDate.text) ??
                  employee.HireDate ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtHireDate,
          decoration: InputDecoration(labelText: 'HireDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForHireDate.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtHireDate.text) ??
                    employee.HireDate ??
                    DateTime.now();
                employee.HireDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtHireDate.text = UITools.convertDate(employee.HireDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForHireDate.text}') ??
                    employee.HireDate ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForHireDate,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowAddress() {
    return TextFormField(
      controller: txtAddress,
      decoration: InputDecoration(labelText: 'Address'),
    );
  }

  Widget buildRowCity() {
    return TextFormField(
      controller: txtCity,
      decoration: InputDecoration(labelText: 'City'),
    );
  }

  Widget buildRowState() {
    return TextFormField(
      controller: txtState,
      decoration: InputDecoration(labelText: 'State'),
    );
  }

  Widget buildRowCountry() {
    return TextFormField(
      controller: txtCountry,
      decoration: InputDecoration(labelText: 'Country'),
    );
  }

  Widget buildRowPostalCode() {
    return TextFormField(
      controller: txtPostalCode,
      decoration: InputDecoration(labelText: 'PostalCode'),
    );
  }

  Widget buildRowPhone() {
    return TextFormField(
      controller: txtPhone,
      decoration: InputDecoration(labelText: 'Phone'),
    );
  }

  Widget buildRowFax() {
    return TextFormField(
      controller: txtFax,
      decoration: InputDecoration(labelText: 'Fax'),
    );
  }

  Widget buildRowEmail() {
    return TextFormField(
      controller: txtEmail,
      decoration: InputDecoration(labelText: 'Email'),
    );
  }

  Widget buildRowReportsTo(
      void Function(int? selectedReportsTo) onChangeDropdownItemForReportsTo) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Employee'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedReportsTo,
                items: _dropdownMenuItemsForReportsTo,
                onChanged: onChangeDropdownItemForReportsTo,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _birthDate = DateTime.tryParse(txtBirthDate.text);
    final _birthDateTime = DateTime.tryParse(txtTimeForBirthDate.text);
    if (_birthDate != null && _birthDateTime != null) {
      _birthDate = _birthDate.add(Duration(
          hours: _birthDateTime.hour,
          minutes: _birthDateTime.minute,
          seconds: _birthDateTime.second));
    }
    var _hireDate = DateTime.tryParse(txtHireDate.text);
    final _hireDateTime = DateTime.tryParse(txtTimeForHireDate.text);
    if (_hireDate != null && _hireDateTime != null) {
      _hireDate = _hireDate.add(Duration(
          hours: _hireDateTime.hour,
          minutes: _hireDateTime.minute,
          seconds: _hireDateTime.second));
    }

    employee
      ..LastName = txtLastName.text
      ..FirstName = txtFirstName.text
      ..Title = txtTitle.text
      ..BirthDate = _birthDate
      ..HireDate = _hireDate
      ..Address = txtAddress.text
      ..City = txtCity.text
      ..State = txtState.text
      ..Country = txtCountry.text
      ..PostalCode = txtPostalCode.text
      ..Phone = txtPhone.text
      ..Fax = txtFax.text
      ..Email = txtEmail.text
      ..ReportsTo = _selectedReportsTo;
    await employee.save();
    if (employee.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(employee.saveResult.toString(),
          title: 'save Employee Failed!', callBack: () {});
    }
  }
}

class GenreAdd extends StatefulWidget {
  GenreAdd(this._genre);
  final dynamic _genre;
  @override
  State<StatefulWidget> createState() => GenreAddState(_genre as Genre);
}

class GenreAddState extends State {
  GenreAddState(this.genre);
  Genre genre;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();

  @override
  void initState() {
    txtName.text = genre.Name == null ? '' : genre.Name.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (genre.GenreId == null)
            ? Text('Add a new genre')
            : Text('Edit genre'),
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
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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
    genre..Name = txtName.text;
    await genre.save();
    if (genre.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(genre.saveResult.toString(),
          title: 'save Genre Failed!', callBack: () {});
    }
  }
}

class InvoiceAdd extends StatefulWidget {
  InvoiceAdd(this._invoice);
  final dynamic _invoice;
  @override
  State<StatefulWidget> createState() => InvoiceAddState(_invoice as Invoice);
}

class InvoiceAddState extends State {
  InvoiceAddState(this.invoice);
  Invoice invoice;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtInvoiceDate = TextEditingController();
  final TextEditingController txtTimeForInvoiceDate = TextEditingController();
  final TextEditingController txtBillingAddress = TextEditingController();
  final TextEditingController txtBillingCity = TextEditingController();
  final TextEditingController txtBillingState = TextEditingController();
  final TextEditingController txtBillingCountry = TextEditingController();
  final TextEditingController txtBillingPostalCode = TextEditingController();
  final TextEditingController txtTotal = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForCustomerId =
      <DropdownMenuItem<int>>[];
  int? _selectedCustomerId;

  @override
  void initState() {
    txtInvoiceDate.text = invoice.InvoiceDate == null
        ? ''
        : UITools.convertDate(invoice.InvoiceDate!);
    txtTimeForInvoiceDate.text = invoice.InvoiceDate == null
        ? ''
        : UITools.convertTime(invoice.InvoiceDate!);

    txtBillingAddress.text =
        invoice.BillingAddress == null ? '' : invoice.BillingAddress.toString();
    txtBillingCity.text =
        invoice.BillingCity == null ? '' : invoice.BillingCity.toString();
    txtBillingState.text =
        invoice.BillingState == null ? '' : invoice.BillingState.toString();
    txtBillingCountry.text =
        invoice.BillingCountry == null ? '' : invoice.BillingCountry.toString();
    txtBillingPostalCode.text = invoice.BillingPostalCode == null
        ? ''
        : invoice.BillingPostalCode.toString();
    txtTotal.text = invoice.Total == null ? '' : invoice.Total.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForCustomerId() async {
      final dropdownMenuItems =
          await Customer().select().toDropDownMenuInt('FirstName');
      setState(() {
        _dropdownMenuItemsForCustomerId = dropdownMenuItems;
        _selectedCustomerId = invoice.CustomerId;
      });
    }

    if (_dropdownMenuItemsForCustomerId.isEmpty) {
      buildDropDownMenuForCustomerId();
    }
    void onChangeDropdownItemForCustomerId(int? selectedCustomerId) {
      setState(() {
        _selectedCustomerId = selectedCustomerId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (invoice.InvoiceId == null)
            ? Text('Add a new invoice')
            : Text('Edit invoice'),
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
                    buildRowInvoiceDate(),
                    buildRowBillingAddress(),
                    buildRowBillingCity(),
                    buildRowBillingState(),
                    buildRowBillingCountry(),
                    buildRowBillingPostalCode(),
                    buildRowTotal(),
                    buildRowCustomerId(onChangeDropdownItemForCustomerId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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

  Widget buildRowInvoiceDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtInvoiceDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForInvoiceDate.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtInvoiceDate.text) ??
                  invoice.InvoiceDate ??
                  DateTime.now();
              invoice.InvoiceDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtInvoiceDate.text) ??
                  invoice.InvoiceDate ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtInvoiceDate,
          decoration: InputDecoration(labelText: 'InvoiceDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForInvoiceDate.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtInvoiceDate.text) ??
                    invoice.InvoiceDate ??
                    DateTime.now();
                invoice.InvoiceDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtInvoiceDate.text = UITools.convertDate(invoice.InvoiceDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForInvoiceDate.text}') ??
                    invoice.InvoiceDate ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForInvoiceDate,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Widget buildRowBillingAddress() {
    return TextFormField(
      controller: txtBillingAddress,
      decoration: InputDecoration(labelText: 'BillingAddress'),
    );
  }

  Widget buildRowBillingCity() {
    return TextFormField(
      controller: txtBillingCity,
      decoration: InputDecoration(labelText: 'BillingCity'),
    );
  }

  Widget buildRowBillingState() {
    return TextFormField(
      controller: txtBillingState,
      decoration: InputDecoration(labelText: 'BillingState'),
    );
  }

  Widget buildRowBillingCountry() {
    return TextFormField(
      controller: txtBillingCountry,
      decoration: InputDecoration(labelText: 'BillingCountry'),
    );
  }

  Widget buildRowBillingPostalCode() {
    return TextFormField(
      controller: txtBillingPostalCode,
      decoration: InputDecoration(labelText: 'BillingPostalCode'),
    );
  }

  Widget buildRowTotal() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtTotal,
      decoration: InputDecoration(labelText: 'Total'),
    );
  }

  Widget buildRowCustomerId(
      void Function(int? selectedCustomerId)
          onChangeDropdownItemForCustomerId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Customer'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedCustomerId,
                items: _dropdownMenuItemsForCustomerId,
                onChanged: onChangeDropdownItemForCustomerId,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _invoiceDate = DateTime.tryParse(txtInvoiceDate.text);
    final _invoiceDateTime = DateTime.tryParse(txtTimeForInvoiceDate.text);
    if (_invoiceDate != null && _invoiceDateTime != null) {
      _invoiceDate = _invoiceDate.add(Duration(
          hours: _invoiceDateTime.hour,
          minutes: _invoiceDateTime.minute,
          seconds: _invoiceDateTime.second));
    }

    invoice
      ..InvoiceDate = _invoiceDate
      ..BillingAddress = txtBillingAddress.text
      ..BillingCity = txtBillingCity.text
      ..BillingState = txtBillingState.text
      ..BillingCountry = txtBillingCountry.text
      ..BillingPostalCode = txtBillingPostalCode.text
      ..Total = double.tryParse(txtTotal.text)
      ..CustomerId = _selectedCustomerId;
    await invoice.save();
    if (invoice.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(invoice.saveResult.toString(),
          title: 'save Invoice Failed!', callBack: () {});
    }
  }
}

class InvoiceLineAdd extends StatefulWidget {
  InvoiceLineAdd(this._invoiceline);
  final dynamic _invoiceline;
  @override
  State<StatefulWidget> createState() =>
      InvoiceLineAddState(_invoiceline as InvoiceLine);
}

class InvoiceLineAddState extends State {
  InvoiceLineAddState(this.invoiceline);
  InvoiceLine invoiceline;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtUnitPrice = TextEditingController();
  final TextEditingController txtQuantity = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForTrackId =
      <DropdownMenuItem<int>>[];
  int? _selectedTrackId;

  List<DropdownMenuItem<int>> _dropdownMenuItemsForInvoiceId =
      <DropdownMenuItem<int>>[];
  int? _selectedInvoiceId;

  @override
  void initState() {
    txtUnitPrice.text =
        invoiceline.UnitPrice == null ? '' : invoiceline.UnitPrice.toString();
    txtQuantity.text =
        invoiceline.Quantity == null ? '' : invoiceline.Quantity.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForTrackId() async {
      final dropdownMenuItems =
          await Track().select().toDropDownMenuInt('Name');
      setState(() {
        _dropdownMenuItemsForTrackId = dropdownMenuItems;
        _selectedTrackId = invoiceline.TrackId;
      });
    }

    if (_dropdownMenuItemsForTrackId.isEmpty) {
      buildDropDownMenuForTrackId();
    }
    void onChangeDropdownItemForTrackId(int? selectedTrackId) {
      setState(() {
        _selectedTrackId = selectedTrackId;
      });
    }

    void buildDropDownMenuForInvoiceId() async {
      final dropdownMenuItems =
          await Invoice().select().toDropDownMenuInt('BillingAddress');
      setState(() {
        _dropdownMenuItemsForInvoiceId = dropdownMenuItems;
        _selectedInvoiceId = invoiceline.InvoiceId;
      });
    }

    if (_dropdownMenuItemsForInvoiceId.isEmpty) {
      buildDropDownMenuForInvoiceId();
    }
    void onChangeDropdownItemForInvoiceId(int? selectedInvoiceId) {
      setState(() {
        _selectedInvoiceId = selectedInvoiceId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (invoiceline.InvoiceLineId == null)
            ? Text('Add a new invoiceline')
            : Text('Edit invoiceline'),
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
                    buildRowUnitPrice(),
                    buildRowQuantity(),
                    buildRowTrackId(onChangeDropdownItemForTrackId),
                    buildRowInvoiceId(onChangeDropdownItemForInvoiceId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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

  Widget buildRowUnitPrice() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtUnitPrice,
      decoration: InputDecoration(labelText: 'UnitPrice'),
    );
  }

  Widget buildRowQuantity() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtQuantity,
      decoration: InputDecoration(labelText: 'Quantity'),
    );
  }

  Widget buildRowTrackId(
      void Function(int? selectedTrackId) onChangeDropdownItemForTrackId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Track'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedTrackId,
                items: _dropdownMenuItemsForTrackId,
                onChanged: onChangeDropdownItemForTrackId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowInvoiceId(
      void Function(int? selectedInvoiceId) onChangeDropdownItemForInvoiceId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Invoice'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedInvoiceId,
                items: _dropdownMenuItemsForInvoiceId,
                onChanged: onChangeDropdownItemForInvoiceId,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    invoiceline
      ..UnitPrice = double.tryParse(txtUnitPrice.text)
      ..Quantity = int.tryParse(txtQuantity.text)
      ..TrackId = _selectedTrackId
      ..InvoiceId = _selectedInvoiceId;
    await invoiceline.save();
    if (invoiceline.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(invoiceline.saveResult.toString(),
          title: 'save InvoiceLine Failed!', callBack: () {});
    }
  }
}

class MediaTypeAdd extends StatefulWidget {
  MediaTypeAdd(this._mediatype);
  final dynamic _mediatype;
  @override
  State<StatefulWidget> createState() =>
      MediaTypeAddState(_mediatype as MediaType);
}

class MediaTypeAddState extends State {
  MediaTypeAddState(this.mediatype);
  MediaType mediatype;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();

  @override
  void initState() {
    txtName.text = mediatype.Name == null ? '' : mediatype.Name.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (mediatype.MediaTypeId == null)
            ? Text('Add a new mediatype')
            : Text('Edit mediatype'),
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
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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
    mediatype..Name = txtName.text;
    await mediatype.save();
    if (mediatype.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(mediatype.saveResult.toString(),
          title: 'save MediaType Failed!', callBack: () {});
    }
  }
}

class PlaylistAdd extends StatefulWidget {
  PlaylistAdd(this._playlist);
  final dynamic _playlist;
  @override
  State<StatefulWidget> createState() =>
      PlaylistAddState(_playlist as Playlist);
}

class PlaylistAddState extends State {
  PlaylistAddState(this.playlist);
  Playlist playlist;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();

  @override
  void initState() {
    txtName.text = playlist.Name == null ? '' : playlist.Name.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (playlist.PlaylistId == null)
            ? Text('Add a new playlist')
            : Text('Edit playlist'),
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
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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
    playlist..Name = txtName.text;
    await playlist.save();
    if (playlist.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(playlist.saveResult.toString(),
          title: 'save Playlist Failed!', callBack: () {});
    }
  }
}

class TrackAdd extends StatefulWidget {
  TrackAdd(this._track);
  final dynamic _track;
  @override
  State<StatefulWidget> createState() => TrackAddState(_track as Track);
}

class TrackAddState extends State {
  TrackAddState(this.track);
  Track track;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtComposer = TextEditingController();
  final TextEditingController txtMilliseconds = TextEditingController();
  final TextEditingController txtBytes = TextEditingController();
  final TextEditingController txtUnitPrice = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForMediaTypeId =
      <DropdownMenuItem<int>>[];
  int? _selectedMediaTypeId;

  List<DropdownMenuItem<int>> _dropdownMenuItemsForGenreId =
      <DropdownMenuItem<int>>[];
  int? _selectedGenreId;

  List<DropdownMenuItem<int>> _dropdownMenuItemsForAlbumId =
      <DropdownMenuItem<int>>[];
  int? _selectedAlbumId;

  @override
  void initState() {
    txtName.text = track.Name == null ? '' : track.Name.toString();
    txtComposer.text = track.Composer == null ? '' : track.Composer.toString();
    txtMilliseconds.text =
        track.Milliseconds == null ? '' : track.Milliseconds.toString();
    txtBytes.text = track.Bytes == null ? '' : track.Bytes.toString();
    txtUnitPrice.text =
        track.UnitPrice == null ? '' : track.UnitPrice.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForMediaTypeId() async {
      final dropdownMenuItems =
          await MediaType().select().toDropDownMenuInt('Name');
      setState(() {
        _dropdownMenuItemsForMediaTypeId = dropdownMenuItems;
        _selectedMediaTypeId = track.MediaTypeId;
      });
    }

    if (_dropdownMenuItemsForMediaTypeId.isEmpty) {
      buildDropDownMenuForMediaTypeId();
    }
    void onChangeDropdownItemForMediaTypeId(int? selectedMediaTypeId) {
      setState(() {
        _selectedMediaTypeId = selectedMediaTypeId;
      });
    }

    void buildDropDownMenuForGenreId() async {
      final dropdownMenuItems =
          await Genre().select().toDropDownMenuInt('Name');
      setState(() {
        _dropdownMenuItemsForGenreId = dropdownMenuItems;
        _selectedGenreId = track.GenreId;
      });
    }

    if (_dropdownMenuItemsForGenreId.isEmpty) {
      buildDropDownMenuForGenreId();
    }
    void onChangeDropdownItemForGenreId(int? selectedGenreId) {
      setState(() {
        _selectedGenreId = selectedGenreId;
      });
    }

    void buildDropDownMenuForAlbumId() async {
      final dropdownMenuItems =
          await Album().select().toDropDownMenuInt('Title');
      setState(() {
        _dropdownMenuItemsForAlbumId = dropdownMenuItems;
        _selectedAlbumId = track.AlbumId;
      });
    }

    if (_dropdownMenuItemsForAlbumId.isEmpty) {
      buildDropDownMenuForAlbumId();
    }
    void onChangeDropdownItemForAlbumId(int? selectedAlbumId) {
      setState(() {
        _selectedAlbumId = selectedAlbumId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (track.TrackId == null)
            ? Text('Add a new track')
            : Text('Edit track'),
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
                    buildRowComposer(),
                    buildRowMilliseconds(),
                    buildRowBytes(),
                    buildRowUnitPrice(),
                    buildRowMediaTypeId(onChangeDropdownItemForMediaTypeId),
                    buildRowGenreId(onChangeDropdownItemForGenreId),
                    buildRowAlbumId(onChangeDropdownItemForAlbumId),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
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
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name'),
    );
  }

  Widget buildRowComposer() {
    return TextFormField(
      controller: txtComposer,
      decoration: InputDecoration(labelText: 'Composer'),
    );
  }

  Widget buildRowMilliseconds() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtMilliseconds,
      decoration: InputDecoration(labelText: 'Milliseconds'),
    );
  }

  Widget buildRowBytes() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtBytes,
      decoration: InputDecoration(labelText: 'Bytes'),
    );
  }

  Widget buildRowUnitPrice() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtUnitPrice,
      decoration: InputDecoration(labelText: 'UnitPrice'),
    );
  }

  Widget buildRowMediaTypeId(
      void Function(int? selectedMediaTypeId)
          onChangeDropdownItemForMediaTypeId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('MediaType'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedMediaTypeId,
                items: _dropdownMenuItemsForMediaTypeId,
                onChanged: onChangeDropdownItemForMediaTypeId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowGenreId(
      void Function(int? selectedGenreId) onChangeDropdownItemForGenreId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Genre'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedGenreId,
                items: _dropdownMenuItemsForGenreId,
                onChanged: onChangeDropdownItemForGenreId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowAlbumId(
      void Function(int? selectedAlbumId) onChangeDropdownItemForAlbumId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Album'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedAlbumId,
                items: _dropdownMenuItemsForAlbumId,
                onChanged: onChangeDropdownItemForAlbumId,
                validator: (value) {
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
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    track
      ..Name = txtName.text
      ..Composer = txtComposer.text
      ..Milliseconds = int.tryParse(txtMilliseconds.text)
      ..Bytes = int.tryParse(txtBytes.text)
      ..UnitPrice = double.tryParse(txtUnitPrice.text)
      ..MediaTypeId = _selectedMediaTypeId
      ..GenreId = _selectedGenreId
      ..AlbumId = _selectedAlbumId;
    await track.save();
    if (track.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(track.saveResult.toString(),
          title: 'save Track Failed!', callBack: () {});
    }
  }
}
