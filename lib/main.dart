import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ev Charging",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 253, 253),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
