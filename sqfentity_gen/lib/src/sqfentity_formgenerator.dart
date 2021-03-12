// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import '../sqfentity_gen.dart';

//import 'package:sqfentity_base/sqfentity_base.dart';

class Imports {
  static Map<String, bool> importedModels = <String, bool>{};
  static List<String> controllers = <String>[];
}

class SqfEntityFormGenerator extends GeneratorForAnnotation<SqfEntityBuilder> {
  @override
  String? generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final model = annotation.read('model').objectValue;

    // When testing, you can uncomment the test line to make sure everything's working properly
    //return '// MODEL -> ${tablemodel.toString()}';

    var instanceName =
        'SqfEntityTable'; //        element.toString().replaceAll('SqfEntityTable', '').trim();
    instanceName = toCamelCase(instanceName);

    final builder = SqfEntityModelBuilder(model, instanceName);
    print(
        '-------------------------------------------------------FormBuilder: $instanceName');
    final dbModel = builder.toModel();

    if (dbModel.formTables!.isEmpty) {
      return null;
    }

    final modelStr = StringBuffer();
    final String path = element.source
        .toString()
        .substring(element.source.toString().lastIndexOf('/') + 1);
    if (dbModel.ignoreForFile != null && dbModel.ignoreForFile!.isNotEmpty) {
      modelStr
          .writeln('// ignore_for_file: ${dbModel.ignoreForFile!.join(', ')}');
    }
    // print('${tables[0].modelName} Model recognized succesfuly');
    modelStr.writeln('part of \'$path\';');

    // print('before for (final table in tables), tables.length=${dbModel.formTables.length}');
    //..writeln('/*') // write output as commented to see what is wrong
    for (final table in dbModel.formTables!) {
      //  print('before toFormWidgetsCode for table ${table.tableName}');
      modelStr.writeln(SqfEntityFormConverter(table).toFormWidgetsCode());
    }
    //..writeln('*/') //  write output as commented to see what is wrong

    if (Imports.importedModels[path] != null) {
      return null;
    } else {
      Imports.importedModels[path] = true;
      return modelStr.toString();
    }
  }
}
