// lib/providers/regions_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final regionsProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final regions = await MasterDataApi.getRegions();
    if (regions.isEmpty) {
      throw Exception('No regions found');
    }
    return regions;
  } catch (e) {
    // Re-throw the error to be handled by UI
    throw Exception('Failed to load regions: $e');
  }
});