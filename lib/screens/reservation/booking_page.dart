import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/reservation/add_reservation.dart';
import 'package:ev_charge/services/user/payment_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  static const String routeName = '/booking-page';
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController chargingStationController =
      TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  // final TextEditingController arrivalTimeController = TextEditingController();
  // final TextEditingController chargingDurationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ReservationService reservationService = ReservationService();
  final PaymentService paymentService = PaymentService();

  late double chargingDurationInHours;

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Format time as hh:mm and set it in the controller
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      controller.text = formattedTime;
    }
  }

  // Function to validate times
  bool validateTime() {
    if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
      showSnackBar(context, 'Please select both start and end times');
      return false;
    }

    // Parse the selected start and end times as TimeOfDay
    TimeOfDay startTime = TimeOfDay(
      hour: int.parse(startTimeController.text.split(":")[0]),
      minute: int.parse(startTimeController.text.split(":")[1]),
    );
    TimeOfDay endTime = TimeOfDay(
      hour: int.parse(endTimeController.text.split(":")[0]),
      minute: int.parse(endTimeController.text.split(":")[1]),
    );

    // Convert TimeOfDay to DateTime for comparison
    final now = DateTime.now();
    final DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Check if start time is in the past
    if (startDateTime.isBefore(now)) {
      showSnackBar(context, 'Starting time must be in the future');
      return false;
    }

    if (endDateTime.isBefore(startDateTime)) {
      showSnackBar(context, 'Please enter a valid time');
      return false;
    }

    final Duration duration = endDateTime.difference(startDateTime);
    chargingDurationInHours = duration.inMinutes / 60.0;
    print('*****************************************');
    print(chargingDurationInHours);

    return true;
  }

  void addReservation() {
    reservationService.bookStation(
      context: context,
      stationId: '671ba28ae9e964cd9b37a1c3',
      startingTime: startTimeController.text,
      endingTime: endTimeController.text,
      paymentAmount: '500',
      remarks: 'remarks',
    );
  }

  void makePayment() {
    paymentService.makePayment(
      context: context,
      duration: chargingDurationInHours,
    );
  }

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
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _selectTime(context, startTimeController),
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      labelText: 'Starting Time',
                      obscureText: false,
                      controller: startTimeController,
                      icon: Icons.watch,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _selectTime(context, endTimeController),
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      labelText: 'Ending Time',
                      obscureText: false,
                      controller: endTimeController,
                      icon: Icons.watch,
                    ),
                  ),
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
                    if (validateTime()) {
                      makePayment();
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
