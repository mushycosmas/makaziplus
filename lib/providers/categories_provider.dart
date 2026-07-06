// lib/providers/categories_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final categoriesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final categories = await MasterDataApi.getCategories();
    return categories;
  } catch (e) {
    // Return empty list instead of throwing
    // This prevents the UI from breaking
    return [];
  }
});