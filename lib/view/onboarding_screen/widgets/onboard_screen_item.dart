import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/view/onboarding_screen/widgets/Onboarding_item.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/Onboarding_page_view.dart';

class OnboardScreenItem extends StatelessWidget {
  const OnboardScreenItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingPageView(
      onboardingItems: [
        OnboardingItem(
          title: AppLocalizations.of(context)!.title_welcome,
          subtitle: AppLocalizations.of(context)!.subtitle_welcome,
          imagePath: "assets/images/Frame 963.png",
        ),
        OnboardingItem(
          title: AppLocalizations.of(context)!.title_safety,
          subtitle: AppLocalizations.of(context)!.subtitle_safety,
          imagePath: "assets/images/Frame 965.png",
        ),
        OnboardingItem(
          title: AppLocalizations.of(context)!.title_control,
          subtitle: AppLocalizations.of(context)!.subtitle_control,
          imagePath: "assets/images/Frame 936.png",
        ),
      ],
    );
  }
}
