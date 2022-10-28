import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/screens/user/user_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //final _firstScreen=ScreenWidgetNotifer();
  final _screenNotifier = ValueNotifier<Widget?>(null);
  _checkLoginUser(_screenNotifier);
/*   _checkLoginUser().then((value) {
    if (value) {
      //_firstScreen.changeScreen(UserScreen(user: User()));
      // _firstScreen = UserScreen(user: User());
      //_screenNotifer.value = UserScreen(user: User());
    } else {
      //_firstScreen.changeScreen(const HomeScreen());// = const HomeScreen();
     // _screenNotifer.value = const HomeScreen();
    }
  }); */
  //final screen=Provider.of(context)
  LocalJsonLocalization.delegate.directories = ['lib/i18n'];
  runApp(
    ValueListenableBuilder(
      valueListenable: _screenNotifier,
      builder: ((context, value, child) {
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
          home: _screenNotifier.value,
        );
      }),
    ),
  );
}

Future<void> _checkLoginUser(ValueNotifier notifier) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString('token') != null) {
    notifier.value = UserScreen(user: await SqlDatabaseRepository().getUser());
  } else {
    notifier.value = const HomeScreen();
   // return false;
  }
}
