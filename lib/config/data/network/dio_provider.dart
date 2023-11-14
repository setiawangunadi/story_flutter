import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:story_app/config/data/local/constants.dart';

class DioProvider {
  final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  DioProvider._privateConstructor();

  static final DioProvider _instance = DioProvider._privateConstructor();

  factory DioProvider() => _instance;

  Future<Response> get({required String path}) async {
    try {
      final response = await dio.get('$baseUrl$path');
      return response;
    } catch (e) {
      throw Exception('Gagal melakukan permintaan GET: $e');
    }
  }

  Future<Response> post({required String path, dynamic data}) async {
    try {
      final response = await dio.post('$baseUrl$path', data: data);
      return response;
    } catch (e) {
      throw Exception('Gagal melakukan permintaan POST: $e');
    }
  }
}
