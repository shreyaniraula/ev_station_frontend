import 'dart:io';
import 'package:ev_charge/constants/ev_station_coordinates.dart';
import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/services/station/get_stations.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupStation extends StatefulWidget {
  const SignupStation({super.key});

  @override
  State<SignupStation> createState() => _SignupStationState();
}

class _SignupStationState extends State<SignupStation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stationNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final StationAuthService _authService = StationAuthService();
  final GetStations getStations = GetStations();

  List<Map<String, String>> stationsName = [];
  Map<String, String>? selectedStation;

  XFile? panCardImage, stationImage;

  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    return pickedImage;
  }

  void registerStation() {
    _authService.registerStation(
      context: context,
      stationName: selectedStation!['name']!,
      username: _usernameController.text,
      password: _passwordController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      noOfSlots: int.tryParse(_slotsController.text)!,
      panCardImage: panCardImage!,
      stationImage: stationImage!,
    );
  }

  void getAllStations() async {
    for (int i = 0; i < evStationsCoordinates.length; i++) {
      stationsName.add({
        'name': evStationsCoordinates[i]['name'],
        'address': evStationsCoordinates[i]['address'],
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllStations();
  }

  @override
  void dispose() {
    super.dispose();
    _stationNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _slotsController.dispose();
    _usernameController.dispose();
  }

  void updateUsernameAndLocation() {
    setState(() {
      String formattedName =
          selectedStation!['name']!.toLowerCase().replaceAll(' ', '_');
      String formattedAddress =
          selectedStation!['address']!.toLowerCase().replaceAll(' ', '_');
      _usernameController.text = '${formattedName}_$formattedAddress';
      _locationController.text = selectedStation!['address'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register Station"),
          backgroundColor: const Color.fromARGB(255, 62, 182, 122),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/ev_image.png',
                        height: 150,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create your station account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 163, 90),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromARGB(255, 240, 242, 246),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        DropdownButtonFormField<Map<String, String>>(
                          value: selectedStation,
                          decoration: InputDecoration(
                            labelText: 'Select a station',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 145, 145, 145),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(205, 221, 169, 0.651),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.business,
                              color: const Color.fromARGB(255, 66, 197, 131),
                            ),
                          ),
                          items:
                              stationsName.map((Map<String, String> station) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: station,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // Adjust padding
                                child: Text(
                                  station['name'] ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Map<String, String>? value) {
                            setState(() {
                              selectedStation = value;
                              updateUsernameAndLocation();
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select a station name.'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomTextfield(
                          labelText: 'Username',
                          icon: Icons.person,
                          controller: _usernameController,
                          obscureText: false,
                          readOnly: true,
                        ),
                        CustomTextfield(
                          labelText: 'Password',
                          obscureText: true,
                          icon: Icons.lock,
                          controller: _passwordController,
                        ),
                        CustomTextfield(
                          labelText: 'Phone Number',
                          icon: Icons.phone,
                          controller: _phoneController,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                        ),
                        CustomTextfield(
                          labelText: 'Location',
                          icon: Icons.location_on,
                          controller: _locationController,
                          obscureText: false,
                          readOnly: true,
                        ),
                        CustomTextfield(
                          labelText: 'Number of Slots',
                          icon: Icons.event_seat,
                          controller: _slotsController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Please upload an image of the Station',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            XFile? image = await _pickImage();
                            if (image != null) {
                              setState(() {
                                stationImage = image;
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: stationImage == null
                                ? Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  )
                                : Image.file(
                                    File(stationImage!.path),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Please upload an image of Pan Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            XFile? image = await _pickImage();
                            if (image != null) {
                              setState(() {
                                panCardImage = image;
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: panCardImage == null
                                ? Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  )
                                : Image.file(
                                    File(panCardImage!.path),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text.length < 6) {
                                showSnackBar(context,
                                    'Password must be at least 6 characters long.');
                                return;
                              }
                              registerStation();
                            }
                          },
                          style: elevatedButtonStyle,
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
