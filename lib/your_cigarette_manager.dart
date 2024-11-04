import 'package:flutter/material.dart';
import 'your_cigarette_manager.dart'; // استيراد الكلاس من الملف الموحد


// your_cigarette_manager.dart
class YourCigaretteManager {
  Duration passedTime;

  YourCigaretteManager({this.passedTime = const Duration()});

  Duration calculatePassedTime() {
    return passedTime;
  }

  void updatePassedTime(Duration newTime) {
    passedTime = newTime;
  }
}
