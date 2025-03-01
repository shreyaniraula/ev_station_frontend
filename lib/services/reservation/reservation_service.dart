import 'dart:convert';
import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/screens/station/reservation_screen.dart';
import 'package:ev_charge/screens/user/my_reservations.dart';
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
    required int paymentAmount,
    required String remarks,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      String formatLocalTime(DateTime dt) {
        final local = dt.toLocal();
        final offset = local.timeZoneOffset;
        final sign = offset.isNegative ? '-' : '+';
        final hours = offset.inHours.abs().toString().padLeft(2, '0');
        final minutes =
            (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
        return '${local.toIso8601String()}$sign$hours:$minutes';
      }

      final res = await http.post(
        Uri.parse('$uri/api/v1/reserve/update-reservation'),
        headers: {
          'Content-Type': 'application/json',
          'station-auth-token': token!,
        },
        body: jsonEncode({
          'paymentAmount': paymentAmount * 100,
          'startingTime': formatLocalTime(startingTime),
          'endingTime': formatLocalTime(endingTime),
          'remarks': remarks,
        }),
      );

      if (context.mounted) {
        if (res.statusCode == 200) {
          showSnackBar(context, 'Booking successful!');
          Navigator.pushNamed(context, ReservationScreen.routeName);
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
    required int paymentAmount,
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
          'startingTime': startingTime.toIso8601String(),
          'endingTime': endingTime.toIso8601String(),
          'date': DateTime.now().toIso8601String(),
          'remarks': remarks,
        }),
      );

      if (context.mounted) {
        if (res.statusCode == 200) {
          showSnackBar(context, 'Booking successful!');
          Navigator.pushNamed(context, MyReservations.routeName);
        } else if (res.statusCode == 409) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Spot unavailable.'),
                  content: Text(jsonDecode(res.body)['message']),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              });
        } else {
          showSnackBar(context, 'Some error occurred');
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
              reserverName: item['reserverName'],
              reservedStation: item['reservedStation'],
              location: item['location'],
              paymentAmount: item['paymentAmount'],
              startingTime: DateTime.parse(item['startingTime']),
              endingTime: DateTime.parse(item['endingTime']),
              date: DateTime.parse(item['date']),
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

  Future<List<Reservation>> myReservations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user-auth-token');

      if (token == null) {
        prefs.setString('user-auth-token', '');
      }

      final res = await http.get(
        Uri.parse('$uri/api/v1/reserve/my-reservations'),
        headers: {
          'Content-Type': 'application/json',
          'user-auth-token': token!,
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
              reserverName: item['reserverName'],
              reservedStation: item['reservedStation'],
              location: item['location'],
              paymentAmount: item['paymentAmount'],
              startingTime: DateTime.parse(item['startingTime']),
              endingTime: DateTime.parse(item['endingTime']),
              date: DateTime.parse(item['date']),
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

  Future<bool> cancelReservation({
    required BuildContext context,
    required String reservationId,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user-auth-token');

      if (token == null) {
        prefs.setString('user-auth-token', '');
      }

      final res = await http.delete(
        Uri.parse('$uri/api/v1/reserve/cancel-reservation/$reservationId'),
        headers: {
          'Content-Type': 'application/json',
          'user-auth-token': token!,
        },
      );

      if (res.statusCode == 200) {
        showSnackBar(context, 'Reservation cancelled!');
        return true;
      } else {
        showSnackBar(context, 'Failed to cancel reservation');
        return false;
      }
    } catch (e) {
      throw Exception('Error fetching reservations: $e');
    }
  }

  Future<void> joinQueue(
      {required BuildContext context,
      required String username,
      required int priority}) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/api/v1/reserve/join-queue'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'priority': priority,
        }),
      );

      if(res.statusCode == 200) {
        final data = jsonDecode(res.body);
        showSnackBar(context, 'Joined queue successfully. Your position: ${data['queuePosition']}');
      } else {
        showSnackBar(context, 'Failed to join queue. Please try again.');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }
}
