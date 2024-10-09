import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/cloudinary_keys.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/user.model.dart';
import 'package:ev_charge/providers/user_provider.dart';
import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      CloudinaryResponse cloudinaryRes = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image.path, folder: 'user'));
      final imageUrl = cloudinaryRes.secureUrl;
      User user = User(
        id: '',
        username: username,
        fullName: fullName,
        password: password,
        phoneNumber: phoneNumber,
        image: imageUrl,
        accessToken: '',
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
          onSuccess: () {
            showSnackBar(
              context,
              "User registered successfully. Login with the same credentials.",
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
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
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(jsonEncode(jsonDecode(res.body)['data']));

            print('Error');
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['data']['accessToken']);

            print('Error 2');
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      print('***********************************');
      print('here');

      http.Response tokenRes = await http.get(
        Uri.parse('$uri/api/v1/users/token-is-valid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      print(tokenRes.body);

      var response = jsonDecode(tokenRes.body);

      print(response);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/v1/users/current-user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        print("User res.body");
        print(userRes.body);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}