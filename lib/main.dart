import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/router.dart';
import 'package:ev_charge/widgets/payment.dart';
// import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: const Payment(),
            //const LoginPage(),
          );
        });
  }
}
