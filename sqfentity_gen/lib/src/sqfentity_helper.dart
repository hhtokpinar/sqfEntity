import 'package:source_gen/source_gen.dart';
import '../sqfentity_gen.dart';

String? getStringValueAnnotation(ConstantReader annotation, String name) =>
    ifExistAnnotation(annotation, name)
        ? annotation.read(name).stringValue
        : null;
bool getBoolValueAnnotation(ConstantReader annotation, String name) =>
    ifExistAnnotation(annotation, name)
        ? annotation.read(name).boolValue
        : false;
int? getIntValueAnnotation(ConstantReader annotation, String name) =>
    ifExistAnnotation(annotation, name) ? annotation.read(name).intValue : null;
dynamic getTypeValueAnnotation(ConstantReader annotation, String name) =>
    ifExistAnnotation(annotation, name)
        ? convertType(annotation.read(name))
        : null;
bool ifExistAnnotation(ConstantReader annotation, String name) =>
    annotation.read(name).toString().contains('_NullConstant') == false;
