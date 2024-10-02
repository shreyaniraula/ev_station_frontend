import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ev_charge/constants/cloudinary_keys.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/login_screen.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<void> registerStation({
    required BuildContext context,
    required String stationName,
    required String username,
    required String password,
    required String phoneNumber,
    required String location,
    required String noOfSlots,
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

      Station station = Station(
        id: '',
        name: stationName,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        location: location,
        panCard: uploadedImage.secureUrl,
        noOfSlots: noOfSlots,
        reservedSlots: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/stations/register'),
        body: station.toJson(), // Ensure it's encoded properly
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      errorHandler(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context,
                "Station registered successfully. It might take a while to be verified. Login with the same credentials.");
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
        Uri.parse('$uri/api/v1/stations/login'),
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
