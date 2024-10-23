import 'dart:io';
import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
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

  final AuthService _authService = AuthService();

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
      stationName: _stationNameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      noOfSlots: int.tryParse(_slotsController.text)!,
      panCardImage: panCardImage!,
      stationImage: stationImage!,
    );
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
                        CustomTextfield(
                          labelText: 'Station Name',
                          icon: Icons.business,
                          controller: _stationNameController,
                          obscureText: false,
                        ),
                        CustomTextfield(
                          labelText: 'Username',
                          icon: Icons.person,
                          controller: _usernameController,
                          obscureText: false,
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
                        ),
                        CustomTextfield(
                          labelText: 'Location',
                          icon: Icons.location_on,
                          controller: _locationController,
                          obscureText: false,
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
