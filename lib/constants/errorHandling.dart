import 'dart:convert';

import 'package:ev_charge/utils/showSnackbar.dart';
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
    case 400:
      showSnackBar(context, jsonDecode(response.body)['message']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}