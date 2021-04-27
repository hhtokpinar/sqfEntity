///****************************   LICENSE   *****************************
/// Copyright (C) 2019, HUSEYIN TOKPUNAR http://huseyintokpinar.com/
/// Download & Update Latest Version: https://github.com/hhtokpinar/sqfEntity
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at

///    http://www.apache.org/licenses/LICENSE-2.0

/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///**********************************************************************/

part of 'sqfentity_gen.dart';

class SqfEntityFormConverter {
  SqfEntityFormConverter(this.table);
  final SqfEntityTableBase table;
  String toFormWidgetsCode() {
    // print('toFormWidgetsCode begin');
    final String tablename = table.tableName!.toLowerCase();
    final String modelName = table.modelName ?? toCamelCase(table.tableName);

    // print('toFormWidgetsCode begin 2: tableName:$tablename');
    if (table.primaryKeyNames.isEmpty) {
      throw Exception(
          '    SQFENTITIY: FORM GENERATOR ERROR:  Table [$tablename] has no primary key. Remove this table from formTables list in your DB Model or add a primary key into the table');
    }
    return '''   
class ${modelName}Add extends StatefulWidget {
  ${modelName}Add(this._$tablename);
  final dynamic _$tablename;
  @override
  State<StatefulWidget> createState() => ${modelName}AddState(_$tablename as $modelName);
}

class ${modelName}AddState extends State {
  ${modelName}AddState(this.$tablename);
  $modelName $tablename;
  final _formKey = GlobalKey<FormState>();
  ${toFormDeclarationCodeTable(table).toString()}

  @override
  void initState() {
    ${toFormInitStateCodeTable(table).toString()}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ${toFormBuildDropDownCodeTable(table).toString()}

    return Scaffold(
      appBar: AppBar(
        title: ($tablename.${table.primaryKeyNames[0]} == null)
            ? Text('Add a new $tablename')
            : Text('Edit $tablename'),
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
                    ${toFormBuildRowWidgets(table).toString()}
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

  ${toFormBuildRowCodeTable(table).toString()}

  
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
    ${toFormSaveCodeDateTimeVariables(table).toString()}
    $tablename
      ${toFormSaveCode(table).toString()};
    await $tablename.${table.relationType == RelationType.ONE_TO_ONE ? '_' : ''}save();
    if ($tablename.saveResult!.success) {
      Navigator.pop(context, true);
    } else
    {
      UITools(context).alertDialog($tablename.saveResult.toString(),
                  title: 'save ${table.modelName} Failed!', callBack: () {
              });
    }
  }
}
''';
  }

  String toFormBuildRowWidgets(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 6: tableName:${table.tableName}');
    final retVal = StringBuffer();
    if (table.primaryKeyName!.isNotEmpty &&
        table.primaryKeyType != PrimaryKeyType.integer_auto_incremental) {
      retVal.writeln('buildRow${toCamelCase(table.primaryKeyName)}(),');
    }
    for (final field in table.fields!.where((f) => f.sequencedBy == null)) {
      final ccName = toCamelCase(field.fieldName);
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.ONE_TO_MANY) {
        retVal.writeln('buildRow$ccName(onChangeDropdownItemFor$ccName),');
      } else if (field is! SqfEntityFieldRelationshipBase &&
          field is! SqfEntityFieldVirtualBase) {
        retVal.writeln('buildRow$ccName(),');
      }
    }
    return retVal.toString();
  }

  String toFormSaveCodeDateTimeVariables(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 8: tableName:${table.tableName}');
    final retVal = StringBuffer();
    for (final field in table.fields!.where((f) =>
        f.dbType == DbType.date ||
        f.dbType == DbType.datetime ||
        f.dbType == DbType.datetimeUtc)) {
      final ccName = toCamelCase(field.fieldName);
      final vName = tocamelCase(field.fieldName);
      if (field.dbType == DbType.datetime) {
        retVal.write('var _');
      } else {
        retVal.write('final _');
      }
      retVal.writeln('$vName = DateTime.tryParse(txt$ccName.text);');
      if (field.dbType == DbType.datetime) {
        retVal.writeln(
            '''final _${vName}Time = DateTime.tryParse(txtTimeFor$ccName.text);
    if (_$vName != null && _${vName}Time != null) {
      _$vName = _$vName.add(
          Duration(hours: _${vName}Time.hour, minutes: _${vName}Time.minute, seconds: _${vName}Time.second));
    }''');
      }
    }
    return retVal.toString();
  }

  String toFormSaveCode(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 9: tableName:${table.tableName}');
    final retVal = StringBuffer();
    if (table.primaryKeyName!.isNotEmpty &&
        table.primaryKeyType != PrimaryKeyType.integer_auto_incremental) {
      retVal.writeln(toFieldSaveCode(SqfEntityFieldBase(
          table.primaryKeyName,
          table.primaryKeyType == PrimaryKeyType.text
              ? DbType.text
              : DbType.integer,
          isPrimaryKeyField: true)));
    }
    for (final field in table.fields!.where((f) => f.dbType != DbType.bool)) {
      retVal.writeln(toFieldSaveCode(field));
    }
    return retVal.toString();
  }

  String toFieldSaveCode(SqfEntityFieldType field) {
    final ccName = toCamelCase(field.fieldName);
    if (field is SqfEntityFieldRelationshipBase &&
        field.relationType == RelationType.ONE_TO_MANY) {
      return '..${field.fieldName} = _selected$ccName';
    } else if (field is! SqfEntityFieldRelationshipBase) {
      switch (field.dbType) {
        case DbType.time:
          return '''..${field.fieldName} = txt$ccName.text.isNotEmpty && txt$ccName.text.split(\':\').length> 1 ? TimeOfDay(
          hour: int.parse(txt$ccName.text.split(\':\')[0]),
          minute: int.parse(txt$ccName.text.split(\':\')[1])): null''';
        case DbType.date:
        case DbType.datetime:
        case DbType.datetimeUtc:
          return '..${field.fieldName} = _${tocamelCase(field.fieldName)}';
        case DbType.integer:
        case DbType.numeric:
          return '..${field.fieldName} = int.tryParse(txt$ccName.text)';
        case DbType.real:
          return '..${field.fieldName} = double.tryParse(txt$ccName.text)';
        case DbType.blob:
          return '..${field.fieldName} = txt$ccName.text  as Uint8List';
        default:
          return '..${field.fieldName} = txt$ccName.text';
      }
    }
    return '';
  }

  String toFormBuildRowCodeTable(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 7: tableName:${table.tableName}');
    final retVal = StringBuffer();
    if (table.primaryKeyName!.isNotEmpty &&
        table.primaryKeyType != PrimaryKeyType.integer_auto_incremental) {
      retVal.writeln(toFormBuildRowCodeField(SqfEntityFieldBase(
          table.primaryKeyName,
          table.primaryKeyType == PrimaryKeyType.text
              ? DbType.text
              : DbType.integer,
          isPrimaryKeyField: true)));
    }
    for (final field in table.fields!) {
      if (field is! SqfEntityFieldRelationshipBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.ONE_TO_MANY)) {
        retVal.writeln(toFormBuildRowCodeField(field));
      }
    }
    return retVal.toString();
  }

  String toFormDeclarationCodeTable(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 3: tableName:${table.tableName}');
    final retVal = StringBuffer();
    if (table.primaryKeyNames.isNotEmpty &&
        table.primaryKeyType != PrimaryKeyType.integer_auto_incremental) {
      retVal.writeln(toFormDeclarationCodeField(SqfEntityFieldBase(
          table.primaryKeyName,
          table.primaryKeyType == PrimaryKeyType.text
              ? DbType.text
              : DbType.integer,
          isPrimaryKeyField: true)));
    }
    for (final field in table.fields!) {
      if (field is! SqfEntityFieldRelationshipBase ||
          (field is SqfEntityFieldRelationshipBase &&
              field.relationType == RelationType.ONE_TO_MANY)) {
        retVal.writeln(toFormDeclarationCodeField(field));
      }
    }
    return retVal.toString();
  }

  String toFormInitStateCodeTable(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 4: tableName:${table.tableName}');
    final retVal = StringBuffer();
    for (final field in table.fields!) {
      if (field is SqfEntityFieldRelationshipBase) {
      } else {
        retVal.writeln(toFormInitStateCodeField(field));
      }
    }
    return retVal.toString();
  }

  String toFormDeclarationCodeField(SqfEntityFieldType field) {
    final String ccName = toCamelCase(field.fieldName);
    if (field is SqfEntityFieldRelationshipBase) {
      return '''List<DropdownMenuItem<${field.table!.primaryKeyTypes[0]}>> _dropdownMenuItemsFor$ccName =
      <DropdownMenuItem<${field.table!.primaryKeyTypes[0]}>>[];
  ${field.table!.primaryKeyTypes[0]}? _selected$ccName;
        ''';
    } else {
      switch (field.dbType) {
        case DbType.bool:
          return '';
        case DbType.date:
          return 'final TextEditingController txt$ccName = TextEditingController();';
        case DbType.datetime:
        case DbType.datetimeUtc:
          return 'final TextEditingController txt$ccName = TextEditingController(); final TextEditingController txtTimeFor$ccName = TextEditingController();';
        default:
          return 'final TextEditingController txt$ccName = TextEditingController();';
      }
    }
  }

  String toFormInitStateCodeField(SqfEntityFieldType field) {
    final String objName = field.table!.tableName!.toLowerCase();
    final String fName = field.fieldName!;
    final String ccName = toCamelCase(fName);
    switch (field.dbType) {
      // case DbType.real:
      // case DbType.blob:
      // case DbType.integer:
      // case DbType.numeric:
      //   return 'txt$ccName.text =$objName.$fName == null ? \'\' : $objName.$fName.toString();';
      case DbType.bool:
        return '';
      case DbType.date:
        return 'txt$ccName.text = $objName.$fName == null? \'\': UITools.convertDate($objName.$fName!);';
      case DbType.datetime:
      case DbType.datetimeUtc:
        return '''txt$ccName.text = $objName.$fName == null? \'\': UITools.convertDate($objName.$fName!);
        txtTimeFor$ccName.text = $objName.$fName == null? \'\': UITools.convertTime($objName.$fName!);
        ''';
      default:
        return 'txt$ccName.text =$objName.$fName == null ? \'\' : $objName.$fName.toString();';
      //return 'txt$ccName.text = $objName.$fName ?? \'\';';
    }
  }

  String toFormBuildDropDownCodeTable(SqfEntityTableBase table) {
    // print('toFormWidgetsCode begin 5: tableName:${table.tableName}');
    final retVal = StringBuffer();
    for (final field in table.fields!) {
      if (field is SqfEntityFieldRelationshipBase &&
          field.relationType == RelationType.ONE_TO_MANY) {
        field.relationshipName = field.relationshipName ?? table.modelName;
        retVal.writeln(toFormBuildDropDownCodeField(field));
      }
    }
    return retVal.toString();
  }

  String toFormBuildDropDownCodeField(SqfEntityFieldRelationshipBase field) {
    final ccName = toCamelCase(field.fieldName);
    return '''void buildDropDownMenuFor$ccName() async {
      final dropdownMenuItems =
          await ${field.relationshipName}().select().toDropDownMenuInt('${field.formDropDownTextField}');
      setState(() {
        _dropdownMenuItemsFor$ccName = dropdownMenuItems;
        _selected$ccName = ${table.tableName!.toLowerCase()}.${field.fieldName};
      });
    }
    if (_dropdownMenuItemsFor$ccName.isEmpty) {
      buildDropDownMenuFor$ccName();
    }
    void onChangeDropdownItemFor$ccName(${field.table!.primaryKeyTypes[0]}? selected$ccName) {
      setState(() {
        _selected$ccName = selected$ccName;
      });
    }''';
  }

  String toFormBuildRowCodeField(SqfEntityFieldType field) {
    // print('toFormWidgetsCode begin 7.1: tableName:${table.tableName}');
    final ccName = toCamelCase(field.fieldName);
    field.table = field.table ?? table;
    final tablename = field.table!.tableName!.toLowerCase();
    final retVal = StringBuffer()..write('''Widget buildRow$ccName() {''');

    if (field is SqfEntityFieldRelationshipBase) {
      return '''Widget buildRow$ccName(void Function(${field.table!.primaryKeyTypes[0]}? selected$ccName) onChangeDropdownItemFor$ccName) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('${field.relationshipName}'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selected$ccName,
                items: _dropdownMenuItemsFor$ccName,
                onChanged: onChangeDropdownItemFor$ccName,
                validator: (value) {
                  ${field.isNotNull != null && field.isNotNull! ? '''
                  if ((_selected$ccName != null && _selected$ccName.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter ${field.relationshipName}';
                  }
                  return null;
                  ''' : 'return null;'}
                },
              ),
            )),
      ],
    );
  }''';
    }

    switch (field.dbType) {
      case DbType.integer:
      case DbType.numeric:
      case DbType.real:
        final rangeValidator = StringBuffer();
        if (field.minValue != null && field.maxValue != null) {
          rangeValidator.write(
              '''else if(${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value)! >${field.maxValue} || ${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value)! < ${field.minValue}){ 
              return 'Please Enter Between ${field.minValue} and ${field.maxValue} (required)'; }''');
        } else if (field.minValue != null) {
          rangeValidator.write(
              '''else if(${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value)! < ${field.minValue}){ 
              return 'Please Enter Minimum ${field.minValue} (required)'; }''');
        } else if (field.maxValue != null) {
          rangeValidator.write(
              '''else if(${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value)! > ${field.maxValue}){ 
              return 'Please Enter Maximum ${field.maxValue} (required)'; }''');
        }

        if ((field.isNotNull != null && field.isNotNull!)) {
          retVal.writeln('''return TextFormField(
      validator: (value) {
         if (${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value!) == null) 
            { 
              return 'Please Enter valid number (required)'; 
            }
        ${rangeValidator.toString()}
        return null;
      },''');
        } else {
          retVal.writeln('''return TextFormField(
      validator: (value) { if (value!.isNotEmpty && ${field.dbType == DbType.real ? 'double' : 'int'}.tryParse(value) == null) 
      { return 'Please Enter valid number'; }
      ${rangeValidator.toString().replaceAll('(required)', '')}
        return null;
      },''');
        }
        break;
      case DbType.bool:
        retVal.writeln('''return Row(
      children: <Widget>[
        Text('$ccName?'),
        Checkbox(
          value: $tablename.${field.fieldName} ?? false,
          onChanged: (bool? value) {
            setState(() {
              $tablename.${field.fieldName} = value;
            });
          },
        ),
        
      ],
    );
  }
''');
        return retVal.toString();
      case DbType.date:
        retVal.writeln('return TextFormField(');
        retVal.writeln(
            '''onTap: () => DatePicker.showDatePicker(context, showTitleActions: true, theme: UITools.mainDatePickerTheme
          ${_getNullableValueField(field.minValue, 'minTime')}
          ${_getNullableValueField(field.maxValue, 'maxTime')}
          , onConfirm: (sqfSelectedDate) {
        txt$ccName.text = UITools.convertDate(sqfSelectedDate);
        setState(() {
          $tablename.${field.fieldName} = sqfSelectedDate;
        });
      }, currentTime: DateTime.tryParse(txt$ccName.text) ?? $tablename.${field.fieldName} ?? DateTime.now(), locale: UITools.mainDatePickerLocaleType),
      ''');
        break;
      case DbType.datetime:
      case DbType.datetimeUtc:
        retVal.writeln(
            '''return Row(children: <Widget>[Expanded(flex: 1, child: TextFormField(onTap: () => DatePicker.showDatePicker(context, showTitleActions: true, theme: UITools.mainDatePickerTheme
          ${_getNullableValueField(field.minValue, 'minTime')}
          ${_getNullableValueField(field.maxValue, 'maxTime')}
          , onConfirm: (sqfSelectedDate) {
        txt$ccName.text = UITools.convertDate(sqfSelectedDate);
        txtTimeFor$ccName.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
                final d = DateTime.tryParse(txt$ccName.text) ?? $tablename.${field.fieldName} ?? DateTime.now();
                $tablename.${field.fieldName} = DateTime(sqfSelectedDate.year, sqfSelectedDate.month, sqfSelectedDate.day).add(Duration(hours: d.hour,minutes: d.minute,seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txt$ccName.text) ?? $tablename.${field.fieldName} ?? DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          ${field.isNotNull != null && field.isNotNull! ? 'validator: (value) { if (value == null || value.isEmpty) { return \'Please enter $ccName\'; } return null;},' : ''}
          controller: txt$ccName,
          decoration: InputDecoration(labelText: '$ccName'),
        ),
      ),
      Expanded(flex: 1,child: TextFormField(onTap: () => DatePicker.showTimePicker(context,showTitleActions: true,theme: UITools.mainDatePickerTheme, 
      onConfirm: (sqfSelectedDate) {
              txtTimeFor$ccName.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txt$ccName.text) ?? $tablename.${field.fieldName} ?? DateTime.now();
                $tablename.${field.fieldName} = DateTime(d.year, d.month, d.day).add(Duration(hours: sqfSelectedDate.hour,minutes: sqfSelectedDate.minute,seconds: sqfSelectedDate.second));
                txt$ccName.text = UITools.convertDate($tablename.${field.fieldName}!);
              });
            },
                currentTime: DateTime.tryParse('\${UITools.convertDate(DateTime.now())} \${txtTimeFor$ccName.text}') ?? $tablename.${field.fieldName} ?? DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeFor$ccName,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
}''');
        return retVal.toString();
      default:
        if ((field.isNotNull != null && field.isNotNull!)) {
          retVal.writeln('''return TextFormField(
     validator: (value) { if (value == null || value.isEmpty)
     { return 'Please enter $ccName'; }
        return null;
     },''');
        } else {
          retVal.writeln('return TextFormField(');
        }
    }

    retVal.writeln('''      controller: txt$ccName,
      decoration: InputDecoration(labelText: '$ccName'),
    );
  }''');
    return retVal.toString();
  }
}

String getformListTitleField(SqfEntityTableBase table) {
  String fieldName = '';
  if (table.formListTitleField != null) {
    fieldName = table.formListTitleField!;
  } else {
    for (final field in table.fields!) {
      if (field is! SqfEntityFieldVirtualBase) {
        if (field.dbType == DbType.text) {
          fieldName = field.fieldName!;
          break;
        }
      }
    }
    if (fieldName.isEmpty) {
      fieldName = table.primaryKeyNames[0];
    }
  }
  return fieldName;
}

String getformListSubTitleField(SqfEntityTableBase table) {
  String fieldName = '';
  table.formListTitleField = getformListTitleField(table);
  if (table.formListSubTitleField != null) {
    fieldName = table.formListSubTitleField!;
  } else {
    for (final field in table.fields!) {
      if (field is! SqfEntityFieldVirtualBase) {
        if (field.dbType == DbType.text &&
            field.fieldName != table.formListTitleField) {
          fieldName = field.fieldName!;
          break;
        }
      }
    }
    if (fieldName.isEmpty) {
      for (final field in table.fields!.where((f) =>
          f is! SqfEntityFieldVirtualBase &&
          !(f is SqfEntityFieldRelationshipBase &&
              f.relationType == RelationType.MANY_TO_MANY))) {
        if (field.fieldName != table.formListTitleField) {
          fieldName = field.fieldName!;
          break;
        }
      }
    }
  }
  return fieldName;
}
