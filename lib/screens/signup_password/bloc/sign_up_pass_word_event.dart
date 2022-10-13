part of 'sign_up_pass_word_bloc.dart';

abstract class SignUpPassWordEvent {}

class PassFieldEvent extends SignUpPassWordEvent {
  String pass;
  PassFieldEvent({required this.pass});
}