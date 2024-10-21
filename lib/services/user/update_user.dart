import 'dart:convert';

import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser {
  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/change-password'),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Password Changed Successfully');
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
