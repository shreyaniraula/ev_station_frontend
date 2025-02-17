import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateStation {
  Future<void> updatePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/stations/change-password'),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'station-auth-token': token!,
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
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<bool> updateImage({
    required BuildContext context,
    required XFile image,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      final cloudinary =
          CloudinaryPublic(kCloudinaryCloudName, kCloudinaryUploadPreset);

      CloudinaryResponse cloudinaryRes = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image.path, folder: 'station'));

      final imageUrl = cloudinaryRes.secureUrl;

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/stations/update-station-image'),
        body: jsonEncode({
          'imageUrl': imageUrl,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'station-auth-token': token!,
        },
      );

      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Image Updated Successfully');
            // Navigator.of(context).pop();
          },
        );
      }
      return res.statusCode == 200;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
      return false;
    }
  }
}
