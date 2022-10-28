import 'package:flutter/material.dart';

class ScreenWidgetNotifer extends ChangeNotifier {
  Widget? firstScreen;
  void changeScreen(Widget screen) {
    firstScreen = screen;
    notifyListeners();
  }
}
