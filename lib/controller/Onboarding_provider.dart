import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage(PageController controller) {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Logic to show "Skip" and "Back" only on second and third page
  bool shouldShowControls() {
    return _currentIndex == 1 || _currentIndex == 2; // Show only on pages 1 and 2
  }

  void skip(PageController controller) {
    controller.jumpToPage(2); // Skips to the last page (third page in this case)
  }
}
