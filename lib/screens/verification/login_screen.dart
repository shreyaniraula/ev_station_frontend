import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/verification/signup_station.dart';
import 'package:ev_charge/screens/verification/signup_user.dart';
import 'package:ev_charge/services/user/auth_service.dart';
import 'package:ev_charge/widgets/custom_textfield.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<bool> isSelected = [true, false];

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void loginUser() {
    _authService.loginUser(
      context: context,
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(136, 242, 243, 242),
              Color.fromARGB(255, 252, 253, 252)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Name
                const Text(
                  'EV Charging\nStation Locator',
                  style: TextStyle(
                    color: Color.fromARGB(255, 156, 240, 88),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Toogle Buttons
                ToggleButtons(
                  borderColor: Colors.white,
                  fillColor: const Color.fromARGB(255, 17, 163, 90),
                  borderWidth: 2,
                  selectedBorderColor: Colors.white,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                      }
                    });
                  },
                  isSelected: isSelected,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text("User"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text("Station"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //Input Details: username and password
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromARGB(255, 240, 242, 246),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomTextfield(
                        controller: _usernameController,
                        labelText: 'Username',
                        obscureText: false,
                        icon: Icons.person,
                      ),
                      CustomTextfield(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        icon: Icons.lock,
                      ),

                      //Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            //  forget password ko lagi
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 170, 230, 230)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      ElevatedButton(
                        onPressed: () {
                          print('Button pressed');
                          if (_formKey.currentState!.validate()) {
                            if (isSelected[0]) {
                              // Authenticate user
                              loginUser();

                              //Comment previous code and comment out following code for running without server
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   HomeScreen.routeName,
                              //   (route) => false,
                              // );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 17, 163, 90), // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ?"),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isSelected[0]) {
                          // If user is selected on toggle button go to signup user
                          Navigator.pushNamed(
                            context,
                            SignupUser.routeName,
                          );
                        } else {
                          // If station is selected on toggle button go to signup station
                          Navigator.pushNamed(
                            context,
                            SignupStation.routeName,
                          );
                        }
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(249, 116, 221, 46),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
