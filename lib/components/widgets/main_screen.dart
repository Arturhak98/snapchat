
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/screens/home/home_screen.dart';
import 'package:snapchat/screens/user/user_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({
    required this.prefs,
  });
  final SharedPreferences prefs;
  @override
  State<FirstScreen> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      navigatorKey: GlobalKey<NavigatorState>(),
      home: widget.prefs.getString('token') != null
          ? const UserScreen()
          : const HomeScreen(),
    );
  }

  void reloadApp() {
    setState(() {});
  }
}