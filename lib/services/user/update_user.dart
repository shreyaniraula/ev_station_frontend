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

class UpdateUser {
  Future<void> updateDetails({
    required BuildContext context,
    required String username,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/update-account'),
        body: jsonEncode({
          'username': username,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'user-auth-token': token!,
        },
      );

      print(res.body);

      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Account Updated Successfully');
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

  Future<void> updatePassword({
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
          'user-auth-token': token!,
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

  Future<void> updateImage({
    required BuildContext context,
    required XFile image,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      final cloudinary =
          CloudinaryPublic(kCloudinaryCloudName, kCloudinaryUploadPreset);

      CloudinaryResponse cloudinaryRes = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image.path, folder: 'user'));

      final imageUrl = cloudinaryRes.secureUrl;

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/users/update-image'),
        body: jsonEncode({
          'imageUrl': imageUrl,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'user-auth-token': token!,
        },
      );

      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Image Updated Successfully');
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
}
