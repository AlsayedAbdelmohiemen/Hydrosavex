import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;

  void startTimer(int totalSeconds) {
    _totalSeconds = totalSeconds;
    _isRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        _totalSeconds--;
        notifyListeners();
      } else {
        _playSound();
        stopTimer();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _totalSeconds = 0;
    notifyListeners();
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('Sounds/alarm.mp3'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
