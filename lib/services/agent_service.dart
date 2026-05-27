import 'package:dio/dio.dart';
import '../models/agent_model.dart';

class AgentService {
  final Dio dio;

  AgentService({required this.dio});

  Future<List<Agent>> fetchAgents() async {
    final response = await dio.get('/users');

    final data = response.data;

    if (data is List) {
      return data.map((e) => Agent.fromJson(e)).toList();
    }

    return [];
  }
}