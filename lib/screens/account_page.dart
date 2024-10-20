import 'package:ev_charge/screens/update_password_page.dart';
import 'package:ev_charge/screens/update_user_details_page.dart';
import 'package:ev_charge/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello,\nShreya Niraula',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.person,
                size: 50.0,
              )
            ],
          ),
          SizedBox(height: 50),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Personal Details',
            frontIcon: Icons.person_outline,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateUserDetailsPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
            buttonText: 'Change Password',
            frontIcon: Icons.lock,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdatePasswordPage.routeName),
          ),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(buttonText: 'Change Photo', frontIcon: Icons.image),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(
              buttonText: 'Notification Settings',
              frontIcon: Icons.notifications),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(buttonText: 'Help', frontIcon: Icons.help),
          Divider(thickness: 2, color: Colors.black),
          CustomTextbutton(buttonText: 'Log Out', frontIcon: Icons.logout),
          Divider(thickness: 2, color: Colors.black),
        ],
      ),
    );
  }
}
