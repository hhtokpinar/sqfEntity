import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class MainProvider extends ChangeNotifier {
  bool darkthemeIson = false;
  bool loading = false;
  static TickerProvider c;
  static String loginbase = "login";
  static AnimationController _controller;
  int _currentIndex = 0;
  int favocurrentIndex = 0;
  String profileUrl = "";
  List<bool> fontlist = <bool>[false, true, false];
  List<bool> language = <bool>[false, false, false];
  bool _visible = true;
  bool __visible = false;
  bool visibilityObs = false;
  List<bool> notificationSit = <bool>[true, false];

  int get bottomNavIndex => _currentIndex;
  bool get visible1 => _visible;
  List<bool> get font => fontlist;
  List<bool> get lang => language;

  bool get visible2 => __visible;
  void changebottomNavIndex(int id) {
    _currentIndex = id;

    notifyListeners();
  }

  void changeImageUrl(String path) {
    profileUrl = path;
    notifyListeners();
  }

  void changenotificationSit(int state) {
    notificationSit = state == 0 ? <bool>[true, false] : <bool>[false, true];
    notifyListeners();
  }

  void changeTheme(bool state) {
    darkthemeIson = state;
    notifyListeners();
  }

  void changelanguageindex(int index) {
    for (int i = 0; i < language.length; i++) {
      if (i == index) {
        language[i] = true;
      } else {
        language[i] = false;
      }
    }

    notifyListeners();
  }

  void changefontindex(int index) {
    for (int i = 0; i < fontlist.length; i++) {
      if (i == index) {
        fontlist[i] = true;
      } else {
        fontlist[i] = false;
      }
    }

    notifyListeners();
  }

  void changeTabBarIndex(int id) {
    favocurrentIndex = id;
    _visible = !_visible;
    __visible = !__visible;
    notifyListeners();
  }

  final SpinKitDoubleBounce spinkit = SpinKitDoubleBounce(
      color: colors.white, size: 50.0, controller: _controller);
      
  Widget f;
  void changechild(String login) {
    loginbase = login;
    if (loading) {
      f = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      f = spinkit;
    }

    notifyListeners();
  }

  Widget returnchild(String login) {
    loginbase = login;
    if (!loading) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }
  Widget returnchildforProfile(String login) {
    loginbase = login;
    if (!loading) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          child: Text(loginbase,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              )));
    } else {
      return spinkit;
    }
  }

  void togelf(bool state) {
    loading = state;
    notifyListeners();
  }

  void togelocationloading(bool state) {
    visibilityObs = state;
    notifyListeners();
  }
}
