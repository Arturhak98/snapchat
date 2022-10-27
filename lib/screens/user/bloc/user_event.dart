part of 'user_bloc.dart';

abstract class UserEvent {}
class UserScreenLoadEvent extends UserEvent{}
class LogOutEvent extends UserEvent{}
class DeleteEvent extends UserEvent{}