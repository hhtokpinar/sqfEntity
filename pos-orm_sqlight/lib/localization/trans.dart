import 'package:flutter/material.dart';
import 'application_localizations.dart';

// simple load translation value.
// input: BuildContext context
// input: String key
// return: a translated string, otherwise return key
String trans(BuildContext context, String key) {
  return ApplicationLocalizations.of(context).translate(key);
}
