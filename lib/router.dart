import 'package:ev_charge/screens/reservation/queue_screen.dart';
import 'package:ev_charge/screens/reservation/user_booking_page.dart';
import 'package:ev_charge/screens/station/home_screen.dart';
import 'package:ev_charge/screens/station/reservation_screen.dart';
import 'package:ev_charge/screens/station/updates/update_image_page.dart';
import 'package:ev_charge/screens/station/updates/update_password_page.dart';
import 'package:ev_charge/screens/station/updates/update_station_details_page.dart';
import 'package:ev_charge/screens/user/home_screen.dart';
import 'package:ev_charge/screens/common/station_details_screen.dart';
import 'package:ev_charge/screens/station/stations_page.dart';
import 'package:ev_charge/screens/user/my_reservations.dart';
import 'package:ev_charge/screens/user/updates/update_image_page.dart';
import 'package:ev_charge/screens/user/updates/update_password_page.dart';
import 'package:ev_charge/screens/user/updates/update_user_details_page.dart';
import 'package:ev_charge/screens/user/verification/login_page.dart';
import 'package:ev_charge/screens/reservation/khalti_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routesettings) {
  switch (routesettings.name) {
    case UserHomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UserHomeScreen(),
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
        builder: (_) => StationDetailsScreen(
          username: args,
        ),
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
    case UpdateUserPasswordPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateUserPasswordPage(),
      );
    case UpdateUserImagePage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateUserImagePage(),
      );
    case StationsPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const StationsPage(),
      );
    case UserBookingPage.routeName:
      final args = routesettings.arguments as UserBookingPage;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => UserBookingPage(
          name: args.name,
          id: args.id,
          address: args.address,
        ),
      );
    case StationHomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => StationHomeScreen(),
      );
    case ReservationScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => ReservationScreen(),
      );
    case UpdateStationDetailsPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => UpdateStationDetailsPage(),
      );
    case UpdateStationImagePage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateStationImagePage(),
      );
    case UpdateStationPasswordPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const UpdateStationPasswordPage(),
      );
    case MyReservations.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const MyReservations(),
      );
    case QueueScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const QueueScreen(),
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
