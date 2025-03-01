import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/station/update_station.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class UpdateStationPasswordPage extends StatelessWidget {
  static const String routeName = '/update-station-password-page';
  const UpdateStationPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    final UpdateStation updateStation = UpdateStation();

    void updatePassword() {
      updateStation.updatePassword(
        context: context,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: Color.fromARGB(248, 203, 243, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Old Password',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  icon: Icons.password,
                  obscureText: true,
                  controller: oldPasswordController,
                ),
                const SizedBox(height: 10),
                Text(
                  'New Password',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  obscureText: true,
                  icon: Icons.lock,
                  controller: newPasswordController,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (oldPasswordController.text ==
                            newPasswordController.text) {
                          showSnackBar(context,
                              'Old and New Passwords cannot be the same');
                          return;
                        }
                        if (newPasswordController.text.length < 6) {
                          showSnackBar(context,
                              'Password must be at least 6 characters');
                          return;
                        }
                        updatePassword();
                        // Navigator.of(context).pop();
                      }
                    },
                    style: elevatedButtonStyle,
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
