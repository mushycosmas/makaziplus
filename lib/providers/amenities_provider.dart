// lib/providers/amenities_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final amenitiesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final amenities = await MasterDataApi.getAmenities();
    if (amenities.isEmpty) {
      throw Exception('No amenities found');
    }
    return amenities;
  } catch (e) {
    throw Exception('Failed to load amenities: $e');
  }
});