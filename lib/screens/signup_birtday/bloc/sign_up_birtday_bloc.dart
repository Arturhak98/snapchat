import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

part 'sign_up_birtday_event.dart';
part 'sign_up_birtday_state.dart';

class SignUpBirtdayBloc extends Bloc<SignUpBirtdayEvent, SignUpBirtdayState> {
  late DateTime _selectedate;
  SignUpBirtdayBloc() : super(SignUpBirtdayInitial()) {
    on<SignUpBirtdayLoadEvent>(_onSignUpBirtdayLoadEvent);
    on<DatePickerEvent>(_onDatePickerEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }
  
  void _onSignUpBirtdayLoadEvent(SignUpBirtdayLoadEvent event, Emitter emit) {
    final now = DateTime.now();
    _selectedate = DateTime(now.year - 16, now.month, now.day);
    final _selectDateText = DateFormat.yMMMMd().format(_selectedate);
    emit(SetDateState(birtday: _selectedate, birtdayText: _selectDateText));
  }

  void _onDatePickerEvent(DatePickerEvent event, Emitter emit) {
    final _selectDateText = DateFormat.yMMMMd().format(event.SelectDate);
    _selectedate = event.SelectDate;
    emit(UpdateBirtdayValid(
        birtdayValid: _isValid, seleqtedDate: _selectDateText));
  }

  void _onNextButtonEvent(NextButtonEvent event, Emitter emit) {
    emit(UpdateUserState(birtday: _selectedate));
  }

  bool get _isValid {
    if (DateTime.now().difference(_selectedate).inDays > 5843) {
      return true;
    }
    return false;
  }
}
