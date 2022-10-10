part of 'country_code_bloc.dart';

abstract class CountryCodeEvent {}

class SearchFieldEvent extends CountryCodeEvent {
  String query;
  List<Country> countries;
  SearchFieldEvent({required this.query,required this.countries});
}
 
