import 'package:dio/dio.dart';
import 'package:story_app/config/data/network/canonical_path.dart';
import 'package:story_app/config/data/network/dio_provider.dart';

class RegisterRepository {
  Future<Response> doRegister(
      {required String name,
      required String email,
      required String password}) async {
    Object data = {"name": name, "email": email, "password": password};

    final response = DioProvider().post(
      path: CanonicalPath.register,
      data: data,
    );
    return response;
  }
}
