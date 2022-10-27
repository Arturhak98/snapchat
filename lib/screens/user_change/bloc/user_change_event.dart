part of 'user_change_bloc.dart';

abstract class UserChangeEvent {}
class EditButtonEvent extends UserChangeEvent{
  User user;
  EditButtonEvent({required this.user});
}

class FirstNameFieldEvent extends UserChangeEvent{
  String firstName;
  FirstNameFieldEvent({required this.firstName});
}

class LastNameFieldEvent extends UserChangeEvent{
  String lastName;
  LastNameFieldEvent({required this.lastName});
}

class BirthDayChangeEvent extends UserChangeEvent{
  DateTime birthDay;
  BirthDayChangeEvent({required this.birthDay});
}

class EmailFieldEvent extends UserChangeEvent{
  String email;
  EmailFieldEvent({required this.email});
}

class PhoneFieldEvent extends UserChangeEvent{
  String phone;
  PhoneFieldEvent({required this.phone});
}

class UserNameFieldEvent extends UserChangeEvent{
  String userName;
  UserNameFieldEvent({required this.userName});
}

class PassFieldEvent extends UserChangeEvent{
  String pass;
  PassFieldEvent({required this.pass});
}