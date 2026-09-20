import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30, // Customize the width
        height: 30, // Customize the height
        decoration: BoxDecoration(
          color: Colors.transparent, // Make the background transparent
          shape: BoxShape.circle, // Circle shape for the button
          border: Border.all(
            color: Color(
                0xFF1980B8), // Add a colored border to represent the button's outer edge
            width: 2.0, // Adjust the border thickness as needed
          ),
        ),
        child: Center(
          child: Icon(
            Icons
                .arrow_back_ios_new_rounded, // You can also use Icons.arrow_back_ios if needed
            color: Color(
                0xFF1980B8), // Color of the arrow (same as the border color)
          ),
        ),
      ),
    );
  }
}
