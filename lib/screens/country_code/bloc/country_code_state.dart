part of 'country_code_bloc.dart';

abstract class CountryCodeState {}

class CountryCodeInitial extends CountryCodeState {}

class SearchCountriesState extends CountryCodeState {
  List<Country> filtredCountries;
  SearchCountriesState({required this.filtredCountries});
}
