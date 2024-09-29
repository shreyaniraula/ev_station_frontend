import 'dart:io';

import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/utils/pick_images.dart';
import 'package:ev_charge/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupStation extends StatefulWidget {
  static const String routeName = '/signup-station-screen';
  const SignupStation({super.key});

  @override
  State<SignupStation> createState() => _SignupStationState();
}

class _SignupStationState extends State<SignupStation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stationNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();

  final AuthService _authService = AuthService();

  XFile? _image;

  @override
  void dispose() {
    super.dispose();
    _stationNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _slotsController.dispose();
  }

  void selectImage() async {
    var img = await pickImage();
    setState(() {
      _image = img;
    });
  }

  void registerStation() {
    _authService.registerStation(
      context: context,
      stationName: _stationNameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      noOfSlots: _slotsController.text,
      image: _image!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up Station"),
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
                          obscureText: false,
                          icon: Icons.business,
                          controller: _stationNameController,
                        ),
                        CustomTextfield(
                          labelText: 'Username',
                          obscureText: false,
                          icon: Icons.person,
                          controller: _usernameController,
                        ),
                        CustomTextfield(
                          labelText: 'Password',
                          obscureText: true,
                          icon: Icons.lock,
                          controller: _passwordController,
                        ),
                        CustomTextfield(
                          labelText: 'Phone Number',
                          obscureText: false,
                          icon: Icons.phone,
                          controller: _phoneController,
                        ),
                        CustomTextfield(
                          labelText: 'Location',
                          obscureText: false,
                          icon: Icons.location_on,
                          controller: _locationController,
                        ),
                        CustomTextfield(
                          labelText: 'Number of Slots',
                          obscureText: false,
                          icon: Icons.event_seat,
                          controller: _slotsController,
                        ),
                        GestureDetector(
                          onTap: selectImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _image == null
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
                                    File(_image!.path),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() && _image != null) {
                              registerStation();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 17, 163, 90),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
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
