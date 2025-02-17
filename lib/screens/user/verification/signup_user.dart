import 'dart:io';
import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/user/auth_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  State<SignupUser> createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final UserAuthService _authService = UserAuthService();

  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void registerUser() {
    _authService.registerUser(
      context: context,
      username: _usernameController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      image: _image!,
      phoneNumber: _phoneController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
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
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      child: Image.asset(
                        'assets/images/ev_image.png',
                        height: 150,
                        fit: BoxFit.cover, // Adjust image to cover the space
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create your account",
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
                          labelText: 'Username',
                          icon: Icons.person,
                          controller: _usernameController,
                          obscureText: false,
                        ),
                        CustomTextfield(
                          labelText: 'Full Name',
                          obscureText: false,
                          icon: Icons.note,
                          controller: _fullNameController,
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
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
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
                            if (_formKey.currentState!.validate()) {
                              if(_passwordController.text.length < 6){
                                showSnackBar(context,
                                    'Password must be at least 6 characters');
                                return;
                              }
                              registerUser();
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
