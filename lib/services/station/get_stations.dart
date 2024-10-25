import 'dart:convert';

import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetStations {
  Future<List<dynamic>?> getAllStations(
      {required BuildContext context}) async {
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/stations/get-all-stations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return jsonDecode(res.body)['data'];
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Something went wrong while displaying stations');
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getStationDetails(
      {required BuildContext context, required String username}) async {
    try {
      http.Response stationRes = await http.get(
        Uri.parse('$uri/api/v1/stations/station-details'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'stationUsername': username,
        },
      );

      if (context.mounted) {
        errorHandler(
          response: stationRes,
          context: context,
          onSuccess: () =>
              Station.fromJson(jsonEncode(jsonDecode(stationRes.body)['data'])),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Something went wrong while displaying stations');
      }
    }
    return null;
  }
}
