import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/signup_station.dart';
import 'package:ev_charge/screens/verification/signup_user.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routesettings) {
  switch (routesettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const HomeScreen(),
      );
      
    case SignupUser.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const SignupUser(),
      );

    case SignupStation.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const SignupStation(),
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
