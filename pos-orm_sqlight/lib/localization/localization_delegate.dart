import 'package:flutter/material.dart';
import 'application_localizations.dart';

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<ApplicationLocalizations> {
  DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'tr', 'en'].contains(locale.languageCode);

  @override
  Future<ApplicationLocalizations> load(Locale locale) async {
    final ApplicationLocalizations localizations =
        ApplicationLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
