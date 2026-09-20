import 'package:flutter/material.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color? labelColor;
  final double? elevation;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.labelColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    Widget field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade700),
        filled: true,
        fillColor: dark ? SColors.dark : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
            color: Color(0xFF1980B8),
            width: 1.5,
          ),
        ),
      ),
    );

    if (elevation != null && elevation! > 0) {
      field = Material(
        elevation: elevation!,
        shadowColor: Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
        child: field,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: labelColor ?? const Color(0xFF1980B8),
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
