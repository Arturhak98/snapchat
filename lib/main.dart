import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/widgets/main_screen.dart';

GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalJsonLocalization.delegate.directories = ['assets/i18n/'];
  runApp(
    FirstScreen(
      prefs: await SharedPreferences.getInstance(),
    ),
  );
}
