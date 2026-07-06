// lib/api/user_property_favorite_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class UserPropertyFavoriteApi {
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

  static Future<http.Response> _post(String endpoint, {String? token, Map<String, dynamic>? body}) async {
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
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> _delete(String endpoint, {String? token, Map<String, dynamic>? body}) async {
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
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // CHECK IF PROPERTY IS IN FAVORITES (SIMPLE)
  // =========================
  /// Check if property is in favorites - returns bool directly
  static Future<bool> isFavorite(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      final response = await _get(
        '/favorites/$userId/$propertyId',
        token: token,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("isFavorite error: $e");
      return false;
    }
  }

  // =========================
  // ADD PROPERTY TO FAVORITES
  // =========================
  /// Add a property to user's favorites
  /// Endpoint: POST /favorites/{userId}/{propertyId}
  static Future<Map<String, dynamic>> addFavorite(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 Adding favorite - User: $userId, Property: $propertyId');
      }

      final response = await _post(
        '/favorites/$userId/$propertyId',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Property added to favorites successfully',
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message': 'Property already in favorites',
          'alreadyFavorited': true,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to add favorite',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding favorite: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // REMOVE PROPERTY FROM FAVORITES
  // =========================
  /// Remove a property from user's favorites
  /// Endpoint: DELETE /favorites/{userId}/{propertyId}
  static Future<Map<String, dynamic>> removeFavorite(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🗑️ Removing favorite - User: $userId, Property: $propertyId');
      }

      final response = await _delete(
        '/favorites/$userId/$propertyId',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Property removed from favorites successfully',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Favorite not found',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to remove favorite',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error removing favorite: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // GET USER FAVORITES (RETURNS MAP)
  // =========================
  /// Get all favorite properties for a user
  /// Endpoint: GET /favorites/user/{userId}
  static Future<Map<String, dynamic>> getUserFavorites(
    int userId, {
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('📥 Fetching favorites for user: $userId');
      }

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/favorites/user/$userId${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _get(endpoint, token: token);

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle different response structures
        List<dynamic> favorites = [];
        int total = 0;
        int currentPage = page;
        int lastPage = 0;

        if (data['data'] != null) {
          if (data['data'] is List) {
            favorites = data['data'];
          } else if (data['data']['data'] != null) {
            favorites = data['data']['data'] as List;
            total = data['data']['total'] ?? data['total'] ?? 0;
            currentPage = data['data']['page'] ?? data['page'] ?? page;
            lastPage = data['data']['lastPage'] ?? data['lastPage'] ?? 0;
          } else {
            favorites = data['data'] as List? ?? [];
            total = data['total'] ?? favorites.length;
          }
        } else if (data is List) {
          favorites = data;
          total = data.length;
        } else if (data['favorites'] != null) {
          favorites = data['favorites'] as List;
          total = data['total'] ?? favorites.length;
        } else {
          favorites = data['items'] as List? ?? [];
          total = data['total'] ?? favorites.length;
        }

        return {
          'success': true,
          'data': favorites,
          'total': total,
          'page': currentPage,
          'lastPage': lastPage,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch favorites',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching favorites: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': [],
        'total': 0,
      };
    }
  }

  // =========================
  // GET USER FAVORITES AS LIST (FIXED)
  // =========================
  /// Get all favorite properties for a user as a List
  /// Returns List<Map<String, dynamic>> directly
  static Future<List<Map<String, dynamic>>> getUserFavoritesList(
    int userId, {
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      final result = await getUserFavorites(
        userId,
        page: page,
        limit: limit,
        token: token,
      );

      if (result['success'] == true) {
        final List<dynamic> data = result['data'] ?? [];
        return data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error getting favorites list: $e");
      return [];
    }
  }

  // =========================
  // GET FAVORITE PROPERTY IDS (NEW)
  // =========================
  /// Get just the property IDs from user favorites
  static Future<List<int>> getUserFavoritePropertyIds(
    int userId, {
    String? token,
  }) async {
    try {
      final result = await getUserFavorites(userId, token: token);
      
      if (result['success'] == true) {
        final List<dynamic> favorites = result['data'] ?? [];
        return favorites
            .map((item) => item['propertyId'] as int)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error getting favorite property IDs: $e");
      return [];
    }
  }

  // =========================
  // CHECK IF PROPERTY IS FAVORITED (DETAILED)
  // =========================
  /// Check if a specific property is in user's favorites
  /// Endpoint: GET /favorites/check/{userId}/{propertyId}
  static Future<Map<String, dynamic>> isPropertyFavorited(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🔍 Checking favorite status - User: $userId, Property: $propertyId');
      }

      final response = await _get(
        '/favorites/check/$userId/$propertyId',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'isFavorited': data['isFavorited'] ?? data['exists'] ?? false,
          'data': data,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'isFavorited': false,
          'message': data['message'] ?? 'Failed to check favorite status',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking favorite: $e');
      }
      return {
        'success': false,
        'isFavorited': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // IS FAVORITED (SIMPLE BOOL)
  // =========================
  /// Simplified method to check if property is favorited
  /// Returns bool directly
  static Future<bool> isFavoritedSimple(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      final result = await isPropertyFavorited(
        userId, 
        propertyId,
        token: token,
      );
      return result['isFavorited'] ?? false;
    } catch (e) {
      debugPrint("Error checking if favorited: $e");
      return false;
    }
  }

  // =========================
  // GET FAVORITE COUNT
  // =========================
  /// Get total number of favorites for a property
  /// Endpoint: GET /favorites/count/{propertyId}
  static Future<Map<String, dynamic>> getFavoriteCount(
    int propertyId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('📊 Getting favorite count for property: $propertyId');
      }

      final response = await _get(
        '/favorites/count/$propertyId',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'count': data['count'] ?? data['total'] ?? 0,
          'data': data,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'count': 0,
          'message': data['message'] ?? 'Failed to get favorite count',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting favorite count: $e');
      }
      return {
        'success': false,
        'count': 0,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // GET FAVORITE COUNT (SIMPLE)
  // =========================
  /// Simplified method to get favorite count
  /// Returns int directly
  static Future<int> getFavoriteCountSimple(
    int propertyId, {
    String? token,
  }) async {
    try {
      final result = await getFavoriteCount(propertyId, token: token);
      return result['count'] ?? 0;
    } catch (e) {
      debugPrint("Error getting favorite count: $e");
      return 0;
    }
  }

  // =========================
  // TOGGLE FAVORITE
  // =========================
  /// Toggle favorite status (add if not favorited, remove if favorited)
  static Future<Map<String, dynamic>> toggleFavorite(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Toggling favorite - User: $userId, Property: $propertyId');
      }

      // First check if property is favorited
      final checkResult = await isPropertyFavorited(
        userId,
        propertyId,
        token: token,
      );

      if (checkResult['success'] == true) {
        final isFavorited = checkResult['isFavorited'] == true;
        
        if (isFavorited) {
          // Remove from favorites
          return await removeFavorite(userId, propertyId, token: token);
        } else {
          // Add to favorites
          return await addFavorite(userId, propertyId, token: token);
        }
      } else {
        // If check fails, try to add (safe fallback)
        if (kDebugMode) {
          print('⚠️ Check failed, attempting to add favorite...');
        }
        return await addFavorite(userId, propertyId, token: token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling favorite: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // TOGGLE FAVORITE (SIMPLE BOOL)
  // =========================
  /// Toggle favorite and return new status
  static Future<bool> toggleFavoriteSimple(
    int userId,
    int propertyId, {
    String? token,
  }) async {
    try {
      final result = await toggleFavorite(userId, propertyId, token: token);
      return result['success'] == true;
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      return false;
    }
  }

  // =========================
  // BULK DELETE FAVORITES
  // =========================
  /// Remove multiple properties from favorites
  /// Endpoint: DELETE /favorites/bulk/{userId}
  static Future<Map<String, dynamic>> bulkDeleteFavorites(
    int userId,
    List<int> propertyIds, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🗑️ Bulk deleting favorites - User: $userId, Properties: $propertyIds');
      }

      if (propertyIds.isEmpty) {
        return {
          'success': false,
          'message': 'No properties selected for removal',
        };
      }

      final response = await _delete(
        '/favorites/bulk/$userId',
        token: token,
        body: {
          'propertyIds': propertyIds,
        },
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Favorites removed successfully',
          'removedCount': propertyIds.length,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to remove favorites',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error bulk deleting favorites: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =========================
  // GET RECENTLY FAVORITED
  // =========================
  /// Get recently favorited properties
  /// Endpoint: GET /favorites/recent/{userId}
  static Future<Map<String, dynamic>> getRecentlyFavorited(
    int userId, {
    int limit = 10,
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🕐 Getting recently favorited for user: $userId');
      }

      final response = await _get(
        '/favorites/recent/$userId?limit=$limit',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
          'message': 'Recent favorites fetched successfully',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch recent favorites',
          'data': [],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting recent favorites: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': [],
      };
    }
  }

  // =========================
  // GET RECENTLY FAVORITED AS LIST
  // =========================
  /// Get recently favorited properties as List
  static Future<List<Map<String, dynamic>>> getRecentlyFavoritedList(
    int userId, {
    int limit = 10,
    String? token,
  }) async {
    try {
      final result = await getRecentlyFavorited(
        userId,
        limit: limit,
        token: token,
      );

      if (result['success'] == true) {
        final List<dynamic> data = result['data'] ?? [];
        return data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error getting recent favorites list: $e");
      return [];
    }
  }

  // =========================
  // GET FAVORITE PROPERTIES WITH DETAILS
  // =========================
  /// Get user favorites with full property details
  /// Endpoint: GET /favorites/user/{userId}/with-details
 static Future<Map<String, dynamic>> getUserFavoritesWithDetails(
  int userId, {
  int page = 1,
  int limit = 20,
  String? token,
}) async {
  try {
    if (kDebugMode) {
      print('📥 Fetching favorites with details for user: $userId');
    }

    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final queryString = Uri(queryParameters: queryParams).query;

    final endpoint =
        '/favorites/user/$userId${queryString.isNotEmpty ? '?$queryString' : ''}';

    final response = await _get(endpoint, token: token);

    if (kDebugMode) {
      print('📡 Status: ${response.statusCode}');
      print('📡 Response: ${response.body}');
    }

    if (response.statusCode == 200) {

      final dynamic data = jsonDecode(response.body);

      List<dynamic> favorites = [];

      if (data is List) {
        favorites = data;
      } 
      else if (data is Map && data['data'] is List) {
        favorites = data['data'];
      }


      return {
        'success': true,
        'data': favorites,
        'total': favorites.length,
        'page': page,
        'lastPage': 1,
      };

    } else {

      final dynamic data = jsonDecode(response.body);

      return {
        'success': false,
        'message': data is Map
            ? data['message'] ?? 'Failed to fetch favorites'
            : 'Failed to fetch favorites',
        'data': [],
        'total': 0,
      };
    }

  } catch (e) {

    if (kDebugMode) {
      print('❌ Error fetching favorites: $e');
    }

    return {
      'success': false,
      'message': e.toString(),
      'data': [],
      'total': 0,
    };
  }
}
  // =========================
  // GET FAVORITE PROPERTIES WITH DETAILS AS LIST
  // =========================
  /// Get user favorites with full property details as List
  static Future<List<Map<String, dynamic>>> getUserFavoritesWithDetailsList(
    int userId, {
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      final result = await getUserFavoritesWithDetails(
        userId,
        page: page,
        limit: limit,
        token: token,
      );

      if (result['success'] == true) {
        final List<dynamic> data = result['data'] ?? [];
        return data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error getting favorites with details list: $e");
      return [];
    }
  }

  // =========================
  // GET FAVORITE STATUS FOR MULTIPLE PROPERTIES
  // =========================
  /// Check favorite status for multiple properties at once
  /// Endpoint: GET /favorites/status/{userId}?propertyIds=1,2,3
  static Future<Map<String, dynamic>> getFavoritesStatus(
    int userId,
    List<int> propertyIds, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('📊 Getting favorites status for ${propertyIds.length} properties');
      }

      if (propertyIds.isEmpty) {
        return {
          'success': true,
          'data': {},
        };
      }

      final ids = propertyIds.join(',');
      final response = await _get(
        '/favorites/status/$userId?propertyIds=$ids',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'] ?? data,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get favorites status',
          'data': {},
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting favorites status: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': {},
      };
    }
  }

  // =========================
  // CLEAR ALL FAVORITES
  // =========================
  /// Remove all favorites for a user
  /// Endpoint: DELETE /favorites/clear/{userId}
  static Future<Map<String, dynamic>> clearAllFavorites(
    int userId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print('🧹 Clearing all favorites for user: $userId');
      }

      final response = await _delete(
        '/favorites/clear/$userId',
        token: token,
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'All favorites cleared successfully',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to clear favorites',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing favorites: $e');
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}