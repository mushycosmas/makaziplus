import 'package:dio/dio.dart';
import '../config/env.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: Env.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  // GET request
  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  // POST request
  Future<Response> post(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }

  // PATCH request
  Future<Response> patch(String path, dynamic data) async {
    return await dio.patch(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}