import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/Onboarding_provider.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/view/onboarding_screen/onboarding_screen.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/Onboarding_item.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/custom_back_button.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/custom_next_button.dart';
import 'package:provider/provider.dart';

class OnboardingPageView extends StatelessWidget {
  final List<OnboardingItem> onboardingItems;
  static const String routeName = "onboarding";

  const OnboardingPageView({super.key, required this.onboardingItems});

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    final PageController controller = PageController();

    return Scaffold(
      body: Stack(
        children: [
          // The PageView for the onboarding content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (onboardingProvider.currentIndex >
                        0) // Show Back on second (1) and third (2) pages
                      CustomBackButton(
                        onPressed: () {
                          // Go back to the previous page
                          if (onboardingProvider.currentIndex > 0) {
                            controller.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      )
                    else
                      SizedBox(
                          width:
                              48), // Add space to align Skip on first page (no Back)

                    if (onboardingProvider.currentIndex <
                        2) // Hide Skip on the third page
                      TextButton(
                        onPressed: () => onboardingProvider.skip(controller),
                        child: Text(
                          AppLocalizations.of(context)!.skip,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                          width:
                              48), // Add space to keep layout aligned when Skip is hidden
                  ],
                ),
              ),

              // Onboarding content (image + text)
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    onboardingProvider.setCurrentIndex(index);
                  },
                  itemCount: onboardingItems.length,
                  itemBuilder: (context, index) {
                    return OnboardingScreen(item: onboardingItems[index]);
                  },
                ),
              ),
            ],
          ),

          // Custom Next Button with progress and navigation
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CustomNextButton(
                controller: controller,
                page: onboardingProvider.currentIndex,
                totalPages: onboardingItems.length,
                showAnimatedContainerCallBack: (bool show) {
                  // Define your custom logic here
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
