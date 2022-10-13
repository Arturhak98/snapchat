import 'package:bloc/bloc.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'sign_up_pass_word_event.dart';
part 'sign_up_pass_word_state.dart';

class SignUpPassWordBloc extends Bloc<SignUpPassWordEvent, SignUpPassWordState> {
  ValidationRepository validation;
  SignUpPassWordBloc({required this.validation}) : super(SignUpPassWordInitial()) {
    on<PassFieldEvent>(_onPassFieldEvent);
  }
  void _onPassFieldEvent(PassFieldEvent event, Emitter emit){
    emit(UpdatePassValid(isPassValid:validation.isPassValid(event.pass)));
  }

}
