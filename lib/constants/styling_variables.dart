import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 17, 163, 90), // Button color
  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  elevation: 5,
);
