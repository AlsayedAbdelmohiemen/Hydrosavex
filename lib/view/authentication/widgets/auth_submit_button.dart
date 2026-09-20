import 'package:flutter/material.dart';
import 'package:hydrosavex/utils/helpers/custom_loading.dart';

class AuthSubmitButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CustomLoading());
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: const Color(0xFF1980B8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
