import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/cloudinary_keys.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/user.model.dart';
import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/login_screen.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  Future<void> registerUser({
    required BuildContext context,
    required String username,
    required String fullName,
    required String password,
    required String phoneNumber,
    required XFile image,
  }) async {
    try {
      final cloudinary =
          CloudinaryPublic(kCloudinaryCloudName, kCloudinaryUploadPreset);

      CloudinaryResponse uploadedImage = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          resourceType: CloudinaryResourceType.Image,
          folder: username,
        ),
      );

      User user = User(
        id: '',
        username: username,
        fullName: fullName,
        password: password,
        phoneNumber: phoneNumber,
        image: uploadedImage.url,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/register'),
        body: user.toJson(), // Ensure it's encoded properly
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context,
                "User registered successfully. Login with the same credentials.");
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> loginUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      // Check network connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        showSnackBar(context, "No internet connection");
        return;
      }

      // Send login request
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

      // Handle response
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
