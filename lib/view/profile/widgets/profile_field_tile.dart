import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProfileFieldTile extends StatelessWidget {
  final String hintText;
  final String type;

  const ProfileFieldTile({
    super.key,
    required this.hintText,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 30, top: 20),
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF1980B8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Material(
          elevation: 4,
          color: dark ? SColors.dark : Colors.white,
          shadowColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: type == "No."
                      ? "Number of swimming Pools is $hintText"
                      : hintText,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: dark ? SColors.dark : Colors.white,
                  filled: true,
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
              ),
              if (type != AppLocalizations.of(context)!.email)
                const Row(
                  children: [
                    Spacer(),
                    SizedBox(width: 10),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
