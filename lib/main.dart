import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home/home_screen.dart';

void main() {

  runApp( const MaterialApp(supportedLocales: [
   Locale('en', ''),
  Locale('ru', ''),
  ], localizationsDelegates: [
    AppLocalizations.delegate, 
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ], home: HomeScreen()));
  
}
