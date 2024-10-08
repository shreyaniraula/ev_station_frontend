import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routesettings) {
  switch (routesettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const HomeScreen(),
      );
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const LoginPage(),
      );
    default:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const Scaffold(
          body: Text('Page not found'),
        ),
      );
  }
}
