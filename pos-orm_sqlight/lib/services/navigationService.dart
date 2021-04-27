import 'package:flutter/material.dart';
// import '../localization/trans.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, Map<String, dynamic> args) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (_) => false, arguments: args);
  }

  Future<dynamic> navigateToNamed(String routeName, Map<String, dynamic> args) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  // String translateWithNoContext(String key) {
  //   return trans(navigatorKey.currentState.context, "your_location");
  // }
}
