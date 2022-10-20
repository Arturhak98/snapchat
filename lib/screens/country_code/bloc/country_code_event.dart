part of 'country_code_bloc.dart';

abstract class CountryCodeEvent {}

class SearchFieldEvent extends CountryCodeEvent {
  String query;
  SearchFieldEvent({required this.query});
}
