import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'main-page';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Station Home Screen'),
      ),
    );
    //use map page here
  }
}
