import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
part 'country_code_event.dart';
part 'country_code_state.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {

  CountryCodeBloc() : super(CountryCodeInitial()) {
    on<SearchFieldEvent>(_onSearchFieldEvent);
  }

  void _onSearchFieldEvent(SearchFieldEvent event, Emitter emit) {
    List<Country> filtredCountres;
    if (event.query.isNotEmpty) {
      filtredCountres = event.countries.where((Country country) {
        return country.CountryName.toLowerCase()
            .contains(event.query.toLowerCase());
      }).toList();
    } else {
      filtredCountres = event.countries;
    }
    emit(SearchCountriesState(filtredCountries: filtredCountres));
  }
}
