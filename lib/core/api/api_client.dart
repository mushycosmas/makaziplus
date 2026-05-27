import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // =========================
    // LOGGING INTERCEPTOR
    // =========================
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // =========================
  // GET
  // =========================
  Future<Response> get(String path) async {
    try {
      return await dio.get(path);
    } on DioException catch (e) {
      _handleError("GET", e);
      rethrow;
    }
  }

  // =========================
  // POST (FIXED)
  // =========================
  Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      _handleError("POST", e);
      rethrow;
    }
  }

  // =========================
  // PATCH (FIXED)
  // =========================
  Future<Response> patch(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.patch(path, data: data);
    } on DioException catch (e) {
      _handleError("PATCH", e);
      rethrow;
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      _handleError("DELETE", e);
      rethrow;
    }
  }

  // =========================
  // ERROR HANDLER
  // =========================
  void _handleError(String method, DioException e) {
    if (kDebugMode) {
      debugPrint("❌ API $method ERROR:");
      debugPrint("Message: ${e.message}");
      debugPrint("Status: ${e.response?.statusCode}");
      debugPrint("Data: ${e.response?.data}");
    }
  }
}