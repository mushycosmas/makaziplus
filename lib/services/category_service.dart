import 'package:dio/dio.dart';
import '../models/category_model.dart';

class CategoryService {
  final Dio dio;

  CategoryService({required this.dio});

  /// 🔹 Fetch all categories from API
  Future<List<Category>> fetchCategories() async {
    try {
      final Response response = await dio.get('/categories');

      final data = response.data;

      /// If API returns raw list: [ ... ]
      if (data is List) {
        return data.map((json) => Category.fromJson(json)).toList();
      }

      /// If API returns wrapped response: { data: [ ... ] }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }

      throw Exception('Invalid API response format');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch categories',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🔹 Optional: fetch single category
  Future<Category> fetchCategoryById(int id) async {
    try {
      final Response response = await dio.get('/categories/$id');

      final data = response.data;

      if (data is Map && data['data'] != null) {
        return Category.fromJson(data['data']);
      }

      return Category.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch category',
      );
    }
  }

  /// 🔹 Optional: create category (admin use)
  Future<Category> createCategory(Map<String, dynamic> body) async {
    try {
      final response = await dio.post('/categories', data: body);

      final data = response.data;

      if (data is Map && data['data'] != null) {
        return Category.fromJson(data['data']);
      }

      return Category.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to create category',
      );
    }
  }
}