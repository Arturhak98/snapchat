import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
part 'sign_up_birtday_event.dart';
part 'sign_up_birtday_state.dart';

class SignUpBirtdayBloc extends Bloc<SignUpBirtdayEvent, SignUpBirtdayState> {
  ValidationRepository validation;
  SignUpBirtdayBloc({required this.validation})
      : super(SignUpBirtdayInitial()) {
    on<DatePickerEvent>(_onDatePickerEvent);
  }

  void _onDatePickerEvent(DatePickerEvent event, Emitter emit) {
    emit(UpdateBirtdayValid(
      birtdayValid: validation.isBirtDateValid(event.selectDate),
    ));
  }
}
