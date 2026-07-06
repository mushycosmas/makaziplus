// lib/providers/listing_types_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listingTypesProvider = Provider<List<String>>((ref) {
  return ['Sale', 'Rent'];
});