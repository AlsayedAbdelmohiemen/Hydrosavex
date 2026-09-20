import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this for Provider support
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:wiredash/wiredash.dart';
import '../../controller/settings_provider.dart';

class WiredashApp extends StatelessWidget {
  final navigatorKey;
  final Widget child;

  const WiredashApp(
      {super.key, required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<SettingsProvider>(context).themeMode;

    return Wiredash(
      projectId: 'drowing-zxbr6pb',
      secret: '9iNLhwVjTlLs7EwPZnsjKKKgEEJxM8JM',

      theme: WiredashThemeData(
        brightness:
            themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
        primaryColor: SColors.primary,
        secondaryColor: SColors.secondary,
        appBackgroundColor:
            themeMode == ThemeMode.dark ? SColors.dark : SColors.light,
      ),
      // Added navigatorKey to Wiredash

      child: child,
    );
  }
}
