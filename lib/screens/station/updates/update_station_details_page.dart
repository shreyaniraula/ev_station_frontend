import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateStationDetailsPage extends StatefulWidget {
  static const String routeName = '/update-station-details-page';
  const UpdateStationDetailsPage({super.key});

  @override
  State<UpdateStationDetailsPage> createState() =>
      _UpdateStationDetailsPageState();
}

class _UpdateStationDetailsPageState extends State<UpdateStationDetailsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void updateUsernameAndLocation(String val) {
    setState(() {
      String formattedName =
          fullNameController.text.toLowerCase().replaceAll(' ', '_');
      String formattedAddress =
          addressController.text.toLowerCase().replaceAll(' ', '_');
      usernameController.text = '${formattedName}_$formattedAddress';
    });
  }

  @override
  Widget build(BuildContext context) {
    addressController.text =
        Provider.of<StationProvider>(context, listen: false).station.location;
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
                  'Name',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  icon: Icons.business,
                  obscureText: false,
                  controller: fullNameController,
                  onChanged: updateUsernameAndLocation,
                ),
                const SizedBox(height: 10),
                Text(
                  'Username',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  obscureText: false,
                  icon: Icons.person,
                  controller: usernameController,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Address',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  obscureText: false,
                  icon: Icons.edit_location_alt,
                  controller: addressController,
                  readOnly: true,
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
                      //TODO: update station account
                      if (formKey.currentState!.validate()) {
                        showSnackBar(context, 'Account Updated Successfully');
                        Navigator.of(context).pop();
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
