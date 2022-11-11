import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/realm_app.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/widgets/main_screen.dart';
//import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RealmApp.init('com.example.snapchat');

  LocalJsonLocalization.delegate.directories = ['assets/i18n/'];
  runApp(
    FirstScreen(
      prefs: await SharedPreferences.getInstance(),
    ),
  );
}
