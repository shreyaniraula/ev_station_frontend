import 'dart:convert';
import 'dart:io';

import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/user.model.dart';
import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  void registerUser({
    required BuildContext context,
    String? username,
    required String fullName,
    required String password,
    String? phoneNumber,
    String? email,
    required File image,
  }) async {
    try {
      User user = User(
        id: '',
        username: username ?? '',
        fullName: fullName,
        password: password,
        phoneNumber: phoneNumber ?? '',
        email: email ?? '',
        image: image,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      errorHandler(
        response: res,
        context: context,
        onSuccess: () => showSnackBar(context,
            "User registered successfully. Login with the same credentials."),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void loginUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/login'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(res.body);

      errorHandler(
        response: res,
        context: context,
        onSuccess: () => Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
