import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'screens/home/home_screen.dart';

void main() {
  LocalJsonLocalization.delegate.directories = ['lib/i18n'];
  runApp(MaterialApp(supportedLocales: [
    const Locale('en', ''),
    const Locale('ru', ''),
  ], localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    LocalJsonLocalization.delegate,
  ], home: const HomeScreen()));
}
