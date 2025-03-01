import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/reservation/reservation_service.dart';
import 'package:ev_charge/services/user/payment_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class StationBookingPage extends StatefulWidget {
  static const String routeName = '/booking-page';
  final String name, address, id;
  const StationBookingPage(
      {super.key, required this.name, required this.address, required this.id});

  @override
  State<StationBookingPage> createState() => _StationBookingPageState();
}

class _StationBookingPageState extends State<StationBookingPage> {
  final TextEditingController chargingStationController =
      TextEditingController();
  final TextEditingController chargingStationLocationController =
      TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ReservationService reservationService = ReservationService();
  final PaymentService paymentService = PaymentService();

  late DateTime startDateTime, endDateTime;

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
    startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    endDateTime =
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

    return true;
  }

  void updateReservation() {
    reservationService.updateReservation(
      context: context,
      startingTime: startDateTime,
      endingTime: endDateTime,
      paymentAmount: int.parse(paymentAmountController.text),
      remarks: remarksController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    chargingStationController.dispose();
    chargingStationLocationController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    paymentAmountController.dispose();
    remarksController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chargingStationController.text = widget.name;
    chargingStationLocationController.text = widget.address;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 240, 242, 246),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  CustomTextfield(
                    labelText: 'Charging Station',
                    obscureText: false,
                    controller: chargingStationController,
                    icon: Icons.business,
                    readOnly: true,
                  ),
                  CustomTextfield(
                    labelText: 'Charging Station Location',
                    obscureText: false,
                    controller: chargingStationLocationController,
                    icon: Icons.location_on,
                    readOnly: true,
                  ),
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
                  CustomTextfield(
                    labelText: 'Payment Amount',
                    obscureText: false,
                    controller: paymentAmountController,
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                    readOnly: false,
                  ),
                  CustomTextfield(
                    labelText: 'Remarks',
                    obscureText: false,
                    controller: remarksController,
                    icon: Icons.note,
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
                        if (validateTime()) {
                          // makePayment();
                          updateReservation();
                        }
                      }
                    },
                    style: elevatedButtonStyle,
                    child: const Text(
                      'Book Station',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
