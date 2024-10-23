import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/screens/khalti_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushNamed(KhaltiScreen.routeName);
                    }
                  },
                  style: elevatedButtonStyle,
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
      ),
    );
  }
}
