import 'dart:convert';

import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void errorHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    default:
      // ignore: avoid_print
      print(response.body);
      showSnackBar(context, jsonDecode(response.body)['message']);
  }
}
