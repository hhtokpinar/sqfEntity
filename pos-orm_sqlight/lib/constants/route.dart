import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:points_of_sale/ui/add_collection.dart';
import 'package:points_of_sale/ui/add_item.dart';
import 'package:points_of_sale/ui/add_transaction.dart';
import 'package:points_of_sale/ui/auth/login_screen.dart';
import 'package:points_of_sale/ui/auth/registration_screen.dart';
import 'package:points_of_sale/ui/home.dart';

// Generate all application routes with simple transition
Route<PageController> onGenerateRoute(RouteSettings settings) {
  Route<PageController> page;

  final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case "/Home":
      page = PageTransition<PageController>(
          child: Home(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/login":
      page = PageTransition<PageController>(
          child: LoginScreen(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AddItem":
      page = PageTransition<PageController>(
          child: AddItem(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/Registration":
      page = PageTransition<PageController>(
          child: Registration(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AddTransaction":
      page = PageTransition<PageController>(
          child: AddTransaction(),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AddCollection":
      page = PageTransition<PageController>(
          child: AddCollection(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AddCustomer":
      page = PageTransition<PageController>(
          child: AddCollection(), type: PageTransitionType.rightToLeftWithFade);
      break;
    // case "/Account":
    //   page = PageTransition<PageController>(
    //       child: Account(), type: PageTransitionType.rightToLeftWithFade);
    //   break;

  }

  return page;
}
