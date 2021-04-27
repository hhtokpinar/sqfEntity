import 'package:flutter/cupertino.dart';

class Config {
  factory Config() {
    return _config;
  }

  Config._internal();

  static final Config _config = Config._internal();
  // default country code prefix mobile number
  String countryCode = '+970';

  final TextEditingController locationController = TextEditingController();
  bool loggedin = false;
  Locale userLnag;
  double lat = 0.0;
  double long = 0.0;

  String token = "";
  String profileUrl =
      "https://png.pngtree.com/png-clipart/20190924/original/pngtree-businessman-user-avatar-free-vector-png-image_4827807.jpg";
  String username;
  int userId;

  bool amIcomingFromHome = false;
  bool prifleNoVerfiyVisit = false;
  bool prifleNoVerfiyDone = false;
}

final Config config = Config();
