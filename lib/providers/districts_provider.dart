import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final districtsProvider =
    FutureProvider.family((ref, int regionId) async {
  return MasterDataApi.getDistricts(regionId);
});