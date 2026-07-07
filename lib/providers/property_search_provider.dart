import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/property_manage_api.dart';

final propertySearchProvider = StateNotifierProvider<PropertySearchNotifier, AsyncValue<List<dynamic>>>(
  (ref) => PropertySearchNotifier(),
);

class PropertySearchNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  String _lastQuery = '';
  bool _hasSearched = false;

  PropertySearchNotifier() : super(const AsyncValue.data([]));

  /// Search properties with the given keyword
  Future<void> searchProperties(String keyword) async {
    final trimmed = keyword.trim();

    // If search is empty, clear results immediately
    if (trimmed.isEmpty) {
      _lastQuery = '';
      _hasSearched = false;
      state = const AsyncValue.data([]);
      return;
    }

    // Only search if the query changed
    if (_lastQuery == trimmed && _hasSearched) {
      return; // Don't repeat the same search
    }

    _lastQuery = trimmed;
    _hasSearched = true;
    state = const AsyncValue.loading();

    try {
      final response = await PropertyManageApi.searchProperties(
        query: trimmed,
        page: 1,
        limit: 20,
      );

      if (response['success'] == true) {
        final data = List<dynamic>.from(response['data'] ?? []);
        state = AsyncValue.data(data);
      } else {
        state = AsyncValue.error(
          response['message'] ?? 'Search failed',
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

  /// Clear search results and reset state
  void clearSearch() {
    _lastQuery = '';
    _hasSearched = false;
    state = const AsyncValue.data([]);
  }
}