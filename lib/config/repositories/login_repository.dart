import 'package:dio/dio.dart';
import 'package:story_app/config/data/network/canonical_path.dart';
import 'package:story_app/config/data/network/service_network.dart';

class LoginRepository {
  Future<Response> doLogin(
      {required String email, required String password}) async {
    Object data = {"email": email, "password": password};
    final response = ServiceNetwork().post(
      path: CanonicalPath.login,
      data: data,
    );
    return response;
  }
}
