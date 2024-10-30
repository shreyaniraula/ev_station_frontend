import 'package:ev_charge/screens/reservation/booking_page.dart';
import 'package:ev_charge/screens/user/home_screen.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentService {
  String generateUniqueProductIdentity() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Timestamp as unique ID
  }

  void makePayment({
    required BuildContext context,
    required double duration,
  }) {
    String productIdentity = generateUniqueProductIdentity();
    int amount = (duration * 250 * 100).toInt(); // Convert to paisa

    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: amount,
        productIdentity: productIdentity,
        productName: 'EV Charging for $duration hour(s)',
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (successModel) {
        showSnackBar(context, 'Payment Successful!');
        Navigator.of(context).pushNamed(HomeScreen.routeName);
      },
      onFailure: (failureModel) {
        showSnackBar(context, 'Payment Failed. Try again.');
        Navigator.of(context).pushNamed(BookingPage.routeName);
      },
      onCancel: () {
        showSnackBar(context, 'Payment Cancelled');
        Navigator.of(context).pushNamed(BookingPage.routeName);
      },
    );
  }
}
