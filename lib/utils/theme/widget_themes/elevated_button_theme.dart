import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.light,
      backgroundColor: SColors.primary,
      disabledForegroundColor: SColors.darkGrey,
      disabledBackgroundColor: SColors.buttonDisabled,
      side: const BorderSide(color: SColors.primary),
      padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: SColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.light,
      backgroundColor: SColors.primary,
      disabledForegroundColor: SColors.darkGrey,
      disabledBackgroundColor: SColors.darkerGrey,
      side: const BorderSide(color: SColors.primary),
      padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: SColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
    ),
  );
}
