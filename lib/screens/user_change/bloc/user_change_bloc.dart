import 'package:bloc/bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

part 'user_change_event.dart';
part 'user_change_state.dart';

class UserChangeBloc extends Bloc<UserChangeEvent, UserChangeState> {
  ValidationRepository validationRepository;
  ApiRepository apiRepository;
  SqlDatabaseRepository sqlDatabaseRepository;
  UserChangeBloc(
      {required this.validationRepository,
      required this.apiRepository,
      required this.sqlDatabaseRepository})
      : super(UserChangeInitial()) {
    on<FirstNameFieldEvent>(_onFirstNameFieldEvent);
    on<LastNameFieldEvent>(_onLastNameFieldEvent);
    on<BirthDayChangeEvent>(_onBirthDayChangeEvent);
    on<EmailFieldEvent>(_onEmailFieldEvent);
    on<PhoneFieldEvent>(_onPhoneFieldEvent);
    on<UserNameFieldEvent>(_onUserNameFieldEvent);
    on<PassFieldEvent>(_onPassFieldEvent);
    on<EditButtonEvent>(_onEditButtonEvent);
    on<LoadEvent>(_onLoadEvent);
  }
  Future<void> _onLoadEvent(LoadEvent event, Emitter emit) async {
    final user = await sqlDatabaseRepository.getUser();
    emit(UserLoadedState(user: user));
  }

  Future<void> _onEditButtonEvent(EditButtonEvent event, Emitter emit) async {
    try {
      await apiRepository.editUser(event.user);
      /*  if (userIsUpDated == null) {
        emit(UserUpdateState());
        await sqlDatabaseRepository.editUser(event.user);
      } else {
        emit(ErrorAlertState(error: userIsUpDated));
      } */
    } catch (e) {
      emit(ErrorAlertState(error: e.toString()));
    }
  }

  void _onFirstNameFieldEvent(FirstNameFieldEvent event, Emitter emit) {
    emit(
      FirstNameValidState(
        firstNameIsValid: validationRepository.isNameValid(event.firstName),
      ),
    );
  }

  void _onLastNameFieldEvent(LastNameFieldEvent event, Emitter emit) {
    emit(
      LastNameValidState(
        lastNameIsValid: validationRepository.isNameValid(event.lastName),
      ),
    );
  }

  void _onBirthDayChangeEvent(BirthDayChangeEvent event, Emitter emit) {
    emit(
      BirthDayValidState(
        birthdayIsValid: validationRepository.isBirtDateValid(event.birthDay),
      ),
    );
  }

  void _onEmailFieldEvent(EmailFieldEvent event, Emitter emit) {
    emit(
      EmailValidState(
        emailIsValid: validationRepository.isEmailValid(event.email),
      ),
    );
  }

  void _onPhoneFieldEvent(PhoneFieldEvent event, Emitter emit) {
    emit(
      PhoneValidState(
        phoneIsValid: validationRepository.isNumberValid(event.phone),
      ),
    );
  }

  void _onUserNameFieldEvent(UserNameFieldEvent event, Emitter emit) {
    emit(
      UserNameValidState(
        userNameIsValid: validationRepository.isUsernameValid(event.userName),
      ),
    );
  }

  void _onPassFieldEvent(PassFieldEvent event, Emitter emit) {
    emit(
      PassValidState(
        passIsValid: validationRepository.isPassValid(event.pass),
      ),
    );
  }
}
