// lib/widgets/agent_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/agents_provider.dart';
import '../models/agent_model.dart';
import 'agent_card.dart';
import 'section_title.dart';

class AgentSection extends ConsumerWidget {
  const AgentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsync = ref.watch(agentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Top Agents"),
        const SizedBox(height: 20),

        agentsAsync.when(
          data: (agents) {
            if (agents.isEmpty) {
              return const Text(
                "No agents found",
                style: TextStyle(color: Colors.grey),
              );
            }
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: agents.length > 5 ? 5 : agents.length,
                itemBuilder: (context, index) {
                  final agent = agents[index];
                  
                  // ✅ Handle both Map and Agent object
                  String name;
                  int propertyCount;
                  
                  if (agent is Map) {
                    // If it's a Map from the API
                    name = agent['fullName'] ?? agent['name'] ?? 'Agent';
                    propertyCount = agent['_count']?['properties'] ?? agent['properties'] ?? 0;
                  } else if (agent is Agent) {
                    // If it's an Agent model object
                    name = agent.fullName;
                    propertyCount = agent.propertyCount;
                  } else {
                    // Fallback
                    name = 'Agent';
                    propertyCount = 0;
                  }

                  return AgentCard(
                    name: name,
                    properties: propertyCount.toString(), // Convert to String
                    rating: "4.5", // You can add rating to your API
                    imageUrl: null,
                  );
                },
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[300]),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load agents',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.refresh(agentsProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}