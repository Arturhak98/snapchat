import 'package:bloc/bloc.dart';
part 'sign_up_birtday_event.dart';
part 'sign_up_birtday_state.dart';

class SignUpBirtdayBloc extends Bloc<SignUpBirtdayEvent, SignUpBirtdayState> {
  SignUpBirtdayBloc() : super(SignUpBirtdayInitial()) {
    on<DatePickerEvent>(_onDatePickerEvent);
  }
  
  void _onDatePickerEvent(DatePickerEvent event, Emitter emit) {
    emit(UpdateBirtdayValid(
        birtdayValid: _isValid(event.selectDate),));
  }


  bool _isValid(DateTime selectDate) {
    if (DateTime.now().difference(selectDate).inDays > 5843) {
      return true;
    }
    return false;
  }
}
