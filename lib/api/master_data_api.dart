// lib/api/master_data_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MasterDataApi {
  static const String baseUrl = "https://makazi.nono.co.tz";

  // =========================
  // GENERIC GET WITH ERROR HANDLING & CORS SUPPORT
  // =========================
  static Future<dynamic> _get(String endpoint) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      if (kDebugMode) {
        print('🔍 Fetching: $url');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // ✅ CORS headers for browser requests
          'Origin': baseUrl,
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet.');
        },
      );

      if (kDebugMode) {
        print('📡 Response status: ${response.statusCode}');
        print('📡 Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print('✅ Data fetched successfully from $endpoint');
        }
        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint not found: $endpoint');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ API Error for $endpoint: $e');
      }
      // Re-throw the error to be handled by the provider
      rethrow;
    }
  }

  // =========================
  // CATEGORIES
  // =========================
  static Future<List<dynamic>> getCategories() async {
    try {
      final data = await _get('/categories');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // AMENITIES
  // =========================
  static Future<List<dynamic>> getAmenities() async {
    try {
      final data = await _get('/amenities');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // REGIONS
  // =========================
  static Future<List<dynamic>> getRegions() async {
    try {
      final data = await _get('/regions');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // DISTRICTS
  // =========================
  static Future<List<dynamic>> getDistricts(int regionId) async {
    try {
      final data = await _get('/districts?region_id=$regionId');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // WARDS
  // =========================
  static Future<List<dynamic>> getWards(int districtId) async {
    try {
      final data = await _get('/wards?district_id=$districtId');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // PROPERTIES
  // =========================
  static Future<List<dynamic>> getProperties() async {
    try {
      final data = await _get('/properties');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getProperty(int id) async {
    try {
      final data = await _get('/properties/$id');
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getFeaturedProperties() async {
    try {
      final data = await _get('/properties/featured');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // AGENTS
  // =========================
  static Future<List<dynamic>> getAgents() async {
    try {
      final data = await _get('/agents');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // PROPERTY TYPES
  // =========================
  static Future<List<dynamic>> getPropertyTypes() async {
    try {
      final data = await _get('/property-types');
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      } else if (data is Map && data['results'] is List) {
        return data['results'];
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}