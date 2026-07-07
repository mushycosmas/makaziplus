import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/property_manage_api.dart';

// Existing provider for home screen
final propertiesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final response = await PropertyManageApi.getProperties(
      page: 1,
      limit: 20,
    );
    
    if (response['success'] == true) {
      final data = response['data'] ?? [];
      return data is List ? data : [];
    }
    return [];
  } catch (e) {
    throw Exception('Failed to load properties: $e');
  }
});

// New provider for paginated properties (for AllPropertiesScreen)
final paginatedPropertiesProvider = StateNotifierProvider<PaginatedPropertiesNotifier, AsyncValue<List<dynamic>>>(
  (ref) => PaginatedPropertiesNotifier(),
);

class PaginatedPropertiesNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  // Don't load on initialization - let the screen handle it
  PaginatedPropertiesNotifier() : super(const AsyncValue.data([]));

  Future<void> loadProperties({
    int page = 1,
    int limit = 20,
    String? status,
    String? type,
    String? category,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await PropertyManageApi.getProperties(
        page: page,
        limit: limit,
        status: status,
        type: type,
        search: category,
      );

      if (response['success'] == true) {
        state = AsyncValue.data(response['data'] ?? []);
      } else {
        state = AsyncValue.error(
          response['message'] ?? 'Failed to load properties',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(
        e.toString(),
        StackTrace.current,
      );
    }
  }

  Future<Map<String, dynamic>> loadMoreProperties({
    int page = 1,
    int limit = 20,
    String? status,
    String? type,
    String? category,
  }) async {
    try {
      final response = await PropertyManageApi.getProperties(
        page: page,
        limit: limit,
        status: status,
        type: type,
        search: category,
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'] ?? [],
          'total': response['total'] ?? 0,
          'page': response['page'] ?? page,
          'lastPage': response['lastPage'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to load properties',
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