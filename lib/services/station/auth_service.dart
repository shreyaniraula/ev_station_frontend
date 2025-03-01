import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/constants/error_handler.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/screens/station/home_screen.dart';
import 'package:ev_charge/screens/user/verification/login_page.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StationAuthService {
  Future<void> registerStation({
    required BuildContext context,
    required String stationName,
    required String username,
    required String password,
    required String phoneNumber,
    required String location,
    required int noOfSlots,
    required XFile panCardImage,
    required XFile stationImage,
  }) async {
    try {
      final cloudinary =
          CloudinaryPublic(kCloudinaryCloudName, kCloudinaryUploadPreset);

      CloudinaryResponse panCardRes = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(panCardImage.path,
              folder: 'station/pancard'));

      CloudinaryResponse stationImageRes = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(stationImage.path, folder: 'station/image'));
      final panCardImageUrl = panCardRes.secureUrl;

      final stationImageUrl = stationImageRes.secureUrl;

      Station station = Station(
        id: '',
        name: stationName,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        location: location,
        panCard: panCardImageUrl,
        stationImage: stationImageUrl,
        accessToken: '',
        noOfSlots: noOfSlots,
        isVerified: false,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/stations/register'),
        body: station.toJson(),
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
              "Station registered successfully. Login with the same credentials.",
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

  Future<void> loginStation({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
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
      if (context.mounted) {
        errorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (context.mounted) {
              Provider.of<StationProvider>(context, listen: false)
                  .setStation(jsonEncode(jsonDecode(res.body)['data']));
            }

            await prefs.setString('station-auth-token',
                jsonDecode(res.body)['data']['accessToken']);

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, StationHomeScreen.routeName, (route)=>false);
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

  void getStationData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      if (token == null) {
        prefs.setString('station-auth-token', '');
      }

      http.Response tokenRes = await http.get(
        Uri.parse('$uri/api/v1/stations/token-is-valid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'station-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response stationRes = await http.get(
          Uri.parse('$uri/api/v1/stations/station-details'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'stationUsername':
                Provider.of<StationProvider>(context, listen: false).station.username,
          },
        );

        if (context.mounted) {
          var stationProvider =
              Provider.of<StationProvider>(context, listen: false);
          stationProvider.setStation(stationRes.body);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> logoutStation({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('station-auth-token');

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/stations/logout'),
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
            prefs.setString('station-auth-token', '');
            showSnackBar(
              context,
              "Station logged out successfully.",
            );
            Navigator.of(context).pushNamed(LoginPage.routeName);
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
