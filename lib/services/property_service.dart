import 'package:dio/dio.dart';
import '../models/property_model.dart';

class PropertyService {
  final Dio dio;

  PropertyService({required this.dio});

  /// GET ALL
  Future<List<Property>> fetchProperties() async {
    try {
      final Response response = await dio.get('/properties');

      final data = response.data;

      List list;

      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      } else {
        throw Exception("Invalid API response");
      }

      return list.map((e) => Property.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to fetch properties");
    }
  }

  /// GET ONE
  Future<Property> fetchPropertyById(int id) async {
    try {
      final Response response = await dio.get('/properties/$id');

      final data = response.data;

      return Property.fromJson(
        data is Map && data['data'] != null ? data['data'] : data,
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to fetch property");
    }
  }

  /// CREATE
  Future<Property> createProperty(Map<String, dynamic> body) async {
    try {
      final Response response = await dio.post('/properties', data: body);

      final data = response.data;

      return Property.fromJson(
        data is Map && data['data'] != null ? data['data'] : data,
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to create property");
    }
  }

  /// UPDATE
  Future<Property> updateProperty(int id, Map<String, dynamic> body) async {
    try {
      final Response response =
          await dio.patch('/properties/$id', data: body);

      final data = response.data;

      return Property.fromJson(
        data is Map && data['data'] != null ? data['data'] : data,
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to update property");
    }
  }

  /// DELETE
  Future<void> deleteProperty(int id) async {
    try {
      await dio.delete('/properties/$id');
    } on DioException catch (e) {
      throw Exception(e.message ?? "Failed to delete property");
    }
  }
}