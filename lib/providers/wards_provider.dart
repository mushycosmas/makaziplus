import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/master_data_api.dart';

final wardsProvider =
    FutureProvider.family((ref, int districtId) async {
  return MasterDataApi.getWards(districtId);
});