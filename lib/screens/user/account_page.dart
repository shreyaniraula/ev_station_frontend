import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_charge/providers/user_provider.dart';
import 'package:ev_charge/screens/user/my_reservations.dart';
import 'package:ev_charge/screens/user/updates/update_image_page.dart';
import 'package:ev_charge/screens/user/updates/update_password_page.dart';
import 'package:ev_charge/screens/user/updates/update_user_details_page.dart';
import 'package:ev_charge/services/station/get_stations.dart';
import 'package:ev_charge/services/user/auth_service.dart';
import 'package:ev_charge/utils/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  final UserAuthService authService = UserAuthService();
  final GetStations getStations = GetStations();

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  void logoutUser() {
    authService.logoutUser(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${greeting()}\n${user.username}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              CachedNetworkImage(
                imageUrl: user.image,
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
            buttonText: 'Update Details',
            frontIcon: Icons.person,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateUserDetailsPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Change Password',
            frontIcon: Icons.lock,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateUserPasswordPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Update Image',
            frontIcon: Icons.image,
            onTap: () =>
                Navigator.of(context).pushNamed(UpdateUserImagePage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'My Reservations',
            frontIcon: Icons.book,
            onTap: () =>
                Navigator.of(context).pushNamed(MyReservations.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Log Out',
            frontIcon: Icons.logout,
            onTap: logoutUser,
          ),
          Divider(thickness: 2, color: Colors.black),
        ],
      ),
    );
  }
}
