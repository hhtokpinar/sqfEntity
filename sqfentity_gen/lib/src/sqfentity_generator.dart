// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../sqfentity_gen.dart';

//import 'package:sqfentity_base/sqfentity_base.dart';

class SqfEntityGenerator extends GeneratorForAnnotation<SqfEntityBuilder> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    //final keepFieldNamesAsOriginal = getBoolValueAnnotation(annotation,'keepFieldNamesAsOriginal');
    //print('keepFieldNamesAsOriginal: $keepFieldNamesAsOriginal');

    final model = annotation.read('model').objectValue;

// When testing, you can uncomment the test line to make sure everything's working properly
    //  return '''/* MODEL -> ${model.toString()} */''';

    final instanceName = element
        .toString()
        .replaceAll('SqfEntityModel', '')
        .replaceAll('*', '')
        .trim();
    print('SQFENTITY GENERATOR STARTED... instance Of:$instanceName');
    final builder = SqfEntityModelBuilder(model, instanceName);
    print(
        'SQFENTITY GENERATOR: builder initialized (${builder.instancename})...');
    final dbModel = builder.toModel();

    print('${dbModel.modelName} Model recognized succesfuly');
    final modelStr = MyStringBuffer()
          //..writeln('/*') // write output as commented to see what is wrong
          ..writeln(SqfEntityConverter(dbModel).createModelDatabase())
          ..printToDebug(
              '${dbModel.modelName} converted to SqfEntityModelBase successfully')
          ..writeln(SqfEntityConverter(dbModel).createEntites())
          ..printToDebug(
              '${dbModel.modelName} converted to Entities successfully')
          ..writeln(SqfEntityConverter(dbModel).createControllers())
          ..printToDebug(
              '${dbModel.modelName} converted to Controller successfully')
        //..writeln('*/') //  write output as commented to see what is wrong
        ;
    return modelStr.toString();
  }
}
