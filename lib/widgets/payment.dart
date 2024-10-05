import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: payWithKhaltiInApp,
            child: const Text('Pay with Khalti'),
          ),
          ElevatedButton(
            onPressed: payWithEsewaInApp,
            child: const Text('Pay with Esewa'),
          ),
        ],
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onKhaltiSuccess,
      onFailure: onKhaltiFailure,
      onCancel: onKhaltiCancelled,
    );
  }

  void onKhaltiSuccess(PaymentSuccessModel success) {
    showSnackBar(context, 'Payment Successful');
  }

  void onKhaltiFailure(PaymentFailureModel failure) {
    showSnackBar(context, 'Payment Failed');
  }

  void onKhaltiCancelled() {
    showSnackBar(context, 'Payment Cancelled');
  }

  payWithEsewaInApp() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: "20",
          callbackUrl: '',
        ),
        onPaymentSuccess: onEsewaPaymentSuccess,
        onPaymentFailure: onEsewaPaymentFailure,
        onPaymentCancellation: onEsewaPaymentCancelled,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  onEsewaPaymentSuccess(EsewaPaymentSuccessResult data) {
    showSnackBar(context, 'Payment Successfull');
    verifyEsewaPayment(data);
  }

  onEsewaPaymentFailure(data) {
    showSnackBar(context, 'Payment Failed');
  }

  onEsewaPaymentCancelled(data) {
    showSnackBar(context, 'Payment Cancelled');
  }

  verifyEsewaPayment(EsewaPaymentSuccessResult result) {}
}
