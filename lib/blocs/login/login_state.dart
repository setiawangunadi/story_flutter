part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class OnLoadingLogin extends LoginState {}

class OnSuccessLogin extends LoginState {}

class OnFailedLogin extends LoginState {
  final String message;
  final int? statusCode;

  OnFailedLogin({required this.message, this.statusCode});
}
