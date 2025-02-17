import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String? labelText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const CustomTextfield(
      {super.key,
      this.labelText,
      required this.obscureText,
      required this.controller,
      required this.icon,
      this.keyboardType,
      this.readOnly = false,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          },
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
