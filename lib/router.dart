import 'package:ev_charge/screens/user/home_screen.dart';
import 'package:ev_charge/screens/common/station_details_screen.dart';
import 'package:ev_charge/screens/station/stations_page.dart';
import 'package:ev_charge/screens/user/updates/update_image_page.dart';
import 'package:ev_charge/screens/user/updates/update_password_page.dart';
import 'package:ev_charge/screens/user/updates/update_user_details_page.dart';
import 'package:ev_charge/screens/user/verification/login_page.dart';
import 'package:ev_charge/screens/reservation/khalti_screen.dart';
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
    case StationDetailsScreen.routeName:
      final args = routesettings.arguments as String;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => StationDetailsScreen(username: args,),
      );
    case KhaltiScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const KhaltiScreen(),
      );
    case UpdateUserDetailsPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateUserDetailsPage(),
      );
    case UpdatePasswordPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdatePasswordPage(),
      );
    case UpdateImagePage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateImagePage(),
      );
    case StationsPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const StationsPage(),
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
