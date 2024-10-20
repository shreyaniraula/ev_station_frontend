import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  final String buttonText;
  final IconData frontIcon;
  final VoidCallback? onTap;
  const CustomTextbutton(
      {super.key, required this.buttonText, required this.frontIcon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  frontIcon,
                  size: 30.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  buttonText,
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Icon(
              Icons.arrow_right,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
