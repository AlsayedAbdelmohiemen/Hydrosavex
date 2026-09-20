import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/settings_provider.dart';
import 'dart:async';
import 'package:hydrosavex/view/onboarding_screen/widgets/Onboarding_page_view.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(OnboardingPageView.routeName);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            provider.isDark()
                ? 'assets/images/Splash-Screen-dark.png'
                : 'assets/images/Splash-Screen.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
