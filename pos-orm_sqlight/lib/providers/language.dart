import 'package:flutter/material.dart';
import 'package:points_of_sale/constants/config.dart';
import 'package:points_of_sale/helpers/data.dart';

class Language with ChangeNotifier {
  Locale _language;

  Locale get currentLanguage => _language;

 Future< void> setLanguage(Locale language)async  {
    _language = language;
   await data.setData('lang', language.languageCode);
    
    config.userLnag = language;
    notifyListeners();
  }
}
