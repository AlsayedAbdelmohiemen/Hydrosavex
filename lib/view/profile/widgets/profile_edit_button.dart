import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProfileEditButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileEditButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: dark ? SColors.dark : SColors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: dark ? SColors.dark : Colors.white,
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFF0C76B0)),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.edit_profile,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0C76B0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF0C76B0),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
