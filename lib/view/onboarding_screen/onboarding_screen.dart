import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/settings_provider.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/Onboarding_item.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingScreen({super.key, required this.item});

  List<TextSpan> _buildTextSpans(
      String text, String keyword, TextStyle defaultStyle, Color keywordColor) {
    List<TextSpan> spans = [];

    // Prepare a case-insensitive RegExp
    RegExp exp = RegExp(RegExp.escape(keyword), caseSensitive: false);

    // Split the text into parts, separating the keyword
    List<RegExpMatch> matches = exp.allMatches(text).toList();
    if (matches.isEmpty) {
      // If no matches are found, return the entire text with default style
      spans.add(TextSpan(text: text, style: defaultStyle));
      return spans;
    }

    int lastMatchEnd = 0;
    for (var match in matches) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: defaultStyle,
        ));
      }
      // Add the matched keyword with the special color
      spans.add(TextSpan(
        text: match.group(0),
        style: defaultStyle.copyWith(color: keywordColor),
      ));
      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: defaultStyle,
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    final dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Container(
        // Add background image using decoration
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(!provider.isDark()
                ? "assets/images/background.png"
                : "assets/images/background_dark.png"), // Your background image path
            fit: BoxFit.contain, // Adjust how the image fills the screen
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the center with appropriate padding
            // Central image part
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  item.imagePath,
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjusted image size
                  height: MediaQuery.of(context).size.height *
                      0.4, // Adjusted image size
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title and Subtitle text
            Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: _buildTextSpans(
                      item.title,
                      'HydroSaveX', // The keyword to match
                      TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: dark ? SColors.white : Colors.black,
                      ),
                      Color(0xFF0C76B0), // The specific color for HydroSaveX
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between title and subtitle
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: _buildTextSpans(
                        item.subtitle,
                        'HydroSaveX', // The keyword to match
                        TextStyle(
                          fontSize: 16,
                          color: dark ? SColors.white : Color(0xFF6A6A6A),
                        ),
                        Color(0xFF0C76B0), // The specific color for HydroSaveX
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(), // Spacer to push the button to the bottom

            // Forward arrow button at the bottom center
          ],
        ),
      ),
    );
  }
}
