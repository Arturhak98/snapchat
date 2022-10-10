part of 'sign_up_pass_word_bloc.dart';

abstract class SignUpPassWordEvent {}
/* class NextButtonEvent extends SignUpPassWordEvent {} */

class PassFieldEvent extends SignUpPassWordEvent {
  String pass;
  PassFieldEvent({required this.pass});
}
/* class HidePassEvent extends SignUpPassWordEvent{
  bool hidepass;
  HidePassEvent({required this.hidepass});
} */