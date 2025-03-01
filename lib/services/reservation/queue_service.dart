import 'dart:convert';

import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QueueService {
  Future<void> joinQueue({
    required BuildContext context,
    required String username,
    required String priority,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }
      final response = await http.post(
        Uri.parse('$uri/api/v1/reserve/join-queue'),
        headers: {
          'Content-Type': 'application/json',
          'station-auth-token': token!
        },
        body: jsonEncode({
          'username': username,
          'priority': priority,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        showSnackBar(context,
            'Joined queue. Your position is ${result['queuePosition']}');
      } else {
        showSnackBar(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getQueueStatus({
    required BuildContext context,
    required Function(List<dynamic>, bool, String) updateState,
    required String myUserId,
  }) async {
    try {
      print('Getting queue status');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }
      final response = await http
          .get(Uri.parse('$uri/api/v1/reserve/queue-status'), headers: {
        'Content-Type': 'application/json',
        'station-auth-token': token!
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Expecting data to have "queue" and "isStationBusy"
        List<dynamic> queueList = data['queue'] ?? [];
        bool isStationBusy = data['isStationBusy'] ?? false;
        String message = '';

        // If the queue isn't empty, check if our user is being processed
        if (queueList.isNotEmpty && myUserId.isNotEmpty) {
          // Look for our user in the queue list
          int index =
              queueList.indexWhere((item) => item['userId'] == myUserId);
          if (index != -1) {
            final item = queueList[index];
            if (item['status'] == 'processing') {
              message = 'Station allocated to you.';
            } else {
              message = 'Your current position in the queue is ${index + 1}';
            }
          }
        }
        updateState(queueList, isStationBusy, message);
      } else {
        updateState([], false, 'Error fetching queue status');
      }
    } catch (e) {
      updateState([], false, e.toString());
    }
  }
}
