import 'package:dio/dio.dart';
import 'package:story_app/config/data/network/canonical_path.dart';
import 'package:story_app/config/data/network/service_network.dart';

class RegisterRepository {
  Future<Response> doRegister(
      {required String name,
      required String email,
      required String password}) async {
    Object data = {"name": name, "email": email, "password": password};

    final response = ServiceNetwork().post(
      path: CanonicalPath.register,
      data: data,
    );
    return response;
  }
}
