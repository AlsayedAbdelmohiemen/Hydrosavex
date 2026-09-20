import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class MedicalEmptyState extends StatelessWidget {
  const MedicalEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/cuate.png'),
          const SizedBox(height: 20),
          Text(
            "There are no notifications yet",
            style: TextStyle(
              fontSize: 18,
              color: dark ? SColors.white : SColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
