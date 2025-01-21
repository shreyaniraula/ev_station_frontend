import 'dart:convert';

import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  Future<void> bookStation({
    required BuildContext context,
    required String stationId,
    required String startingTime,
    required String endingTime,
    required String paymentAmount,
    required String remarks,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      final res = await http.post(
        Uri.parse('$uri/api/v1/reserve/reserve-station/$stationId'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token!,
        },
        body: jsonEncode({
          'paymentAmount': paymentAmount,
          'startingTime': startingTime,
          'endingTime': endingTime,
          'remarks': remarks,
        }),
      );

      if (context.mounted) {
        if (res.statusCode == 200) {
          showSnackBar(context, 'Booking successful!');
        } else {
          showSnackBar(context, 'Booking failed! Please try again.');
        }
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar(context, 'Error: $error');
      }
    }
  }

  Future<List<Reservation>> getReservations() async {
    try {
      print('#####################################');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      final res = await http.get(
        Uri.parse('$uri/api/v1/reserve/view-reservation'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token!,
        },
      );

      if (res.statusCode == 200) {
        List<Reservation> reservations = [];
        final List<dynamic> responseData = jsonDecode(res.body)['data'];
        print(responseData);

        for (var item in responseData) {
          print(item);
          reservations.add(
            Reservation(
              id: item['_id'],
              reservedBy: item['reservedBy'],
              reservedTo: item['reservedTo'],
              paymentAmount: item['paymentAmount'].toString(),
              startingTime: item['startingTime'],
              endingTime: item['endingTime'],
              remarks: item['remarks'],
            ),
          );
        }

        return reservations;
      } else {
        throw Exception('Failed to load reservations: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching reservations: $e');
    }
  }
}
