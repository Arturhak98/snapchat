part of 'user_change_bloc.dart';

abstract class UserChangeState {}


class UserChangeInitial extends UserChangeState {}

class ErrorAlertState extends UserChangeState{
  String error;
  ErrorAlertState ({required this.error});
}

class UserUpdateState extends UserChangeState{}

class FirstNameValidState extends UserChangeState {
  bool firstNameIsValid;
  FirstNameValidState({required this.firstNameIsValid});
}

class LastNameValidState extends UserChangeState {
  bool lastNameIsValid;
  LastNameValidState({required this.lastNameIsValid});
}

class BirthDayValidState extends UserChangeState {
  bool birthdayIsValid;
  BirthDayValidState({required this.birthdayIsValid});
}

class EmailValidState extends UserChangeState {
  bool emailIsValid;
  EmailValidState({required this.emailIsValid});
}

class PhoneValidState extends UserChangeState {
  bool phoneIsValid;
  PhoneValidState({required this.phoneIsValid});
}

class UserNameValidState extends UserChangeState {
  bool userNameIsValid;
  UserNameValidState({required this.userNameIsValid});
}

class PassValidState extends UserChangeState {
  bool passIsValid;
  PassValidState({required this.passIsValid});
}
