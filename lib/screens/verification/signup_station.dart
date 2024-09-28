import 'package:ev_charge/screens/home_screen.dart';
import 'package:flutter/material.dart';

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

  Widget _buildTextField(String label,
      {bool obscureText = false,
      IconData? icon,
      TextEditingController? controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: const Color.fromARGB(255, 66, 197, 131))
              : null,
          labelText: label,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 145, 145, 145)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 17, 163, 90)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
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
                        _buildTextField('Station Name',
                            icon: Icons.business,
                            controller: _stationNameController),
                        _buildTextField('Password',
                            obscureText: true,
                            icon: Icons.lock,
                            controller: _passwordController),
                        _buildTextField('Phone Number',
                            icon: Icons.phone, controller: _phoneController),
                        _buildTextField('Location',
                            icon: Icons.location_on,
                            controller: _locationController),
                        _buildTextField('Number of Slots',
                            icon: Icons.event_seat,
                            controller: _slotsController),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
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
