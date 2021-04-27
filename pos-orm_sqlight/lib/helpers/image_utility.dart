import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
 
class Utility {
 
  static Image imageFromBase64String(String base64String,BuildContext context) {
    return Image.memory(
      base64Decode(base64String),
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
 
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }
 
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}