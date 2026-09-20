import 'package:flutter/material.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';

class AuthDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color? labelColor;

  const AuthDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

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
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 2.0,
              ),
            ),
          ),
          dropdownColor: dark ? SColors.dark : Colors.white,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF1980B8),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
