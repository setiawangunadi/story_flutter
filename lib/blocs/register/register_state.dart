part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class OnLoadingRegister extends RegisterState {}

class OnSuccessRegister extends RegisterState {
  final Register data;

  OnSuccessRegister({required this.data});
}

class OnFailedRegister extends RegisterState {
  final String message;
  final int? statusCode;

  OnFailedRegister({required this.message, this.statusCode});
}
