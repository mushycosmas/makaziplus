// lib/providers/property_types_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final propertyTypesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final types = await MasterDataApi.getPropertyTypes();
    return types;
  } catch (e) {
    return [];
  }
});