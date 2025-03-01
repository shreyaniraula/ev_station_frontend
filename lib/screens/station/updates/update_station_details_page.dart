import 'package:ev_charge/providers/station_provider.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateStationDetailsPage extends StatefulWidget {
  static const String routeName = '/view-station-details-page';
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


  @override
  Widget build(BuildContext context) {
    final station = Provider.of<StationProvider>(context).station;

    addressController.text = station.location;
    fullNameController.text = station.name;
    usernameController.text = station.username;
    phoneController.text = station.phoneNumber;
    final String imageUrl = station.stationImage;
    final String panCard = station.panCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Details'),
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
                  'Name',
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextfield(
                  icon: Icons.business,
                  obscureText: false,
                  controller: fullNameController,
                  readOnly: true,
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
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                Text(
                  'Station Image',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pan Card Image',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(panCard, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
