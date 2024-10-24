import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetStations {
  Future<void> getAllStations({required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/stations/get-all-stations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () => print(res.body),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Something went wrong while displaying stations');
      }
    }
  }
}
