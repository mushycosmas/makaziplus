// lib/api/property_manage_api.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

class PropertyManageApi {
  static const String baseUrl = "https://makazi.nono.co.tz";

  // =========================
  // PRIVATE HELPERS
  // =========================
  static Future<http.Response> _get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> _post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> _put(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> _delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // CREATE PROPERTY WITH IMAGES
  // =========================
  static Future<Map<String, dynamic>> createProperty(
    Map<String, dynamic> data,
    List<File> images, {
    String? token,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/properties");
      
      final request = http.MultipartRequest('POST', url);
      
      // Add text fields
      data.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Add authorization header
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add images
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        final extension = mimeType.split('/').last;
        
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          file.path,
          contentType: MediaType.parse(mimeType),
          filename: 'property_${DateTime.now().millisecondsSinceEpoch}_$i.$extension',
        );
        request.files.add(multipartFile);
      }

      if (kDebugMode) {
        print('📤 Submitting property with ${images.length} images');
        print('📤 Data: $data');
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: $responseBody');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': decodedResponse,
          'message': 'Property created successfully',
        };
      } else {
        return {
          'success': false,
          'message': decodedResponse['message'] ?? 'Failed to create property',
          'errors': decodedResponse['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating property: $e');
      }
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // GET ALL PROPERTIES
  // =========================
  static Future<Map<String, dynamic>> getProperties({
    int page = 1,
    int limit = 20,
    String? status,
    String? type,
    String? search,
    String? token,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (type != null) 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/properties${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
          'total': data['total'] ?? 0,
          'page': data['page'] ?? page,
          'lastPage': data['lastPage'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch properties',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // GET SINGLE PROPERTY
  // =========================
  static Future<Map<String, dynamic>> getProperty(int id, {String? token}) async {
    try {
      final response = await _get('/properties/$id', token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Property not found',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch property',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // GET PROPERTIES BY USER
  // =========================
  static Future<Map<String, dynamic>> getUserProperties(
    int userId, {
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/users/$userId/properties${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
          'total': data['total'] ?? 0,
          'page': data['page'] ?? page,
          'lastPage': data['lastPage'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch user properties',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // UPDATE PROPERTY
  // =========================
  static Future<Map<String, dynamic>> updateProperty(
    int id,
    Map<String, dynamic> data, {
    List<File>? images,
    String? token,
  }) async {
    try {
      if (images != null && images.isNotEmpty) {
        // Update with images (multipart)
        final url = Uri.parse("$baseUrl/properties/$id");
        final request = http.MultipartRequest('PUT', url);
        
        data.forEach((key, value) {
          if (value != null) {
            if (value is List) {
              request.fields[key] = jsonEncode(value);
            } else {
              request.fields[key] = value.toString();
            }
          }
        });

        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
          
          final multipartFile = await http.MultipartFile.fromPath(
            'images',
            file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartFile);
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'data': decodedResponse,
            'message': 'Property updated successfully',
          };
        } else {
          return {
            'success': false,
            'message': decodedResponse['message'] ?? 'Failed to update property',
          };
        }
      } else {
        // Update without images (JSON)
        final response = await _put('/properties/$id', data, token: token);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
            'message': 'Property updated successfully',
          };
        } else {
          return {
            'success': false,
            'message': 'Failed to update property',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // DELETE PROPERTY
  // =========================
  static Future<Map<String, dynamic>> deleteProperty(int id, {String? token}) async {
    try {
      final response = await _delete('/properties/$id', token: token);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Property deleted successfully',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Property not found',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete property',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // CHANGE PROPERTY STATUS
  // =========================
  static Future<Map<String, dynamic>> changePropertyStatus(
    int id,
    String status, {
    String? token,
  }) async {
    try {
      final data = {'status': status};
      final response = await _patch('/properties/$id/status', data, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Property status updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update property status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<http.Response> _patch(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // GET FEATURED PROPERTIES
  // =========================
  static Future<Map<String, dynamic>> getFeaturedProperties({String? token}) async {
    try {
      final response = await _get('/properties/featured', token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch featured properties',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // SEARCH PROPERTIES
  // =========================
  static Future<Map<String, dynamic>> searchProperties({
    required String query,
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/properties/search?$queryString';
      
      final response = await _get(endpoint, token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
          'total': data['total'] ?? 0,
          'page': data['page'] ?? page,
          'lastPage': data['lastPage'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to search properties',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // UPLOAD PROPERTY IMAGES
  // =========================
  static Future<Map<String, dynamic>> uploadPropertyImages(
    int propertyId,
    List<File> images, {
    String? token,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/properties/$propertyId/images");
      final request = http.MultipartRequest('POST', url);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          file.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': decodedResponse,
          'message': 'Images uploaded successfully',
        };
      } else {
        return {
          'success': false,
          'message': decodedResponse['message'] ?? 'Failed to upload images',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // DELETE PROPERTY IMAGE
  // =========================
  static Future<Map<String, dynamic>> deletePropertyImage(
    int propertyId,
    int imageId, {
    String? token,
  }) async {
    try {
      final response = await _delete('/properties/$propertyId/images/$imageId', token: token);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Image deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete image',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // =========================
  // GET PROPERTY STATISTICS
  // =========================
  static Future<Map<String, dynamic>> getPropertyStats({String? token}) async {
    try {
      final response = await _get('/properties/stats', token: token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch property statistics',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}