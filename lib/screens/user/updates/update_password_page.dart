import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/user/update_user.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatelessWidget {
  static const String routeName = 'update-password-page';
  const UpdatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    final UpdateUser updateUser = UpdateUser();

    void updatePassword() {
      updateUser.updatePassword(
        context: context,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: const Color.fromARGB(255, 62, 182, 122),
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
