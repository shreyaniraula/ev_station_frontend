import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/user.model.dart';
import 'package:ev_charge/providers/user_provider.dart';
import 'package:ev_charge/screens/user/home_screen.dart';
import 'package:ev_charge/screens/user/verification/login_page.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthService {
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

      if (context.mounted) {
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
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> loginUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
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

      if (context.mounted) {
        // Handle response
        errorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(jsonEncode(jsonDecode(res.body)['data']));
            }

            await prefs.setString(
                'user-auth-token', jsonDecode(res.body)['data']['accessToken']);

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, UserHomeScreen.routeName, (route)=>false);
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user-auth-token');

      if (token == null) {
        prefs.setString('user-auth-token', '');
      }

      http.Response tokenRes = await http.get(
        Uri.parse('$uri/api/v1/users/token-is-valid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'user-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/v1/users/current-user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'user-auth-token': token,
          },
        );

        if (context.mounted) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(userRes.body);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> logoutUser({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user-auth-token');

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/users/logout'),
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
            prefs.setString('user-auth-token', '');
            showSnackBar(
              context,
              "User logged out successfully.",
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            );
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
