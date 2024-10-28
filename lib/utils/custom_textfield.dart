import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String? labelText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  const CustomTextfield({
    super.key,
    this.labelText,
    required this.obscureText,
    required this.controller,
    required this.icon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, color: const Color.fromARGB(255, 66, 197, 131)),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 145, 145, 145),
            ),
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
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
