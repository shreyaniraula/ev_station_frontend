import 'package:ev_charge/screens/user/map_page.dart';
import 'package:ev_charge/screens/user/account_page.dart';
import 'package:ev_charge/screens/station/stations_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomeScreen extends StatefulWidget {
  static const String routeName = '/user-home-screen';
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: index == 0
            ? const Text('Nearby Stations')
            : index == 1
                ? const Text('Popular Stations')
                : const Text('Personal Account'),
                backgroundColor: const Color.fromARGB(255, 196, 231, 167),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          if (mounted) {
            setState(() {
              index = value;
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 196, 231, 167),
        selectedItemColor: const Color.fromARGB(
            169, 9, 14, 0), // Customize selected item color
        unselectedItemColor: Colors.grey, // Customize unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.battery_charging),
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle),
            label: 'Account',
          ),
        ],
      ),
      body: index == 0
          ? MapPage()
          : index == 1
              ? const StationsPage()
              : const UserAccountPage(),
    );
  }
}
