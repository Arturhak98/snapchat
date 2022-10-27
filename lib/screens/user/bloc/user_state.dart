part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}
class LogOutState extends UserState{}
class DeleteState extends UserState{}
class ScreenLoadedState extends UserState{
  User user;
  ScreenLoadedState({required this.user});
}
class ShowErrorAler extends UserState{
  String error;
  ShowErrorAler({required this.error});
}
