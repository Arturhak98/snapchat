import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
part 'country_code_event.dart';
part 'country_code_state.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {

  CountryCodeBloc() : super(CountryCodeInitial()) {
    on<SearchFieldEvent>(_onSearchFieldEvent);
  }

 Future<void> _onSearchFieldEvent(SearchFieldEvent event, Emitter emit)async {
    final sqlRepository=SqlDatabaseRepository();
    final filtredCountres=await sqlRepository.getCountries(event.query);
    emit(SearchCountriesState(filtredCountries: filtredCountres));
  }
}
