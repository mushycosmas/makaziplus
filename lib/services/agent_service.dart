// lib/services/agent_service.dart
import '../api/master_data_api.dart';
import '../models/agent_model.dart';

class AgentService {
  Future<List<Agent>> fetchAgents() async {
    try {
      final data = await MasterDataApi.getAgents();
      
      if (data is List) {
        return data.map((item) => Agent.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch agents: $e');
    }
  }
}