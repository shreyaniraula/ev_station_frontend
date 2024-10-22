import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:ev_charge/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class UpdateUserDetailsPage extends StatelessWidget {
  static const String routeName = '/update-user-details-page';
  const UpdateUserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
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
                        showSnackBar(context, 'Account Updated Successfully');
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 17, 163, 90),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
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
