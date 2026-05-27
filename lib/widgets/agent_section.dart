import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/agent_provider.dart';
import 'agent_card.dart';
import 'section_title.dart';

class AgentSection extends StatelessWidget {
  const AgentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final agentProvider = context.watch<AgentProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Top Agents"),
        const SizedBox(height: 20),

        if (agentProvider.isLoading)
          const Center(child: CircularProgressIndicator())

        else if (agentProvider.agents.isEmpty)
          const Text("No agents found")

        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: agentProvider.agents.length,
              itemBuilder: (context, index) {
                final agent = agentProvider.agents[index];

                return AgentCard(
                  name: agent.name,
                  properties: agent.properties,
                  rating: agent.rating,
                );
              },
            ),
          ),
      ],
    );
  }
}