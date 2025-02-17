import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/screens/station/verification/signup_station.dart';
import 'package:ev_charge/screens/user/verification/signup_user.dart';
import 'package:ev_charge/services/user/auth_service.dart';
import 'package:ev_charge/services/station/auth_service.dart';
import 'package:ev_charge/utils/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<bool> isSelected = [true, false];

  final UserAuthService _userAuthService = UserAuthService();
  final StationAuthService _stationAuthService = StationAuthService();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void loginUser() {
    _userAuthService.loginUser(
      context: context,
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  void loginStation() {
    _stationAuthService.loginStation(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50, left: 8.0, right: 8.0, bottom: 8.0),
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
            
                        const SizedBox(height: 40),
            
                        ElevatedButton(
                          onPressed: () {
                            if (isSelected[0]) {
                              loginUser();
                            } else {
                              loginStation();
                            }
                          },
                          style: elevatedButtonStyle,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupUser(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupStation(),
                              ),
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
