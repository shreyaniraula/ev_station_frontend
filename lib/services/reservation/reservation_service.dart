import 'dart:convert';
import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  Future<void> updateReservation({
    required BuildContext context,
    required DateTime startingTime,
    required DateTime endingTime,
    required String paymentAmount,
    required String remarks,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      final res = await http.post(
        Uri.parse('$uri/api/v1/reserve/update-reservation'),
        headers: {
          'Content-Type': 'application/json',
          'station-auth-token': token!,
        },
        body: jsonEncode({
          'paymentAmount': paymentAmount,
          'startingTime': startingTime.toIso8601String(),
          'endingTime': endingTime.toIso8601String(),
          'remarks': remarks,
        }),
      );

      if (context.mounted) {
        if (res.statusCode == 200) {
          showSnackBar(context, 'Booking successful!');
        } else {
          showSnackBar(context, jsonDecode(res.body)['message']);
        }
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar(context, 'Error: $error');
      }
    }
  }

  Future<void> bookStation({
    required BuildContext context,
    required String stationId,
    required DateTime startingTime,
    required DateTime endingTime,
    required String paymentAmount,
    required String remarks,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user-auth-token');

      if (token == null) {
        prefs.setString('user-auth-token', '');
      }

      final res = await http.post(
        Uri.parse('$uri/api/v1/reserve/reserve-station/$stationId'),
        headers: {
          'Content-Type': 'application/json',
          'user-auth-token': token!,
        },
        body: jsonEncode({
          'paymentAmount': paymentAmount,
          'startingTime': startingTime.toLocal().toIso8601String(),
          'endingTime': endingTime.toLocal().toIso8601String(),
          'date': DateTime.now().toLocal().toIso8601String(),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      final res = await http.get(
        Uri.parse('$uri/api/v1/reserve/view-reservation'),
        headers: {
          'Content-Type': 'application/json',
          'station-auth-token': token!,
        },
      );

      if (res.statusCode == 200) {
        List<Reservation> reservations = [];
        final List<dynamic> responseData = jsonDecode(res.body)['data'];

        for (var item in responseData) {
          reservations.add(
            Reservation(
              id: item['_id'],
              reservedBy: item['reservedBy'],
              reservedTo: item['reservedTo'],
              paymentAmount: item['paymentAmount'].toString(),
              startingTime: item['startingTime'],
              endingTime: item['endingTime'],
              date: item['date'],
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
