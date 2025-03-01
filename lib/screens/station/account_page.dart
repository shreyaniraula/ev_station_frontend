import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/screens/station/updates/update_image_page.dart';
import 'package:ev_charge/screens/station/updates/update_password_page.dart';
import 'package:ev_charge/screens/station/updates/update_station_details_page.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/utils/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationAccountPage extends StatefulWidget {
  const StationAccountPage({super.key});

  @override
  State<StationAccountPage> createState() => _StationAccountPageState();
}

class _StationAccountPageState extends State<StationAccountPage> {
  final StationAuthService authService = StationAuthService();

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  void logoutStation() {
    authService.logoutStation(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final station = Provider.of<StationProvider>(context).station;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${greeting()}\n${station.username}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              CachedNetworkImage(
                imageUrl: station.stationImage,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 30,
                  foregroundImage: imageProvider,
                ),
                placeholder: (context, url) => Icon(Icons.person, size: 50),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],
          ),
          SizedBox(height: 50),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Personal Details',
            frontIcon: Icons.person_outline,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateStationDetailsPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Change Password',
            frontIcon: Icons.lock,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateStationPasswordPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
              buttonText: 'Update Image',
              frontIcon: Icons.image,
              onTap: () => Navigator.of(context)
                  .pushNamed(UpdateStationImagePage.routeName)),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Log Out',
            frontIcon: Icons.logout,
            onTap: logoutStation,
          ),
          Divider(thickness: 2, color: Colors.black),
        ],
      ),
    );
  }
}
