import 'package:flutter/material.dart';
import 'package:hydrosavex/view/my_app.dart';
import 'package:hydrosavex/view/onboarding_screen/widgets/dashed_circular_progress_painter.dart';

class CustomNextButton extends StatelessWidget {
  final PageController controller;
  final int page;
  final int totalPages;
  final Function(bool) showAnimatedContainerCallBack;

  const CustomNextButton({
    super.key,
    required this.controller,
    required this.page,
    required this.totalPages,
    required this.showAnimatedContainerCallBack,
  });

  @override
  Widget build(BuildContext context) {
    double defaultSize =
        15; // Default size for the button and progress indicator
    return SizedBox(
      width: defaultSize * 5, // Outer container size for the segmented circle
      height: defaultSize * 5,
      child: Stack(
        alignment:
            Alignment.center, // Align button and progress circle in the center
        children: [
          // Outer segmented circular progress
          CustomPaint(
            size: Size(defaultSize * 5, defaultSize * 5),
            painter: SegmentedCircularProgressPainter(
              progress: (page + 1) / (totalPages + 1), // Progress calculation
              color: Colors.blue, // Customize the color of the segmented ring
              strokeWidth: 4.0, // Thickness of the segments
              segments:
                  totalPages, // Number of segments corresponding to total pages
            ),
          ),
          // Centered button inside the segmented progress circle
          Center(
            child: InkWell(
              onTap: () {
                if (page == totalPages - 1) {
                  // If on the last page, navigate to AuthStream
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthStream()), // Navigate to AuthStream
                  );
                } else {
                  // If not on the last page, go to the next page
                  controller.animateToPage(
                    page + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCirc,
                  );
                  showAnimatedContainerCallBack(false); // Custom logic
                }
              },
              child: Container(
                width: defaultSize * 3.5, // Inner button size
                height: defaultSize * 3.5,
                decoration: BoxDecoration(
                  color: Colors.blue, // Customize the button color
                  borderRadius: BorderRadius.all(
                      Radius.circular(100.0)), // Circular button
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white, // Customize icon color
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
