import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/timer_provider.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class CustomTimerScreen extends StatefulWidget {
  const CustomTimerScreen({super.key});

  @override
  _CustomTimerScreenState createState() => _CustomTimerScreenState();
}

class _CustomTimerScreenState extends State<CustomTimerScreen> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  int _calculateTotalSeconds() {
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;
    return hours * 3600 + minutes * 60 + seconds;
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer", style: TextStyle(fontSize: 28)),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(timerProvider.totalSeconds),
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            // Input fields for hours, minutes, and seconds
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours input field
                buildTextField(context, 'Hours', _hoursController),
                SizedBox(width: 10),
                buildTextField(context, 'Minutes', _minutesController),
                SizedBox(width: 10),
                buildTextField(context, 'Seconds', _secondsController),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timerProvider.isRunning
                      ? null
                      : () {
                          int totalSeconds = _calculateTotalSeconds();
                          timerProvider.startTimer(totalSeconds);
                        },
                  child: Text("Start"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      timerProvider.isRunning ? timerProvider.stopTimer : null,
                  child: Text("Stop"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: timerProvider.resetTimer,
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    final dark = SHelperFunctions.isDarkMode(context);
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: dark ? SColors.dark : Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF1980B8), width: 1.5),
          ),
        ),
      ),
    );
  }

  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
