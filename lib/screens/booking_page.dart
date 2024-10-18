import 'package:ev_charge/widgets/custom_textfield.dart';
import 'package:ev_charge/widgets/khalti_screen.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController chargingStationController =
      TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final TextEditingController chargingDurationController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 240, 242, 246),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextfield(
                labelText: 'Charging Station',
                obscureText: false,
                controller: chargingStationController,
                icon: Icons.business,
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Arrival Time',
                obscureText: false,
                controller: arrivalTimeController,
                icon: Icons.watch,
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Charging Duration',
                obscureText: false,
                controller: chargingDurationController,
                icon: Icons.timelapse,
              ),
              const SizedBox(height: 20),
              const Text(
                'Note: You would not get the refund of the payment and you are supposed to reach the charging station within 30 minutes of your booking. Otherwise, your booking might get cancelled.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(KhaltiScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 17, 163, 90), // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Book with Khalti',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
