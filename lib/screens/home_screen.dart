import 'package:ev_charge/screens/account_page.dart';
import 'package:ev_charge/screens/booking_page.dart';
import 'package:ev_charge/screens/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watt to do'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
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
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle),
            label: 'Account',
          ),
        ],
      ),
      body: index == 0
          ? const MainPage()
          : index == 1
              ? const BookingPage()
              : const AccountPage(),
    );
  }
}
