import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/settings_provider.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Adjusting paddings and icon size based on screen size
    final padding = screenWidth * 0.04;
    final iconSize = screenWidth * 0.05;
    final borderThickness = screenWidth * 0.005;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.theme,
          style: TextStyle(
              fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Transform.scale(
            scale: 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF1980B8),
                  width: borderThickness,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1980B8),
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Load different Lottie animations based on the theme
          settingsProvider.isDark()
              ? Lottie.asset(
                  'assets/animation/Animation - 1728599099437.json',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Lottie.asset(
                  'assets/animation/Animation - 1728648908718.json',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.choose_theme,
                      style: TextStyle(fontSize: screenWidth * 0.06),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: settingsProvider.isDark()
                          ? Icon(Icons.nightlight_round,
                              key: ValueKey('dark'),
                              color: Colors.blue,
                              size: iconSize)
                          : Icon(Icons.wb_sunny,
                              key: ValueKey('light'),
                              color: Colors.orange,
                              size: iconSize),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: DayNightSwitch(
                        value: settingsProvider.isDark(),
                        onChanged: (bool value) {
                          if (value) {
                            settingsProvider.enableDarkTheme();
                          } else {
                            settingsProvider.enableLightTheme();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
