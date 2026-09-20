import 'package:flutter/material.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: TextStyle(
              color: dark ? Colors.white : Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
