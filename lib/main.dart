import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:snapchat/middle_wares/db.dart';

import 'screens/home/home_screen.dart';

void main() {

  runApp(MaterialApp(supportedLocales: [
    const Locale('en', ''),
    const Locale('ru', ''),
  ], localizationsDelegates: [
    AppLocalizations.delegate, 
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ], home: HomeScreen()));
    DB.init();
}
