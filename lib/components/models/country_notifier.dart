import 'package:flutter/material.dart';
import 'package:snapchat/components/models/country_code.dart';

class CountryNotifier extends ChangeNotifier {
  Country country = Country();
  set changeCountry(country) {
    this.country = country;
    notifyListeners();
  }
/*    changeCountry(Country country)set {
    this.country.CountryCode = country.CountryCode;
    this.country.CountryName = country.CountryName;
    this.country.CountryCodeString = country.CountryCodeString;
    notifyListeners(); */

  /*  } */
}
