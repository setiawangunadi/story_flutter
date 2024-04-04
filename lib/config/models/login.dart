import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/config/models/login_result.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  Login(this.error, this.message, this.loginResult);

  bool error;
  String message;
  LoginResult loginResult;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}