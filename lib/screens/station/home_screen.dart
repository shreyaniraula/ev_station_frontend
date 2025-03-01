import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/screens/reservation/queue_screen.dart';
import 'package:ev_charge/screens/reservation/station_booking_page.dart';
import 'package:ev_charge/screens/station/account_page.dart';
import 'package:ev_charge/screens/station/reservation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationHomeScreen extends StatefulWidget {
  static const String routeName = '/station-home-screen';
  const StationHomeScreen({super.key});

  @override
  State<StationHomeScreen> createState() => _StationHomeScreenState();
}

class _StationHomeScreenState extends State<StationHomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final station = Provider.of<StationProvider>(context).station;

    return Scaffold(
      appBar: AppBar(
        title: index == 0
            ? const Text('Reservations')
            : index == 1
                ? const Text('Add Reservation')
                : const Text('Account'),
        backgroundColor: Color.fromARGB(248, 203, 243, 175),
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
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: 'Add Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle),
            label: 'Account',
          ),
        ],
      ),
      body: index == 0
          ? ReservationScreen()
          : index == 1
              ? StationBookingPage(
                  name: station.name,
                  address: station.location,
                  id: station.id,
                )
              : const StationAccountPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(248, 203, 243, 175),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QueueScreen()),
          );
        },
        child: const Icon(Icons.queue),
      ),
    );
  }
}
