import '../models/agent_model.dart';
import '../services/agent_service.dart';

class AgentRepository {
  final AgentService service;

  AgentRepository({required this.service});

  Future<List<Agent>> getAgents() async {
    try {
      final data = await service.fetchAgents();
      return data;
    } catch (e) {
      throw Exception("Repository Error: $e");
    }
  }
}