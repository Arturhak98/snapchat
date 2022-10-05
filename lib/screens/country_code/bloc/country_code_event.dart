part of 'country_code_bloc.dart';

abstract class CountryCodeEvent {}

class SelectCountryEvent extends CountryCodeEvent {
  int countryIndex;
  SelectCountryEvent({required this.countryIndex});
}

class SearchFieldEvent extends CountryCodeEvent {
  String query;
  SearchFieldEvent({required this.query});
}
 
 class CountryCodeScreenLoadEvent extends CountryCodeEvent{
  List<Country> countries;
  CountryCodeScreenLoadEvent({required this.countries});
 }
