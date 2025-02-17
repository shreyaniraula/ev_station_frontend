import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/providers/user_provider.dart';
import 'package:ev_charge/router.dart';
import 'package:ev_charge/screens/station/home_screen.dart';
import 'package:ev_charge/screens/user/home_screen.dart';
import 'package:ev_charge/screens/user/verification/login_page.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/services/user/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => StationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserAuthService userAuthService = UserAuthService();
  final StationAuthService stationAuthService = StationAuthService();

  @override
  void initState() {
    super.initState();
    userAuthService.getUserData(context);
    stationAuthService.getStationData(context);
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: kKhaltiApiKey,
        builder: (context, navKey) {
          return MaterialApp(
            navigatorKey: navKey,
            localizationsDelegates: const [KhaltiLocalizations.delegate],
            title: "Ev Charging",
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 248, 253, 253),
            ),
            onGenerateRoute: (settings) => generateRoute(settings),
            debugShowCheckedModeBanner: false,
            home: Provider.of<UserProvider>(context).user.accessToken.isNotEmpty
                ? const UserHomeScreen()
                : Provider.of<StationProvider>(context).station.accessToken.isNotEmpty
                    ? const StationHomeScreen()
                    : const LoginPage(),
          );
        });
  }
}
