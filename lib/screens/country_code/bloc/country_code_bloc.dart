import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';


part 'country_code_event.dart';
part 'country_code_state.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {
  List<Country> _filtredCountres=[], _countries=[];
  CountryCodeBloc() : super(CountryCodeInitial()) {
    on<CountryCodeScreenLoadEvent>(_onCountryCodeScreenLoadEvent);
    on<SelectCountryEvent>(_onSelectCountryEvent);
    on<SearchFieldEvent>(_onSearchFieldEvent);
  }
  void _onCountryCodeScreenLoadEvent(CountryCodeScreenLoadEvent event, Emitter emit) {
    _countries = event.countries;
    _filtredCountres = event.countries;
  }

  void _onSelectCountryEvent(SelectCountryEvent event, Emitter emit) {
    emit(SelectCountryState(
        selectedCountry: _filtredCountres[event.countryIndex]));
  }

  void _onSearchFieldEvent(SearchFieldEvent event, Emitter emit) {
    if (event.query.isNotEmpty) {
      _filtredCountres = _countries.where((Country country) {
        return country.CountryName.toLowerCase()
            .contains(event.query.toLowerCase());
      }).toList();
    } else {
      _filtredCountres = _countries;
    }
    emit(SearchCountriesState(filtredCountries: _filtredCountres));
  }
}
