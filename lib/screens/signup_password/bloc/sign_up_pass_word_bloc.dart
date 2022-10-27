import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'sign_up_pass_word_event.dart';
part 'sign_up_pass_word_state.dart';

class SignUpPassWordBloc extends Bloc<SignUpPassWordEvent, SignUpPassWordState> {
  ValidationRepository validation;
  ApiRepository apiRepository;
  SqlDatabaseRepository sqlDatabaseRepository;
  SignUpPassWordBloc({required this.validation,required this.apiRepository,required this.sqlDatabaseRepository}) : super(SignUpPassWordInitial()) {
    on<PassFieldEvent>(_onPassFieldEvent);
    on<NextButtonEvent>(_onNextButtonEvent);
  }
  Future<void> _onNextButtonEvent(NextButtonEvent event,Emitter emit)async{
   final userAdded=await apiRepository.addUser(event.user);
   if(userAdded){
    sqlDatabaseRepository.insert(event.user);
    emit(UserAddedState());
   }
   else{
    emit(ErrorAlertState());
   }
  }
  void _onPassFieldEvent(PassFieldEvent event, Emitter emit){
    emit(UpdatePassValid(isPassValid:validation.isPassValid(event.pass)));
  }

}
