part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class DoRegister extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  DoRegister({
    required this.name,
    required this.email,
    required this.password,
  });
}
