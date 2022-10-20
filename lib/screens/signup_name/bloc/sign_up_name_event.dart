part of 'sign_up_name_block.dart';

abstract class SignUpNameEvent {}

class NameFieldEvent extends SignUpNameEvent {
  String name;
  NameFieldEvent({required this.name});
}

class LastNameFieldEvent extends SignUpNameEvent {
  String lastName;
  LastNameFieldEvent({required this.lastName});
}
