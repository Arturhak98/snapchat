import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

final TitleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

final FieldTitleStyle =
    const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400);

final SearchFieldBorderStyle = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: const BorderSide(width: 1, color: Colors.grey),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: const BorderSide(width: 1, color: Colors.grey),
  ),
  prefixIcon: const Icon(Icons.search),
  labelText: 'search'.i18n(),
  labelStyle: const TextStyle(fontSize: 15),
);
