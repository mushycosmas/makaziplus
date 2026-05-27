import 'package:flutter/material.dart';
import '../models/agent_model.dart';
import '../repositories/agent_repository.dart';

class AgentProvider extends ChangeNotifier {
  final AgentRepository repository;

  AgentProvider({required this.repository});

  bool isLoading = false;
  List<Agent> agents = [];
  String? errorMessage;

  Future<void> fetchAgents() async {
    try {
      isLoading = true;
      notifyListeners();

      agents = await repository.getAgents();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}