import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/home_view/details_screen.dart';

import '../../utils/constants/colors.dart';

class HomeScreenInto extends StatelessWidget {
  const HomeScreenInto({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final List<Map<String, String>> firstAidTopics = [
      {
        'title': AppLocalizations.of(context)!
            .rescue_breathing_for_drowning_victims_title,
        'videoUrl': 'https://www.youtube.com/watch?v=Hlrbio-NpxQ',
        'instruction': AppLocalizations.of(context)!
            .rescue_breathing_for_drowning_victims_instruction,
      },
      {
        'title':
            AppLocalizations.of(context)!.chest_compressions_in_drowning_title,
        'videoUrl': 'https://www.youtube.com/watch?v=DUaxt8OlT3o',
        'instruction': AppLocalizations.of(context)!
            .chest_compressions_in_drowning_instruction,
      },
      {
        'title': AppLocalizations.of(context)!
            .emergency_response_for_drowning_victims_title,
        'videoUrl': 'https://www.youtube.com/watch?v=TNFzH_b4svk',
        'instruction': AppLocalizations.of(context)!
            .emergency_response_for_drowning_victims_instruction,
      },
      {
        'title': AppLocalizations.of(context)!
            .checking_for_breathing_and_pulse_title,
        'videoUrl': 'https://www.youtube.com/watch?v=sS34gcZBX88',
        'instruction': AppLocalizations.of(context)!
            .checking_for_breathing_and_pulse_instruction,
      },
      {
        'title':
            AppLocalizations.of(context)!.dealing_with_secondary_drowning_title,
        'videoUrl': 'https://www.youtube.com/watch?v=ARoLSRrltI8',
        'instruction': AppLocalizations.of(context)!
            .dealing_with_secondary_drowning_instruction,
      },
      {
        'title':
            AppLocalizations.of(context)!.preventing_drowning_in_children_title,
        'videoUrl': 'https://www.youtube.com/watch?v=_FG0WEvFrhg',
        'instruction': AppLocalizations.of(context)!
            .preventing_drowning_in_children_instruction,
      },
      {
        'title':
            AppLocalizations.of(context)!.water_safety_best_practices_title,
        'videoUrl': 'https://www.youtube.com/watch?v=pDDWEqI45M4',
        'instruction': AppLocalizations.of(context)!
            .water_safety_best_practices_instruction,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.first_aid_for_drowning,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF1980B8),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Transform.scale(
            scale: 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF1980B8),
                  width: 1.8,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1980B8),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: firstAidTopics.length,
          itemBuilder: (context, index) {
            return Card(
              color: dark ? SColors.black : Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: firstAidTopics[index]['title']!,
                        videoUrl: firstAidTopics[index]['videoUrl']!,
                        instruction: firstAidTopics[index]['instruction']!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.safe_home,
                        color: Color(0xFF1980B8),
                        size: 40,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstAidTopics[index]['title']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1980B8),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              firstAidTopics[index]['instruction']!,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    dark ? SColors.white : Colors.grey.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      title: firstAidTopics[index]['title']!,
                                      videoUrl: firstAidTopics[index]
                                          ['videoUrl']!,
                                      instruction: firstAidTopics[index]
                                          ['instruction']!,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                backgroundColor: Color(0xFF1980B8),
                              ),
                              child:
                                  Text(AppLocalizations.of(context)!.show_more),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
