// providers/properties_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final propertiesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    // You'll need to implement getProperties in MasterDataApi
    final properties = await MasterDataApi.getProperties();
    return properties is List ? properties : [];
  } catch (e) {
    throw Exception('Failed to load properties: $e');
  }
});