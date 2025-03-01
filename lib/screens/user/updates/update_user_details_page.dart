import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/user/update_user.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:flutter/material.dart';

class UpdateUserDetailsPage extends StatelessWidget {
  static const String routeName = '/update-user-details-page';
  const UpdateUserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateUser updateUser = UpdateUser();
    final formKey = GlobalKey<FormState>();

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();

    void updateUserDetails(
        String username, String fullName, String phoneNumber) {
      updateUser.updateDetails(
        context: context,
        username: username,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
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
                  'Username',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  icon: Icons.person,
                  obscureText: false,
                  controller: usernameController,
                ),
                const SizedBox(height: 10),
                Text(
                  'Full Name',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  obscureText: false,
                  icon: Icons.note,
                  controller: fullNameController,
                ),
                const SizedBox(height: 10),
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  obscureText: false,
                  icon: Icons.phone,
                  controller: phoneController,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        updateUserDetails(
                          usernameController.text,
                          fullNameController.text,
                          phoneController.text,
                        );
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
